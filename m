Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47392 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751735AbdKYPfd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:09 +0200
Message-Id: <20171125153510.25359-6-luca@coelho.fi> (sfid-20171125_163536_779216_78DCFEEC)
In-Reply-To: <20171125153510.25359-1-luca@coelho.fi>
References: <20171125153510.25359-1-luca@coelho.fi>
Subject: [PATCH 5/6] iwlwifi: pcie: fix erroneous "Read failed message"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Current pci dumping code code is always falling to the error
path, resulting with a constant "Read failed" message, also
for the successful reads.

Fixes: a5c932e41fdd ("iwlwifi: pcie: dump registers when HW becomes inaccessible")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b7a51603465b..3dee95e6a475 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -166,6 +166,7 @@ static void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
 		print_hex_dump(KERN_ERR, prefix, DUMP_PREFIX_OFFSET, 32,
 			       4, buf, i, 0);
 	}
+	goto out;
 
 err_read:
 	print_hex_dump(KERN_ERR, prefix, DUMP_PREFIX_OFFSET, 32, 4, buf, i, 0);
-- 
2.15.0
