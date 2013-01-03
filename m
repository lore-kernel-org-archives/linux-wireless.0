Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3ACOnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:43:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] iwlwifi: fix PCIe interrupt handle return value
Date: Thu,  3 Jan 2013 15:43:22 +0100
Message-Id: <1357224203-27639-1-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154306_398970_08EBD119)
In-Reply-To: <1357224173.9741.18.camel@jlt4.sipsolutions.net>
References: <1357224173.9741.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By accident, commit eb6476441bc2fecf6232a87d0313a85f8e3da7f4
("iwlwifi: protect use_ict with irq_lock") changed the return
value of the iwl_pcie_isr() function in case it handles an
interrupt -- it now returns IRQ_NONE instead of IRQ_HANDLED.

Put back the correct return value.

Cc: stable@vger.kernel.org
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index dad4c4a..8389cd3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1166,6 +1166,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 		 !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
+	return IRQ_HANDLED;
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
-- 
1.8.0

