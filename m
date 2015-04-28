Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:17041 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457AbbD1MnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/8] iwlwifi: mvm: fix Tx Power firmware API
Date: Tue, 28 Apr 2015 15:43:05 +0300
Message-Id: <1430224992-20327-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144325_666242_4BD5D831)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The firmware doesn't relate the scan to a vif. The scan is
run by a separate entity called auxiliary MAC (aka AUX MAC).
This AUX MAC needs to get Tx power limitations that are
not applied on a specific vif, but on the device as a whole.

This can be implemented by using the minimum of all the
values set by the user for all the MACs. But then we need
to ignore the limitations that come from the AP or
regulatory for a specific vif: a specific vif might have
regulatory limitations because of the channel is works on.
This limit is irrelevant for the AUX MAC.
Use the new API from mac80211: the user_power_level in
bss_conf to achieve this.

Firmware -13.ucode has already moved to this API.

Change-Id: Ifba83660f378e91b93bd46d29fe8ba35a7c168a4
Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 34 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       | 13 ----------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 24 +++++++++++++++--
 4 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index bfdf3fa..62db2e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -244,6 +244,7 @@ enum iwl_ucode_tlv_flag {
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
+ * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
  * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
  *	regardless of the band or the number of the probes. FW will calculate
  *	the actual dwell time.
@@ -260,6 +261,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= BIT(9),
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
+	IWL_UCODE_TLV_API_TX_POWER_DEV		= BIT(11),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
 	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 4fc0938b..b1baa33 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -298,6 +298,40 @@ struct iwl_uapsd_misbehaving_ap_notif {
 } __packed;
 
 /**
+ * struct iwl_reduce_tx_power_cmd - TX power reduction command
+ * REDUCE_TX_POWER_CMD = 0x9f
+ * @flags: (reserved for future implementation)
+ * @mac_context_id: id of the mac ctx for which we are reducing TX power.
+ * @pwr_restriction: TX power restriction in dBms.
+ */
+struct iwl_reduce_tx_power_cmd {
+	u8 flags;
+	u8 mac_context_id;
+	__le16 pwr_restriction;
+} __packed; /* TX_REDUCED_POWER_API_S_VER_1 */
+
+/**
+ * struct iwl_dev_tx_power_cmd - TX power reduction command
+ * REDUCE_TX_POWER_CMD = 0x9f
+ * @set_mode: 0 - MAC tx power, 1 - device tx power
+ * @mac_context_id: id of the mac ctx for which we are reducing TX power.
+ * @pwr_restriction: TX power restriction in 1/8 dBms.
+ * @dev_24: device TX power restriction in 1/8 dBms
+ * @dev_52_low: device TX power restriction upper band - low
+ * @dev_52_high: device TX power restriction upper band - high
+ */
+struct iwl_dev_tx_power_cmd {
+	__le32 set_mode;
+	__le32 mac_context_id;
+	__le16 pwr_restriction;
+	__le16 dev_24;
+	__le16 dev_52_low;
+	__le16 dev_52_high;
+} __packed; /* TX_REDUCED_POWER_API_S_VER_2 */
+
+#define IWL_DEV_MAX_TX_POWER 0x7FFF
+
+/**
  * struct iwl_beacon_filter_cmd
  * REPLY_BEACON_FILTERING_CMD = 0xd2 (command)
  * @id_and_color: MAC contex identifier
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index aab68cb..01b1da6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -281,19 +281,6 @@ struct iwl_tx_ant_cfg_cmd {
 	__le32 valid;
 } __packed;
 
-/**
- * struct iwl_reduce_tx_power_cmd - TX power reduction command
- * REDUCE_TX_POWER_CMD = 0x9f
- * @flags: (reserved for future implementation)
- * @mac_context_id: id of the mac ctx for which we are reducing TX power.
- * @pwr_restriction: TX power restriction in dBms.
- */
-struct iwl_reduce_tx_power_cmd {
-	u8 flags;
-	u8 mac_context_id;
-	__le16 pwr_restriction;
-} __packed; /* TX_REDUCED_POWER_API_S_VER_1 */
-
 /*
  * Calibration control struct.
  * Sent as part of the phy configuration command.
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8455517..7c2d5ac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1471,8 +1471,8 @@ static struct iwl_mvm_phy_ctxt *iwl_mvm_get_free_phy_ctxt(struct iwl_mvm *mvm)
 	return NULL;
 }
 
-static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				s8 tx_power)
+static int iwl_mvm_set_tx_power_old(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif, s8 tx_power)
 {
 	/* FW is in charge of regulatory enforcement */
 	struct iwl_reduce_tx_power_cmd reduce_txpwr_cmd = {
@@ -1485,6 +1485,26 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				    &reduce_txpwr_cmd);
 }
 
+static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				s16 tx_power)
+{
+	struct iwl_dev_tx_power_cmd cmd = {
+		.set_mode = 0,
+		.mac_context_id =
+			cpu_to_le32(iwl_mvm_vif_from_mac80211(vif)->id),
+		.pwr_restriction = cpu_to_le16(8 * tx_power),
+	};
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_TX_POWER_DEV))
+		return iwl_mvm_set_tx_power_old(mvm, vif, tx_power);
+
+	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
+		cmd.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
+
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
+				    sizeof(cmd), &cmd);
+}
+
 static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
-- 
2.1.0

