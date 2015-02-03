Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbBCHOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/19] iwlwifi: mvm: check IWL_UCODE_TLV_API_SCD_CFG in API and not in capa
Date: Tue,  3 Feb 2015 09:14:20 +0200
Message-Id: <1422947678-16917-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081446_806287_33584B58)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IWL_UCODE_TLV_API_SCD_CFG is a new API and hence, check if
enabled in the correct field.

Fixes: 0294d9eece86 ("iwlwifi: mvm: let the firmware configure the scheduler")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 979ac23..7773ffc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -874,7 +874,7 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_API_SCD_CFG;
+	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SCD_CFG;
 }
 
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
-- 
1.9.1

