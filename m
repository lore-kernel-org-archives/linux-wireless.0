Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:57181 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab0LUUox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:53 -0500
Subject: [PATCH 7/7] rndis_wlan: add support for set_power_mgmt
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:49 +0200
Message-ID: <20101221204449.12250.77510.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   48 +++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 0cd971a..848cc2c 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -129,6 +129,7 @@ MODULE_PARM_DESC(workaround_interval,
 #define OID_802_11_RTS_THRESHOLD		cpu_to_le32(0x0d01020a)
 #define OID_802_11_SUPPORTED_RATES		cpu_to_le32(0x0d01020e)
 #define OID_802_11_CONFIGURATION		cpu_to_le32(0x0d010211)
+#define OID_802_11_POWER_MODE			cpu_to_le32(0x0d010216)
 #define OID_802_11_BSSID_LIST			cpu_to_le32(0x0d010217)
 
 
@@ -239,6 +240,12 @@ enum ndis_80211_addwep_bits {
 	NDIS_80211_ADDWEP_TRANSMIT_KEY = cpu_to_le32(1 << 31)
 };
 
+enum ndis_80211_power_mode {
+	NDIS_80211_POWER_MODE_CAM,
+	NDIS_80211_POWER_MODE_MAX_PSP,
+	NDIS_80211_POWER_MODE_FAST_PSP,
+};
+
 struct ndis_80211_auth_request {
 	__le32 length;
 	u8 bssid[6];
@@ -503,6 +510,7 @@ struct rndis_wlan_private {
 
 	/* hardware state */
 	bool radio_on;
+	int power_mode;
 	int infra_mode;
 	bool connected;
 	u8 bssid[ETH_ALEN];
@@ -572,6 +580,9 @@ static int rndis_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev);
 
+static int rndis_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+				bool enabled, int timeout);
+
 static int rndis_set_cqm_rssi_config(struct wiphy *wiphy,
 					struct net_device *dev,
 					s32 rssi_thold, u32 rssi_hyst);
@@ -595,6 +606,7 @@ static const struct cfg80211_ops rndis_config_ops = {
 	.set_pmksa = rndis_set_pmksa,
 	.del_pmksa = rndis_del_pmksa,
 	.flush_pmksa = rndis_flush_pmksa,
+	.set_power_mgmt = rndis_set_power_mgmt,
 	.set_cqm_rssi_config = rndis_set_cqm_rssi_config,
 };
 
@@ -694,6 +706,7 @@ static const char *oid_to_string(__le32 oid)
 		OID_STR(OID_802_11_ADD_KEY);
 		OID_STR(OID_802_11_REMOVE_KEY);
 		OID_STR(OID_802_11_ASSOCIATION_INFORMATION);
+		OID_STR(OID_802_11_CAPABILITY);
 		OID_STR(OID_802_11_PMKID);
 		OID_STR(OID_802_11_NETWORK_TYPES_SUPPORTED);
 		OID_STR(OID_802_11_NETWORK_TYPE_IN_USE);
@@ -704,6 +717,7 @@ static const char *oid_to_string(__le32 oid)
 		OID_STR(OID_802_11_RTS_THRESHOLD);
 		OID_STR(OID_802_11_SUPPORTED_RATES);
 		OID_STR(OID_802_11_CONFIGURATION);
+		OID_STR(OID_802_11_POWER_MODE);
 		OID_STR(OID_802_11_BSSID_LIST);
 #undef OID_STR
 	}
@@ -2574,6 +2588,38 @@ static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return rndis_set_oid(usbdev, OID_802_11_PMKID, &pmkid, sizeof(pmkid));
 }
 
+static int rndis_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+				bool enabled, int timeout)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	int power_mode;
+	__le32 mode;
+	int ret;
+
+	netdev_dbg(usbdev->net, "%s(): %s, %d\n", __func__,
+				enabled ? "enabled" : "disabled",
+				timeout);
+
+	if (enabled)
+		power_mode = NDIS_80211_POWER_MODE_FAST_PSP;
+	else
+		power_mode = NDIS_80211_POWER_MODE_CAM;
+
+	if (power_mode == priv->power_mode)
+		return 0;
+
+	priv->power_mode = power_mode;
+
+	mode = cpu_to_le32(power_mode);
+	ret = rndis_set_oid(usbdev, OID_802_11_POWER_MODE, &mode, sizeof(mode));
+
+	netdev_dbg(usbdev->net, "%s(): OID_802_11_POWER_MODE -> %d\n",
+				__func__, ret);
+
+	return ret;
+}
+
 static int rndis_set_cqm_rssi_config(struct wiphy *wiphy,
 					struct net_device *dev,
 					s32 rssi_thold, u32 rssi_hyst)
@@ -3441,6 +3487,8 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 
 	set_default_iw_params(usbdev);
 
+	priv->power_mode = -1;
+
 	/* set default rts/frag */
 	rndis_set_wiphy_params(wiphy,
 			WIPHY_PARAM_FRAG_THRESHOLD | WIPHY_PARAM_RTS_THRESHOLD);

