Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbcCBH4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:56:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/43] iwlwifi: mvm: add registration to cooling device
Date: Wed,  2 Mar 2016 09:56:04 +0200
Message-Id: <1456905404-14435-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085655_591913_F0758D30)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Register cooling device in order to have the Thermal
Manager handle the device's power budget according to the sent
notifications.
The interface adds a new thermal cooling device to
/sys/class/thermal/ folder.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h  |  26 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c      |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  19 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      | 147 +++++++++++++++++++++++
 6 files changed, 200 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 724a3ee..63dc109 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -321,6 +321,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_CT_KILL_BY_FW: firmware responsible for CT-kill
  * @IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT: supports temperature
  *	thresholds reporting
+ * @IWL_UCODE_TLV_CAPA_CTDP_SUPPORT: supports cTDP command
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -356,6 +357,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V2		= (__force iwl_ucode_tlv_capa_t)73,
 	IWL_UCODE_TLV_CAPA_CT_KILL_BY_FW		= (__force iwl_ucode_tlv_capa_t)74,
 	IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT	= (__force iwl_ucode_tlv_capa_t)75,
+	IWL_UCODE_TLV_CAPA_CTDP_SUPPORT			= (__force iwl_ucode_tlv_capa_t)76,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index e692098..d5f9037 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -279,6 +279,7 @@ enum {
  */
 enum iwl_phy_ops_subcmd_ids {
 	CMD_DTS_MEASUREMENT_TRIGGER_WIDE = 0x0,
+	CTDP_CONFIG_CMD = 0x03,
 	TEMP_REPORTING_THRESHOLDS_CMD = 0x04,
 	CT_KILL_NOTIFICATION = 0xFE,
 	DTS_MEASUREMENT_NOTIF_WIDE = 0xFF,
@@ -1711,6 +1712,31 @@ struct ct_kill_notif {
 	__le16 reserved;
 } __packed; /* GRP_PHY_CT_KILL_NTF */
 
+/**
+* enum ctdp_cmd_operation - CTDP command operations
+* @CTDP_CMD_OPERATION_START: update the current budget
+* @CTDP_CMD_OPERATION_STOP: stop ctdp
+* @CTDP_CMD_OPERATION_REPORT: get the avgerage budget
+*/
+enum iwl_mvm_ctdp_cmd_operation {
+	CTDP_CMD_OPERATION_START	= 0x1,
+	CTDP_CMD_OPERATION_STOP		= 0x2,
+	CTDP_CMD_OPERATION_REPORT	= 0x4,
+};/* CTDP_CMD_OPERATION_TYPE_E */
+
+/**
+ * struct iwl_mvm_ctdp_cmd - track and manage the FW power consumption budget
+ *
+ * @operation: see &enum iwl_mvm_ctdp_cmd_operation
+ * @budget: the budget in milliwatt
+ * @window_size: defined in API but not used
+ */
+struct iwl_mvm_ctdp_cmd {
+	__le32 operation;
+	__le32 budget;
+	__le32 window_size;
+} __packed;
+
 #define IWL_MAX_DTS_TRIPS	8
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 07f2cbd..3e596e4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -963,6 +963,11 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		/* Initialize tx backoffs to the minimal possible */
 		iwl_mvm_tt_tx_backoff(mvm, 0);
 	}
+
+	/* TODO: read the budget from BIOS / Platform NVM */
+	if (iwl_mvm_is_ctdp_supported(mvm) && mvm->cooling_dev.cur_state > 0)
+		ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_START,
+					   mvm->cooling_dev.cur_state);
 #else
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 87d3e28..d867cb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -535,6 +535,16 @@ struct iwl_mvm_thermal_device {
 	u8 fw_trips_index[IWL_MAX_DTS_TRIPS];
 	struct thermal_zone_device *tzone;
 };
+
+/*
+ * iwl_mvm_cooling_device
+ * @cur_state: current state in milliwatts
+ * @cdev: struct thermal cooling device
+ */
+struct iwl_mvm_cooling_device {
+	u32 cur_state;
+	struct thermal_cooling_device *cdev;
+};
 #endif
 
 #define IWL_MVM_NUM_LAST_FRAMES_UCODE_RATES 8
@@ -819,6 +829,7 @@ struct iwl_mvm {
 	struct iwl_mvm_tt_mgmt thermal_throttle;
 #ifdef CONFIG_THERMAL
 	struct iwl_mvm_thermal_device tz_device;
+	struct iwl_mvm_cooling_device cooling_dev;
 #endif
 
 	s32 temperature;	/* Celsius */
@@ -1068,6 +1079,12 @@ static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
 #endif /* CONFIG_THERMAL */
 }
 
+static inline bool iwl_mvm_is_ctdp_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_CTDP_SUPPORT);
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
@@ -1544,6 +1561,8 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp);
 void iwl_mvm_ct_kill_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 int iwl_mvm_send_temp_report_ths_cmd(struct iwl_mvm *mvm);
+int iwl_mvm_cooling_device_register(struct iwl_mvm *mvm);
+int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget);
 
 /* Location Aware Regulatory */
 struct iwl_mcc_update_resp *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a7acadd..ec36046 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -389,6 +389,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
  */
 static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 	HCMD_NAME(CMD_DTS_MEASUREMENT_TRIGGER_WIDE),
+	HCMD_NAME(CTDP_CONFIG_CMD),
 	HCMD_NAME(TEMP_REPORTING_THRESHOLDS_CMD),
 	HCMD_NAME(CT_KILL_NOTIFICATION),
 	HCMD_NAME(DTS_MEASUREMENT_NOTIF_WIDE),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 466d169..999bcb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -706,6 +706,139 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 		mvm->tz_device.temp_trips[i] = S16_MIN;
 }
 
+static const u32 iwl_mvm_cdev_budgets[] = {
+	2000,	/* cooling state 0 */
+	1800,	/* cooling state 1 */
+	1600,	/* cooling state 2 */
+	1400,	/* cooling state 3 */
+	1200,	/* cooling state 4 */
+	1000,	/* cooling state 5 */
+	900,	/* cooling state 6 */
+	800,	/* cooling state 7 */
+	700,	/* cooling state 8 */
+	650,	/* cooling state 9 */
+	600,	/* cooling state 10 */
+	550,	/* cooling state 11 */
+	500,	/* cooling state 12 */
+	450,	/* cooling state 13 */
+	400,	/* cooling state 14 */
+	350,	/* cooling state 15 */
+	300,	/* cooling state 16 */
+	250,	/* cooling state 17 */
+	200,	/* cooling state 18 */
+	150,	/* cooling state 19 */
+};
+
+int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
+{
+	struct iwl_mvm_ctdp_cmd cmd = {
+		.operation = cpu_to_le32(op),
+		.budget = cpu_to_le32(budget),
+		.window_size = 0,
+	};
+	int ret;
+	u32 status;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, WIDE_ID(PHY_OPS_GROUP,
+						       CTDP_CONFIG_CMD),
+					  sizeof(cmd), &cmd, &status);
+
+	if (ret) {
+		IWL_ERR(mvm, "cTDP command failed (err=%d)\n", ret);
+		return ret;
+	}
+
+	if (op == CTDP_CMD_OPERATION_START)
+		mvm->cooling_dev.cur_state = budget;
+
+	else if (op == CTDP_CMD_OPERATION_REPORT)
+		IWL_DEBUG_TEMP(mvm, "cTDP avg energy in mWatt = %d\n", status);
+
+	return 0;
+}
+
+static int iwl_mvm_tcool_get_max_state(struct thermal_cooling_device *cdev,
+				       unsigned long *state)
+{
+	*state = ARRAY_SIZE(iwl_mvm_cdev_budgets) - 1;
+
+	return 0;
+}
+
+static int iwl_mvm_tcool_get_cur_state(struct thermal_cooling_device *cdev,
+				       unsigned long *state)
+{
+	struct iwl_mvm *mvm = (struct iwl_mvm *)(cdev->devdata);
+
+	if (test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status))
+		return -EBUSY;
+
+	*state = mvm->cooling_dev.cur_state;
+	return 0;
+}
+
+static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
+				       unsigned long new_state)
+{
+	struct iwl_mvm *mvm = (struct iwl_mvm *)(cdev->devdata);
+	int ret;
+
+	if (!mvm->ucode_loaded || !(mvm->cur_ucode == IWL_UCODE_REGULAR))
+		return -EIO;
+
+	if (test_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status))
+		return -EBUSY;
+
+	mutex_lock(&mvm->mutex);
+
+	if (new_state >= ARRAY_SIZE(iwl_mvm_cdev_budgets)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_START,
+				   iwl_mvm_cdev_budgets[new_state]);
+
+unlock:
+	mutex_unlock(&mvm->mutex);
+	return ret;
+}
+
+static struct thermal_cooling_device_ops tcooling_ops = {
+	.get_max_state = iwl_mvm_tcool_get_max_state,
+	.get_cur_state = iwl_mvm_tcool_get_cur_state,
+	.set_cur_state = iwl_mvm_tcool_set_cur_state,
+};
+
+int iwl_mvm_cooling_device_register(struct iwl_mvm *mvm)
+{
+	char name[] = "iwlwifi";
+
+	if (!iwl_mvm_is_ctdp_supported(mvm)) {
+		mvm->cooling_dev.cdev = NULL;
+
+		return 0;
+	}
+
+	BUILD_BUG_ON(ARRAY_SIZE(name) >= THERMAL_NAME_LENGTH);
+
+	mvm->cooling_dev.cdev =
+		thermal_cooling_device_register(name,
+						mvm,
+						&tcooling_ops);
+
+	if (IS_ERR(mvm->cooling_dev.cdev)) {
+		IWL_DEBUG_TEMP(mvm,
+			       "Failed to register to cooling device (err = %ld)\n",
+			       PTR_ERR(mvm->cooling_dev.cdev));
+		return PTR_ERR(mvm->cooling_dev.cdev);
+	}
+
+	return 0;
+}
+
 static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
 {
 	if (!iwl_mvm_is_tt_in_fw(mvm))
@@ -717,6 +850,18 @@ static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
 		mvm->tz_device.tzone = NULL;
 	}
 }
+
+static void iwl_mvm_cooling_device_unregister(struct iwl_mvm *mvm)
+{
+	if (!iwl_mvm_is_ctdp_supported(mvm))
+		return;
+
+	if (mvm->cooling_dev.cdev) {
+		IWL_DEBUG_TEMP(mvm, "Cooling device unregister\n");
+		thermal_cooling_device_unregister(mvm->cooling_dev.cdev);
+		mvm->cooling_dev.cdev = NULL;
+	}
+}
 #endif /* CONFIG_THERMAL */
 
 void iwl_mvm_thermal_initialize(struct iwl_mvm *mvm, u32 min_backoff)
@@ -736,6 +881,7 @@ void iwl_mvm_thermal_initialize(struct iwl_mvm *mvm, u32 min_backoff)
 	INIT_DELAYED_WORK(&tt->ct_kill_exit, check_exit_ctkill);
 
 #ifdef CONFIG_THERMAL
+	iwl_mvm_cooling_device_register(mvm);
 	iwl_mvm_thermal_zone_register(mvm);
 #endif
 }
@@ -746,6 +892,7 @@ void iwl_mvm_thermal_exit(struct iwl_mvm *mvm)
 	IWL_DEBUG_TEMP(mvm, "Exit Thermal Throttling\n");
 
 #ifdef CONFIG_THERMAL
+	iwl_mvm_cooling_device_unregister(mvm);
 	iwl_mvm_thermal_zone_unregister(mvm);
 #endif
 }
-- 
2.5.0

