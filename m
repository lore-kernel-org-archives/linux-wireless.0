Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbbEZTSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/39] iwlwifi: mvm: handle device start failure correctly
Date: Tue, 26 May 2015 22:17:26 +0300
Message-Id: <1432667872-18092-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211827_453030_27648F5A)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device fails to start correctly prior to loading the
regular runtime firmware (after having run the INIT firmware),
treat that error correctly by actually checking the return
value of _iwl_trans_start_hw() and stopping the device again
before returning an error.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 0601445..2f76fb2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -662,9 +662,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		 * device that are triggered by the INIT firwmare (MFUART).
 		 */
 		_iwl_trans_stop_device(mvm->trans, false);
-		_iwl_trans_start_hw(mvm->trans, false);
+		ret = _iwl_trans_start_hw(mvm->trans, false);
 		if (ret)
-			return ret;
+			goto error;
 	}
 
 	if (iwlmvm_mod_params.init_dbg)
-- 
2.1.4

