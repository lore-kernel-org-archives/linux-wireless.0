Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44610 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 04/10] ath9k_hw: turn a few big macros into functions
Date: Wed, 23 Mar 2011 20:57:27 +0100
Message-Id: <1300910253-28189-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-3-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RF_BANK_SETUP, REG_WRITE_RF_ARRAY and REG_WRITE_ARRAY are way too big,
so they shouldn't be inlined at every single callsite, especially since they
can easily be turned into real functions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   38 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/hw.c         |   14 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |   14 +++-------
 drivers/net/wireless/ath/ath9k/phy.h        |   16 -----------
 4 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 94acce5..4361704 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -44,6 +44,34 @@ static const int m1ThreshExt_off = 127;
 static const int m2ThreshExt_off = 127;
 
 
+static void ar5008_rf_bank_setup(u32 *bank, struct ar5416IniArray *array,
+				 int col)
+{
+	int i;
+
+	for (i = 0; i < array->ia_rows; i++)
+		bank[i] = INI_RA(array, i, col);
+}
+
+
+#define REG_WRITE_RF_ARRAY(iniarray, regData, regWr) \
+	ar5008_write_rf_array(ah, iniarray, regData, &(regWr))
+
+static void ar5008_write_rf_array(struct ath_hw *ah, struct ar5416IniArray *array,
+				  u32 *data, unsigned int *writecnt)
+{
+	int r;
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
+	for (r = 0; r < array->ia_rows; r++) {
+		REG_WRITE(ah, INI_RA(array, r, 0), data[r]);
+		DO_DELAY(*writecnt);
+	}
+
+	REGWRITE_BUFFER_FLUSH(ah);
+}
+
 /**
  * ar5008_hw_phy_modify_rx_buffer() - perform analog swizzling of parameters
  * @rfbuf:
@@ -530,16 +558,16 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
 
 	/* Setup Bank 0 Write */
-	RF_BANK_SETUP(ah->analogBank0Data, &ah->iniBank0, 1);
+	ar5008_rf_bank_setup(ah->analogBank0Data, &ah->iniBank0, 1);
 
 	/* Setup Bank 1 Write */
-	RF_BANK_SETUP(ah->analogBank1Data, &ah->iniBank1, 1);
+	ar5008_rf_bank_setup(ah->analogBank1Data, &ah->iniBank1, 1);
 
 	/* Setup Bank 2 Write */
-	RF_BANK_SETUP(ah->analogBank2Data, &ah->iniBank2, 1);
+	ar5008_rf_bank_setup(ah->analogBank2Data, &ah->iniBank2, 1);
 
 	/* Setup Bank 6 Write */
-	RF_BANK_SETUP(ah->analogBank3Data, &ah->iniBank3,
+	ar5008_rf_bank_setup(ah->analogBank3Data, &ah->iniBank3,
 		      modesIndex);
 	{
 		int i;
@@ -569,7 +597,7 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	}
 
 	/* Setup Bank 7 Setup */
-	RF_BANK_SETUP(ah->analogBank7Data, &ah->iniBank7, 1);
+	ar5008_rf_bank_setup(ah->analogBank7Data, &ah->iniBank7, 1);
 
 	/* Write Analog registers */
 	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 807d410..bb9a3f3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -130,6 +130,20 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 }
 EXPORT_SYMBOL(ath9k_hw_wait);
 
+void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
+			  int column, unsigned int *writecnt)
+{
+	int r;
+
+	ENABLE_REGWRITE_BUFFER(ah);
+	for (r = 0; r < array->ia_rows; r++) {
+		REG_WRITE(ah, INI_RA(array, r, 0),
+			  INI_RA(array, r, column));
+		DO_DELAY(*writecnt);
+	}
+	REGWRITE_BUFFER_FLUSH(ah);
+}
+
 u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 {
 	u32 retval;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e256658..dafbe97 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -106,16 +106,8 @@
 			udelay(1);				\
 	} while (0)
 
-#define REG_WRITE_ARRAY(iniarray, column, regWr) do {                   \
-		int r;							\
-		ENABLE_REGWRITE_BUFFER(ah);				\
-		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
-			REG_WRITE(ah, INI_RA((iniarray), (r), 0),	\
-				  INI_RA((iniarray), r, (column)));	\
-			DO_DELAY(regWr);				\
-		}							\
-		REGWRITE_BUFFER_FLUSH(ah);				\
-	} while (0)
+#define REG_WRITE_ARRAY(iniarray, column, regWr) \
+	ath9k_hw_write_array(ah, iniarray, column, &(regWr))
 
 #define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
 #define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
@@ -913,6 +905,8 @@ void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
+void ath9k_hw_write_array(struct ath_hw *ah, struct ar5416IniArray *array,
+			  int column, unsigned int *writecnt);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
 bool ath9k_get_channel_edges(struct ath_hw *ah, u16 flags, u16 *low, u16 *high);
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index e402932..f50e2c2 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -38,27 +38,11 @@
 #define AR_PHY_CLC_Q0        0x0000ffd0
 #define AR_PHY_CLC_Q0_S      5
 
-#define REG_WRITE_RF_ARRAY(iniarray, regData, regWr) do {               \
-		int r;							\
-		ENABLE_REGWRITE_BUFFER(ah);				\
-		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
-			REG_WRITE(ah, INI_RA((iniarray), r, 0), (regData)[r]); \
-			DO_DELAY(regWr);				\
-		}							\
-		REGWRITE_BUFFER_FLUSH(ah);				\
-	} while (0)
-
 #define ANTSWAP_AB 0x0001
 #define REDUCE_CHAIN_0 0x00000050
 #define REDUCE_CHAIN_1 0x00000051
 #define AR_PHY_CHIP_ID 0x9818
 
-#define RF_BANK_SETUP(_bank, _iniarray, _col) do {			\
-		int i;							\
-		for (i = 0; i < (_iniarray)->ia_rows; i++)		\
-			(_bank)[i] = INI_RA((_iniarray), i, _col);;	\
-	} while (0)
-
 #define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
 #define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
 
-- 
1.7.3.2

