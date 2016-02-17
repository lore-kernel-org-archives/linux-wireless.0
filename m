Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:28493
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161119AbcBQK13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:29 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 20/21] brcmfmac: integrate add_keyext in add_key
Date: Wed, 17 Feb 2016 11:27:09 +0100
Message-Id: <1455704830-10088-21-git-send-email-arend@broadcom.com> (sfid-20160217_112749_299537_64FD7B08)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

brcmf_add_keyext is called when a key is configured for a specific
mac address. This function is very similar to the calling function
brcmf_add_key. Integrate this function and also use existing del_key
function in case key is to be cleared.

Reviewed-by: Arend Van Spriel <arend.van@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 154 ++++++---------------
 1 file changed, 39 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5e3acac..5203d8f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2073,84 +2073,34 @@ done:
 }
 
 static s32
-brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
-	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
+brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
+		       u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
-	u8 keybuf[8];
+
+	brcmf_dbg(TRACE, "Enter\n");
+	if (!check_vif_up(ifp->vif))
+		return -EIO;
+
+	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
+		/* we ignore this key index in this case */
+		return -EINVAL;
+	}
 
 	memset(&key, 0, sizeof(key));
-	key.index = (u32) key_idx;
-	/* Instead of bcast for ea address for default wep keys,
-		 driver needs it to be Null */
-	if (!is_multicast_ether_addr(mac_addr))
-		memcpy((char *)&key.ea, (void *)mac_addr, ETH_ALEN);
-	key.len = (u32) params->key_len;
-	/* check for key index change */
-	if (key.len == 0) {
-		/* key delete */
-		err = send_key_to_dongle(ifp, &key);
-		if (err)
-			brcmf_err("key delete error (%d)\n", err);
-	} else {
-		if (key.len > sizeof(key.data)) {
-			brcmf_err("Invalid key length (%d)\n", key.len);
-			return -EINVAL;
-		}
 
-		brcmf_dbg(CONN, "Setting the key index %d\n", key.index);
-		memcpy(key.data, params->key, key.len);
+	key.index = (u32)key_idx;
+	key.flags = BRCMF_PRIMARY_KEY;
+	key.algo = CRYPTO_ALGO_OFF;
 
-		if (!brcmf_is_apmode(ifp->vif) &&
-		    (params->cipher == WLAN_CIPHER_SUITE_TKIP)) {
-			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
-			memcpy(keybuf, &key.data[24], sizeof(keybuf));
-			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
-			memcpy(&key.data[16], keybuf, sizeof(keybuf));
-		}
+	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
 
-		/* if IW_ENCODE_EXT_RX_SEQ_VALID set */
-		if (params->seq && params->seq_len == 6) {
-			/* rx iv */
-			u8 *ivptr;
-			ivptr = (u8 *) params->seq;
-			key.rxiv.hi = (ivptr[5] << 24) | (ivptr[4] << 16) |
-			    (ivptr[3] << 8) | ivptr[2];
-			key.rxiv.lo = (ivptr[1] << 8) | ivptr[0];
-			key.iv_initialized = true;
-		}
+	/* Set the new key/index */
+	err = send_key_to_dongle(ifp, &key);
 
-		switch (params->cipher) {
-		case WLAN_CIPHER_SUITE_WEP40:
-			key.algo = CRYPTO_ALGO_WEP1;
-			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP40\n");
-			break;
-		case WLAN_CIPHER_SUITE_WEP104:
-			key.algo = CRYPTO_ALGO_WEP128;
-			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
-			break;
-		case WLAN_CIPHER_SUITE_TKIP:
-			key.algo = CRYPTO_ALGO_TKIP;
-			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
-			break;
-		case WLAN_CIPHER_SUITE_AES_CMAC:
-			key.algo = CRYPTO_ALGO_AES_CCM;
-			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
-			break;
-		case WLAN_CIPHER_SUITE_CCMP:
-			key.algo = CRYPTO_ALGO_AES_CCM;
-			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
-			break;
-		default:
-			brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
-			return -EINVAL;
-		}
-		err = send_key_to_dongle(ifp, &key);
-		if (err)
-			brcmf_err("wsec_key error (%d)\n", err);
-	}
+	brcmf_dbg(TRACE, "Exit\n");
 	return err;
 }
 
@@ -2163,8 +2113,9 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_wsec_key *key;
 	s32 val;
 	s32 wsec;
-	s32 err = 0;
+	s32 err;
 	u8 keybuf[8];
+	bool ext_key;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
@@ -2177,27 +2128,32 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -EINVAL;
 	}
 
-	if (mac_addr &&
-		(params->cipher != WLAN_CIPHER_SUITE_WEP40) &&
-		(params->cipher != WLAN_CIPHER_SUITE_WEP104)) {
-		brcmf_dbg(TRACE, "Exit");
-		return brcmf_add_keyext(wiphy, ndev, key_idx, mac_addr, params);
-	}
-
-	key = &ifp->vif->profile.key[key_idx];
-	memset(key, 0, sizeof(*key));
+	if (params->key_len == 0)
+		return brcmf_cfg80211_del_key(wiphy, ndev, key_idx, pairwise,
+					      mac_addr);
 
 	if (params->key_len > sizeof(key->data)) {
 		brcmf_err("Too long key length (%u)\n", params->key_len);
-		err = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
+
+	ext_key = false;
+	if (mac_addr && (params->cipher != WLAN_CIPHER_SUITE_WEP40) &&
+	    (params->cipher != WLAN_CIPHER_SUITE_WEP104)) {
+		brcmf_dbg(TRACE, "Ext key, mac %pM", mac_addr);
+		ext_key = true;
+	}
+
+	key = &ifp->vif->profile.key[key_idx];
+	memset(key, 0, sizeof(*key));
+	if ((ext_key) && (!is_multicast_ether_addr(mac_addr)))
+		memcpy((char *)&key->ea, (void *)mac_addr, ETH_ALEN);
 	key->len = params->key_len;
 	key->index = key_idx;
-
 	memcpy(key->data, params->key, key->len);
+	if (!ext_key)
+		key->flags = BRCMF_PRIMARY_KEY;
 
-	key->flags = BRCMF_PRIMARY_KEY;
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key->algo = CRYPTO_ALGO_WEP1;
@@ -2237,7 +2193,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	err = send_key_to_dongle(ifp, key);
-	if (err)
+	if (ext_key || err)
 		goto done;
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
@@ -2258,38 +2214,6 @@ done:
 }
 
 static s32
-brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
-		    u8 key_idx, bool pairwise, const u8 *mac_addr)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_wsec_key key;
-	s32 err = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
-
-	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
-		/* we ignore this key index in this case */
-		return -EINVAL;
-	}
-
-	memset(&key, 0, sizeof(key));
-
-	key.index = (u32) key_idx;
-	key.flags = BRCMF_PRIMARY_KEY;
-	key.algo = CRYPTO_ALGO_OFF;
-
-	brcmf_dbg(CONN, "key index (%d)\n", key_idx);
-
-	/* Set the new key/index */
-	err = send_key_to_dongle(ifp, &key);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-}
-
-static s32
 brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr, void *cookie,
 		    void (*callback) (void *cookie, struct key_params * params))
-- 
1.9.1

