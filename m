Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45329 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaLULoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: Fix WEP configuration for AP mode.
Date: Sun, 21 Dec 2014 12:43:49 +0100
Message-ID: <1419162233-19492-7-git-send-email-arend@broadcom.com> (sfid-20141221_124420_264698_95EE2D45)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When a device is configured for AP mode and it is configured for
WEP then the keys are plumbed first, followed by AP configuration.
During configuration a down command is given to the firmware which
will clear the configured keys. This patch reprograms the WEP keys
after AP has been brought up.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 95 ++++++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |  4 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  4 +-
 4 files changed, 76 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 3aecc5f..1172551 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -452,16 +452,16 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
+send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
 	convert_key_from_CPU(key, &key_le);
 
-	brcmf_netdev_wait_pend8021x(ndev);
+	brcmf_netdev_wait_pend8021x(ifp);
 
-	err = brcmf_fil_bsscfg_data_set(netdev_priv(ndev), "wsec_key", &key_le,
+	err = brcmf_fil_bsscfg_data_set(ifp, "wsec_key", &key_le,
 					sizeof(key_le));
 
 	if (err)
@@ -1670,7 +1670,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	brcmf_dbg(CONN, "key length (%d) key index (%d) algo (%d)\n",
 		  key.len, key.index, key.algo);
 	brcmf_dbg(CONN, "key \"%s\"\n", key.data);
-	err = send_key_to_dongle(ndev, &key);
+	err = send_key_to_dongle(netdev_priv(ndev), &key);
 	if (err)
 		return err;
 
@@ -2052,7 +2052,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		err = send_key_to_dongle(ndev, &key);
+		err = send_key_to_dongle(ifp, &key);
 		if (err)
 			brcmf_err("key delete error (%d)\n", err);
 	} else {
@@ -2108,7 +2108,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
-		err = send_key_to_dongle(ndev, &key);
+		err = send_key_to_dongle(ifp, &key);
 		if (err)
 			brcmf_err("wsec_key error (%d)\n", err);
 	}
@@ -2121,7 +2121,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		    struct key_params *params)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_wsec_key key;
+	struct brcmf_wsec_key *key;
 	s32 val;
 	s32 wsec;
 	s32 err = 0;
@@ -2132,54 +2132,62 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
+	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
+		/* we ignore this key index in this case */
+		brcmf_err("invalid key index (%d)\n", key_idx);
+		return -EINVAL;
+	}
+
 	if (mac_addr &&
 		(params->cipher != WLAN_CIPHER_SUITE_WEP40) &&
 		(params->cipher != WLAN_CIPHER_SUITE_WEP104)) {
 		brcmf_dbg(TRACE, "Exit");
 		return brcmf_add_keyext(wiphy, ndev, key_idx, mac_addr, params);
 	}
-	memset(&key, 0, sizeof(key));
 
-	key.len = (u32) params->key_len;
-	key.index = (u32) key_idx;
+	key = &ifp->vif->profile.key[key_idx];
+	memset(key, 0, sizeof(*key));
 
-	if (key.len > sizeof(key.data)) {
-		brcmf_err("Too long key length (%u)\n", key.len);
+	if (params->key_len > sizeof(key->data)) {
+		brcmf_err("Too long key length (%u)\n", params->key_len);
 		err = -EINVAL;
 		goto done;
 	}
-	memcpy(key.data, params->key, key.len);
+	key->len = params->key_len;
+	key->index = key_idx;
 
-	key.flags = BRCMF_PRIMARY_KEY;
+	memcpy(key->data, params->key, key->len);
+
+	key->flags = BRCMF_PRIMARY_KEY;
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-		key.algo = CRYPTO_ALGO_WEP1;
+		key->algo = CRYPTO_ALGO_WEP1;
 		val = WEP_ENABLED;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP40\n");
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
-		key.algo = CRYPTO_ALGO_WEP128;
+		key->algo = CRYPTO_ALGO_WEP128;
 		val = WEP_ENABLED;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		if (!brcmf_is_apmode(ifp->vif)) {
 			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
-			memcpy(keybuf, &key.data[24], sizeof(keybuf));
-			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
-			memcpy(&key.data[16], keybuf, sizeof(keybuf));
+			memcpy(keybuf, &key->data[24], sizeof(keybuf));
+			memcpy(&key->data[24], &key->data[16], sizeof(keybuf));
+			memcpy(&key->data[16], keybuf, sizeof(keybuf));
 		}
-		key.algo = CRYPTO_ALGO_TKIP;
+		key->algo = CRYPTO_ALGO_TKIP;
 		val = TKIP_ENABLED;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		key.algo = CRYPTO_ALGO_AES_CCM;
+		key->algo = CRYPTO_ALGO_AES_CCM;
 		val = AES_ENABLED;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		key.algo = CRYPTO_ALGO_AES_CCM;
+		key->algo = CRYPTO_ALGO_AES_CCM;
 		val = AES_ENABLED;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 		break;
@@ -2189,7 +2197,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	err = send_key_to_dongle(ndev, &key);
+	err = send_key_to_dongle(ifp, key);
 	if (err)
 		goto done;
 
@@ -2222,7 +2230,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	if (key_idx >= DOT11_MAX_DEFAULT_KEYS) {
+	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
 		brcmf_err("invalid key index (%d)\n", key_idx);
 		return -EINVAL;
@@ -2237,7 +2245,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 
 	/* Set the new key/index */
-	err = send_key_to_dongle(ndev, &key);
+	err = send_key_to_dongle(ifp, &key);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -2305,6 +2313,39 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 	return -EOPNOTSUPP;
 }
 
+static void
+brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
+{
+	s32 err;
+	u8 key_idx;
+	struct brcmf_wsec_key *key;
+	s32 wsec;
+
+	for (key_idx = 0; key_idx < BRCMF_MAX_DEFAULT_KEYS; key_idx++) {
+		key = &ifp->vif->profile.key[key_idx];
+		if ((key->algo == CRYPTO_ALGO_WEP1) ||
+		    (key->algo == CRYPTO_ALGO_WEP128))
+			break;
+	}
+	if (key_idx == BRCMF_MAX_DEFAULT_KEYS)
+		return;
+
+	err = send_key_to_dongle(ifp, key);
+	if (err) {
+		brcmf_err("Setting WEP key failed (%d)\n", err);
+		return;
+	}
+	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
+	if (err) {
+		brcmf_err("get wsec error (%d)\n", err);
+		return;
+	}
+	wsec |= WEP_ENABLED;
+	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
+	if (err)
+		brcmf_err("set wsec error (%d)\n", err);
+}
+
 static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
@@ -4057,6 +4098,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("BRCMF_C_UP error (%d)\n", err);
 			goto exit;
 		}
+		/* On DOWN the firmware removes the WEP keys, reconfigure
+		 * them if they were set.
+		 */
+		brcmf_cfg80211_reconfigure_wep(ifp);
 
 		memset(&join_params, 0, sizeof(join_params));
 		/* join parameters starts with ssid */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index 9e98b8d..a5242af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -75,6 +75,8 @@
 
 #define BRCMF_VNDR_IE_P2PAF_SHIFT	12
 
+#define BRCMF_MAX_DEFAULT_KEYS		4
+
 
 /**
  * enum brcmf_scan_status - scan engine status
@@ -125,11 +127,13 @@ struct brcmf_cfg80211_security {
  * @ssid: ssid of associated/associating ap.
  * @bssid: bssid of joined/joining ibss.
  * @sec: security information.
+ * @key: key information
  */
 struct brcmf_cfg80211_profile {
 	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	struct brcmf_cfg80211_security sec;
+	struct brcmf_wsec_key key[BRCMF_MAX_DEFAULT_KEYS];
 };
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index effe6d7..e2a9e33 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -1093,9 +1093,8 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_if *ifp)
 	return atomic_read(&ifp->pend_8021x_cnt);
 }
 
-int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
+int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	int err;
 
 	err = wait_event_timeout(ifp->pend_8021x_wait,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 23f74b1..f2f7d3d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -29,8 +29,6 @@
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
 
-#define DOT11_MAX_DEFAULT_KEYS	4
-
 /* Small, medium and maximum buffer size for dcmd
  */
 #define BRCMF_DCMD_SMLEN	256
@@ -167,7 +165,7 @@ struct brcmf_skb_reorder_data {
 	u8 *reorder;
 };
 
-int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
+int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
 
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
-- 
1.9.1

