Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbcCBH5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/43] iwlwifi: mvm: disable DQA support
Date: Wed,  2 Mar 2016 09:56:40 +0200
Message-Id: <1456905404-14435-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_161835_055F3096)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Do not allow entrance into DQA flows until feature is
completely ready and merged.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6d4e487..7ea2baa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -986,8 +986,9 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
 {
-	return fw_has_capa(&mvm->fw->ucode_capa,
-			   IWL_UCODE_TLV_CAPA_DQA_SUPPORT);
+	/* Make sure DQA isn't allowed in driver until feature is complete */
+	return false && fw_has_capa(&mvm->fw->ucode_capa,
+				    IWL_UCODE_TLV_CAPA_DQA_SUPPORT);
 }
 
 static inline bool iwl_mvm_enter_d0i3_on_suspend(struct iwl_mvm *mvm)
-- 
2.5.0

