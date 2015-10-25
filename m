Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 03/16] iwlwifi: pcie: fix (again) prepare card flow
Date: Sun, 25 Oct 2015 14:01:03 +0200
Message-Id: <1445774476-24792-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130130_619309_B681645E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware bug in the commit mentioned below forces us
not to re-enable the clock gating in the Host Cluster.
The impact on the power consumption is minimal and it allows
the WAKE_ME interrupt to propagate.

CC: <stable@vger.kernel.org> [4.1+]
Fixes: c9fdec9f3970 ("iwlwifi: pcie: fix prepare card flow")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 6ba7d30..9028345 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -592,10 +592,8 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 
 		do {
 			ret = iwl_pcie_set_hw_ready(trans);
-			if (ret >= 0) {
-				ret = 0;
-				goto out;
-			}
+			if (ret >= 0)
+				return 0;
 
 			usleep_range(200, 1000);
 			t += 200;
@@ -605,10 +603,6 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 
 	IWL_ERR(trans, "Couldn't prepare the card\n");
 
-out:
-	iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-		      CSR_RESET_LINK_PWR_MGMT_DISABLED);
-
 	return ret;
 }
 
-- 
2.1.4

