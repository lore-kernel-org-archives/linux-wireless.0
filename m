Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51150 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaIOFNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:33 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so3403318wes.33
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/28] iwlwifi: mvm: use the firmware to get the temperature during CT kill
Date: Mon, 15 Sep 2014 08:12:51 +0300
Message-Id: <1410757980-2138-19-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_666389_96F618E3)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Reading the temperature directly from the hardware, without the help
of the firmware, is a complex process and is not entirely the same for
different hardware.  Also, some NICs don't easily allow access to the
sensors when the firmware is not running, which would add even more
complexity to the code.

To reduce the code complexity and to avoid code duplication between
the firmware and the driver, boot the firmware briefly to read the
current temperature while in CT kill mode.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  32 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  34 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   3 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   2 +
 drivers/net/wireless/iwlwifi/mvm/tt.c       | 326 +++++++---------------------
 5 files changed, 140 insertions(+), 257 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b599b52..fbcc036 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -205,6 +205,10 @@ enum {
 	REPLY_SF_CFG_CMD = 0xd1,
 	REPLY_BEACON_FILTERING_CMD = 0xd2,
 
+	/* DTS measurements */
+	CMD_DTS_MEASUREMENT_TRIGGER = 0xdc,
+	DTS_MEASUREMENT_NOTIFICATION = 0xdd,
+
 	REPLY_DEBUG_CMD = 0xf0,
 	DEBUG_LOG_MSG = 0xf7,
 
@@ -1618,4 +1622,32 @@ struct iwl_sf_cfg_cmd {
 	__le32 full_on_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
 } __packed; /* SF_CFG_API_S_VER_2 */
 
+/* DTS measurements */
+
+enum iwl_dts_measurement_flags {
+	DTS_TRIGGER_CMD_FLAGS_TEMP	= BIT(0),
+	DTS_TRIGGER_CMD_FLAGS_VOLT	= BIT(1),
+};
+
+/**
+ * iwl_dts_measurement_cmd - request DTS temperature and/or voltage measurements
+ *
+ * @flags: indicates which measurements we want as specified in &enum
+ *	   iwl_dts_measurement_flags
+ */
+struct iwl_dts_measurement_cmd {
+	__le32 flags;
+} __packed; /* TEMPERATURE_MEASUREMENT_TRIGGER_CMD_S */
+
+/**
+ * iwl_dts_measurement_notif - notification received with the measurements
+ *
+ * @temp: the measured temperature
+ * @voltage: the measured voltage
+ */
+struct iwl_dts_measurement_notif {
+	__le32 temp;
+	__le32 voltage;
+} __packed; /* TEMPERATURE_MEASUREMENT_TRIGGER_NTFY_S */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 089d7b3..5c33d2d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -815,12 +815,11 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->rx_ba_sessions = 0;
 }
 
-static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
+int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
-	mutex_lock(&mvm->mutex);
+	lockdep_assert_held(&mvm->mutex);
 
 	/* Clean up some internal and mac80211 state on restart */
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
@@ -837,6 +836,16 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 		iwl_mvm_d0i3_enable_tx(mvm, NULL);
 	}
 
+	return ret;
+}
+
+static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = __iwl_mvm_mac_start(mvm);
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
@@ -862,14 +871,9 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 	mutex_unlock(&mvm->mutex);
 }
 
-static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
+void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-
-	flush_work(&mvm->d0i3_exit_work);
-	flush_work(&mvm->async_handlers_wk);
-
-	mutex_lock(&mvm->mutex);
+	lockdep_assert_held(&mvm->mutex);
 
 	/* disallow low power states when the FW is down */
 	iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
@@ -891,7 +895,17 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	iwl_mvm_del_aux_sta(mvm);
 
 	mvm->ucode_loaded = false;
+}
 
+static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	flush_work(&mvm->d0i3_exit_work);
+	flush_work(&mvm->async_handlers_wk);
+
+	mutex_lock(&mvm->mutex);
+	__iwl_mvm_mac_stop(mvm);
 	mutex_unlock(&mvm->mutex);
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4b1db9a..a36fa6c6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -792,6 +792,9 @@ struct iwl_rate_info {
 	u8 ieee;	/* MAC header:  IWL_RATE_6M_IEEE, etc. */
 };
 
+void __iwl_mvm_mac_stop(struct iwl_mvm *mvm);
+int __iwl_mvm_mac_start(struct iwl_mvm *mvm);
+
 /******************
  * MVM Methods
  ******************/
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 5d8c562..9710084 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -332,6 +332,8 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BCAST_FILTER_CMD),
 	CMD(REPLY_SF_CFG_CMD),
 	CMD(REPLY_BEACON_FILTERING_CMD),
+	CMD(CMD_DTS_MEASUREMENT_TRIGGER),
+	CMD(DTS_MEASUREMENT_NOTIFICATION),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
 	CMD(BT_COEX_CI),
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index c3e1fe4..c750ca7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -69,275 +69,99 @@
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 
-#define OTP_DTS_DIODE_DEVIATION 96 /*in words*/
-/* VBG - Voltage Band Gap error data (temperature offset) */
-#define OTP_WP_DTS_VBG			(OTP_DTS_DIODE_DEVIATION + 2)
-#define MEAS_VBG_MIN_VAL		2300
-#define MEAS_VBG_MAX_VAL		3000
-#define MEAS_VBG_DEFAULT_VAL		2700
-#define DTS_DIODE_VALID(flags)		(flags & DTS_DIODE_REG_FLAGS_PASS_ONCE)
-#define MIN_TEMPERATURE			0
-#define MAX_TEMPERATURE			125
-#define TEMPERATURE_ERROR		(MAX_TEMPERATURE + 1)
-#define PTAT_DIGITAL_VALUE_MIN_VALUE	0
-#define PTAT_DIGITAL_VALUE_MAX_VALUE	0xFF
-#define DTS_VREFS_NUM			5
-static inline u32 DTS_DIODE_GET_VREFS_ID(u32 flags)
-{
-	return (flags & DTS_DIODE_REG_FLAGS_VREFS_ID) >>
-					DTS_DIODE_REG_FLAGS_VREFS_ID_POS;
-}
+#define IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT	HZ
 
-#define CALC_VREFS_MIN_DIFF	43
-#define CALC_VREFS_MAX_DIFF	51
-#define CALC_LUT_SIZE		(1 + CALC_VREFS_MAX_DIFF - CALC_VREFS_MIN_DIFF)
-#define CALC_LUT_INDEX_OFFSET	CALC_VREFS_MIN_DIFF
-#define CALC_TEMPERATURE_RESULT_SHIFT_OFFSET	23
-
-/*
- * @digital_value: The diode's digital-value sampled (temperature/voltage)
- * @vref_low: The lower voltage-reference (the vref just below the diode's
- *	sampled digital-value)
- * @vref_high: The higher voltage-reference (the vref just above the diode's
- *	sampled digital-value)
- * @flags: bits[1:0]: The ID of the Vrefs pair (lowVref,highVref)
- *	bits[6:2]: Reserved.
- *	bits[7:7]: Indicates completion of at least 1 successful sample
- *	since last DTS reset.
- */
-struct iwl_mvm_dts_diode_bits {
-	u8 digital_value;
-	u8 vref_low;
-	u8 vref_high;
-	u8 flags;
-} __packed;
-
-union dts_diode_results {
-	u32 reg_value;
-	struct iwl_mvm_dts_diode_bits bits;
-} __packed;
-
-static s16 iwl_mvm_dts_get_volt_band_gap(struct iwl_mvm *mvm)
+static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 {
-	struct iwl_nvm_section calib_sec;
-	const __le16 *calib;
-	u16 vbg;
-
-	/* TODO: move parsing to NVM code */
-	calib_sec = mvm->nvm_sections[NVM_SECTION_TYPE_CALIBRATION];
-	calib = (__le16 *)calib_sec.data;
+	u32 duration = mvm->thermal_throttle.params->ct_kill_duration;
 
-	vbg = le16_to_cpu(calib[OTP_WP_DTS_VBG]);
+	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
+		return;
 
-	if (vbg < MEAS_VBG_MIN_VAL || vbg > MEAS_VBG_MAX_VAL)
-		vbg = MEAS_VBG_DEFAULT_VAL;
+	IWL_ERR(mvm, "Enter CT Kill\n");
+	iwl_mvm_set_hw_ctkill_state(mvm, true);
 
-	return vbg;
+	/* Don't schedule an exit work if we're in test mode, since
+	 * the temperature will not change unless we manually set it
+	 * again (or disable testing).
+	 */
+	if (!mvm->temperature_test)
+		schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
+				      round_jiffies_relative(duration * HZ));
 }
 
-static u16 iwl_mvm_dts_get_ptat_deviation_offset(struct iwl_mvm *mvm)
+static void iwl_mvm_exit_ctkill(struct iwl_mvm *mvm)
 {
-	const u8 *calib;
-	u8 ptat, pa1, pa2, median;
-
-	/* TODO: move parsing to NVM code */
-	calib = mvm->nvm_sections[NVM_SECTION_TYPE_CALIBRATION].data;
-	ptat = calib[OTP_DTS_DIODE_DEVIATION * 2];
-	pa1 = calib[OTP_DTS_DIODE_DEVIATION * 2 + 1];
-	pa2 = calib[OTP_DTS_DIODE_DEVIATION * 2 + 2];
-
-	/* get the median: */
-	if (ptat > pa1) {
-		if (ptat > pa2)
-			median = (pa1 > pa2) ? pa1 : pa2;
-		else
-			median = ptat;
-	} else {
-		if (pa1 > pa2)
-			median = (ptat > pa2) ? ptat : pa2;
-		else
-			median = pa1;
-	}
+	if (!test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
+		return;
 
-	return ptat - median;
+	IWL_ERR(mvm, "Exit CT Kill\n");
+	iwl_mvm_set_hw_ctkill_state(mvm, false);
 }
 
-static u8 iwl_mvm_dts_calibrate_ptat_deviation(struct iwl_mvm *mvm, u8 value)
+static bool iwl_mvm_temp_notif(struct iwl_notif_wait_data *notif_wait,
+			       struct iwl_rx_packet *pkt, void *data)
 {
-	/* Calibrate the PTAT digital value, based on PTAT deviation data: */
-	s16 new_val = value - iwl_mvm_dts_get_ptat_deviation_offset(mvm);
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	int *temp = data;
+	struct iwl_dts_measurement_notif *notif;
+	int len = iwl_rx_packet_payload_len(pkt);
+
+	if (WARN_ON_ONCE(len != sizeof(*notif))) {
+		IWL_ERR(mvm, "Invalid DTS_MEASUREMENT_NOTIFICATION\n");
+		return true;
+	}
 
-	if (new_val > PTAT_DIGITAL_VALUE_MAX_VALUE)
-		new_val = PTAT_DIGITAL_VALUE_MAX_VALUE;
-	else if (new_val < PTAT_DIGITAL_VALUE_MIN_VALUE)
-		new_val = PTAT_DIGITAL_VALUE_MIN_VALUE;
+	notif = (void *)pkt->data;
 
-	return new_val;
-}
+	*temp = le32_to_cpu(notif->temp);
 
-static bool dts_get_adjacent_vrefs(struct iwl_mvm *mvm,
-				   union dts_diode_results *avg_ptat)
-{
-	u8 vrefs_results[DTS_VREFS_NUM];
-	u8 low_vref_index = 0, flags;
-	u32 reg;
-
-	reg = iwl_read_prph(mvm->trans, DTSC_VREF_AVG);
-	memcpy(vrefs_results, &reg, sizeof(reg));
-	reg = iwl_read_prph(mvm->trans, DTSC_VREF5_AVG);
-	vrefs_results[4] = reg & 0xff;
-
-	if (avg_ptat->bits.digital_value < vrefs_results[0] ||
-	    avg_ptat->bits.digital_value > vrefs_results[4])
-		return false;
-
-	if (avg_ptat->bits.digital_value > vrefs_results[3])
-		low_vref_index = 3;
-	else if (avg_ptat->bits.digital_value > vrefs_results[2])
-		low_vref_index = 2;
-	else if (avg_ptat->bits.digital_value > vrefs_results[1])
-		low_vref_index = 1;
-
-	avg_ptat->bits.vref_low  = vrefs_results[low_vref_index];
-	avg_ptat->bits.vref_high = vrefs_results[low_vref_index + 1];
-	flags = avg_ptat->bits.flags;
-	avg_ptat->bits.flags =
-		(flags & ~DTS_DIODE_REG_FLAGS_VREFS_ID) |
-		(low_vref_index & DTS_DIODE_REG_FLAGS_VREFS_ID);
-	return true;
-}
+	/* shouldn't be negative, but since it's s32, make sure it isn't */
+	if (WARN_ON_ONCE(*temp < 0))
+		*temp = 0;
 
-/*
- * return true it the results are valid, and false otherwise.
- */
-static bool dts_read_ptat_avg_results(struct iwl_mvm *mvm,
-				      union dts_diode_results *avg_ptat)
-{
-	u32 reg;
-	u8 tmp;
-
-	/* fill the diode value and pass_once with avg-reg results */
-	reg = iwl_read_prph(mvm->trans, DTSC_PTAT_AVG);
-	reg &= DTS_DIODE_REG_DIG_VAL | DTS_DIODE_REG_PASS_ONCE;
-	avg_ptat->reg_value = reg;
-
-	/* calibrate the PTAT digital value */
-	tmp = avg_ptat->bits.digital_value;
-	tmp = iwl_mvm_dts_calibrate_ptat_deviation(mvm, tmp);
-	avg_ptat->bits.digital_value = tmp;
-
-	/*
-	 * fill vrefs fields, based on the avgVrefs results
-	 * and the diode value
-	 */
-	return dts_get_adjacent_vrefs(mvm, avg_ptat) &&
-		DTS_DIODE_VALID(avg_ptat->bits.flags);
+	IWL_DEBUG_TEMP(mvm, "DTS_MEASUREMENT_NOTIFICATION - %d\n", *temp);
+	return true;
 }
 
-static s32 calculate_nic_temperature(union dts_diode_results avg_ptat,
-				     u16 volt_band_gap)
+static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 {
-	u32 tmp_result;
-	u8 vrefs_diff;
-	/*
-	 * For temperature calculation (at the end, shift right by 23)
-	 * LUT[(D2-D1)] = ROUND{ 2^23 / ((D2-D1)*9*10) }
-	 * (D2-D1) ==   43    44    45    46    47    48    49    50    51
-	 */
-	static const u16 calc_lut[CALC_LUT_SIZE] = {
-		2168, 2118, 2071, 2026, 1983, 1942, 1902, 1864, 1828,
+	struct iwl_dts_measurement_cmd cmd = {
+		.flags = cpu_to_le32(DTS_TRIGGER_CMD_FLAGS_TEMP),
 	};
 
-	/*
-	 * The diff between the high and low voltage-references is assumed
-	 * to be strictly be in range of [60,68]
-	 */
-	vrefs_diff = avg_ptat.bits.vref_high - avg_ptat.bits.vref_low;
-
-	if (vrefs_diff < CALC_VREFS_MIN_DIFF ||
-	    vrefs_diff > CALC_VREFS_MAX_DIFF)
-		return TEMPERATURE_ERROR;
-
-	/* calculate the result: */
-	tmp_result =
-		vrefs_diff * (DTS_DIODE_GET_VREFS_ID(avg_ptat.bits.flags) + 9);
-	tmp_result += avg_ptat.bits.digital_value;
-	tmp_result -= avg_ptat.bits.vref_high;
-
-	/* multiply by the LUT value (based on the diff) */
-	tmp_result *= calc_lut[vrefs_diff - CALC_LUT_INDEX_OFFSET];
-
-	/*
-	 * Get the BandGap (the voltage refereces source) error data
-	 * (temperature offset)
-	 */
-	tmp_result *= volt_band_gap;
-
-	/*
-	 * here, tmp_result value can be up to 32-bits. We want to right-shift
-	 * it *without* sign-extend.
-	 */
-	tmp_result = tmp_result >> CALC_TEMPERATURE_RESULT_SHIFT_OFFSET;
-
-	/*
-	 * at this point, tmp_result should be in the range:
-	 * 200 <= tmp_result <= 365
-	 */
-	return (s16)tmp_result - 240;
-}
-
-static s32 check_nic_temperature(struct iwl_mvm *mvm)
-{
-	u16 volt_band_gap;
-	union dts_diode_results avg_ptat;
-
-	volt_band_gap = iwl_mvm_dts_get_volt_band_gap(mvm);
-
-	/* disable DTS */
-	iwl_write_prph(mvm->trans, SHR_MISC_WFM_DTS_EN, 0);
-
-	/* SV initialization */
-	iwl_write_prph(mvm->trans, SHR_MISC_WFM_DTS_EN, 1);
-	iwl_write_prph(mvm->trans, DTSC_CFG_MODE,
-		       DTSC_CFG_MODE_PERIODIC);
-
-	/* wait for results */
-	msleep(100);
-	if (!dts_read_ptat_avg_results(mvm, &avg_ptat))
-		return TEMPERATURE_ERROR;
-
-	/* disable DTS */
-	iwl_write_prph(mvm->trans, SHR_MISC_WFM_DTS_EN, 0);
-
-	return calculate_nic_temperature(avg_ptat, volt_band_gap);
+	return iwl_mvm_send_cmd_pdu(mvm, CMD_DTS_MEASUREMENT_TRIGGER, 0,
+				    sizeof(cmd), &cmd);
 }
 
-static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
+static int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 {
-	u32 duration = mvm->thermal_throttle.params->ct_kill_duration;
+	struct iwl_notification_wait wait_temp_notif;
+	static const u8 temp_notif[] = { DTS_MEASUREMENT_NOTIFICATION };
+	int ret, temp;
 
-	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
-		return;
+	lockdep_assert_held(&mvm->mutex);
 
-	IWL_ERR(mvm, "Enter CT Kill\n");
-	iwl_mvm_set_hw_ctkill_state(mvm, true);
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_temp_notif,
+				   temp_notif, ARRAY_SIZE(temp_notif),
+				   iwl_mvm_temp_notif, &temp);
 
-	/* Don't schedule an exit work if we're in test mode, since
-	 * the temperature will not change unless we manually set it
-	 * again (or disable testing).
-	 */
-	if (!mvm->temperature_test)
-		schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
-				      round_jiffies_relative(duration * HZ));
-}
+	ret = iwl_mvm_get_temp_cmd(mvm);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to get the temperature (err=%d)\n", ret);
+		iwl_remove_notification(&mvm->notif_wait, &wait_temp_notif);
+		return ret;
+	}
 
-static void iwl_mvm_exit_ctkill(struct iwl_mvm *mvm)
-{
-	if (!test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
-		return;
+	ret = iwl_wait_notification(&mvm->notif_wait, &wait_temp_notif,
+				    IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT);
+	if (ret) {
+		IWL_ERR(mvm, "Getting the temperature timed out\n");
+		return ret;
+	}
 
-	IWL_ERR(mvm, "Exit CT Kill\n");
-	iwl_mvm_set_hw_ctkill_state(mvm, false);
+	return temp;
 }
 
 static void check_exit_ctkill(struct work_struct *work)
@@ -352,28 +176,36 @@ static void check_exit_ctkill(struct work_struct *work)
 
 	duration = tt->params->ct_kill_duration;
 
+	mutex_lock(&mvm->mutex);
+
+	if (__iwl_mvm_mac_start(mvm))
+		goto reschedule;
+
 	/* make sure the device is available for direct read/writes */
-	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_CHECK_CTKILL))
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_CHECK_CTKILL)) {
+		__iwl_mvm_mac_stop(mvm);
 		goto reschedule;
+	}
 
-	iwl_trans_start_hw(mvm->trans);
-	temp = check_nic_temperature(mvm);
-	iwl_trans_stop_device(mvm->trans);
+	temp = iwl_mvm_get_temp(mvm);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_CHECK_CTKILL);
 
-	if (temp < MIN_TEMPERATURE || temp > MAX_TEMPERATURE) {
-		IWL_DEBUG_TEMP(mvm, "Failed to measure NIC temperature\n");
+	__iwl_mvm_mac_stop(mvm);
+
+	if (temp < 0)
 		goto reschedule;
-	}
+
 	IWL_DEBUG_TEMP(mvm, "NIC temperature: %d\n", temp);
 
 	if (temp <= tt->params->ct_kill_exit) {
+		mutex_unlock(&mvm->mutex);
 		iwl_mvm_exit_ctkill(mvm);
 		return;
 	}
 
 reschedule:
+	mutex_unlock(&mvm->mutex);
 	schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
 			      round_jiffies(duration * HZ));
 }
-- 
1.9.1

