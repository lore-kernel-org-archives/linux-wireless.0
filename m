Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56882 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749AbbJELlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:41:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	<stable@vger.kernel.org>, Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:46 +0300
Message-Id: <1444045246-9946-8-git-send-email-luca@coelho.fi> (sfid-20151005_134108_541255_35A23E4F)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 8/8] iwlwifi: mvm: flush fw_dump_wk when mvm fails to start
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

FW dump may be triggered when running init ucode, for example due to a
sysassert. In this case fw_dump_wk may run after mvm is freed, resulting
in a kernel panic.
Fix it by flushing the work.

Fixes: 01b988a708af ("iwlwifi: mvm: allow to collect debug data when restart is disabled")
Cc: <stable@vger.kernel.org> [3.18+]
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a37de3f..f0cb092 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -590,6 +590,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	ieee80211_unregister_hw(mvm->hw);
 	iwl_mvm_leds_exit(mvm);
  out_free:
+	flush_delayed_work(&mvm->fw_dump_wk);
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
 	if (!cfg->no_power_up_nic_in_init || !mvm->nvm_file_name)
-- 
2.5.3

