Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbbCLNFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/49] iwlwifi: mvm: BT Coex - disable RRC by default
Date: Thu, 12 Mar 2015 15:04:08 +0200
Message-Id: <1426165474-25586-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_054498_A32AC41B)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable this feature only if the firmware advertises support
for it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 6 ++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index e5fd19d..291a338 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -290,6 +290,7 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
+ * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
@@ -306,6 +307,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= BIT(22),
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= BIT(28),
+	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= BIT(30),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 9717ee6..593bed7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -633,7 +633,7 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 	if (IWL_MVM_BT_COEX_TTC)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_TTC);
 
-	if (IWL_MVM_BT_COEX_RRC)
+	if (iwl_mvm_bt_is_rrc_supported(mvm))
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_RRC);
 
 	if (mvm->cfg->bt_shared_single_ant)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 9a8868e..4d44cf0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -948,6 +948,12 @@ static inline bool iwl_mvm_bt_is_plcr_supported(struct iwl_mvm *mvm)
 		IWL_MVM_BT_COEX_CORUNNING;
 }
 
+static inline bool iwl_mvm_bt_is_rrc_supported(struct iwl_mvm *mvm)
+{
+	return (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BT_COEX_RRC) &&
+		IWL_MVM_BT_COEX_RRC;
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
-- 
1.9.1

