Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40810 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755702AbcH2TkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:40:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 29 Aug 2016 22:39:53 +0300
Message-Id: <1472499594-3369-3-git-send-email-luca@coelho.fi> (sfid-20160829_214013_148700_04D155DF)
In-Reply-To: <1472499594-3369-1-git-send-email-luca@coelho.fi>
References: <1472499451.27868.31.camel@coelho.fi>
 <1472499594-3369-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 3/4] iwlwifi: mvm: don't use ret when not initialised
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

fw-dbg code return ret but that variable was either 0
or not initialised. Return 0 always.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: 6a95126763fb ("iwlwifi: mvm: send dbg config hcmds to fw if set in tlv")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 1abcabb..46b52bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -960,5 +960,6 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 	}
 
 	mvm->fw_dbg_conf = conf_id;
-	return ret;
+
+	return 0;
 }
-- 
2.8.1
