Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40798 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2EDHyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 03:54:49 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20387.35607.177237.775950@gargle.gargle.HOWL> (sfid-20120504_095930_262041_2C054F87)
Date: Fri, 4 May 2012 13:23:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Fix RTT calibration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes multiple issues with the current RTT
implementation in ath9k.

* The data that is obtained from the RTT interface registers
  are stored in 31:5 - mask out the extra bits when reading them.

* A history buffer is maintained which is not needed at all.
  Remove this array and just store the baseband data for each
  chain (or bank).

* A 'num_readings' variable was being used to handle the
  last entry. But it was being used in an improper manner, with
  the result that the RTT values were never being written
  to the RTT Interface registers. Fix this by using a simple
  flag.

* Stop baseband operations before programming the calibration values
  to the HW.

* Do not restore RX gain settings as part of RTT.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   50 +++------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c   |   84 ++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/ar9003_rtt.h   |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    9 ++-
 drivers/net/wireless/ath/ath9k/hw.h           |    9 +--
 6 files changed, 89 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index a0387a0..9fdd70f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -892,34 +892,6 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 }
 
-static bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	struct ath9k_rtt_hist *hist;
-	u32 *table;
-	int i;
-	bool restore;
-
-	if (!ah->caldata)
-		return false;
-
-	hist = &ah->caldata->rtt_hist;
-	if (!hist->num_readings)
-		return false;
-
-	ar9003_hw_rtt_enable(ah);
-	ar9003_hw_rtt_set_mask(ah, 0x00);
-	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-		if (!(ah->rxchainmask & (1 << i)))
-			continue;
-		table = &hist->table[i][hist->num_readings][0];
-		ar9003_hw_rtt_load_hist(ah, i, table);
-	}
-	restore = ar9003_hw_rtt_force_restore(ah);
-	ar9003_hw_rtt_disable(ah);
-
-	return restore;
-}
-
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
@@ -942,9 +914,10 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
 
-		ath_dbg(common, CALIBRATE, "RTT restore %s\n",
-			run_rtt_cal ? "failed" : "succeed");
+		if (run_rtt_cal)
+			ath_dbg(common, CALIBRATE, "RTT calibration to be done\n");
 	}
+
 	run_agc_cal = run_rtt_cal;
 
 	if (run_rtt_cal) {
@@ -1069,17 +1042,14 @@ skip_tx_iqcal:
 #undef CL_TAB_ENTRY
 
 	if (run_rtt_cal && caldata) {
-		struct ath9k_rtt_hist *hist = &caldata->rtt_hist;
-		if (is_reusable && (hist->num_readings < RTT_HIST_MAX)) {
-			u32 *table;
+		if (is_reusable) {
+			if (!ath9k_hw_rfbus_req(ah))
+				ath_err(ath9k_hw_common(ah),
+					"Could not stop baseband\n");
+			else
+				ar9003_hw_rtt_fill_hist(ah);
 
-			hist->num_readings++;
-			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-				if (!(ah->rxchainmask & (1 << i)))
-					continue;
-				table = &hist->table[i][hist->num_readings][0];
-				ar9003_hw_rtt_fill_hist(ah, i, table);
-			}
+			ath9k_hw_rfbus_done(ah);
 		}
 
 		ar9003_hw_rtt_disable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 3cac293..ffbb180 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -756,7 +756,7 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (caldata) {
 			caldata->done_txiqcal_once = false;
 			caldata->done_txclcal_once = false;
-			caldata->rtt_hist.num_readings = 0;
+			caldata->rtt_done = false;
 		}
 
 		if (!ath9k_hw_init_cal(ah, chan))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
index 458bedf..74de353 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "hw-ops.h"
 #include "ar9003_phy.h"
 #include "ar9003_rtt.h"
 
@@ -69,7 +70,7 @@ bool ar9003_hw_rtt_force_restore(struct ath_hw *ah)
 }
 
 static void ar9003_hw_rtt_load_hist_entry(struct ath_hw *ah, u8 chain,
-		u32 index, u32 data28)
+					  u32 index, u32 data28)
 {
 	u32 val;
 
@@ -100,12 +101,21 @@ static void ar9003_hw_rtt_load_hist_entry(struct ath_hw *ah, u8 chain,
 		      RTT_ACCESS_TIMEOUT);
 }
 
-void ar9003_hw_rtt_load_hist(struct ath_hw *ah, u8 chain, u32 *table)
+void ar9003_hw_rtt_load_hist(struct ath_hw *ah)
 {
-	int i;
+	int chain, i;
 
-	for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
-		ar9003_hw_rtt_load_hist_entry(ah, chain, i, table[i]);
+	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
+		if (!(ah->rxchainmask & (1 << chain)))
+			continue;
+		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++) {
+			ar9003_hw_rtt_load_hist_entry(ah, chain, i,
+					      ah->caldata->rtt_table[chain][i]);
+			ath_dbg(ath9k_hw_common(ah), CALIBRATE,
+				"Load RTT value at idx %d, chain %d: 0x%x\n",
+				i, chain, ah->caldata->rtt_table[chain][i]);
+		}
+	}
 }
 
 static int ar9003_hw_rtt_fill_hist_entry(struct ath_hw *ah, u8 chain, u32 index)
@@ -128,27 +138,71 @@ static int ar9003_hw_rtt_fill_hist_entry(struct ath_hw *ah, u8 chain, u32 index)
 			   RTT_ACCESS_TIMEOUT))
 		return RTT_BAD_VALUE;
 
-	val = REG_READ(ah, AR_PHY_RTT_TABLE_SW_INTF_1_B(chain));
+	val = MS(REG_READ(ah, AR_PHY_RTT_TABLE_SW_INTF_1_B(chain)),
+		 AR_PHY_RTT_SW_RTT_TABLE_DATA);
+
 
 	return val;
 }
 
-void ar9003_hw_rtt_fill_hist(struct ath_hw *ah, u8 chain, u32 *table)
+void ar9003_hw_rtt_fill_hist(struct ath_hw *ah)
 {
-	int i;
+	int chain, i;
+
+	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
+		if (!(ah->rxchainmask & (1 << chain)))
+			continue;
+		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++) {
+			ah->caldata->rtt_table[chain][i] =
+				ar9003_hw_rtt_fill_hist_entry(ah, chain, i);
+			ath_dbg(ath9k_hw_common(ah), CALIBRATE,
+				"RTT value at idx %d, chain %d is: 0x%x\n",
+				i, chain, ah->caldata->rtt_table[chain][i]);
+		}
+	}
 
-	for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
-		table[i] = ar9003_hw_rtt_fill_hist_entry(ah, chain, i);
+	ah->caldata->rtt_done = true;
 }
 
 void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
 {
-	int i, j;
+	int chain, i;
 
-	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-		if (!(ah->rxchainmask & (1 << i)))
+	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
+		if (!(ah->rxchainmask & (1 << chain)))
 			continue;
-		for (j = 0; j < MAX_RTT_TABLE_ENTRY; j++)
-			ar9003_hw_rtt_load_hist_entry(ah, i, j, 0);
+		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
+			ar9003_hw_rtt_load_hist_entry(ah, chain, i, 0);
 	}
+
+	if (ah->caldata)
+		ah->caldata->rtt_done = false;
+}
+
+bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	bool restore;
+
+	if (!ah->caldata)
+		return false;
+
+	if (!ah->caldata->rtt_done)
+		return false;
+
+	ar9003_hw_rtt_enable(ah);
+	ar9003_hw_rtt_set_mask(ah, 0x10);
+
+	if (!ath9k_hw_rfbus_req(ah)) {
+		ath_err(ath9k_hw_common(ah), "Could not stop baseband\n");
+		restore = false;
+		goto fail;
+	}
+
+	ar9003_hw_rtt_load_hist(ah);
+	restore = ar9003_hw_rtt_force_restore(ah);
+
+fail:
+	ath9k_hw_rfbus_done(ah);
+	ar9003_hw_rtt_disable(ah);
+	return restore;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.h b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
index 030758d..a43b30d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
@@ -21,8 +21,9 @@ void ar9003_hw_rtt_enable(struct ath_hw *ah);
 void ar9003_hw_rtt_disable(struct ath_hw *ah);
 void ar9003_hw_rtt_set_mask(struct ath_hw *ah, u32 rtt_mask);
 bool ar9003_hw_rtt_force_restore(struct ath_hw *ah);
-void ar9003_hw_rtt_load_hist(struct ath_hw *ah, u8 chain, u32 *table);
-void ar9003_hw_rtt_fill_hist(struct ath_hw *ah, u8 chain, u32 *table);
+void ar9003_hw_rtt_load_hist(struct ath_hw *ah);
+void ar9003_hw_rtt_fill_hist(struct ath_hw *ah);
 void ar9003_hw_rtt_clear_hist(struct ath_hw *ah);
+bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f84477c..abe05ec 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1702,10 +1702,10 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * For AR9462, make sure that calibration data for
 	 * re-using are present.
 	 */
-	if (AR_SREV_9462(ah) && (!ah->caldata ||
-				 !ah->caldata->done_txiqcal_once ||
-				 !ah->caldata->done_txclcal_once ||
-				 !ah->caldata->rtt_hist.num_readings))
+	if (AR_SREV_9462(ah) && (ah->caldata &&
+				 (!ah->caldata->done_txiqcal_once ||
+				  !ah->caldata->done_txclcal_once ||
+				  !ah->caldata->rtt_done)))
 		goto fail;
 
 	ath_dbg(common, RESET, "FastChannelChange for %d -> %d\n",
@@ -1941,7 +1941,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (caldata) {
 		caldata->done_txiqcal_once = false;
 		caldata->done_txclcal_once = false;
-		caldata->rtt_hist.num_readings = 0;
 	}
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 828b9bb..b620c55 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -348,12 +348,6 @@ enum ath9k_int {
 	 CHANNEL_HT40MINUS)
 
 #define MAX_RTT_TABLE_ENTRY     6
-#define RTT_HIST_MAX            3
-struct ath9k_rtt_hist {
-	u32 table[AR9300_MAX_CHAINS][RTT_HIST_MAX][MAX_RTT_TABLE_ENTRY];
-	u8 num_readings;
-};
-
 #define MAX_IQCAL_MEASUREMENT	8
 #define MAX_CL_TAB_ENTRY	16
 
@@ -363,6 +357,7 @@ struct ath9k_hw_cal_data {
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
+	bool rtt_done;
 	bool paprd_done;
 	bool nfcal_pending;
 	bool nfcal_interference;
@@ -373,8 +368,8 @@ struct ath9k_hw_cal_data {
 	u32 num_measures[AR9300_MAX_CHAINS];
 	int tx_corr_coeff[MAX_IQCAL_MEASUREMENT][AR9300_MAX_CHAINS];
 	u32 tx_clcal[AR9300_MAX_CHAINS][MAX_CL_TAB_ENTRY];
+	u32 rtt_table[AR9300_MAX_CHAINS][MAX_RTT_TABLE_ENTRY];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-	struct ath9k_rtt_hist rtt_hist;
 };
 
 struct ath9k_channel {
-- 
1.7.10

