Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2IRRs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 13:48:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v3.6] iwlwifi: don't double free the interrupt in failure path
Date: Tue, 18 Sep 2012 19:48:59 +0200
Message-Id: <1347990539-27214-1-git-send-email-johannes@sipsolutions.net> (sfid-20120918_194832_816361_F02AB21B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the driver can't get the HW ready, we would release
the interrupt twice which made the kernel complain loudly.

Cc: stable@vger.kernel.org
Reported-by: Brian Cockrell <brian.cockrell@intel.com>
Tested-by: Brian Cockrell <brian.cockrell@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1e86ea2..dbeebef 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1442,6 +1442,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	return err;
 
 err_free_irq:
+	trans_pcie->irq_requested = false;
 	free_irq(trans_pcie->irq, trans);
 error:
 	iwl_free_isr_ict(trans);
-- 
1.7.10.4

