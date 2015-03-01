Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbbCATcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:23 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/31] iwlwifi: mvm: don't write to DBGC_OUT_CTRL when stopping the recording
Date: Sun,  1 Mar 2015 21:31:29 +0200
Message-Id: <1425238304-498-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203419_808458_48988252)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Due to HW bug in the DBGC when driver want to stop the dbg recording it
should wait 100us before collecting the data instead of write 0 to
DBGC_OUT_CTRL.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index ca38e98..ab81124 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -458,7 +458,8 @@ void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
 		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
 	} else {
 		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
-		iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, 0);
+		/* wait before we collect the data till the DBGC stop */
+		udelay(100);
 	}
 
 	schedule_work(&mvm->fw_error_dump_wk);
-- 
1.9.1

