Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34819 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0KTTWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 14:22:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: fix more bitfield related endian issues
Date: Sat, 20 Nov 2010 20:22:50 +0100
Message-Id: <1290280970-37519-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few LNA control related flags were also specified as a bitfields, however
for some strange reason they were written in big-endian order this time.
Fix this by using flags instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kenrel.org
---
 drivers/net/wireless/ath/ath9k/eeprom.h     |   14 ++++++++++----
 drivers/net/wireless/ath/ath9k/eeprom_def.c |   11 ++++++-----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 5766ce9..8a644fc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -236,6 +236,15 @@
 #define CTL_EDGE_TPOWER(_ctl) ((_ctl) & 0x3f)
 #define CTL_EDGE_FLAGS(_ctl) (((_ctl) >> 6) & 0x03)
 
+#define LNA_CTL_BUF_MODE	BIT(0)
+#define LNA_CTL_ISEL_LO		BIT(1)
+#define LNA_CTL_ISEL_HI		BIT(2)
+#define LNA_CTL_BUF_IN		BIT(3)
+#define LNA_CTL_FEM_BAND	BIT(4)
+#define LNA_CTL_LOCAL_BIAS	BIT(5)
+#define LNA_CTL_FORCE_XPA	BIT(6)
+#define LNA_CTL_USE_ANT1	BIT(7)
+
 enum eeprom_param {
 	EEP_NFTHRESH_5,
 	EEP_NFTHRESH_2,
@@ -381,10 +390,7 @@ struct modal_eep_header {
 	u8 xatten2Margin[AR5416_MAX_CHAINS];
 	u8 ob_ch1;
 	u8 db_ch1;
-	u8 useAnt1:1,
-	    force_xpaon:1,
-	    local_bias:1,
-	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
+	u8 lna_ctl;
 	u8 miscBits;
 	u16 xpaBiasLvlFreq[3];
 	u8 futureModal[6];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index a819ddc..b1b48ef 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -451,9 +451,10 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 		ath9k_hw_analog_shift_rmw(ah, AR_AN_TOP2,
 					  AR_AN_TOP2_LOCALBIAS,
 					  AR_AN_TOP2_LOCALBIAS_S,
-					  pModal->local_bias);
+					  !!(pModal->lna_ctl &
+					     LNA_CTL_LOCAL_BIAS));
 		REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
-			      pModal->force_xpaon);
+			      !!(pModal->lna_ctl & LNA_CTL_FORCE_XPA));
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
@@ -1432,9 +1433,9 @@ static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 
 	num_ant_config = 1;
 
-	if (pBase->version >= 0x0E0D)
-		if (pModal->useAnt1)
-			num_ant_config += 1;
+	if (pBase->version >= 0x0E0D &&
+	    (pModal->lna_ctl & LNA_CTL_USE_ANT1))
+		num_ant_config += 1;
 
 	return num_ant_config;
 }
-- 
1.7.3.2

