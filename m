Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:2847 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757729Ab0IHHFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:31 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0742099530
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:30 +0900 (JST)
Subject: [PATCH 6/8] ath5k: Use common crypt capabilities flags
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:59 +0900
Message-ID: <20100908070459.11255.52256.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ah_aes_support and ah_combined_mic with common ath_crypt_caps
ATH_CRYPT_CAP_CIPHER_AESCCM and ATH_CRYPT_CAP_MIC_COMBINED.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 --
 drivers/net/wireless/ath/ath5k/attach.c |   10 ++++++----
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 932ed56..50209ae 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1028,8 +1028,6 @@ struct ath5k_hw {
 	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_single_chip;
-	bool			ah_aes_support;
-	bool			ah_combined_mic;
 
 	enum ath5k_version	ah_version;
 	enum ath5k_radio	ah_radio;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index eb125d6..a0e0820 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -317,12 +317,14 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	common->keymax = (sc->ah->ah_version == AR5K_AR5210 ?
 			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
 
-	ah->ah_aes_support = srev >= AR5K_SREV_AR5212_V4 &&
-		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
-		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5));
+	if (srev >= AR5K_SREV_AR5212_V4 &&
+	    (ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
+	    !AR5K_EEPROM_AES_DIS(ee->ee_misc5)))
+		common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM |
+					ATH_CRYPT_CAP_MIC_AESCCM;
 
 	if (srev >= AR5K_SREV_AR2414) {
-		ah->ah_combined_mic = true;
+		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
 		AR5K_REG_ENABLE_BITS(ah, AR5K_MISC_MODE,
 			AR5K_MISC_MODE_COMBINED_MIC);
 	}
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9e907da..f8c699d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3298,7 +3298,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_TKIP:
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		if (sc->ah->ah_aes_support)
+		if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
 			break;
 		return -EOPNOTSUPP;
 	default:

