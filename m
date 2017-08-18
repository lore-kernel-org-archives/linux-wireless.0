Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44664 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751695AbdHRPxA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:53:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:21 +0300
Message-Id: <20170818154922.2904-24-luca@coelho.fi> (sfid-20170818_175303_484623_F4B04D88)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 23/24] iwlwifi: mvm: remove useless check for mvm->cfg in iwl_parse_nvm_section()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

At this point we have already copied the cfg pointer to mvm and we
have been dereferencing this pointer many times before, so it will
never be NULL or we would have crashed.  Remove the useless check.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 5a6916f0b9ec..b05673e4a193 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -326,9 +326,6 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 		}
 	}
 
-	if (WARN_ON(!mvm->cfg))
-		return NULL;
-
 	hw = (const __le16 *)sections[mvm->cfg->nvm_hw_section_num].data;
 	sw = (const __le16 *)sections[NVM_SECTION_TYPE_SW].data;
 	calib = (const __le16 *)sections[NVM_SECTION_TYPE_CALIBRATION].data;
-- 
2.14.1
