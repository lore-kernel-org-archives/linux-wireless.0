Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbbCLNGO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/49] iwlwifi: mvm: don't init MCC during CT-kill
Date: Thu, 12 Mar 2015 15:04:23 +0200
Message-Id: <1426165474-25586-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_319904_74B4966B)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

RTNL is not taken during CT-kill so regulatory APIs cannot be invoked.
That's fine, since the HW is only brought up to check the temperature
during CT-kill. We don't expect Tx or scanning.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index c03bde0..6cf7d98 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -739,9 +739,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
-	ret = iwl_mvm_init_mcc(mvm);
-	if (ret)
-		goto error;
+	/*
+	 * RTNL is not taken during Ct-kill, but we don't need to scan/Tx
+	 * anyway, so don't init MCC.
+	 */
+	if (!test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status)) {
+		ret = iwl_mvm_init_mcc(mvm);
+		if (ret)
+			goto error;
+	}
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		ret = iwl_mvm_config_scan(mvm);
-- 
1.9.1

