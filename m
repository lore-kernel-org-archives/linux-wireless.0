Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45642 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaJUQFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:05:01 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/8] iwlwifi: configure the LTR
Date: Tue, 21 Oct 2014 19:04:32 +0300
Message-Id: <1413907479-9073-1-git-send-email-egrumbach@gmail.com> (sfid-20141021_180529_270404_07065BAD)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The LTR is the handshake between the device and the root
complex about the latency allowed when the bus exits power
save. This configuration was missing and this led to high
latency in the link power up. The end user could experience
high latency in the network because of this.

Cc: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 35 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  9 +++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 16 ++++++-----
 6 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9eb8524..d8fc548 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -563,6 +563,7 @@ enum iwl_trans_state {
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
+ * @ltr_enabled: set to true if the LTR is enabled
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @dev_cmd_headroom: room needed for the transport's private use before the
@@ -589,6 +590,7 @@ struct iwl_trans {
 	u8 rx_mpdu_cmd, rx_mpdu_cmd_hdr_size;
 
 	bool pm_support;
+	bool ltr_enabled;
 
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 27dd863..2fd8ad4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -68,13 +68,46 @@
 
 /* Power Management Commands, Responses, Notifications */
 
+/**
+ * enum iwl_ltr_config_flags - masks for LTR config command flags
+ * @LTR_CFG_FLAG_FEATURE_ENABLE: Feature operational status
+ * @LTR_CFG_FLAG_HW_DIS_ON_SHADOW_REG_ACCESS: allow LTR change on shadow
+ *	memory access
+ * @LTR_CFG_FLAG_HW_EN_SHRT_WR_THROUGH: allow LTR msg send on ANY LTR
+ *	reg change
+ * @LTR_CFG_FLAG_HW_DIS_ON_D0_2_D3: allow LTR msg send on transition from
+ *	D0 to D3
+ * @LTR_CFG_FLAG_SW_SET_SHORT: fixed static short LTR register
+ * @LTR_CFG_FLAG_SW_SET_LONG: fixed static short LONG register
+ * @LTR_CFG_FLAG_DENIE_C10_ON_PD: allow going into C10 on PD
+ */
+enum iwl_ltr_config_flags {
+	LTR_CFG_FLAG_FEATURE_ENABLE = BIT(0),
+	LTR_CFG_FLAG_HW_DIS_ON_SHADOW_REG_ACCESS = BIT(1),
+	LTR_CFG_FLAG_HW_EN_SHRT_WR_THROUGH = BIT(2),
+	LTR_CFG_FLAG_HW_DIS_ON_D0_2_D3 = BIT(3),
+	LTR_CFG_FLAG_SW_SET_SHORT = BIT(4),
+	LTR_CFG_FLAG_SW_SET_LONG = BIT(5),
+	LTR_CFG_FLAG_DENIE_C10_ON_PD = BIT(6),
+};
+
+/**
+ * struct iwl_ltr_config_cmd - configures the LTR
+ * @flags: See %enum iwl_ltr_config_flags
+ */
+struct iwl_ltr_config_cmd {
+	__le32 flags;
+	__le32 static_long;
+	__le32 static_short;
+} __packed;
+
 /* Radio LP RX Energy Threshold measured in dBm */
 #define POWER_LPRX_RSSI_THRESHOLD	75
 #define POWER_LPRX_RSSI_THRESHOLD_MAX	94
 #define POWER_LPRX_RSSI_THRESHOLD_MIN	30
 
 /**
- * enum iwl_scan_flags - masks for power table command flags
+ * enum iwl_power_flags - masks for power table command flags
  * @POWER_FLAGS_POWER_SAVE_ENA_MSK: '1' Allow to save power by turning off
  *		receiver and transmitter. '0' - does not allow.
  * @POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK: '0' Driver disables power management,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 667a922..c62575d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -157,6 +157,7 @@ enum {
 	/* Power - legacy power table command */
 	POWER_TABLE_CMD = 0x77,
 	PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION = 0x78,
+	LTR_CONFIG = 0xee,
 
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 23fd711..e0d9f19 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -480,6 +480,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
 
+	if (mvm->trans->ltr_enabled) {
+		struct iwl_ltr_config_cmd cmd = {
+			.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
+		};
+
+		WARN_ON(iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
+					     sizeof(cmd), &cmd));
+	}
+
 	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 15aa298..48cb25a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -336,6 +336,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(DTS_MEASUREMENT_NOTIFICATION),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
+	CMD(LTR_CONFIG),
 	CMD(BT_COEX_CI),
 	CMD(BT_COEX_UPDATE_SW_BOOST),
 	CMD(BT_COEX_UPDATE_CORUN_LUT),
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1393bac..c706dba 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -174,6 +174,7 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u16 lctl;
+	u16 cap;
 
 	/*
 	 * HW bug W/A for instability in PCIe bus L0S->L1 transition.
@@ -184,16 +185,17 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
 	 *    power savings, even without L1.
 	 */
 	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_LNKCTL, &lctl);
-	if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
-		/* L1-ASPM enabled; disable(!) L0S */
+	if (lctl & PCI_EXP_LNKCTL_ASPM_L1)
 		iwl_set_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_info(trans->dev, "L1 Enabled; Disabling L0S\n");
-	} else {
-		/* L1-ASPM disabled; enable(!) L0S */
+	else
 		iwl_clear_bit(trans, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_info(trans->dev, "L1 Disabled; Enabling L0S\n");
-	}
 	trans->pm_support = !(lctl & PCI_EXP_LNKCTL_ASPM_L0S);
+
+	pcie_capability_read_word(trans_pcie->pci_dev, PCI_EXP_DEVCTL2, &cap);
+	trans->ltr_enabled = cap & PCI_EXP_DEVCTL2_LTR_EN;
+	dev_info(trans->dev, "L1 %sabled - LTR %sabled\n",
+		 (lctl & PCI_EXP_LNKCTL_ASPM_L1) ? "En" : "Dis",
+		 trans->ltr_enabled ? "En" : "Dis");
 }
 
 /*
-- 
1.9.1

