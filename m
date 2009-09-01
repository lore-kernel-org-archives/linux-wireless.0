Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:49573 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbZIAMdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:33:00 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/4] rndis_wlan: cleanup
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 01 Sep 2009 15:33:00 +0300
Message-ID: <20090901123300.9213.94947.stgit@fate.lan>
In-Reply-To: <20090901123255.9213.57970.stgit@fate.lan>
References: <20090901123255.9213.57970.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- remove double newlines between functions
- remove commented out function (rndis_set_config_parameter_u32())
- coding style fix in rndis_set_config_parameter_str()
- add comment banners between function sections

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   62 ++++---------------------------------
 1 files changed, 7 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index dc2804f..add2eb8 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -560,7 +560,6 @@ static struct rndis_wlan_private *get_rndis_wlan_priv(struct usbnet *dev)
 	return (struct rndis_wlan_private *)dev->driver_priv;
 }
 
-
 static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 {
 	switch (priv->param_power_output) {
@@ -576,7 +575,6 @@ static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 	}
 }
 
-
 static bool is_wpa_key(struct rndis_wlan_private *priv, int idx)
 {
 	int cipher = priv->encr_keys[idx].cipher;
@@ -585,7 +583,6 @@ static bool is_wpa_key(struct rndis_wlan_private *priv, int idx)
 		cipher == WLAN_CIPHER_SUITE_TKIP);
 }
 
-
 static int rndis_cipher_to_alg(u32 cipher)
 {
 	switch (cipher) {
@@ -613,7 +610,6 @@ static int rndis_akm_suite_to_key_mgmt(u32 akm_suite)
 	}
 }
 
-
 #ifdef DEBUG
 static const char *oid_to_string(__le32 oid)
 {
@@ -675,7 +671,6 @@ static const char *oid_to_string(__le32 oid)
 }
 #endif
 
-
 /* translate error code */
 static int rndis_error_status(__le32 rndis_status)
 {
@@ -699,7 +694,6 @@ static int rndis_error_status(__le32 rndis_status)
 	return ret;
 }
 
-
 static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(dev);
@@ -758,7 +752,6 @@ static int rndis_query_oid(struct usbnet *dev, __le32 oid, void *data, int *len)
 	return ret;
 }
 
-
 static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(dev);
@@ -817,7 +810,6 @@ static int rndis_set_oid(struct usbnet *dev, __le32 oid, void *data, int len)
 	return ret;
 }
 
-
 static int rndis_reset(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -840,7 +832,6 @@ static int rndis_reset(struct usbnet *usbdev)
 	return 0;
 }
 
-
 /*
  * Specs say that we can only set config parameters only soon after device
  * initialization.
@@ -927,16 +918,9 @@ static int rndis_set_config_parameter(struct usbnet *dev, char *param,
 static int rndis_set_config_parameter_str(struct usbnet *dev,
 						char *param, char *value)
 {
-	return(rndis_set_config_parameter(dev, param, 2, value));
+	return rndis_set_config_parameter(dev, param, 2, value);
 }
 
-/*static int rndis_set_config_parameter_u32(struct usbnet *dev,
-						char *param, u32 value)
-{
-	return(rndis_set_config_parameter(dev, param, 0, &value));
-}*/
-
-
 /*
  * data conversion functions
  */
@@ -946,7 +930,6 @@ static int level_to_qual(int level)
 	return qual >= 0 ? (qual <= 100 ? qual : 100) : 0;
 }
 
-
 /*
  * common functions
  */
@@ -1027,7 +1010,6 @@ static bool is_associated(struct usbnet *usbdev)
 	return (ret == 0 && !is_zero_ether_addr(bssid));
 }
 
-
 static int disassociate(struct usbnet *usbdev, bool reset_ssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1064,7 +1046,6 @@ static int disassociate(struct usbnet *usbdev, bool reset_ssid)
 	return ret;
 }
 
-
 static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 				enum nl80211_auth_type auth_type, int keymgmt)
 {
@@ -1109,7 +1090,6 @@ static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 	return 0;
 }
 
-
 static int set_priv_filter(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1127,7 +1107,6 @@ static int set_priv_filter(struct usbnet *usbdev)
 								sizeof(tmp));
 }
 
-
 static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1163,7 +1142,6 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 	return 0;
 }
 
-
 static int set_infra_mode(struct usbnet *usbdev, int mode)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1189,7 +1167,6 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 	return 0;
 }
 
-
 static int set_rts_threshold(struct usbnet *usbdev, u32 rts_threshold)
 {
 	__le32 tmp;
@@ -1204,7 +1181,6 @@ static int set_rts_threshold(struct usbnet *usbdev, u32 rts_threshold)
 								sizeof(tmp));
 }
 
-
 static int set_frag_threshold(struct usbnet *usbdev, u32 frag_threshold)
 {
 	__le32 tmp;
@@ -1219,7 +1195,6 @@ static int set_frag_threshold(struct usbnet *usbdev, u32 frag_threshold)
 								sizeof(tmp));
 }
 
-
 static void set_default_iw_params(struct usbnet *usbdev)
 {
 	set_infra_mode(usbdev, NDIS_80211_INFRA_INFRA);
@@ -1229,7 +1204,6 @@ static void set_default_iw_params(struct usbnet *usbdev)
 	set_encr_mode(usbdev, RNDIS_WLAN_ALG_NONE, RNDIS_WLAN_ALG_NONE);
 }
 
-
 static int deauthenticate(struct usbnet *usbdev)
 {
 	int ret;
@@ -1239,7 +1213,6 @@ static int deauthenticate(struct usbnet *usbdev)
 	return ret;
 }
 
-
 static int set_channel(struct usbnet *usbdev, int channel)
 {
 	struct ndis_80211_conf config;
@@ -1270,7 +1243,6 @@ static int set_channel(struct usbnet *usbdev, int channel)
 	return ret;
 }
 
-
 /* index must be 0 - N, as per NDIS  */
 static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 								int index)
@@ -1322,7 +1294,6 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	return 0;
 }
 
-
 static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 			int index, const u8 *addr, const u8 *rx_seq,
 			int seq_len, u32 cipher, int flags)
@@ -1417,7 +1388,6 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	return 0;
 }
 
-
 static int restore_key(struct usbnet *usbdev, int key_idx)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1436,7 +1406,6 @@ static int restore_key(struct usbnet *usbdev, int key_idx)
 	return add_wep_key(usbdev, key.material, key.len, key_idx);
 }
 
-
 static void restore_keys(struct usbnet *usbdev)
 {
 	int i;
@@ -1445,13 +1414,11 @@ static void restore_keys(struct usbnet *usbdev)
 		restore_key(usbdev, i);
 }
 
-
 static void clear_key(struct rndis_wlan_private *priv, int idx)
 {
 	memset(&priv->encr_keys[idx], 0, sizeof(priv->encr_keys[idx]));
 }
 
-
 /* remove_key is for both wep and wpa */
 static int remove_key(struct usbnet *usbdev, int index, const u8 *bssid)
 {
@@ -1508,7 +1475,6 @@ static int remove_key(struct usbnet *usbdev, int index, const u8 *bssid)
 	return 0;
 }
 
-
 static void set_multicast_list(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1568,7 +1534,6 @@ static void set_multicast_list(struct usbnet *usbdev)
 						le32_to_cpu(filter), ret);
 }
 
-
 /*
  * cfg80211 ops
  */
@@ -1597,7 +1562,6 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy,
 	return set_infra_mode(usbdev, mode);
 }
 
-
 static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
@@ -1619,7 +1583,6 @@ static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
-
 static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
 				int dbm)
 {
@@ -1642,7 +1605,6 @@ static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
 	return -ENOTSUPP;
 }
 
-
 static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
@@ -1655,7 +1617,6 @@ static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
 	return 0;
 }
 
-
 #define SCAN_DELAY_JIFFIES (6 * HZ)
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request)
@@ -1692,7 +1653,6 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-
 static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 					struct ndis_80211_bssid_ex *bssid)
 {
@@ -1741,7 +1701,6 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 		GFP_KERNEL);
 }
 
-
 static int rndis_check_bssid_list(struct usbnet *usbdev)
 {
 	void *buf = NULL;
@@ -1790,7 +1749,6 @@ out:
 	return ret;
 }
 
-
 static void rndis_get_scan_results(struct work_struct *work)
 {
 	struct rndis_wlan_private *priv =
@@ -2175,7 +2133,9 @@ static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-
+/*
+ * workers, indication handlers, device poller
+ */
 static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2293,7 +2253,6 @@ static void rndis_wlan_set_multicast_list(struct net_device *dev)
 	queue_work(priv->workqueue, &priv->work);
 }
 
-
 static void rndis_wlan_auth_indication(struct usbnet *usbdev,
 				struct ndis_80211_status_indication *indication,
 				int len)
@@ -2476,7 +2435,6 @@ static void rndis_wlan_media_specific_indication(struct usbnet *usbdev,
 	}
 }
 
-
 static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2523,7 +2481,6 @@ static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 	}
 }
 
-
 static int rndis_wlan_get_caps(struct usbnet *usbdev)
 {
 	struct {
@@ -2560,7 +2517,6 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev)
 	return retval;
 }
 
-
 #define DEVICE_POLLER_JIFFIES (HZ)
 static void rndis_device_poller(struct work_struct *work)
 {
@@ -2632,7 +2588,9 @@ end:
 								update_jiffies);
 }
 
-
+/*
+ * driver/device initialization
+ */
 static int bcm4320a_early_init(struct usbnet *usbdev)
 {
 	/* bcm4320a doesn't handle configuration parameters well. Try
@@ -2642,7 +2600,6 @@ static int bcm4320a_early_init(struct usbnet *usbdev)
 	return 0;
 }
 
-
 static int bcm4320b_early_init(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2721,7 +2678,6 @@ static const struct net_device_ops rndis_wlan_netdev_ops = {
 	.ndo_set_multicast_list	= rndis_wlan_set_multicast_list,
 };
 
-
 static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 {
 	struct wiphy *wiphy;
@@ -2840,7 +2796,6 @@ fail:
 	return retval;
 }
 
-
 static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2863,7 +2818,6 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	wiphy_free(priv->wdev.wiphy);
 }
 
-
 static int rndis_wlan_reset(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2885,7 +2839,6 @@ static int rndis_wlan_reset(struct usbnet *usbdev)
 	return deauthenticate(usbdev);
 }
 
-
 static int rndis_wlan_stop(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -2916,7 +2869,6 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 	return retval;
 }
 
-
 static const struct driver_info	bcm4320b_info = {
 	.description =	"Wireless RNDIS device, BCM4320b based",
 	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT |

