Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34228 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753731AbdFVVVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:39 +0300
Message-Id: <20170622212101.16422-4-luca@coelho.fi> (sfid-20170622_232115_930937_59ACFA87)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: disable dbg data collect when fw isn't alive
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

If FW isn't alive, trying to collect debug data will
result in errors both in driver and in the collected
data, so just warn and leave the collecting function
in this case.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index c66baf1e1443..d5cb47e2fe44 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -915,6 +915,10 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 	if (trigger)
 		delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 
+	if (WARN(mvm->trans->state == IWL_TRANS_NO_FW,
+		 "Can't collect dbg data when FW isn't alive\n"))
+		return -EIO;
+
 	if (test_and_set_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status))
 		return -EBUSY;
 
-- 
2.11.0
