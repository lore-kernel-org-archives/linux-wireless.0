Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49715 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933229AbcATJok (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 04:44:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jprvita@gmail.com, netdev@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rfkill: disentangle polling pause and suspend
Date: Wed, 20 Jan 2016 10:44:34 +0100
Message-Id: <1453283074-23925-1-git-send-email-johannes@sipsolutions.net> (sfid-20160120_104449_898261_12802F98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When suspended while polling is paused, polling will erroneously
resume at resume time. Fix this by tracking pause and suspend in
separate state variable and adding the necessary checks.

Clarify the documentation on this as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/rfkill.h |  3 ++-
 net/rfkill/core.c      | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index d9010789b4e8..7af625f6d226 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -104,7 +104,8 @@ int __must_check rfkill_register(struct rfkill *rfkill);
  *
  * Pause polling -- say transmitter is off for other reasons.
  * NOTE: not necessary for suspend/resume -- in that case the
- * core stops polling anyway
+ * core stops polling anyway (but will also correctly handle
+ * the case of polling having been paused before suspend.)
  */
 void rfkill_pause_polling(struct rfkill *rfkill);
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f53bf3b6558b..166439995f34 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -57,6 +57,8 @@ struct rfkill {
 
 	bool			registered;
 	bool			persistent;
+	bool			polling_paused;
+	bool			suspended;
 
 	const struct rfkill_ops	*ops;
 	void			*data;
@@ -786,6 +788,7 @@ void rfkill_pause_polling(struct rfkill *rfkill)
 	if (!rfkill->ops->poll)
 		return;
 
+	rfkill->polling_paused = true;
 	cancel_delayed_work_sync(&rfkill->poll_work);
 }
 EXPORT_SYMBOL(rfkill_pause_polling);
@@ -797,6 +800,11 @@ void rfkill_resume_polling(struct rfkill *rfkill)
 	if (!rfkill->ops->poll)
 		return;
 
+	rfkill->polling_paused = false;
+
+	if (rfkill->suspended)
+		return;
+
 	queue_delayed_work(system_power_efficient_wq,
 			   &rfkill->poll_work, 0);
 }
@@ -807,7 +815,8 @@ static int rfkill_suspend(struct device *dev)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	rfkill_pause_polling(rfkill);
+	rfkill->suspended = true;
+	cancel_delayed_work_sync(&rfkill->poll_work);
 
 	return 0;
 }
@@ -817,12 +826,16 @@ static int rfkill_resume(struct device *dev)
 	struct rfkill *rfkill = to_rfkill(dev);
 	bool cur;
 
+	rfkill->suspended = false;
+
 	if (!rfkill->persistent) {
 		cur = !!(rfkill->state & RFKILL_BLOCK_SW);
 		rfkill_set_block(rfkill, cur);
 	}
 
-	rfkill_resume_polling(rfkill);
+	if (rfkill->ops->poll && !rfkill->polling_paused)
+		queue_delayed_work(system_power_efficient_wq,
+				   &rfkill->poll_work, 0);
 
 	return 0;
 }
-- 
2.6.2

