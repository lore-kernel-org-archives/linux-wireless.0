Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbCATcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/31] iwlwifi: add new TLV capability flag for BT PLCR
Date: Sun,  1 Mar 2015 21:31:33 +0200
Message-Id: <1425238304-498-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_237594_1E0E01FF)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packet Level Co-Running is a BT Coex feature which is
supported on certain devices only, hence the need for
a TLV flag for it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 6 ++++++
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 3ec32e8..5970682 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -289,6 +289,7 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
+ * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -304,6 +305,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= BIT(22),
+	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= BIT(28),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 1ec4d55..ce99572 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -611,7 +611,7 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		bt_cmd->enabled_modules |=
 			cpu_to_le32(BT_COEX_SYNC2SCO_ENABLED);
 
-	if (IWL_MVM_BT_COEX_CORUNNING)
+	if (iwl_mvm_bt_is_plcr_supported(mvm))
 		bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_CORUN_ENABLED);
 
 	if (IWL_MVM_BT_COEX_MPLUT) {
@@ -1234,7 +1234,7 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_rx_ant_coupling_notif_old(mvm, rxb, dev_cmd);
 
-	if (!IWL_MVM_BT_COEX_CORUNNING)
+	if (!iwl_mvm_bt_is_plcr_supported(mvm))
 		return 0;
 
 	lockdep_assert_held(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index adfd1ec..9717ee6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -619,7 +619,7 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 	if (IWL_MVM_BT_COEX_SYNC2SCO)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
 
-	if (IWL_MVM_BT_COEX_CORUNNING) {
+	if (iwl_mvm_bt_is_plcr_supported(mvm)) {
 		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_CORUN_LUT_20 |
 						     BT_VALID_CORUN_LUT_40);
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
@@ -1207,7 +1207,7 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 
-	if (!IWL_MVM_BT_COEX_CORUNNING)
+	if (!iwl_mvm_bt_is_plcr_supported(mvm))
 		return 0;
 
 	lockdep_assert_held(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5e383db..f78a006 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -898,6 +898,12 @@ static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SCD_CFG;
 }
 
+static inline bool iwl_mvm_bt_is_plcr_supported(struct iwl_mvm *mvm)
+{
+	return (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BT_COEX_PLCR) &&
+		IWL_MVM_BT_COEX_CORUNNING;
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
-- 
1.9.1

