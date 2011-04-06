Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53692 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DFMOs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 08:14:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 05:14:23 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2] ath9k_hw: Fix instable target power control b/w CCK/OFDM
Date: Wed, 6 Apr 2011 17:44:52 +0530
Message-ID: <1302092092-11896-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The problem is that when the attenuation is increased,
the rate will start to drop from MCS7 -> MCS6, and finally
will see MCS1 -> CCK_11Mbps. When the rate is changed b/w
CCK and OFDM, it will use register desired_scale to calculate
how much tx gain need to change.

The output power with the same tx gain for CCK and OFDM modulated
signals are different. This difference is constant for AR9280
but not AR9285/AR9271. It has different PA architecture
a constant. So it should be calibrated against this PA
characteristic.

The driver has to read the calibrated values from EEPROM and set
the tx power registers accordingly.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2 : removed magic macro and a for loop

 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    6 +++++
 drivers/net/wireless/ath/ath9k/eeprom.h     |    6 ++++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c  |   33 +++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 37663db..47780ef 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -483,7 +483,11 @@
 #define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN     0x01F80000
 #define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN_S   19
 
+#define AR_PHY_TX_PWRCTRL8       0xa278
+
 #define AR_PHY_TX_PWRCTRL9       0xa27C
+
+#define AR_PHY_TX_PWRCTRL10       0xa394
 #define AR_PHY_TX_DESIRED_SCALE_CCK        0x00007C00
 #define AR_PHY_TX_DESIRED_SCALE_CCK_S      10
 #define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL  0x80000000
@@ -495,6 +499,8 @@
 
 #define AR_PHY_CH0_TX_PWRCTRL11  0xa398
 #define AR_PHY_CH1_TX_PWRCTRL11  0xb398
+#define AR_PHY_CH0_TX_PWRCTRL12  0xa3dc
+#define AR_PHY_CH0_TX_PWRCTRL13  0xa3e0
 #define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP   0x0000FC00
 #define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP_S 10
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index bd82447..3e31613 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -436,7 +436,11 @@ struct modal_eep_4k_header {
 	u8 db2_2:4, db2_3:4;
 	u8 db2_4:4, reserved:4;
 #endif
-	u8 futureModal[4];
+	u8 tx_diversity;
+	u8 flc_pwr_thresh;
+	u8 bb_scale_smrt_antenna;
+#define EEP_4K_BB_DESIRED_SCALE_MASK	0x1f
+	u8 futureModal[1];
 	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index bc77a30..28851b5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -781,6 +781,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 {
 	struct modal_eep_4k_header *pModal;
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
+	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
 	u8 txRxAttenLocal;
 	u8 ob[5], db1[5], db2[5];
 	u8 ant_div_control1, ant_div_control2;
@@ -1003,6 +1004,38 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 				      AR_PHY_SETTLING_SWITCH,
 				      pModal->swSettleHt40);
 	}
+	if (AR_SREV_9271(ah) || AR_SREV_9285(ah)) {
+		u8 bb_desired_scale = (pModal->bb_scale_smrt_antenna &
+				EEP_4K_BB_DESIRED_SCALE_MASK);
+		if ((pBase->txGainType == 0) && (bb_desired_scale != 0)) {
+			u32 pwrctrl, mask;
+
+			/* AR_PHY_TX_PWRCTRL8 */
+			mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
+			pwrctrl = mask * bb_desired_scale;
+			REG_RMW(ah, AR_PHY_TX_PWRCTRL8, pwrctrl, 0x3fffffff);
+
+			/* AR_PHY_TX_PWRCTRL9 */
+			mask = BIT(0)|BIT(5)|BIT(15);
+			pwrctrl = mask * bb_desired_scale;
+			REG_RMW(ah, AR_PHY_TX_PWRCTRL9, pwrctrl, 0xf83ff);
+
+			/* AR_PHY_TX_PWRCTRL10 */
+			mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
+			pwrctrl = mask * bb_desired_scale;
+			REG_RMW(ah, AR_PHY_TX_PWRCTRL10, pwrctrl, 0x3fffffff);
+
+			/* AR_PHY_CH0_TX_PWRCTRL11 */
+			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL11, pwrctrl, 0x3ff);
+
+			/* AR_PHY_CH0_TX_PWRCTRL12 */
+			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL12,
+				pwrctrl, 0x3fffffff);
+
+			/* AR_PHY_CH0_TX_PWRCTRL13 */
+			REG_RMW(ah, AR_PHY_CH0_TX_PWRCTRL13, pwrctrl, 0x3ff);
+		}
+	}
 }
 
 static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
-- 
1.7.4.3

