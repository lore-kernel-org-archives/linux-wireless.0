Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnainternet-smtp-135.dnaip.fi ([81.175.170.19]:34067 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751151AbZFDRTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 13:19:15 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] rndis_wlan: cleanup: rename all rndis_wext* objects to
	rndis_wlan*
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Thu, 04 Jun 2009 20:13:25 +0300
Message-ID: <20090604171325.12853.68627.stgit@fate.lan>
In-Reply-To: <20090604171319.12853.90551.stgit@fate.lan>
References: <20090604171319.12853.90551.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver used to be named rndis_wext before inclusion to upstream. Since
rndis_wlan is being converted to cfg80211, use of rndis_wext* names
can be confusing. So rename all rndis_wext to rndis_wlan (as should
have been when driver was renamed).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  156 +++++++++++++++++++------------------
 1 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index de94496..7441d55 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -361,7 +361,7 @@ static const struct ieee80211_rate rndis_rates[] = {
 };
 
 /* RNDIS device private data */
-struct rndis_wext_private {
+struct rndis_wlan_private {
 	struct usbnet *usbdev;
 
 	struct wireless_dev wdev;
@@ -441,13 +441,13 @@ static const unsigned char ffff_bssid[ETH_ALEN] = { 0xff, 0xff, 0xff,
 							0xff, 0xff, 0xff };
 
 
-static struct rndis_wext_private *get_rndis_wext_priv(struct usbnet *dev)
+static struct rndis_wlan_private *get_rndis_wlan_priv(struct usbnet *dev)
 {
-	return (struct rndis_wext_private *)dev->driver_priv;
+	return (struct rndis_wlan_private *)dev->driver_priv;
 }
 
 
-static u32 get_bcm4320_power(struct rndis_wext_private *priv)
+static u32 get_bcm4320_power(struct rndis_wlan_private *priv)
 {
 	return BCM4320_DEFAULT_TXPOWER *
 		bcm4320_power_output[priv->param_power_output] / 100;
@@ -480,7 +480,7 @@ static int rndis_error_status(__le32 rndis_status)
 
 static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(dev);
 	union {
 		void			*buf;
 		struct rndis_msg_hdr	*header;
@@ -526,7 +526,7 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 
 static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(dev);
 	union {
 		void			*buf;
 		struct rndis_msg_hdr	*header;
@@ -747,7 +747,7 @@ static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 
 static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
 
 	ret = rndis_set_oid(usbdev, OID_802_11_SSID, ssid, sizeof(*ssid));
@@ -794,7 +794,7 @@ static int is_associated(struct usbnet *usbdev)
 
 static int disassociate(struct usbnet *usbdev, int reset_ssid)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_ssid ssid;
 	int i, ret = 0;
 
@@ -826,7 +826,7 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 
 static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int auth_mode, ret;
 
@@ -869,7 +869,7 @@ static int set_auth_mode(struct usbnet *usbdev, int wpa_version, int authalg)
 
 static int set_priv_filter(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 
 	devdbg(usbdev, "set_priv_filter: wpa_version=0x%x", priv->wpa_version);
@@ -887,7 +887,7 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int encr_mode, ret;
 
@@ -925,7 +925,7 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 
 static int set_assoc_params(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	set_auth_mode(usbdev, priv->wpa_version, priv->wpa_authalg);
 	set_priv_filter(usbdev);
@@ -937,7 +937,7 @@ static int set_assoc_params(struct usbnet *usbdev)
 
 static int set_infra_mode(struct usbnet *usbdev, int mode)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int ret, i;
 
@@ -970,7 +970,7 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 
 static void set_default_iw_params(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	priv->wpa_keymgmt = 0;
 	priv->wpa_version = 0;
@@ -996,7 +996,7 @@ static int deauthenticate(struct usbnet *usbdev)
 /* index must be 0 - N, as per NDIS  */
 static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_wep_key ndis_key;
 	int ret;
 
@@ -1039,7 +1039,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 			int index, const struct sockaddr *addr,
 			const u8 *rx_seq, int alg, int flags)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_key ndis_key;
 	int ret;
 
@@ -1106,7 +1106,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 /* remove_key is for both wep and wpa */
 static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_remove_key remove_key;
 	__le32 keyindex;
 	int ret;
@@ -1161,7 +1161,7 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 
 static void set_multicast_list(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct dev_mc_list *mclist;
 	__le32 filter;
 	int ret, i, size;
@@ -1256,7 +1256,7 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
 	__le32 tmp;
 
@@ -1286,7 +1286,7 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 					struct ndis_80211_bssid_ex *bssid)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
 	s32 signal;
 	u64 timestamp;
@@ -1371,8 +1371,8 @@ out:
 
 static void rndis_get_scan_results(struct work_struct *work)
 {
-	struct rndis_wext_private *priv =
-		container_of(work, struct rndis_wext_private, scan_work.work);
+	struct rndis_wlan_private *priv =
+		container_of(work, struct rndis_wlan_private, scan_work.work);
 	struct usbnet *usbdev = priv->usbdev;
 	int ret;
 
@@ -1497,7 +1497,7 @@ static int rndis_iw_set_auth(struct net_device *dev,
 {
 	struct iw_param *p = &wrqu->param;
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret = -ENOTSUPP;
 
 	switch (p->flags & IW_AUTH_INDEX) {
@@ -1578,7 +1578,7 @@ static int rndis_iw_get_auth(struct net_device *dev,
 {
 	struct iw_param *p = &wrqu->param;
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	switch (p->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
@@ -1609,7 +1609,7 @@ static int rndis_iw_set_encode(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret, index, key_len;
 	u8 *key;
 
@@ -1672,7 +1672,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 {
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int keyidx, flags;
 
 	keyidx = wrqu->encoding.flags & IW_ENCODE_INDEX;
@@ -1713,7 +1713,7 @@ static int rndis_iw_set_genie(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret = 0;
 
 #ifdef DEBUG
@@ -1747,7 +1747,7 @@ static int rndis_iw_get_genie(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	devdbg(usbdev, "SIOCGIWGENIE");
 
@@ -1886,7 +1886,7 @@ static int rndis_iw_get_txpower(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tx_power;
 
 	if (priv->radio_on) {
@@ -1912,7 +1912,7 @@ static int rndis_iw_set_txpower(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tx_power = 0;
 
 	if (!wrqu->txpower.disabled) {
@@ -1969,7 +1969,7 @@ static int rndis_iw_set_mlme(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	unsigned char bssid[ETH_ALEN];
 
@@ -1994,7 +1994,7 @@ static int rndis_iw_set_mlme(struct net_device *dev,
 static struct iw_statistics *rndis_get_wireless_stats(struct net_device *dev)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->stats_lock, flags);
@@ -2037,28 +2037,28 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCSIWMLME)      = rndis_iw_set_mlme,
 };
 
-static const iw_handler rndis_wext_private_handler[] = {
+static const iw_handler rndis_wlan_private_handler[] = {
 };
 
-static const struct iw_priv_args rndis_wext_private_args[] = {
+static const struct iw_priv_args rndis_wlan_private_args[] = {
 };
 
 
 static const struct iw_handler_def rndis_iw_handlers = {
 	.num_standard = ARRAY_SIZE(rndis_iw_handler),
-	.num_private  = ARRAY_SIZE(rndis_wext_private_handler),
-	.num_private_args = ARRAY_SIZE(rndis_wext_private_args),
+	.num_private  = ARRAY_SIZE(rndis_wlan_private_handler),
+	.num_private_args = ARRAY_SIZE(rndis_wlan_private_args),
 	.standard = (iw_handler *)rndis_iw_handler,
-	.private  = (iw_handler *)rndis_wext_private_handler,
-	.private_args = (struct iw_priv_args *)rndis_wext_private_args,
+	.private  = (iw_handler *)rndis_wlan_private_handler,
+	.private_args = (struct iw_priv_args *)rndis_wlan_private_args,
 	.get_wireless_stats = rndis_get_wireless_stats,
 };
 
 
-static void rndis_wext_worker(struct work_struct *work)
+static void rndis_wlan_worker(struct work_struct *work)
 {
-	struct rndis_wext_private *priv =
-		container_of(work, struct rndis_wext_private, work);
+	struct rndis_wlan_private *priv =
+		container_of(work, struct rndis_wlan_private, work);
 	struct usbnet *usbdev = priv->usbdev;
 	union iwreq_data evt;
 	unsigned char bssid[ETH_ALEN];
@@ -2119,10 +2119,10 @@ get_bssid:
 		set_multicast_list(usbdev);
 }
 
-static void rndis_wext_set_multicast_list(struct net_device *dev)
+static void rndis_wlan_set_multicast_list(struct net_device *dev)
 {
 	struct usbnet *usbdev = netdev_priv(dev);
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	if (test_bit(WORK_SET_MULTICAST_LIST, &priv->work_pending))
 		return;
@@ -2131,9 +2131,9 @@ static void rndis_wext_set_multicast_list(struct net_device *dev)
 	queue_work(priv->workqueue, &priv->work);
 }
 
-static void rndis_wext_link_change(struct usbnet *usbdev, int state)
+static void rndis_wlan_link_change(struct usbnet *usbdev, int state)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	/* queue work to avoid recursive calls into rndis_command */
 	set_bit(state ? WORK_LINK_UP : WORK_LINK_DOWN, &priv->work_pending);
@@ -2141,14 +2141,14 @@ static void rndis_wext_link_change(struct usbnet *usbdev, int state)
 }
 
 
-static int rndis_wext_get_caps(struct usbnet *usbdev)
+static int rndis_wlan_get_caps(struct usbnet *usbdev)
 {
 	struct {
 		__le32	num_items;
 		__le32	items[8];
 	} networks_supported;
 	int len, retval, i, n;
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	/* determine supported modes */
 	len = sizeof(networks_supported);
@@ -2181,8 +2181,8 @@ static int rndis_wext_get_caps(struct usbnet *usbdev)
 #define STATS_UPDATE_JIFFIES (HZ)
 static void rndis_update_wireless_stats(struct work_struct *work)
 {
-	struct rndis_wext_private *priv =
-		container_of(work, struct rndis_wext_private, stats_work.work);
+	struct rndis_wlan_private *priv =
+		container_of(work, struct rndis_wlan_private, stats_work.work);
 	struct usbnet *usbdev = priv->usbdev;
 	struct iw_statistics iwstats;
 	__le32 rssi, tmp;
@@ -2297,7 +2297,7 @@ static int bcm4320a_early_init(struct usbnet *usbdev)
 
 static int bcm4320b_early_init(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	char buf[8];
 
 	/* Early initialization settings, setting these won't have effect
@@ -2363,21 +2363,21 @@ static int bcm4320b_early_init(struct usbnet *usbdev)
 }
 
 /* same as rndis_netdev_ops but with local multicast handler */
-static const struct net_device_ops rndis_wext_netdev_ops = {
+static const struct net_device_ops rndis_wlan_netdev_ops = {
 	.ndo_open		= usbnet_open,
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_multicast_list	= rndis_wext_set_multicast_list,
+	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
 };
 
 
-static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
+static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 {
 	struct wiphy *wiphy;
-	struct rndis_wext_private *priv;
+	struct rndis_wlan_private *priv;
 	int retval, len;
 	__le32 tmp;
 
@@ -2385,7 +2385,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	 * NOTE: We only support a single virtual interface, so wiphy
 	 * and wireless_dev are somewhat synonymous for this device.
 	 */
-	wiphy = wiphy_new(&rndis_config_ops, sizeof(struct rndis_wext_private));
+	wiphy = wiphy_new(&rndis_config_ops, sizeof(struct rndis_wlan_private));
 	if (!wiphy)
 		return -ENOMEM;
 
@@ -2395,7 +2395,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	priv->wdev.iftype = NL80211_IFTYPE_STATION;
 
 	/* These have to be initialized before calling generic_rndis_bind().
-	 * Otherwise we'll be in big trouble in rndis_wext_early_init().
+	 * Otherwise we'll be in big trouble in rndis_wlan_early_init().
 	 */
 	usbdev->driver_priv = priv;
 	usbdev->net->wireless_handlers = &rndis_iw_handlers;
@@ -2406,7 +2406,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
-	INIT_WORK(&priv->work, rndis_wext_worker);
+	INIT_WORK(&priv->work, rndis_wlan_worker);
 	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
 	INIT_DELAYED_WORK(&priv->scan_work, rndis_get_scan_results);
 
@@ -2420,9 +2420,9 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	 * picks up rssi to closest station instead of to access point).
 	 *
 	 * rndis_host wants to avoid all OID as much as possible
-	 * so do promisc/multicast handling in rndis_wext.
+	 * so do promisc/multicast handling in rndis_wlan.
 	 */
-	usbdev->net->netdev_ops = &rndis_wext_netdev_ops;
+	usbdev->net->netdev_ops = &rndis_wlan_netdev_ops;
 
 	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
 	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
@@ -2455,7 +2455,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	wiphy->max_scan_ssids = 1;
 
 	/* TODO: fill-out band information based on priv->caps */
-	rndis_wext_get_caps(usbdev);
+	rndis_wlan_get_caps(usbdev);
 
 	memcpy(priv->channels, rndis_channels, sizeof(rndis_channels));
 	memcpy(priv->rates, rndis_rates, sizeof(rndis_rates));
@@ -2497,9 +2497,9 @@ fail:
 }
 
 
-static void rndis_wext_unbind(struct usbnet *usbdev, struct usb_interface *intf)
+static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
 	/* turn radio off */
 	disassociate(usbdev, 0);
@@ -2520,7 +2520,7 @@ static void rndis_wext_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 }
 
 
-static int rndis_wext_reset(struct usbnet *usbdev)
+static int rndis_wlan_reset(struct usbnet *usbdev)
 {
 	return deauthenticate(usbdev);
 }
@@ -2529,40 +2529,40 @@ static int rndis_wext_reset(struct usbnet *usbdev)
 static const struct driver_info	bcm4320b_info = {
 	.description =	"Wireless RNDIS device, BCM4320b based",
 	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
-	.bind =		rndis_wext_bind,
-	.unbind =	rndis_wext_unbind,
+	.bind =		rndis_wlan_bind,
+	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
-	.reset =	rndis_wext_reset,
+	.reset =	rndis_wlan_reset,
 	.early_init =	bcm4320b_early_init,
-	.link_change =	rndis_wext_link_change,
+	.link_change =	rndis_wlan_link_change,
 };
 
 static const struct driver_info	bcm4320a_info = {
 	.description =	"Wireless RNDIS device, BCM4320a based",
 	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
-	.bind =		rndis_wext_bind,
-	.unbind =	rndis_wext_unbind,
+	.bind =		rndis_wlan_bind,
+	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
-	.reset =	rndis_wext_reset,
+	.reset =	rndis_wlan_reset,
 	.early_init =	bcm4320a_early_init,
-	.link_change =	rndis_wext_link_change,
+	.link_change =	rndis_wlan_link_change,
 };
 
-static const struct driver_info rndis_wext_info = {
+static const struct driver_info rndis_wlan_info = {
 	.description =	"Wireless RNDIS device",
 	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
-	.bind =		rndis_wext_bind,
-	.unbind =	rndis_wext_unbind,
+	.bind =		rndis_wlan_bind,
+	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
-	.reset =	rndis_wext_reset,
+	.reset =	rndis_wlan_reset,
 	.early_init =	bcm4320a_early_init,
-	.link_change =	rndis_wext_link_change,
+	.link_change =	rndis_wlan_link_change,
 };
 
 /*-------------------------------------------------------------------------*/
@@ -2672,11 +2672,11 @@ static const struct usb_device_id products [] = {
 {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
-	.driver_info = (unsigned long) &rndis_wext_info,
+	.driver_info = (unsigned long) &rndis_wlan_info,
 }, {
 	/* "ActiveSync" is an undocumented variant of RNDIS, used in WM5 */
 	USB_INTERFACE_INFO(USB_CLASS_MISC, 1, 1),
-	.driver_info = (unsigned long) &rndis_wext_info,
+	.driver_info = (unsigned long) &rndis_wlan_info,
 },
 	{ },		// END
 };

