Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2IJROy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 2/6] iwlwifi: stop interrupts before stopping device
Date: Mon, 10 Sep 2012 19:15:26 +0200
Message-Id: <1347297330-23338-3-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191506_435631_CB5D06B1)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

If an RX interrupt is signalled after or during apm_stop
we may try to access the peripherals which are already
down. Prevent this by disabling interrupts first.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 913ad46..7da075f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1453,6 +1453,10 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
 	bool hw_rfkill;
 	unsigned long flags;
 
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	iwl_disable_interrupts(trans);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+
 	iwl_apm_stop(trans);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-- 
1.7.10.4

