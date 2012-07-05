Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab2GEIZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] iwlwifi: remove unneeded NULL check
Date: Thu,  5 Jul 2012 10:24:54 +0200
Message-Id: <1341476695-6889-9-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102537_070809_EC143BE7)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to check trans for non-null
here as it has already been checked in the
caller. This fixes an smatch warning that we
check after having dereferenced it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index be143eb..39a6ca1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -879,9 +879,6 @@ static irqreturn_t iwl_isr(int irq, void *data)
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
-	if (!trans)
-		return IRQ_NONE;
-
 	trace_iwlwifi_dev_irq(trans->dev);
 
 	/* Disable (but don't clear!) interrupts here to avoid
-- 
1.7.10

