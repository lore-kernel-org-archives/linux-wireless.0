Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47213 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaKOTGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 14:06:36 -0500
Received: by mail-pd0-f171.google.com with SMTP id r10so18673726pdi.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2014 11:06:35 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 1/2] ath9k|ath9k_htc: Seperate the software crypto flag for Tx and Rx
Date: Sun, 16 Nov 2014 03:05:40 +0800
Message-Id: <1416078341-4411-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20141115_201538_352149_9B4CFD40)
In-Reply-To: <1416078341-4411-1-git-send-email-yeohchunyeow@gmail.com>
References: <1416078341-4411-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the sw_mgmt_crypto_tx flag to trigger the CCMP encryption
for transmitted management frames to be done in software while
the sw_mgmt_crypto_rx flag is used to trigger the CCMP decryption
for received management frames to be done in software.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common.c       | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c           | 9 ++++++---
 drivers/net/wireless/ath/ath9k/hw.h           | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c         | 2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 33b0c7a..e8c6994 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -159,7 +159,7 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 		if (test_bit(keyix, common->keymap))
 			rxs->flag |= RX_FLAG_DECRYPTED;
 	}
-	if (ah->sw_mgmt_crypto &&
+	if (ah->sw_mgmt_crypto_rx &&
 	    (rxs->flag & RX_FLAG_DECRYPTED) &&
 	    ieee80211_is_mgmt(fc))
 		/* Use software decrypt for management frames. */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 689ac99..c7d12ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1447,7 +1447,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (priv->ah->sw_mgmt_crypto &&
+			if (priv->ah->sw_mgmt_crypto_tx &&
 			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 04ae1f8..a53d304 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1585,16 +1585,19 @@ static void ath9k_hw_init_mfp(struct ath_hw *ah)
 		 * frames when constructing CCMP AAD. */
 		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
 			      0xc7ff);
-		ah->sw_mgmt_crypto = false;
+		ah->sw_mgmt_crypto_tx = false;
+		ah->sw_mgmt_crypto_rx = false;
 	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
 		/* Disable hardware crypto for management frames */
 		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
 			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
 		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
 			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
-		ah->sw_mgmt_crypto = true;
+		ah->sw_mgmt_crypto_tx = true;
+		ah->sw_mgmt_crypto_rx = true;
 	} else {
-		ah->sw_mgmt_crypto = true;
+		ah->sw_mgmt_crypto_tx = true;
+		ah->sw_mgmt_crypto_rx = true;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e49721e8..55ee0a5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -753,7 +753,8 @@ struct ath_hw {
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
 
-	bool sw_mgmt_crypto;
+	bool sw_mgmt_crypto_tx;
+	bool sw_mgmt_crypto_rx;
 	bool is_pciexpress;
 	bool aspm_enabled;
 	bool is_monitoring;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 644552c..6bf87c0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1657,7 +1657,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-			if (sc->sc_ah->sw_mgmt_crypto &&
+			if (sc->sc_ah->sw_mgmt_crypto_tx &&
 			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
-- 
2.1.1

