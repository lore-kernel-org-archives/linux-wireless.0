Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2FTHiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/12] iwlwifi: don't disable interrupt in iwl_abort_notification_waits
Date: Wed, 20 Jun 2012 09:38:07 +0200
Message-Id: <1340177894-12992-6-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093835_175708_4707D445)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is not needed since notif_wait_lock is never accessed
from IRQ.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
index 5cfed29..c61f207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -121,13 +121,12 @@ EXPORT_SYMBOL_GPL(iwl_notification_wait_notify);
 
 void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
 {
-	unsigned long flags;
 	struct iwl_notification_wait *wait_entry;
 
-	spin_lock_irqsave(&notif_wait->notif_wait_lock, flags);
+	spin_lock(&notif_wait->notif_wait_lock);
 	list_for_each_entry(wait_entry, &notif_wait->notif_waits, list)
 		wait_entry->aborted = true;
-	spin_unlock_irqrestore(&notif_wait->notif_wait_lock, flags);
+	spin_unlock(&notif_wait->notif_wait_lock);
 
 	wake_up_all(&notif_wait->notif_waitq);
 }
-- 
1.7.10

