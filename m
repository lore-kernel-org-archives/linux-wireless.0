Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23061 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbbEGJ7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 05:59:05 -0400
Date: Thu, 7 May 2015 12:58:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Eran Harary <eran.harary@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Arik Nemtsov <arik@wizery.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: mvm: remove some dead code
Message-ID: <20150507095844.GA17996@mwanda> (sfid-20150507_115917_046200_420B91D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ret" is zero here so we can remove this stray check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index df86963..41f4763 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -663,8 +663,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		 */
 		_iwl_trans_stop_device(mvm->trans, false);
 		_iwl_trans_start_hw(mvm->trans, false);
-		if (ret)
-			return ret;
 	}
 
 	if (iwlmvm_mod_params.init_dbg)
