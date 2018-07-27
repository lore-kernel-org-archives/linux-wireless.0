Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38628 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730088AbeG0OKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:30 +0300
Message-Id: <20180727124838.25910-9-luca@coelho.fi> (sfid-20180727_144900_780884_C4D3D55C)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: d3: disable dbg recording before entering D3
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Currently the firmware does not stop recording debugging data when
entering D3 and this causes trouble (e.g. sporadic wake ups).

Fix that by stopping dbg recording when suspending.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 3fcf489f3120..79bdae994822 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1037,6 +1037,13 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			cpu_to_le32(IWL_WAKEUP_D3_CONFIG_FW_ERROR);
 #endif
 
+	/*
+	 * TODO: this is needed because the firmware is not stopping
+	 * the recording automatically before entering D3.  This can
+	 * be removed once the FW starts doing that.
+	 */
+	iwl_fw_dbg_stop_recording(&mvm->fwrt);
+
 	/* must be last -- this switches firmware state */
 	ret = iwl_mvm_send_cmd(mvm, &d3_cfg_cmd);
 	if (ret)
-- 
2.18.0
