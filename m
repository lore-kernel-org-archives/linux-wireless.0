Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:59293 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbZCZVkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 17:40:37 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 6/6] rndis_wlan: convert scan to cfg80211
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Mar 2009 23:40:31 +0200
Message-ID: <20090326214031.19238.88315.stgit@fate.lan> (sfid-20090326_224059_352597_5BD22951)
In-Reply-To: <20090326213953.19238.59497.stgit@fate.lan>
References: <20090326213953.19238.59497.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert scan function to cfg80211. Unlike old scan code new code
waits 1 sec before getting scan data from device and passing
forward to cfg80211.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  341 ++++++++++++++++---------------------
 1 files changed, 147 insertions(+), 194 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3674c67..6d4a1ef 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -356,8 +356,11 @@ struct rndis_wext_private {
 
 	struct wireless_dev wdev;
 
+	struct cfg80211_scan_request *scan_request;
+
 	struct workqueue_struct *workqueue;
 	struct delayed_work stats_work;
+	struct delayed_work scan_work;
 	struct work_struct work;
 	struct mutex command_lock;
 	spinlock_t stats_lock;
@@ -413,8 +416,12 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
 					enum nl80211_iftype type, u32 *flags,
 					struct vif_params *params);
 
+static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_scan_request *request);
+
 struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
+	.scan = rndis_scan,
 };
 
 void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -1164,6 +1171,142 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
 	return set_infra_mode(usbdev, mode);
 }
 
+
+#define SCAN_DELAY_JIFFIES (HZ)
+static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_scan_request *request)
+{
+	struct usbnet *usbdev = netdev_priv(dev);
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	int ret;
+	__le32 tmp;
+
+	devdbg(usbdev, "cfg80211.scan");
+
+	if (!request)
+		return -EINVAL;
+
+	if (priv->scan_request && priv->scan_request != request)
+		return -EBUSY;
+
+	priv->scan_request = request;
+
+	tmp = ccpu2(1);
+	ret = rndis_set_oid(usbdev, OID_802_11_BSSID_LIST_SCAN, &tmp,
+							sizeof(tmp));
+	if (ret == 0) {
+		/* Wait before retrieving scan results from device */
+		queue_delayed_work(priv->workqueue, &priv->scan_work,
+			SCAN_DELAY_JIFFIES);
+	}
+
+	return ret;
+}
+
+
+static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
+					struct ndis_80211_bssid_ex *bssid)
+{
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct ieee80211_channel *channel;
+	s32 signal;
+	u64 timestamp;
+	u16 capability;
+	u16 beacon_interval;
+	struct ndis_80211_fixed_ies *fixed;
+	int ie_len, bssid_len;
+	u8 *ie;
+
+	/* parse bssid structure */
+	bssid_len = le32_to_cpu(bssid->length);
+
+	if (bssid_len < sizeof(struct ndis_80211_bssid_ex) +
+			sizeof(struct ndis_80211_fixed_ies))
+		return NULL;
+
+	fixed = (struct ndis_80211_fixed_ies *)bssid->ies;
+
+	ie = (void *)(bssid->ies + sizeof(struct ndis_80211_fixed_ies));
+	ie_len = min(bssid_len - (int)sizeof(*bssid),
+					(int)le32_to_cpu(bssid->ie_length));
+	ie_len -= sizeof(struct ndis_80211_fixed_ies);
+	if (ie_len < 0)
+		return NULL;
+
+	/* extract data for cfg80211_inform_bss */
+	channel = ieee80211_get_channel(priv->wdev.wiphy,
+			KHZ_TO_MHZ(le32_to_cpu(bssid->config.ds_config)));
+	if (!channel)
+		return NULL;
+
+	signal = level_to_qual(le32_to_cpu(bssid->rssi));
+	timestamp = le64_to_cpu(*(__le64 *)fixed->timestamp);
+	capability = le16_to_cpu(fixed->capabilities);
+	beacon_interval = le16_to_cpu(fixed->beacon_interval);
+
+	return cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
+		timestamp, capability, beacon_interval, ie, ie_len, signal,
+		GFP_KERNEL);
+}
+
+
+static int rndis_check_bssid_list(struct usbnet *usbdev)
+{
+	void *buf = NULL;
+	struct ndis_80211_bssid_list_ex *bssid_list;
+	struct ndis_80211_bssid_ex *bssid;
+	int ret = -EINVAL, len, count, bssid_len;
+
+	devdbg(usbdev, "check_bssid_list");
+
+	len = CONTROL_BUFFER_SIZE;
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = rndis_query_oid(usbdev, OID_802_11_BSSID_LIST, buf, &len);
+	if (ret != 0)
+		goto out;
+
+	bssid_list = buf;
+	bssid = bssid_list->bssid;
+	bssid_len = le32_to_cpu(bssid->length);
+	count = le32_to_cpu(bssid_list->num_items);
+	devdbg(usbdev, "check_bssid_list: %d BSSIDs found", count);
+
+	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
+		rndis_bss_info_update(usbdev, bssid);
+
+		bssid = (void *)bssid + bssid_len;
+		bssid_len = le32_to_cpu(bssid->length);
+		count--;
+	}
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+
+static void rndis_get_scan_results(struct work_struct *work)
+{
+	struct rndis_wext_private *priv =
+		container_of(work, struct rndis_wext_private, scan_work.work);
+	struct usbnet *usbdev = priv->usbdev;
+	int ret;
+
+	devdbg(usbdev, "get_scan_results");
+
+	ret = rndis_check_bssid_list(usbdev);
+
+	cfg80211_scan_done(priv->scan_request, ret < 0);
+
+	priv->scan_request = NULL;
+}
+
+
 /*
  * wireless extension handlers
  */
@@ -1531,198 +1674,6 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 }
 
 
-static int rndis_iw_set_scan(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	union iwreq_data evt;
-	int ret = -EINVAL;
-	__le32 tmp;
-
-	devdbg(usbdev, "SIOCSIWSCAN");
-
-	if (wrqu->data.flags == 0) {
-		tmp = ccpu2(1);
-		ret = rndis_set_oid(usbdev, OID_802_11_BSSID_LIST_SCAN, &tmp,
-								sizeof(tmp));
-		evt.data.flags = 0;
-		evt.data.length = 0;
-		wireless_send_event(dev, SIOCGIWSCAN, &evt, NULL);
-	}
-	return ret;
-}
-
-
-static char *rndis_translate_scan(struct net_device *dev,
-				  struct iw_request_info *info, char *cev,
-				  char *end_buf,
-				  struct ndis_80211_bssid_ex *bssid)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	u8 *ie;
-	char *current_val;
-	int bssid_len, ie_len, i;
-	u32 beacon, atim;
-	struct iw_event iwe;
-	unsigned char sbuf[32];
-
-	bssid_len = le32_to_cpu(bssid->length);
-
-	devdbg(usbdev, "BSSID %pM", bssid->mac);
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bssid->mac, ETH_ALEN);
-	cev = iwe_stream_add_event(info, cev, end_buf, &iwe, IW_EV_ADDR_LEN);
-
-	devdbg(usbdev, "SSID(%d) %s", le32_to_cpu(bssid->ssid.length),
-						bssid->ssid.essid);
-	iwe.cmd = SIOCGIWESSID;
-	iwe.u.essid.length = le32_to_cpu(bssid->ssid.length);
-	iwe.u.essid.flags = 1;
-	cev = iwe_stream_add_point(info, cev, end_buf, &iwe, bssid->ssid.essid);
-
-	devdbg(usbdev, "MODE %d", le32_to_cpu(bssid->net_infra));
-	iwe.cmd = SIOCGIWMODE;
-	switch (le32_to_cpu(bssid->net_infra)) {
-	case ndis_80211_infra_adhoc:
-		iwe.u.mode = IW_MODE_ADHOC;
-		break;
-	case ndis_80211_infra_infra:
-		iwe.u.mode = IW_MODE_INFRA;
-		break;
-	/*case ndis_80211_infra_auto_unknown:*/
-	default:
-		iwe.u.mode = IW_MODE_AUTO;
-		break;
-	}
-	cev = iwe_stream_add_event(info, cev, end_buf, &iwe, IW_EV_UINT_LEN);
-
-	devdbg(usbdev, "FREQ %d kHz", le32_to_cpu(bssid->config.ds_config));
-	iwe.cmd = SIOCGIWFREQ;
-	dsconfig_to_freq(le32_to_cpu(bssid->config.ds_config), &iwe.u.freq);
-	cev = iwe_stream_add_event(info, cev, end_buf, &iwe, IW_EV_FREQ_LEN);
-
-	devdbg(usbdev, "QUAL %d", le32_to_cpu(bssid->rssi));
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual  = level_to_qual(le32_to_cpu(bssid->rssi));
-	iwe.u.qual.level = level_to_qual(le32_to_cpu(bssid->rssi));
-	iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED
-			| IW_QUAL_LEVEL_UPDATED
-			| IW_QUAL_NOISE_INVALID;
-	cev = iwe_stream_add_event(info, cev, end_buf, &iwe, IW_EV_QUAL_LEN);
-
-	devdbg(usbdev, "ENCODE %d", le32_to_cpu(bssid->privacy));
-	iwe.cmd = SIOCGIWENCODE;
-	iwe.u.data.length = 0;
-	if (le32_to_cpu(bssid->privacy) == ndis_80211_priv_accept_all)
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	else
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-
-	cev = iwe_stream_add_point(info, cev, end_buf, &iwe, NULL);
-
-	devdbg(usbdev, "RATES:");
-	current_val = cev + iwe_stream_lcp_len(info);
-	iwe.cmd = SIOCGIWRATE;
-	for (i = 0; i < sizeof(bssid->rates); i++) {
-		if (bssid->rates[i] & 0x7f) {
-			iwe.u.bitrate.value =
-				((bssid->rates[i] & 0x7f) *
-				500000);
-			devdbg(usbdev, " %d", iwe.u.bitrate.value);
-			current_val = iwe_stream_add_value(info, cev,
-				current_val, end_buf, &iwe,
-				IW_EV_PARAM_LEN);
-		}
-	}
-
-	if ((current_val - cev) > iwe_stream_lcp_len(info))
-		cev = current_val;
-
-	beacon = le32_to_cpu(bssid->config.beacon_period);
-	devdbg(usbdev, "BCN_INT %d", beacon);
-	iwe.cmd = IWEVCUSTOM;
-	snprintf(sbuf, sizeof(sbuf), "bcn_int=%d", beacon);
-	iwe.u.data.length = strlen(sbuf);
-	cev = iwe_stream_add_point(info, cev, end_buf, &iwe, sbuf);
-
-	atim = le32_to_cpu(bssid->config.atim_window);
-	devdbg(usbdev, "ATIM %d", atim);
-	iwe.cmd = IWEVCUSTOM;
-	snprintf(sbuf, sizeof(sbuf), "atim=%u", atim);
-	iwe.u.data.length = strlen(sbuf);
-	cev = iwe_stream_add_point(info, cev, end_buf, &iwe, sbuf);
-
-	ie = (void *)(bssid->ies + sizeof(struct ndis_80211_fixed_ies));
-	ie_len = min(bssid_len - (int)sizeof(*bssid),
-					(int)le32_to_cpu(bssid->ie_length));
-	ie_len -= sizeof(struct ndis_80211_fixed_ies);
-	while (ie_len >= 2 && 2 + ie[1] <= ie_len) {
-		if ((ie[0] == WLAN_EID_GENERIC && ie[1] >= 4 &&
-		     memcmp(ie + 2, "\x00\x50\xf2\x01", 4) == 0) ||
-		    ie[0] == WLAN_EID_RSN) {
-			devdbg(usbdev, "IE: WPA%d",
-					(ie[0] == WLAN_EID_RSN) ? 2 : 1);
-			iwe.cmd = IWEVGENIE;
-			/* arbitrary cut-off at 64 */
-			iwe.u.data.length = min(ie[1] + 2, 64);
-			cev = iwe_stream_add_point(info, cev, end_buf, &iwe, ie);
-		}
-
-		ie_len -= 2 + ie[1];
-		ie += 2 + ie[1];
-	}
-
-	return cev;
-}
-
-
-static int rndis_iw_get_scan(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	void *buf = NULL;
-	char *cev = extra;
-	struct ndis_80211_bssid_list_ex *bssid_list;
-	struct ndis_80211_bssid_ex *bssid;
-	int ret = -EINVAL, len, count, bssid_len;
-
-	devdbg(usbdev, "SIOCGIWSCAN");
-
-	len = CONTROL_BUFFER_SIZE;
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = rndis_query_oid(usbdev, OID_802_11_BSSID_LIST, buf, &len);
-
-	if (ret != 0)
-		goto out;
-
-	bssid_list = buf;
-	bssid = bssid_list->bssid;
-	bssid_len = le32_to_cpu(bssid->length);
-	count = le32_to_cpu(bssid_list->num_items);
-	devdbg(usbdev, "SIOCGIWSCAN: %d BSSIDs found", count);
-
-	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
-		cev = rndis_translate_scan(dev, info, cev,
-					   extra + IW_SCAN_MAX_DATA, bssid);
-		bssid = (void *)bssid + bssid_len;
-		bssid_len = le32_to_cpu(bssid->length);
-		count--;
-	}
-
-out:
-	wrqu->data.length = cev - extra;
-	wrqu->data.flags = 0;
-	kfree(buf);
-	return ret;
-}
-
-
 static int rndis_iw_set_genie(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2085,8 +2036,8 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWRANGE)     = (iw_handler) cfg80211_wext_giwrange,
 	IW_IOCTL(SIOCSIWAP)        = rndis_iw_set_bssid,
 	IW_IOCTL(SIOCGIWAP)        = rndis_iw_get_bssid,
-	IW_IOCTL(SIOCSIWSCAN)      = rndis_iw_set_scan,
-	IW_IOCTL(SIOCGIWSCAN)      = rndis_iw_get_scan,
+	IW_IOCTL(SIOCSIWSCAN)      = (iw_handler) cfg80211_wext_siwscan,
+	IW_IOCTL(SIOCGIWSCAN)      = (iw_handler) cfg80211_wext_giwscan,
 	IW_IOCTL(SIOCSIWESSID)     = rndis_iw_set_essid,
 	IW_IOCTL(SIOCGIWESSID)     = rndis_iw_get_essid,
 	IW_IOCTL(SIOCSIWNICKN)     = rndis_iw_set_nick,
@@ -2535,6 +2486,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
 		round_jiffies_relative(STATS_UPDATE_JIFFIES));
+	INIT_DELAYED_WORK(&priv->scan_work, rndis_get_scan_results);
 	INIT_WORK(&priv->work, rndis_wext_worker);
 
 	return 0;
@@ -2553,6 +2505,7 @@ static void rndis_wext_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	disassociate(usbdev, 0);
 
 	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);
 	flush_workqueue(priv->workqueue);
 	destroy_workqueue(priv->workqueue);

