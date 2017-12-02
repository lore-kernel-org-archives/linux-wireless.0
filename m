Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48556 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752252AbdLBQ3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:07 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:47 +0200
Message-Id: <20171202162858.4167-5-luca@coelho.fi> (sfid-20171202_172922_582470_2EC7B689)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 04/15] iwlwifi: mvm: avoid dumping assert log when device is stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We might erroneously get to error dumping code when the
device is already stopped.

In that case the driver will detect a defective value and will try to
reset the HW, assuming it is only a bus issue.  The driver than
proceeds with the dumping.

The result has two side effects:

1. The device won't be stopped again, since the transport status is
already stopped, so the device remains powered on while it actually
should be stopped.

2. The dump in that case is completely garbaged and useless.

Detect and avoid this.  It will also make debugging such issues
easier.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index d46115e2d69e..79acb13f203a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -595,6 +595,12 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 {
+	if (!test_bit(STATUS_DEVICE_ENABLED, &mvm->trans->status)) {
+		IWL_ERR(mvm,
+			"DEVICE_ENABLED bit is not set. Aborting dump.\n");
+		return;
+	}
+
 	iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[0]);
 
 	if (mvm->error_event_table[1])
-- 
2.15.0
