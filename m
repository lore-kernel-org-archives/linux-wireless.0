Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXLCLol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:41 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 11/34] iwlwifi: Document Rx calibration
Date: Mon,  3 Dec 2007 13:43:23 +0200
Message-Id: <11966822302932-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114447_759536_15212F9A)
In-Reply-To: <1196682230902-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document Rx calibration

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  267 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-4965.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   18 --
 3 files changed, 261 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 00d4ab7..575a065 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1573,25 +1573,278 @@ struct iwl4965_missed_beacon_notif {
 	__le32 num_recvd_beacons;
 } __attribute__ ((packed));
 
+
 /******************************************************************************
  * (11)
  * Rx Calibration Commands:
  *
+ * With the uCode used for open source drivers, most Tx calibration (except
+ * for Tx Power) and most Rx calibration is done by uCode during the
+ * "initialize" phase of uCode boot.  Driver must calibrate only:
+ *
+ * 1)  Tx power (depends on temperature), described elsewhere
+ * 2)  Receiver gain balance (optimize MIMO, and detect disconnected antennas)
+ * 3)  Receiver sensitivity (to optimize signal detection)
+ *
  *****************************************************************************/
 
-#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
-#define HD_TABLE_SIZE  (11)
+/**
+ * SENSITIVITY_CMD = 0xa8 (command, has simple generic response)
+ *
+ * This command sets up the Rx signal detector for a sensitivity level that
+ * is high enough to lock onto all signals within the associated network,
+ * but low enough to ignore signals that are below a certain threshold, so as
+ * not to have too many "false alarms".  False alarms are signals that the
+ * Rx DSP tries to lock onto, but then discards after determining that they
+ * are noise.
+ *
+ * The optimum number of false alarms is between 5 and 50 per 200 TUs
+ * (200 * 1024 uSecs, i.e. 204.8 milliseconds) of actual Rx time (i.e.
+ * time listening, not transmitting).  Driver must adjust sensitivity so that
+ * the ratio of actual false alarms to actual Rx time falls within this range.
+ *
+ * While associated, uCode delivers STATISTICS_NOTIFICATIONs after each
+ * received beacon.  These provide information to the driver to analyze the
+ * sensitivity.  Don't analyze statistics that come in from scanning, or any
+ * other non-associated-network source.  Pertinent statistics include:
+ *
+ * From "general" statistics (struct statistics_rx_non_phy):
+ *
+ * (beacon_energy_[abc] & 0x0FF00) >> 8 (unsigned, higher value is lower level)
+ *   Measure of energy of desired signal.  Used for establishing a level
+ *   below which the device does not detect signals.
+ *
+ * (beacon_silence_rssi_[abc] & 0x0FF00) >> 8 (unsigned, units in dB)
+ *   Measure of background noise in silent period after beacon.
+ *
+ * channel_load
+ *   uSecs of actual Rx time during beacon period (varies according to
+ *   how much time was spent transmitting).
+ *
+ * From "cck" and "ofdm" statistics (struct statistics_rx_phy), separately:
+ *
+ * false_alarm_cnt
+ *   Signal locks abandoned early (before phy-level header).
+ *
+ * plcp_err
+ *   Signal locks abandoned late (during phy-level header).
+ *
+ * NOTE:  Both false_alarm_cnt and plcp_err increment monotonically from
+ *        beacon to beacon, i.e. each value is an accumulation of all errors
+ *        before and including the latest beacon.  Values will wrap around to 0
+ *        after counting up to 2^32 - 1.  Driver must differentiate vs.
+ *        previous beacon's values to determine # false alarms in the current
+ *        beacon period.
+ *
+ * Total number of false alarms = false_alarms + plcp_errs
+ *
+ * For OFDM, adjust the following table entries in struct iwl_sensitivity_cmd
+ * (notice that the start points for OFDM are at or close to settings for
+ * maximum sensitivity):
+ *
+ *                                             START  /  MIN  /  MAX
+ *   HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX          90   /   85  /  120
+ *   HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX     170   /  170  /  210
+ *   HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX         105   /  105  /  140
+ *   HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX     220   /  220  /  270
+ *
+ *   If actual rate of OFDM false alarms (+ plcp_errors) is too high
+ *   (greater than 50 for each 204.8 msecs listening), reduce sensitivity
+ *   by *adding* 1 to all 4 of the table entries above, up to the max for
+ *   each entry.  Conversely, if false alarm rate is too low (less than 5
+ *   for each 204.8 msecs listening), *subtract* 1 from each entry to
+ *   increase sensitivity.
+ *
+ * For CCK sensitivity, keep track of the following:
+ *
+ *   1).  20-beacon history of maximum background noise, indicated by
+ *        (beacon_silence_rssi_[abc] & 0x0FF00), units in dB, across the
+ *        3 receivers.  For any given beacon, the "silence reference" is
+ *        the maximum of last 60 samples (20 beacons * 3 receivers).
+ *
+ *   2).  10-beacon history of strongest signal level, as indicated
+ *        by (beacon_energy_[abc] & 0x0FF00) >> 8, across the 3 receivers,
+ *        i.e. the strength of the signal through the best receiver at the
+ *        moment.  These measurements are "upside down", with lower values
+ *        for stronger signals, so max energy will be *minimum* value.
+ *
+ *        Then for any given beacon, the driver must determine the *weakest*
+ *        of the strongest signals; this is the minimum level that needs to be
+ *        successfully detected, when using the best receiver at the moment.
+ *        "Max cck energy" is the maximum (higher value means lower energy!)
+ *        of the last 10 minima.  Once this is determined, driver must add
+ *        a little margin by adding "6" to it.
+ *
+ *   3).  Number of consecutive beacon periods with too few false alarms.
+ *        Reset this to 0 at the first beacon period that falls within the
+ *        "good" range (5 to 50 false alarms per 204.8 milliseconds rx).
+ *
+ * Then, adjust the following CCK table entries in struct iwl_sensitivity_cmd
+ * (notice that the start points for CCK are at maximum sensitivity):
+ *
+ *                                             START  /  MIN  /  MAX
+ *   HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX         125   /  125  /  200
+ *   HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX     200   /  200  /  400
+ *   HD_MIN_ENERGY_CCK_DET_INDEX                100   /    0  /  100
+ *
+ *   If actual rate of CCK false alarms (+ plcp_errors) is too high
+ *   (greater than 50 for each 204.8 msecs listening), method for reducing
+ *   sensitivity is:
+ *
+ *   1)  *Add* 3 to value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX,
+ *       up to max 400.
+ *
+ *   2)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX is < 160,
+ *       sensitivity has been reduced a significant amount; bring it up to
+ *       a moderate 161.  Otherwise, *add* 3, up to max 200.
+ *
+ *   3)  a)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX is > 160,
+ *       sensitivity has been reduced only a moderate or small amount;
+ *       *subtract* 2 from value in HD_MIN_ENERGY_CCK_DET_INDEX,
+ *       down to min 0.  Otherwise (if gain has been significantly reduced),
+ *       don't change the HD_MIN_ENERGY_CCK_DET_INDEX value.
+ *
+ *       b)  Save a snapshot of the "silence reference".
+ *
+ *   If actual rate of CCK false alarms (+ plcp_errors) is too low
+ *   (less than 5 for each 204.8 msecs listening), method for increasing
+ *   sensitivity is used only if:
+ *
+ *   1a)  Previous beacon did not have too many false alarms
+ *   1b)  AND difference between previous "silence reference" and current
+ *        "silence reference" (prev - current) is 2 or more,
+ *   OR 2)  100 or more consecutive beacon periods have had rate of
+ *          less than 5 false alarms per 204.8 milliseconds rx time.
+ *
+ *   Method for increasing sensitivity:
+ *
+ *   1)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX,
+ *       down to min 125.
+ *
+ *   2)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX,
+ *       down to min 200.
+ *
+ *   3)  *Add* 2 to value in HD_MIN_ENERGY_CCK_DET_INDEX, up to max 100.
+ *
+ *   If actual rate of CCK false alarms (+ plcp_errors) is within good range
+ *   (between 5 and 50 for each 204.8 msecs listening):
+ *
+ *   1)  Save a snapshot of the silence reference.
+ *
+ *   2)  If previous beacon had too many CCK false alarms (+ plcp_errors),
+ *       give some extra margin to energy threshold by *subtracting* 8
+ *       from value in HD_MIN_ENERGY_CCK_DET_INDEX.
+ *
+ *   For all cases (too few, too many, good range), make sure that the CCK
+ *   detection threshold (energy) is below the energy level for robust
+ *   detection over the past 10 beacon periods, the "Max cck energy".
+ *   Lower values mean higher energy; this means making sure that the value
+ *   in HD_MIN_ENERGY_CCK_DET_INDEX is at or *above* "Max cck energy".
+ *
+ * Driver should set the following entries to fixed values:
+ *
+ *   HD_MIN_ENERGY_OFDM_DET_INDEX               100
+ *   HD_BARKER_CORR_TH_ADD_MIN_INDEX            190
+ *   HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX        390
+ *   HD_OFDM_ENERGY_TH_IN_INDEX                  62
+ */
+
+/*
+ * Table entries in SENSITIVITY_CMD (struct iwl4965_sensitivity_cmd)
+ */
+#define HD_TABLE_SIZE  (11)	/* number of entries */
+#define HD_MIN_ENERGY_CCK_DET_INDEX                 (0)	/* table indexes */
+#define HD_MIN_ENERGY_OFDM_DET_INDEX                (1)
+#define HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX          (2)
+#define HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX      (3)
+#define HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX      (4)
+#define HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX          (5)
+#define HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX      (6)
+#define HD_BARKER_CORR_TH_ADD_MIN_INDEX             (7)
+#define HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX         (8)
+#define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
+#define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
+
+/* Control field in struct iwl4965_sensitivity_cmd */
+#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	__constant_cpu_to_le16(0)
+#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	__constant_cpu_to_le16(1)
 
+/**
+ * struct iwl4965_sensitivity_cmd
+ * @control:  (1) updates working table, (0) updates default table
+ * @table:  energy threshold values, use HD_* as index into table
+ *
+ * Always use "1" in "control" to update uCode's working table and DSP.
+ */
 struct iwl4965_sensitivity_cmd {
-	__le16 control;
-	__le16 table[HD_TABLE_SIZE];
+	__le16 control;			/* always use "1" */
+	__le16 table[HD_TABLE_SIZE];	/* use HD_* as index */
 } __attribute__ ((packed));
 
+
+/**
+ * REPLY_PHY_CALIBRATION_CMD = 0xb0 (command, has simple generic response)
+ *
+ * This command sets the relative gains of 4965's 3 radio receiver chains.
+ *
+ * After the first association, driver should accumulate signal and noise
+ * statistics from the STATISTICS_NOTIFICATIONs that follow the first 20
+ * beacons from the associated network (don't collect statistics that come
+ * in from scanning, or any other non-network source).
+ *
+ * DISCONNECTED ANTENNA:
+ *
+ * Driver should determine which antennas are actually connected, by comparing
+ * average beacon signal levels for the 3 Rx chains.  Accumulate (add) the
+ * following values over 20 beacons, one accumulator for each of the chains
+ * a/b/c, from struct statistics_rx_non_phy:
+ *
+ * beacon_rssi_[abc] & 0x0FF (unsigned, units in dB)
+ *
+ * Find the strongest signal from among a/b/c.  Compare the other two to the
+ * strongest.  If any signal is more than 15 dB (times 20, unless you
+ * divide the accumulated values by 20) below the strongest, the driver
+ * considers that antenna to be disconnected, and should not try to use that
+ * antenna/chain for Rx or Tx.  If both A and B seem to be disconnected,
+ * driver should declare the stronger one as connected, and attempt to use it
+ * (A and B are the only 2 Tx chains!).
+ *
+ *
+ * RX BALANCE:
+ *
+ * Driver should balance the 3 receivers (but just the ones that are connected
+ * to antennas, see above) for gain, by comparing the average signal levels
+ * detected during the silence after each beacon (background noise).
+ * Accumulate (add) the following values over 20 beacons, one accumulator for
+ * each of the chains a/b/c, from struct statistics_rx_non_phy:
+ *
+ * beacon_silence_rssi_[abc] & 0x0FF (unsigned, units in dB)
+ *
+ * Find the weakest background noise level from among a/b/c.  This Rx chain
+ * will be the reference, with 0 gain adjustment.  Attenuate other channels by
+ * finding noise difference:
+ *
+ * (accum_noise[i] - accum_noise[reference]) / 30
+ *
+ * The "30" adjusts the dB in the 20 accumulated samples to units of 1.5 dB.
+ * For use in diff_gain_[abc] fields of struct iwl_calibration_cmd, the
+ * driver should limit the difference results to a range of 0-3 (0-4.5 dB),
+ * and set bit 2 to indicate "reduce gain".  The value for the reference
+ * (weakest) chain should be "0".
+ *
+ * diff_gain_[abc] bit fields:
+ *   2: (1) reduce gain, (0) increase gain
+ * 1-0: amount of gain, units of 1.5 dB
+ */
+
+/* "Differential Gain" opcode used in REPLY_PHY_CALIBRATION_CMD. */
+#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
+
 struct iwl4965_calibration_cmd {
-	u8 opCode;
-	u8 flags;
+	u8 opCode;		/* PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
+	u8 flags;		/* not used */
 	__le16 reserved;
-	s8 diff_gain_a;
+	s8 diff_gain_a;		/* see above */
 	s8 diff_gain_b;
 	s8 diff_gain_c;
 	u8 reserved1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index fc7e6b6..e6e6280 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1074,6 +1074,7 @@ static int iwl4965_sensitivity_write(struct iwl4965_priv *priv, u8 flags)
 			data->auto_corr_cck, data->auto_corr_cck_mrc,
 			data->nrg_th_cck);
 
+	/* Update uCode's "work" table, and copy it to DSP */
 	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
 
 	if (flags & CMD_ASYNC)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 0fb8ee9..33eca96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -926,22 +926,6 @@ struct iwl4965_lq_mngr {
 #define CAL_NUM_OF_BEACONS		20
 #define MAXIMUM_ALLOWED_PATHLOSS	15
 
-/* Param table within SENSITIVITY_CMD */
-#define HD_MIN_ENERGY_CCK_DET_INDEX                 (0)
-#define HD_MIN_ENERGY_OFDM_DET_INDEX                (1)
-#define HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX          (2)
-#define HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX      (3)
-#define HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX      (4)
-#define HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX          (5)
-#define HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX      (6)
-#define HD_BARKER_CORR_TH_ADD_MIN_INDEX             (7)
-#define HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX         (8)
-#define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
-#define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
-
-#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	__constant_cpu_to_le16(0)
-#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	__constant_cpu_to_le16(1)
-
 #define CHAIN_NOISE_MAX_DELTA_GAIN_CODE 3
 
 #define MAX_FA_OFDM  50
@@ -969,8 +953,6 @@ struct iwl4965_lq_mngr {
 #define AUTO_CORR_STEP_CCK     3
 #define AUTO_CORR_MAX_TH_CCK   160
 
-#define NRG_ALG                0
-#define AUTO_CORR_ALG          1
 #define NRG_DIFF               2
 #define NRG_STEP_CCK           2
 #define NRG_MARGIN             8
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
