Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:57257 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbZFPO0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 10:26:25 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/3] rndis_wlan: convert get/set frag/rts to cfg80211
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 16 Jun 2009 17:17:21 +0300
Message-ID: <20090616141721.23639.15379.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  135 +++++++++++++++++--------------------
 1 files changed, 63 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 7441d55..323dd29 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -427,9 +427,12 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
 
+static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
+	.set_wiphy_params = rndis_set_wiphy_params,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -968,6 +971,36 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 }
 
 
+static int set_rts_threshold(struct usbnet *usbdev, u32 rts_threshold)
+{
+	__le32 tmp;
+
+	devdbg(usbdev, "set_rts_threshold %i", rts_threshold);
+
+	if (rts_threshold < 0 || rts_threshold > 2347)
+		rts_threshold = 2347;
+
+	tmp = cpu_to_le32(rts_threshold);
+	return rndis_set_oid(usbdev, OID_802_11_RTS_THRESHOLD, &tmp,
+								sizeof(tmp));
+}
+
+
+static int set_frag_threshold(struct usbnet *usbdev, u32 frag_threshold)
+{
+	__le32 tmp;
+
+	devdbg(usbdev, "set_frag_threshold %i", frag_threshold);
+
+	if (frag_threshold < 256 || frag_threshold > 2346)
+		frag_threshold = 2346;
+
+	tmp = cpu_to_le32(frag_threshold);
+	return rndis_set_oid(usbdev, OID_802_11_FRAGMENTATION_THRESHOLD, &tmp,
+								sizeof(tmp));
+}
+
+
 static void set_default_iw_params(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1251,6 +1284,28 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
 }
 
 
+static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	int err;
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		err = set_frag_threshold(usbdev, wiphy->frag_threshold);
+		if (err < 0)
+			return err;
+	}
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		err = set_rts_threshold(usbdev, wiphy->rts_threshold);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+
 #define SCAN_DELAY_JIFFIES (HZ)
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
@@ -1766,74 +1821,6 @@ static int rndis_iw_get_genie(struct net_device *dev,
 }
 
 
-static int rndis_iw_set_rts(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	__le32 tmp;
-	devdbg(usbdev, "SIOCSIWRTS");
-
-	tmp = cpu_to_le32(wrqu->rts.value);
-	return rndis_set_oid(usbdev, OID_802_11_RTS_THRESHOLD, &tmp,
-								sizeof(tmp));
-}
-
-
-static int rndis_iw_get_rts(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	__le32 tmp;
-	int len, ret;
-
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_802_11_RTS_THRESHOLD, &tmp, &len);
-	if (ret == 0) {
-		wrqu->rts.value = le32_to_cpu(tmp);
-		wrqu->rts.flags = 1;
-		wrqu->rts.disabled = 0;
-	}
-
-	devdbg(usbdev, "SIOCGIWRTS: %d", wrqu->rts.value);
-
-	return ret;
-}
-
-
-static int rndis_iw_set_frag(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	__le32 tmp;
-
-	devdbg(usbdev, "SIOCSIWFRAG");
-
-	tmp = cpu_to_le32(wrqu->frag.value);
-	return rndis_set_oid(usbdev, OID_802_11_FRAGMENTATION_THRESHOLD, &tmp,
-								sizeof(tmp));
-}
-
-
-static int rndis_iw_get_frag(struct net_device *dev,
-    struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
-{
-	struct usbnet *usbdev = netdev_priv(dev);
-	__le32 tmp;
-	int len, ret;
-
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_802_11_FRAGMENTATION_THRESHOLD, &tmp,
-									&len);
-	if (ret == 0) {
-		wrqu->frag.value = le32_to_cpu(tmp);
-		wrqu->frag.flags = 1;
-		wrqu->frag.disabled = 0;
-	}
-	devdbg(usbdev, "SIOCGIWFRAG: %d", wrqu->frag.value);
-	return ret;
-}
-
-
 static int rndis_iw_set_freq(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
@@ -2022,10 +2009,10 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCSIWESSID)     = rndis_iw_set_essid,
 	IW_IOCTL(SIOCGIWESSID)     = rndis_iw_get_essid,
 	IW_IOCTL(SIOCGIWRATE)      = rndis_iw_get_rate,
-	IW_IOCTL(SIOCSIWRTS)       = rndis_iw_set_rts,
-	IW_IOCTL(SIOCGIWRTS)       = rndis_iw_get_rts,
-	IW_IOCTL(SIOCSIWFRAG)      = rndis_iw_set_frag,
-	IW_IOCTL(SIOCGIWFRAG)      = rndis_iw_get_frag,
+	IW_IOCTL(SIOCSIWRTS)       = (iw_handler) cfg80211_wext_siwrts,
+	IW_IOCTL(SIOCGIWRTS)       = (iw_handler) cfg80211_wext_giwrts,
+	IW_IOCTL(SIOCSIWFRAG)      = (iw_handler) cfg80211_wext_siwfrag,
+	IW_IOCTL(SIOCGIWFRAG)      = (iw_handler) cfg80211_wext_giwfrag,
 	IW_IOCTL(SIOCSIWTXPOW)     = rndis_iw_set_txpower,
 	IW_IOCTL(SIOCGIWTXPOW)     = rndis_iw_get_txpower,
 	IW_IOCTL(SIOCSIWENCODE)    = rndis_iw_set_encode,
@@ -2475,6 +2462,10 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 
 	set_default_iw_params(usbdev);
 
+	/* set default rts/frag */
+	rndis_set_wiphy_params(wiphy,
+			WIPHY_PARAM_FRAG_THRESHOLD | WIPHY_PARAM_RTS_THRESHOLD);
+
 	/* turn radio on */
 	priv->radio_on = 1;
 	disassociate(usbdev, 1);

