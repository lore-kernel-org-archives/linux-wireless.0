Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34958 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751339AbdFYLMm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:53 +0300
Message-Id: <20170625111158.1792-22-luca@coelho.fi> (sfid-20170625_131301_815239_A5DDBC5C)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 21/26] iwlwifi: mvm: print base HW address during init
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

It's sometimes hard to find out which HW address the iwlwifi device is
using, for instance when reading crouded sniffer logs.  To make it
easier, print out an info level message with the HW address as soon as
we know it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 070f3dfb94ce..5c08f4d40f6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -640,6 +640,8 @@ static int iwl_set_hw_address(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
+	IWL_INFO(trans, "base HW address: %pM\n", data->hw_addr);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index efdcffbaac6f..dac7e542a190 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -599,6 +599,8 @@ int iwl_mvm_nvm_get_from_fw(struct iwl_mvm *mvm)
 		goto err_free;
 	}
 
+	IWL_INFO(trans, "base HW address: %pM\n", mvm->nvm_data->hw_addr);
+
 	/* Initialize general data */
 	mvm->nvm_data->nvm_version = le16_to_cpu(rsp->general.nvm_version);
 
-- 
2.11.0
