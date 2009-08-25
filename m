Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3181 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZHYDBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:01:36 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/4] ath5k: add hardware CCMP encyption support
Date: Mon, 24 Aug 2009 23:00:33 -0400
Message-Id: <1251169233-24169-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent ath5k hardware is capable of doing CCMP acceleration.
Enable it for the cards that support it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 +
 drivers/net/wireless/ath/ath5k/attach.c |   10 ++++++++++
 drivers/net/wireless/ath/ath5k/base.c   |    3 +++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 862762c..cdc79cd 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1037,6 +1037,7 @@ struct ath5k_hw {
 	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_single_chip;
+	bool			ah_aes_support;
 	bool			ah_combined_mic;
 
 	enum ath5k_version	ah_version;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 65d438b..109ab7b 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -106,6 +106,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 {
 	struct ath5k_hw *ah;
 	struct pci_dev *pdev = sc->pdev;
+	struct ath5k_eeprom_info *ee;
 	int ret;
 	u32 srev;
 
@@ -315,6 +316,15 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 	}
 
+	/* Crypto settings */
+	ee = &ah->ah_capabilities.cap_eeprom;
+	ah->ah_aes_support =
+		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
+		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5) &&
+		 (ah->ah_mac_version > (AR5K_SREV_AR5212 >> 4) ||
+		  (ah->ah_mac_version == (AR5K_SREV_AR5212 >> 4) &&
+		   ah->ah_mac_revision >= (AR5K_SREV_AR5211 >> 4))));
+
 	if (srev >= AR5K_SREV_AR2414) {
 		ah->ah_combined_mic = true;
 		AR5K_REG_ENABLE_BITS(ah, AR5K_MISC_MODE,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 10bf015..94d46fd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3022,6 +3022,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case ALG_TKIP:
 		break;
 	case ALG_CCMP:
+		if (sc->ah->ah_aes_support)
+			break;
+
 		return -EOPNOTSUPP;
 	default:
 		WARN_ON(1);
-- 
1.6.2.5


