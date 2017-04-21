Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19875 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038026AbdDUKkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 06:40:06 -0400
Date: Fri, 21 Apr 2017 13:39:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: missing unlock on error path
Message-ID: <20170421103937.jko3eguvfn3i6r3v@mwanda> (sfid-20170421_124014_474328_C114F21E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should unlock before returning.

Fixes: eda50cde58de ("iwlwifi: pcie: add context information support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 302310dfef9e..4e84955d55c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -212,8 +212,10 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		goto out;
 	}
 
-	if (iwl_pcie_ctxt_info_init(trans, fw))
-		return -ENOMEM;
+	if (iwl_pcie_ctxt_info_init(trans, fw)) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
 	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
