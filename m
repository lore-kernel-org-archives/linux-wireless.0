Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:43636 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757871Ab0IHHFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:15 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0739479514
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:14 +0900 (JST)
Subject: [PATCH 3/8] ath5k: Use common ath key management functions
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:43 +0900
Message-ID: <20100908070443.11255.13951.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use common ath key management functions in ath5k. This fixes problems with HW
encryption in AP mode, which was broken in the ath5k implementation.

Before (with the ath5k implementation) only one client could connect to the AP
using HW encryption and WPA. When a second client connected, the first client
was not able to send/receive any more packets. Because of the problems with HW
encryption, software encryption was always used in AP mode, which resulted in a
high CPU load (and/or low thruput) on embedded devices. Instead of trying to
fix the implementation in ath5k it makes more sense to share the code with
ath9k.

This also enables HW encryption for AP mode again.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/attach.c |    3 +++
 drivers/net/wireless/ath/ath5k/base.c   |   33 +++++++++++++------------------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index aabad4f..eb125d6 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -314,6 +314,9 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	}
 
 	/* Crypto settings */
+	common->keymax = (sc->ah->ah_version == AR5K_AR5210 ?
+			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
+
 	ah->ah_aes_support = srev >= AR5K_SREV_AR5212_V4 &&
 		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
 		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5));
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 116ac66..9e907da 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2574,6 +2574,7 @@ static int
 ath5k_init(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, i;
 
 	mutex_lock(&sc->lock);
@@ -2609,8 +2610,8 @@ ath5k_init(struct ath5k_softc *sc)
 	 * Reset the key cache since some parts do not reset the
 	 * contents on initial power up or resume from suspend.
 	 */
-	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
+	for (i = 0; i < common->keymax; i++)
+		ath_hw_keyreset(common, (u16)i);
 
 	ath5k_hw_set_ack_bitrate_high(ah, true);
 	ret = 0;
@@ -3291,9 +3292,6 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
-	if (sc->opmode == NL80211_IFTYPE_AP)
-		return -EOPNOTSUPP;
-
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -3302,7 +3300,6 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (sc->ah->ah_aes_support)
 			break;
-
 		return -EOPNOTSUPP;
 	default:
 		WARN_ON(1);
@@ -3313,27 +3310,25 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key,
-				       sta ? sta->addr : NULL);
-		if (ret) {
-			ATH5K_ERR(sc, "can't set the key\n");
-			goto unlock;
+		ret = ath_key_config(common, vif, sta, key);
+		if (ret >= 0) {
+			key->hw_key_idx = ret;
+			/* push IV and Michael MIC generation to stack */
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
+				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
+			ret = 0;
 		}
-		__set_bit(key->keyidx, common->keymap);
-		key->hw_key_idx = key->keyidx;
-		key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
-			       IEEE80211_KEY_FLAG_GENERATE_MMIC);
 		break;
 	case DISABLE_KEY:
-		ath5k_hw_reset_key(sc->ah, key->keyidx);
-		__clear_bit(key->keyidx, common->keymap);
+		ath_key_delete(common, key);
 		break;
 	default:
 		ret = -EINVAL;
-		goto unlock;
 	}
 
-unlock:
 	mmiowb();
 	mutex_unlock(&sc->lock);
 	return ret;

