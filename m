Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3BLQCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/15] iwlwifi: mvm: beautify code in rx_handlers
Date: Tue, 12 Feb 2013 17:02:07 +0100
Message-Id: <1360684927-1367-15-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170255_945797_FEC95CC3)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Make the code more readable, and while at it also
add a missing "break" to avoid checking handlers
that cannot be used.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 41 ++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 983dca3..aa59adf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -536,25 +536,28 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 
 	for (i = 0; i < ARRAY_SIZE(iwl_mvm_rx_handlers); i++) {
 		const struct iwl_rx_handlers *rx_h = &iwl_mvm_rx_handlers[i];
-		if (rx_h->cmd_id == pkt->hdr.cmd) {
-			struct iwl_async_handler_entry *entry;
-			if (!rx_h->async)
-				return rx_h->fn(mvm, rxb, cmd);
-
-			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-			/* we can't do much... */
-			if (!entry)
-				return 0;
-
-			entry->rxb._page = rxb_steal_page(rxb);
-			entry->rxb._offset = rxb->_offset;
-			entry->rxb._rx_page_order = rxb->_rx_page_order;
-			entry->fn = rx_h->fn;
-			spin_lock(&mvm->async_handlers_lock);
-			list_add_tail(&entry->list, &mvm->async_handlers_list);
-			spin_unlock(&mvm->async_handlers_lock);
-			schedule_work(&mvm->async_handlers_wk);
-		}
+		struct iwl_async_handler_entry *entry;
+
+		if (rx_h->cmd_id != pkt->hdr.cmd)
+			continue;
+
+		if (!rx_h->async)
+			return rx_h->fn(mvm, rxb, cmd);
+
+		entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+		/* we can't do much... */
+		if (!entry)
+			return 0;
+
+		entry->rxb._page = rxb_steal_page(rxb);
+		entry->rxb._offset = rxb->_offset;
+		entry->rxb._rx_page_order = rxb->_rx_page_order;
+		entry->fn = rx_h->fn;
+		spin_lock(&mvm->async_handlers_lock);
+		list_add_tail(&entry->list, &mvm->async_handlers_list);
+		spin_unlock(&mvm->async_handlers_lock);
+		schedule_work(&mvm->async_handlers_wk);
+		break;
 	}
 
 	return 0;
-- 
1.8.0

