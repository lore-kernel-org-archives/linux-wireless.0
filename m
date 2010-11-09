Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:34250 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab0KIRck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 12:32:40 -0500
Subject: [PATCH 1/2] rndis_wlan: workaround device not returning bss for
	currently connected AP
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: =?utf-8?b?THXDrXM=?= Picciochi <Pitxyoki@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 09 Nov 2010 19:25:47 +0200
Message-ID: <20101109172547.11708.73988.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM4320a devices do not return bss for currently connected AP in bss-list,
althought this is required by NDIS specs. Missing bss leads to warning at
net/wireless/sme.c:__cfg80211_connect_result(), WARN_ON(!bss).

Workaround this by crafting bss manually with information we can read from
device. Workaround is only used when device bss-list does not return current
bss, and so is only used with BCM4320a devices and not newer BCM4320b ones.

Fixes bug #20152.

Reported-by: Luís Picciochi <Pitxyoki@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |  130 ++++++++++++++++++++++++++++++++++---
 1 files changed, 121 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 71b5971..0a423c4 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -994,7 +994,8 @@ static int level_to_qual(int level)
  */
 static int set_infra_mode(struct usbnet *usbdev, int mode);
 static void restore_keys(struct usbnet *usbdev);
-static int rndis_check_bssid_list(struct usbnet *usbdev);
+static int rndis_check_bssid_list(struct usbnet *usbdev, u8 *match_bssid,
+					bool *matched);
 
 static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
@@ -1911,7 +1912,7 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 	/* Get current bssid list from device before new scan, as new scan
 	 * clears internal bssid list.
 	 */
-	rndis_check_bssid_list(usbdev);
+	rndis_check_bssid_list(usbdev, NULL, NULL);
 
 	if (!request)
 		return -EINVAL;
@@ -1981,7 +1982,8 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 		GFP_KERNEL);
 }
 
-static int rndis_check_bssid_list(struct usbnet *usbdev)
+static int rndis_check_bssid_list(struct usbnet *usbdev, u8 *match_bssid,
+					bool *matched)
 {
 	void *buf = NULL;
 	struct ndis_80211_bssid_list_ex *bssid_list;
@@ -2017,7 +2019,11 @@ resize_buf:
 		   count, len);
 
 	while (count && ((void *)bssid + bssid_len) <= (buf + len)) {
-		rndis_bss_info_update(usbdev, bssid);
+		if (rndis_bss_info_update(usbdev, bssid) && match_bssid &&
+		    matched) {
+			if (compare_ether_addr(bssid->mac, match_bssid))
+				*matched = true;
+		}
 
 		bssid = (void *)bssid + bssid_len;
 		bssid_len = le32_to_cpu(bssid->length);
@@ -2041,7 +2047,7 @@ static void rndis_get_scan_results(struct work_struct *work)
 	if (!priv->scan_request)
 		return;
 
-	ret = rndis_check_bssid_list(usbdev);
+	ret = rndis_check_bssid_list(usbdev, NULL, NULL);
 
 	cfg80211_scan_done(priv->scan_request, ret < 0);
 
@@ -2495,6 +2501,91 @@ static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return rndis_set_oid(usbdev, OID_802_11_PMKID, &pmkid, sizeof(pmkid));
 }
 
+static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
+					   struct ndis_80211_assoc_info *info)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct ieee80211_channel *channel;
+	struct ndis_80211_conf config;
+	struct ndis_80211_ssid ssid;
+	s32 signal;
+	u64 timestamp;
+	u16 capability;
+	u16 beacon_interval;
+	__le32 rssi;
+	u8 ie_buf[34];
+	int len, ret, ie_len;
+
+	/* Get signal quality, in case of error use rssi=0 and ignore error. */
+	len = sizeof(rssi);
+	rssi = 0;
+	rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
+	signal = level_to_qual(le32_to_cpu(rssi));
+
+	netdev_dbg(usbdev->net, "%s(): OID_802_11_RSSI -> %d, "
+		   "rssi:%d, qual: %d\n", __func__, ret, le32_to_cpu(rssi),
+		   level_to_qual(le32_to_cpu(rssi)));
+
+	/* Get AP capabilities */
+	if (info) {
+		capability = le16_to_cpu(info->resp_ie.capa);
+	} else {
+		/* Set atleast ESS/IBSS capability */
+		capability = (priv->infra_mode == NDIS_80211_INFRA_INFRA) ?
+				WLAN_CAPABILITY_ESS : WLAN_CAPABILITY_IBSS;
+	}
+
+	/* Get channel and beacon interval */
+	len = sizeof(config);
+	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
+	netdev_dbg(usbdev->net, "%s(): OID_802_11_CONFIGURATION -> %d\n",
+				__func__, ret);
+	if (ret >= 0) {
+		beacon_interval = le16_to_cpu(config.beacon_period);
+		channel = ieee80211_get_channel(priv->wdev.wiphy,
+				KHZ_TO_MHZ(le32_to_cpu(config.ds_config)));
+		if (!channel) {
+			netdev_warn(usbdev->net, "%s(): could not get channel."
+						 "\n", __func__);
+			return;
+		}
+	} else {
+		netdev_warn(usbdev->net, "%s(): could not get configuration.\n",
+					 __func__);
+		return;
+	}
+
+	/* Get SSID, in case of error, use zero length SSID and ignore error. */
+	len = sizeof(ssid);
+	memset(&ssid, 0, sizeof(ssid));
+	ret = rndis_query_oid(usbdev, OID_802_11_SSID, &ssid, &len);
+	netdev_dbg(usbdev->net, "%s(): OID_802_11_SSID -> %d, len: %d, ssid: "
+				"'%.32s'\n", __func__, ret,
+				le32_to_cpu(ssid.length), ssid.essid);
+
+	if (le32_to_cpu(ssid.length) > 32)
+		ssid.length = cpu_to_le32(32);
+
+	ie_buf[0] = WLAN_EID_SSID;
+	ie_buf[1] = le32_to_cpu(ssid.length);
+	memcpy(&ie_buf[2], ssid.essid, le32_to_cpu(ssid.length));
+
+	ie_len = le32_to_cpu(ssid.length) + 2;
+
+	/* no tsf */
+	timestamp = 0;
+
+	netdev_dbg(usbdev->net, "%s(): channel:%d(freq), bssid:[%pM], tsf:%d, "
+		"capa:%x, beacon int:%d, resp_ie(len:%d, essid:'%.32s'), "
+		"signal:%d\n", __func__, (channel ? channel->center_freq : -1),
+		bssid, (u32)timestamp, capability, beacon_interval, ie_len,
+		ssid.essid, signal);
+
+	cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
+		timestamp, capability, beacon_interval, ie_buf, ie_len,
+		signal, GFP_KERNEL);
+}
+
 /*
  * workers, indication handlers, device poller
  */
@@ -2507,6 +2598,7 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	u8 *req_ie, *resp_ie;
 	int ret, offset;
 	bool roamed = false;
+	bool match_bss;
 
 	if (priv->infra_mode == NDIS_80211_INFRA_INFRA && priv->connected) {
 		/* received media connect indication while connected, either
@@ -2558,6 +2650,13 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 					resp_ie_len =
 						CONTROL_BUFFER_SIZE - offset;
 			}
+		} else {
+			/* Since rndis_wlan_craft_connected_bss() might use info
+			 * later and expects info to contain valid data if
+			 * non-null, free info and set NULL here.
+			 */
+			kfree(info);
+			info = NULL;
 		}
 	} else if (WARN_ON(priv->infra_mode != NDIS_80211_INFRA_ADHOC))
 		return;
@@ -2569,13 +2668,26 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	netdev_dbg(usbdev->net, "link up work: [%pM]%s\n",
 		   bssid, roamed ? " roamed" : "");
 
-	/* Internal bss list in device always contains at least the currently
+	/* Internal bss list in device should contain at least the currently
 	 * connected bss and we can get it to cfg80211 with
 	 * rndis_check_bssid_list().
-	 * NOTE: This is true for Broadcom chip, but not mentioned in RNDIS
-	 * spec.
+	 *
+	 * NDIS spec says: "If the device is associated, but the associated
+	 *  BSSID is not in its BSSID scan list, then the driver must add an
+	 *  entry for the BSSID at the end of the data that it returns in
+	 *  response to query of OID_802_11_BSSID_LIST."
+	 *
+	 * NOTE: Seems to be true for BCM4320b variant, but not BCM4320a.
 	 */
-	rndis_check_bssid_list(usbdev);
+	match_bss = false;
+	rndis_check_bssid_list(usbdev, bssid, &match_bss);
+
+	if (!is_zero_ether_addr(bssid) && !match_bss) {
+		/* Couldn't get bss from device, we need to manually craft bss
+		 * for cfg80211.
+		 */
+		rndis_wlan_craft_connected_bss(usbdev, bssid, info);
+	}
 
 	if (priv->infra_mode == NDIS_80211_INFRA_INFRA) {
 		if (!roamed)

