Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751339AbdFYLM4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:49 +0300
Message-Id: <20170625111158.1792-18-luca@coelho.fi> (sfid-20170625_131303_620690_C794D4CE)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 17/26] iwlwifi: mvm: set assoc_beacon_arrive_time
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When updating the mac context after association,
assoc_beacon_arrive_time is not being set, which causes the FW to
set a wrong TSF to the MAC.

Fix this by setting the assoc_beacon_arrive_time when updating the
mac context after association.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 50a71da2e96e..f06751598fb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -846,6 +846,8 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 			cpu_to_le64(vif->bss_conf.sync_tsf + dtim_offs);
 		ctxt_sta->dtim_time =
 			cpu_to_le32(vif->bss_conf.sync_device_ts + dtim_offs);
+		ctxt_sta->assoc_beacon_arrive_time =
+			cpu_to_le32(vif->bss_conf.sync_device_ts);
 
 		IWL_DEBUG_INFO(mvm, "DTIM TBTT is 0x%llx/0x%x, offset %d\n",
 			       le64_to_cpu(ctxt_sta->dtim_tsf),
-- 
2.11.0
