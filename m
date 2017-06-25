Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35030 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751134AbdFYLNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:50 +0300
Message-Id: <20170625111158.1792-19-luca@coelho.fi> (sfid-20170625_131324_011054_C30AA17B)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 18/26] iwlwifi: mvm: reset the fw_dump_desc pointer after ASSERT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we get an ASSERT, the fw_dump_desc pointer points to
iwl_mvm_dump_desc_assert which can't be freed since it is
a global. We still need to NULL'ify the pointer when we
call iwl_mvm_free_fw_dump_desc otherwise we will hit

int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
                                const struct iwl_mvm_dump_desc *desc,
                                const struct iwl_fw_dbg_trigger_tlv *trigger)
{
<snip>
        if (WARN_ON(mvm->fw_dump_desc))
                iwl_mvm_free_fw_dump_desc(mvm);

Fixes: b6eaa45aa18b ("iwlwifi: mvm: add the cause of the firmware dump in the dump")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index d5cb47e2fe44..1602b360353c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -319,10 +319,8 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 
 void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
 {
-	if (mvm->fw_dump_desc == &iwl_mvm_dump_desc_assert)
-		return;
-
-	kfree(mvm->fw_dump_desc);
+	if (mvm->fw_dump_desc != &iwl_mvm_dump_desc_assert)
+		kfree(mvm->fw_dump_desc);
 	mvm->fw_dump_desc = NULL;
 }
 
-- 
2.11.0
