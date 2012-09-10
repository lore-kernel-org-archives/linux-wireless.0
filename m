Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2IJROy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 1/6] iwlwifi: don't reset interupts after disabling
Date: Mon, 10 Sep 2012 19:15:25 +0200
Message-Id: <1347297330-23338-2-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191504_080105_FF67CEC4)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

iwl_disable_interupts() already resets the register, no
need to do it again.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index e555dff..913ad46 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1459,8 +1459,6 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
 	iwl_disable_interrupts(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
-	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
-
 	if (!op_mode_leaving) {
 		/*
 		 * Even if we stop the HW, we still want the RF kill
-- 
1.7.10.4

