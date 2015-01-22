Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbAVUeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:19 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/38] iwlwifi: mvm: ignore temperature updates in the RX statistics notification
Date: Thu, 22 Jan 2015 22:33:13 +0200
Message-Id: <1421958809-3371-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214448_434151_9436C7D8)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If the firmware sends spontaneous DTS notfications with the
temperature (indicated in a TLV), we can ignore the temperature we get
in the RX statistics notifications.  This prevents potentially
handling the same temperature change twice.  It also ignores
notifications with temperature equal to 0 that happens from time to
time.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/rx.c      | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 32e8b5b..115e604 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -246,6 +246,7 @@ enum iwl_ucode_tlv_flag {
  *	the actual dwell time.
  * @IWL_UCODE_TLV_API_SCD_CFG: This firmware can configure the scheduler
  *	through the dedicated host command.
+ * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -255,6 +256,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
 	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
+	IWL_UCODE_TLV_API_ASYNC_DTM		= BIT(17),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 02e0f37..7919a7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -516,7 +516,11 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 		.mvm = mvm,
 	};
 
-	iwl_mvm_tt_temp_changed(mvm,
+	/* Only handle rx statistics temperature changes if async temp
+	 * notifications are not supported
+	 */
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_ASYNC_DTM))
+		iwl_mvm_tt_temp_changed(mvm,
 				le32_to_cpu(stats->general.radio_temperature));
 
 	iwl_mvm_update_rx_statistics(mvm, stats);
-- 
1.9.1

