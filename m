Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaL3OU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:28 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/33] iwlwifi: mvm: ask the fw to wakeup (from d0i3) on sysassert
Date: Tue, 30 Dec 2014 16:19:04 +0200
Message-Id: <1419949148-24046-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154350_444444_0B51EE41)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Set the wakeup flag (of the d3 command) to configure the fw
to wakeup when sysassert happens while in d0i3.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 4906967..239f033 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1049,6 +1049,7 @@ int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	};
 	struct iwl_d3_manager_config d3_cfg_cmd = {
 		.min_sleep_time = cpu_to_le32(1000),
+		.wakeup_flags = cpu_to_le32(IWL_WAKEUP_D3_CONFIG_FW_ERROR),
 	};
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
-- 
1.9.1

