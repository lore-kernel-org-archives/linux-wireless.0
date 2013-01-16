Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3APN6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] iwlwifi: don't enable all interrupts on resuming
Date: Wed, 16 Jan 2013 14:58:35 +0100
Message-Id: <1358344719-26486-2-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145824_784536_02A43FFB)
In-Reply-To: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
 <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Enabling the RF-kill interrupt is sufficient for getting
RF-kill notifications, and no other interrupt is needed
as the device isn't functional when suspended and will be
restarted/reconfigured when mac80211 resumes it later.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index db3b055..2de5770 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -719,9 +719,6 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
-	if (!hw_rfkill)
-		iwl_enable_interrupts(trans);
-
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
-- 
1.8.0

