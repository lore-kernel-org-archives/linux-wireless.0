Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44594 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbdHRPwZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:19 +0300
Message-Id: <20170818154922.2904-22-luca@coelho.fi> (sfid-20170818_175227_757123_BEF2AA36)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 21/24] iwlwifi: fw: fix lar_enabled endian problem in iwl_fw_get_nvm
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We read the regulatory.lar_enabled field in iwl_fw_get_nvm() and store
it in nvm->lar_enabled, taking care of endianness.  But then later we
read it again to pass the value to iwl_init_sbands() without handling
endianness.  To solve this, simply reuse nvm->lar_enabled when calling
that function.

Fixes: e9e1ba3dbf00 ("iwlwifi: mvm: support getting nvm data from firmware")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/nvm.c b/drivers/net/wireless/intel/iwlwifi/fw/nvm.c
index e81f6dd3744e..bd2e1fb43f5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/nvm.c
@@ -148,8 +148,7 @@ struct iwl_nvm_data *iwl_fw_get_nvm(struct iwl_fw_runtime *fwrt)
 			rsp->regulatory.channel_profile,
 			nvm->valid_tx_ant & fwrt->fw->valid_tx_ant,
 			nvm->valid_rx_ant & fwrt->fw->valid_rx_ant,
-			rsp->regulatory.lar_enabled && lar_fw_supported,
-			false);
+			nvm->lar_enabled, false);
 
 	iwl_free_resp(&hcmd);
 	return nvm;
-- 
2.14.1
