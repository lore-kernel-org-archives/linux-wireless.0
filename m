Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2LJVs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/10] iwlwifi: reset_ict in stop_hw
Date: Mon, 10 Dec 2012 22:49:14 +0100
Message-Id: <1355176158-24675-6-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224907_131809_F91C8F50)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the device is taken down in stop_hw, call reset_ict
from there too.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 09d2ed1..39d6219 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -635,6 +635,8 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
 	iwl_disable_interrupts(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
+	iwl_pcie_disable_ict(trans);
+
 	if (!op_mode_leaving) {
 		/*
 		 * Even if we stop the HW, we still want the RF kill
-- 
1.8.0

