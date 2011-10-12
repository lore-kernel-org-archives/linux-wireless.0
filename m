Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4985 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/22] brcm80211: fmac: fixed weird indentation
Date: Wed, 12 Oct 2011 20:51:24 +0200
Message-ID: <1318445492-24207-15-git-send-email-arend@broadcom.com> (sfid-20111012_205209_273472_D60E554A)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

And changed function name to something more appropriate.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   99 ++++++++++----------
 1 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1b09be0..27a748e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1152,7 +1152,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 }
 
 static s32
-brcmf_set_set_sharedkey(struct net_device *ndev,
+brcmf_set_wep_sharedkey(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
@@ -1162,52 +1162,55 @@ brcmf_set_set_sharedkey(struct net_device *ndev,
 	s32 err = 0;
 
 	WL_CONN("key len (%d)\n", sme->key_len);
-	if (sme->key_len) {
-		sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
-		WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
-		       sec->wpa_versions, sec->cipher_pairwise);
-		if (!
-		    (sec->wpa_versions & (NL80211_WPA_VERSION_1 |
-					  NL80211_WPA_VERSION_2))
-&& (sec->cipher_pairwise & (WLAN_CIPHER_SUITE_WEP40 |
-			    WLAN_CIPHER_SUITE_WEP104))) {
-			memset(&key, 0, sizeof(key));
-			key.len = (u32) sme->key_len;
-			key.index = (u32) sme->key_idx;
-			if (key.len > sizeof(key.data)) {
-				WL_ERR("Too long key length (%u)\n", key.len);
-				return -EINVAL;
-			}
-			memcpy(key.data, sme->key, key.len);
-			key.flags = BRCMF_PRIMARY_KEY;
-			switch (sec->cipher_pairwise) {
-			case WLAN_CIPHER_SUITE_WEP40:
-				key.algo = CRYPTO_ALGO_WEP1;
-				break;
-			case WLAN_CIPHER_SUITE_WEP104:
-				key.algo = CRYPTO_ALGO_WEP128;
-				break;
-			default:
-				WL_ERR("Invalid algorithm (%d)\n",
-				       sme->crypto.ciphers_pairwise[0]);
-				return -EINVAL;
-			}
-			/* Set the new key/index */
-			WL_CONN("key length (%d) key index (%d) algo (%d)\n",
-			       key.len, key.index, key.algo);
-			WL_CONN("key \"%s\"\n", key.data);
-			err = send_key_to_dongle(ndev, &key);
-			if (err)
-				return err;
 
-			if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
-				WL_CONN("set auth_type to shared key\n");
-				val = 1;	/* shared key */
-				err = brcmf_dev_intvar_set(ndev, "auth", val);
-				if (err) {
-					WL_ERR("set auth failed (%d)\n", err);
-					return err;
-				}
+	if (sme->key_len == 0)
+		return 0;
+
+	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
+		sec->wpa_versions, sec->cipher_pairwise);
+
+	if (sec->wpa_versions & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2))
+		return 0;
+
+	if (sec->cipher_pairwise &
+	    (WLAN_CIPHER_SUITE_WEP40 | WLAN_CIPHER_SUITE_WEP104)) {
+		memset(&key, 0, sizeof(key));
+		key.len = (u32) sme->key_len;
+		key.index = (u32) sme->key_idx;
+		if (key.len > sizeof(key.data)) {
+			WL_ERR("Too long key length (%u)\n", key.len);
+			return -EINVAL;
+		}
+		memcpy(key.data, sme->key, key.len);
+		key.flags = BRCMF_PRIMARY_KEY;
+		switch (sec->cipher_pairwise) {
+		case WLAN_CIPHER_SUITE_WEP40:
+			key.algo = CRYPTO_ALGO_WEP1;
+			break;
+		case WLAN_CIPHER_SUITE_WEP104:
+			key.algo = CRYPTO_ALGO_WEP128;
+			break;
+		default:
+			WL_ERR("Invalid algorithm (%d)\n",
+			       sme->crypto.ciphers_pairwise[0]);
+			return -EINVAL;
+		}
+		/* Set the new key/index */
+		WL_CONN("key length (%d) key index (%d) algo (%d)\n",
+			key.len, key.index, key.algo);
+		WL_CONN("key \"%s\"\n", key.data);
+		err = send_key_to_dongle(ndev, &key);
+		if (err)
+			return err;
+
+		if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
+			WL_CONN("set auth_type to shared key\n");
+			val = 1;	/* shared key */
+			err = brcmf_dev_intvar_set(ndev, "auth", val);
+			if (err) {
+				WL_ERR("set auth failed (%d)\n", err);
+				return err;
 			}
 		}
 	}
@@ -1271,9 +1274,9 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	err = brcmf_set_set_sharedkey(ndev, sme);
+	err = brcmf_set_wep_sharedkey(ndev, sme);
 	if (err) {
-		WL_ERR("wl_set_set_sharedkey failed (%d)\n", err);
+		WL_ERR("brcmf_set_wep_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
-- 
1.7.4.1


