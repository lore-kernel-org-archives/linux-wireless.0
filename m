Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbcAGMrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/21] iwlwifi: mvm: let the firmware choose the antenna for beacons
Date: Thu,  7 Jan 2016 14:47:23 +0200
Message-Id: <1452170861-10060-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134857_735657_351D6D1E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware knows better what antenna to choose.
Old firmware still need the setting, so use a flag to know
if the driver should choose the antenna or if the firmware
can do it iself.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index d2294ad6..9f24f99 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -309,6 +309,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
+ * @IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION: firmware will decide on what
+ *	antenna the beacon should be transmitted
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -336,6 +338,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
+	IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION		= (__force iwl_ucode_tlv_capa_t)71,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 5e3a758..448b9c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1012,9 +1012,12 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 						TX_CMD_FLG_BT_PRIO_POS;
 	beacon_cmd.tx.tx_flags = cpu_to_le32(tx_flags);
 
-	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
-				     mvm->mgmt_last_antenna_idx);
+	if (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION)) {
+		mvm->mgmt_last_antenna_idx =
+			iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
+					     mvm->mgmt_last_antenna_idx);
+	}
 
 	beacon_cmd.tx.rate_n_flags =
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
-- 
2.5.0

