Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43422 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1JJFvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 10/13] ath9k_hw: Add radio retention support for AR9480
Date: Mon, 10 Oct 2011 11:21:15 +0530
Message-ID: <1318225878-7283-10-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075155_730037_4E9C1C76)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Supported calibrations of radio retention table (RTT) are
	- DC offset
	- Filter
	- Peak detect

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile       |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  113 ++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |   20 +++-
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c   |  153 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_rtt.h   |   28 +++++
 drivers/net/wireless/ath/ath9k/hw.c           |    4 +
 drivers/net/wireless/ath/ath9k/hw.h           |    9 ++
 drivers/net/wireless/ath/ath9k/reg.h          |    1 +
 8 files changed, 315 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_rtt.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_rtt.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 05a6fad..36ed3c4 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -21,6 +21,7 @@ ath9k_hw-y:=	\
 		ar5008_phy.o \
 		ar9002_calib.o \
 		ar9003_calib.o \
+		ar9003_rtt.o \
 		calib.o \
 		eeprom.o \
 		eeprom_def.o \
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 3506e7b..47f140c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -17,6 +17,7 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include "ar9003_phy.h"
+#include "ar9003_rtt.h"
 
 #define MAX_MEASUREMENT	MAX_IQCAL_MEASUREMENT
 #define MAX_MAG_DELTA	11
@@ -900,25 +901,81 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 }
 
+static bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath9k_rtt_hist *hist;
+	u32 *table;
+	int i;
+	bool restore;
+
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT) || !ah->caldata)
+		return false;
+
+	hist = &ah->caldata->rtt_hist;
+	ar9003_hw_rtt_enable(ah);
+	ar9003_hw_rtt_set_mask(ah, 0x10);
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (!(ah->rxchainmask & (1 << i)))
+			continue;
+		table = &hist->table[i][hist->num_readings][0];
+		ar9003_hw_rtt_load_hist(ah, i, table);
+	}
+	restore = ar9003_hw_rtt_force_restore(ah);
+	ar9003_hw_rtt_disable(ah);
+
+	return restore;
+}
+
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false, txclcal_done = false;
-	bool is_reusable = true;
+	bool is_reusable = true, status = true;
+	bool run_rtt_cal = false, run_agc_cal;
+	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
+	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
+					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
+					  AR_PHY_AGC_CONTROL_PKDET_CAL;
 	int i, j;
 	u32 cl_idx[AR9300_MAX_CHAINS] = { AR_PHY_CL_TAB_0,
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	if (rtt) {
+		if (!ar9003_hw_rtt_restore(ah, chan))
+			run_rtt_cal = true;
+
+		ath_dbg(common, ATH_DBG_CALIBRATE, "RTT restore %s\n",
+			run_rtt_cal ? "failed" : "succeed");
+	}
+	run_agc_cal = run_rtt_cal;
+
+	if (run_rtt_cal) {
+		ar9003_hw_rtt_enable(ah);
+		ar9003_hw_rtt_set_mask(ah, 0x00);
+		ar9003_hw_rtt_clear_hist(ah);
+	}
+
+	if (rtt && !run_rtt_cal) {
+		agc_ctrl = REG_READ(ah, AR_PHY_AGC_CONTROL);
+		agc_supp_cals &= agc_ctrl;
+		agc_ctrl &= ~(AR_PHY_AGC_CONTROL_OFFSET_CAL |
+			     AR_PHY_AGC_CONTROL_FLTR_CAL |
+			     AR_PHY_AGC_CONTROL_PKDET_CAL);
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+	}
+
 	if (ah->enabled_cals & TX_CL_CAL) {
 		if (caldata && caldata->done_txclcal_once)
 			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
 				    AR_PHY_CL_CAL_ENABLE);
-		else
+		else {
 			REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL,
 				    AR_PHY_CL_CAL_ENABLE);
+			run_agc_cal = true;
+		}
 	}
 
 	if (!(ah->enabled_cals & TX_IQ_CAL))
@@ -940,25 +997,41 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		else
 			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
-		txiqcal_done = true;
+		txiqcal_done = run_agc_cal = true;
 		goto skip_tx_iqcal;
-	}
+	} else if (caldata && !caldata->done_txiqcal_once)
+		run_agc_cal = true;
+
 	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 	udelay(5);
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
 skip_tx_iqcal:
-	/* Calibrate the AGC */
-	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-		  AR_PHY_AGC_CONTROL_CAL);
 
-	/* Poll for offset calibration complete */
-	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
-			   0, AH_WAIT_TIMEOUT)) {
+	if (run_agc_cal) {
+		/* Calibrate the AGC */
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			  AR_PHY_AGC_CONTROL_CAL);
+
+		/* Poll for offset calibration complete */
+		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				       AR_PHY_AGC_CONTROL_CAL,
+				       0, AH_WAIT_TIMEOUT);
+	}
+	if (rtt && !run_rtt_cal) {
+		agc_ctrl |= agc_supp_cals;
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+	}
+
+	if (!status) {
+		if (run_rtt_cal)
+			ar9003_hw_rtt_disable(ah);
+
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"offset calibration failed to complete in 1ms; noisy environment?\n");
+			"offset calibration failed to complete in 1ms;"
+			"noisy environment?\n");
 		return false;
 	}
 
@@ -993,6 +1066,22 @@ skip_tx_iqcal:
 	}
 #undef CL_TAB_ENTRY
 
+	if (run_rtt_cal && caldata) {
+		struct ath9k_rtt_hist *hist = &caldata->rtt_hist;
+		if (is_reusable && (hist->num_readings < RTT_HIST_MAX)) {
+			u32 *table;
+
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (!(ah->rxchainmask & (1 << i)))
+					continue;
+				table = &hist->table[i][hist->num_readings][0];
+				ar9003_hw_rtt_fill_hist(ah, i, table);
+			}
+		}
+
+		ar9003_hw_rtt_disable(ah);
+	}
+
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 64e9bea..9fe6fbe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -584,8 +584,6 @@
 					     (AR_SREV_9485(ah) ? \
 					      0x3d0 : 0x450) + ((_i) << 2))
 #define AR_PHY_RTT_CTRL			(AR_SM_BASE + 0x380)
-#define AR_PHY_RTT_TABLE_SW_INTF_B	(AR_SM_BASE + 0x384)
-#define AR_PHY_RTT_TABLE_SW_INTF_1_B0	(AR_SM_BASE + 0x388)
 
 #define AR_PHY_WATCHDOG_STATUS      (AR_SM_BASE + 0x5c0)
 #define AR_PHY_WATCHDOG_CTL_1       (AR_SM_BASE + 0x5c4)
@@ -825,6 +823,20 @@
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT   0x01000000
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S 24
 #define AR_PHY_CHANNEL_STATUS_RX_CLEAR      0x00000004
+#define AR_PHY_RTT_CTRL_ENA_RADIO_RETENTION     0x00000001
+#define AR_PHY_RTT_CTRL_ENA_RADIO_RETENTION_S   0
+#define AR_PHY_RTT_CTRL_RESTORE_MASK            0x0000007E
+#define AR_PHY_RTT_CTRL_RESTORE_MASK_S          1
+#define AR_PHY_RTT_CTRL_FORCE_RADIO_RESTORE     0x00000080
+#define AR_PHY_RTT_CTRL_FORCE_RADIO_RESTORE_S   7
+#define AR_PHY_RTT_SW_RTT_TABLE_ACCESS          0x00000001
+#define AR_PHY_RTT_SW_RTT_TABLE_ACCESS_S        0
+#define AR_PHY_RTT_SW_RTT_TABLE_WRITE           0x00000002
+#define AR_PHY_RTT_SW_RTT_TABLE_WRITE_S         1
+#define AR_PHY_RTT_SW_RTT_TABLE_ADDR            0x0000001C
+#define AR_PHY_RTT_SW_RTT_TABLE_ADDR_S          2
+#define AR_PHY_RTT_SW_RTT_TABLE_DATA            0xFFFFFFF0
+#define AR_PHY_RTT_SW_RTT_TABLE_DATA_S          4
 #define AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL                   0x80000000
 #define AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL_S                         31
 #define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT             0x01fc0000
@@ -919,6 +931,10 @@
 #define AR_PHY_AIC_SRAM_ADDR_B1	(AR_SM1_BASE + 0x5f0)
 #define AR_PHY_AIC_SRAM_DATA_B1	(AR_SM1_BASE + 0x5f4)
 
+#define AR_PHY_RTT_TABLE_SW_INTF_B(i)	(0x384 + (i) ? \
+					AR_SM1_BASE : AR_SM_BASE)
+#define AR_PHY_RTT_TABLE_SW_INTF_1_B(i)	(0x388 + (i) ? \
+					AR_SM1_BASE : AR_SM_BASE)
 /*
  * Channel 2 Register Map
  */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
new file mode 100644
index 0000000..48803ee
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "ar9003_phy.h"
+
+#define RTT_RESTORE_TIMEOUT          1000
+#define RTT_ACCESS_TIMEOUT           100
+#define RTT_BAD_VALUE                0x0bad0bad
+
+/*
+ * RTT (Radio Retention Table) hardware implementation information
+ *
+ * There is an internal table (i.e. the rtt) for each chain (or bank).
+ * Each table contains 6 entries and each entry is corresponding to
+ * a specific calibration parameter as depicted below.
+ *  0~2 - DC offset DAC calibration: loop, low, high (offsetI/Q_...)
+ *  3   - Filter cal (filterfc)
+ *  4   - RX gain settings
+ *  5   - Peak detector offset calibration (agc_caldac)
+ */
+
+void ar9003_hw_rtt_enable(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_RTT_CTRL, 1);
+}
+
+void ar9003_hw_rtt_disable(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_RTT_CTRL, 0);
+}
+
+void ar9003_hw_rtt_set_mask(struct ath_hw *ah, u32 rtt_mask)
+{
+	REG_RMW_FIELD(ah, AR_PHY_RTT_CTRL,
+		      AR_PHY_RTT_CTRL_RESTORE_MASK, rtt_mask);
+}
+
+bool ar9003_hw_rtt_force_restore(struct ath_hw *ah)
+{
+	if (!ath9k_hw_wait(ah, AR_PHY_RTT_CTRL,
+			   AR_PHY_RTT_CTRL_FORCE_RADIO_RESTORE,
+			   0, RTT_RESTORE_TIMEOUT))
+		return false;
+
+	REG_RMW_FIELD(ah, AR_PHY_RTT_CTRL,
+		      AR_PHY_RTT_CTRL_FORCE_RADIO_RESTORE, 1);
+
+	if (!ath9k_hw_wait(ah, AR_PHY_RTT_CTRL,
+			   AR_PHY_RTT_CTRL_FORCE_RADIO_RESTORE,
+			   0, RTT_RESTORE_TIMEOUT))
+		return false;
+
+	return true;
+}
+
+static void ar9003_hw_rtt_load_hist_entry(struct ath_hw *ah, u8 chain,
+		u32 index, u32 data28)
+{
+	u32 val;
+
+	val = SM(data28, AR_PHY_RTT_SW_RTT_TABLE_DATA);
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_1_B(chain), val);
+
+	val = SM(0, AR_PHY_RTT_SW_RTT_TABLE_ACCESS) |
+	      SM(1, AR_PHY_RTT_SW_RTT_TABLE_WRITE) |
+	      SM(index, AR_PHY_RTT_SW_RTT_TABLE_ADDR);
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain), val);
+	udelay(1);
+
+	val |= SM(1, AR_PHY_RTT_SW_RTT_TABLE_ACCESS);
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain), val);
+	udelay(1);
+
+	if (!ath9k_hw_wait(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain),
+			   AR_PHY_RTT_SW_RTT_TABLE_ACCESS, 0,
+			   RTT_ACCESS_TIMEOUT))
+		return;
+
+	val &= ~SM(1, AR_PHY_RTT_SW_RTT_TABLE_WRITE);
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain), val);
+	udelay(1);
+
+	ath9k_hw_wait(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain),
+		      AR_PHY_RTT_SW_RTT_TABLE_ACCESS, 0,
+		      RTT_ACCESS_TIMEOUT);
+}
+
+void ar9003_hw_rtt_load_hist(struct ath_hw *ah, u8 chain, u32 *table)
+{
+	int i;
+
+	for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
+		ar9003_hw_rtt_load_hist_entry(ah, chain, i, table[i]);
+}
+
+static int ar9003_hw_rtt_fill_hist_entry(struct ath_hw *ah, u8 chain, u32 index)
+{
+	u32 val;
+
+	val = SM(0, AR_PHY_RTT_SW_RTT_TABLE_ACCESS) |
+	      SM(0, AR_PHY_RTT_SW_RTT_TABLE_WRITE) |
+	      SM(index, AR_PHY_RTT_SW_RTT_TABLE_ADDR);
+
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain), val);
+	udelay(1);
+
+	val |= SM(1, AR_PHY_RTT_SW_RTT_TABLE_ACCESS);
+	REG_WRITE(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain), val);
+	udelay(1);
+
+	if (!ath9k_hw_wait(ah, AR_PHY_RTT_TABLE_SW_INTF_B(chain),
+			   AR_PHY_RTT_SW_RTT_TABLE_ACCESS, 0,
+			   RTT_ACCESS_TIMEOUT))
+		return RTT_BAD_VALUE;
+
+	val = REG_READ(ah, AR_PHY_RTT_TABLE_SW_INTF_1_B(chain));
+
+	return val;
+}
+
+void ar9003_hw_rtt_fill_hist(struct ath_hw *ah, u8 chain, u32 *table)
+{
+	int i;
+
+	for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
+		table[i] = ar9003_hw_rtt_fill_hist_entry(ah, chain, i);
+}
+
+void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
+{
+	int i, j;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (!(ah->rxchainmask & (1 << i)))
+			continue;
+		for (j = 0; j < MAX_RTT_TABLE_ENTRY; j++)
+			ar9003_hw_rtt_load_hist_entry(ah, i, j, 0);
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.h b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
new file mode 100644
index 0000000..030758d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef AR9003_RTT_H
+#define AR9003_RTT_H
+
+void ar9003_hw_rtt_enable(struct ath_hw *ah);
+void ar9003_hw_rtt_disable(struct ath_hw *ah);
+void ar9003_hw_rtt_set_mask(struct ath_hw *ah, u32 rtt_mask);
+bool ar9003_hw_rtt_force_restore(struct ath_hw *ah);
+void ar9003_hw_rtt_load_hist(struct ath_hw *ah, u8 chain, u32 *table);
+void ar9003_hw_rtt_fill_hist(struct ath_hw *ah, u8 chain, u32 *table);
+void ar9003_hw_rtt_clear_hist(struct ath_hw *ah);
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9c60132..0ef8566 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1716,6 +1716,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (caldata) {
 		caldata->done_txiqcal_once = false;
 		caldata->done_txclcal_once = false;
+		caldata->rtt_hist.num_readings = 0;
 	}
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
@@ -2332,6 +2333,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		if (!AR_SREV_9330(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
+	if (AR_SREV_9480(ah))
+		pCap->hw_caps |= ATH9K_HW_CAP_RTT;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5ac013a..64f5a92 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -202,6 +202,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_2GHZ			= BIT(13),
 	ATH9K_HW_CAP_5GHZ			= BIT(14),
 	ATH9K_HW_CAP_APM			= BIT(15),
+	ATH9K_HW_CAP_RTT			= BIT(16),
 };
 
 struct ath9k_hw_capabilities {
@@ -337,6 +338,13 @@ enum ath9k_int {
 	 CHANNEL_HT40PLUS |			\
 	 CHANNEL_HT40MINUS)
 
+#define MAX_RTT_TABLE_ENTRY     6
+#define RTT_HIST_MAX            3
+struct ath9k_rtt_hist {
+	u32 table[AR9300_MAX_CHAINS][RTT_HIST_MAX][MAX_RTT_TABLE_ENTRY];
+	u8 num_readings;
+};
+
 #define MAX_IQCAL_MEASUREMENT	8
 #define MAX_CL_TAB_ENTRY	16
 
@@ -357,6 +365,7 @@ struct ath9k_hw_cal_data {
 	int tx_corr_coeff[MAX_IQCAL_MEASUREMENT][AR9300_MAX_CHAINS];
 	u32 tx_clcal[AR9300_MAX_CHAINS][MAX_CL_TAB_ENTRY];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
+	struct ath9k_rtt_hist rtt_hist;
 };
 
 struct ath9k_channel {
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index b76c49d..87a1245 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1933,6 +1933,7 @@ enum {
 #define AR_PHY_AGC_CONTROL_NO_UPDATE_NF		0x00020000  /* don't update noise floor automatically */
 #define AR_PHY_AGC_CONTROL_EXT_NF_PWR_MEAS	0x00040000  /* extend noise floor power measurement */
 #define AR_PHY_AGC_CONTROL_CLC_SUCCESS		0x00080000  /* carrier leak calibration done */
+#define AR_PHY_AGC_CONTROL_PKDET_CAL		0x00100000
 #define AR_PHY_AGC_CONTROL_YCOK_MAX		0x000003c0
 #define AR_PHY_AGC_CONTROL_YCOK_MAX_S		6
 
-- 
1.7.7

