Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZCMDaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53837.603530.332324@gargle.gargle.HOWL> (sfid-20090313_043016_483082_AA5866F7)
Date: Fri, 13 Mar 2009 08:56:05 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/7] ath9k: Change return type for set_board_values()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We always return true, checking for 'false' return value
is bogus anyway, so fix this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    8 ++------
 drivers/net/wireless/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath9k/hw.c     |    6 +-----
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index c3bb196..973b576 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1232,7 +1232,7 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 }
 
-static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
+static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
 	struct modal_eep_4k_header *pModal;
@@ -1378,8 +1378,6 @@ static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 				      AR_PHY_SETTLING_SWITCH,
 				      pModal->swSettleHt40);
 	}
-
-	return true;
 }
 
 static u16 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
@@ -1718,7 +1716,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 	}
 }
 
-static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
+static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 					  struct ath9k_channel *chan)
 {
 	struct modal_eep_header *pModal;
@@ -1884,8 +1882,6 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			      AR_PHY_TX_DESIRED_SCALE_CCK,
 			      eep->baseEepHeader.desiredScaleCCK);
 	}
-
-	return true;
 }
 
 static void ath9k_hw_def_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 0a4b22a..8e5b880 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -490,7 +490,7 @@ struct eeprom_ops {
 	u8 (*get_num_ant_config)(struct ath_hw *hw, enum ieee80211_band band);
 	u16 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
 				      struct ath9k_channel *chan);
-	bool (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
+	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
 	int (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
 			   u16 cfgCtl, u8 twiceAntennaReduction,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 00c9e78..7555894 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2283,11 +2283,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	else
 		ath9k_hw_spur_mitigate(ah, chan);
 
-	if (!ah->eep_ops->set_board_values(ah, chan)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"error setting board options\n");
-		return -EIO;
-	}
+	ah->eep_ops->set_board_values(ah, chan);
 
 	ath9k_hw_decrease_chain_power(ah, chan);
 
-- 
1.6.2

