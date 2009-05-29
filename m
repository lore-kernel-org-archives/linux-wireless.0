Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZE2Xkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 19:40:36 -0400
Subject: [PATCH] rfkill: add function to query state
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 30 May 2009 01:40:35 +0200
Message-Id: <1243640435.13863.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes it is necessary to know how the state is,
and it is easier to query rfkill than keep track of
it somewhere else, so add a function for that. This
could later be expanded to return hard/soft block,
but so far that isn't necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/rfkill.h |   12 ++++++++++++
 net/rfkill/core.c      |   13 +++++++++++++
 2 files changed, 25 insertions(+)

--- wireless-testing.orig/include/linux/rfkill.h	2009-05-30 01:38:40.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-05-30 01:38:44.000000000 +0200
@@ -256,6 +256,13 @@ void rfkill_set_states(struct rfkill *rf
  *	registered drivers?
  */
 void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked);
+
+/**
+ * rfkill_blocked - query rfkill block
+ *
+ * @rfkill: rfkill struct to query
+ */
+bool rfkill_blocked(struct rfkill *rfkill);
 #else /* !RFKILL */
 static inline struct rfkill * __must_check
 rfkill_alloc(const char *name,
@@ -308,6 +315,11 @@ static inline void rfkill_set_global_sw_
 					      bool blocked)
 {
 }
+
+static inline bool rfkill_blocked(struct rfkill *rfkill)
+{
+	return false;
+}
 #endif /* RFKILL || RFKILL_MODULE */
 
 
--- wireless-testing.orig/net/rfkill/core.c	2009-05-30 01:38:40.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-05-30 01:38:44.000000000 +0200
@@ -756,6 +756,19 @@ static struct class rfkill_class = {
 	.resume		= rfkill_resume,
 };
 
+bool rfkill_blocked(struct rfkill *rfkill)
+{
+	unsigned long flags;
+	u32 state;
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	state = rfkill->state;
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	return !!(state & RFKILL_BLOCK_ANY);
+}
+EXPORT_SYMBOL(rfkill_blocked);
+
 
 struct rfkill * __must_check rfkill_alloc(const char *name,
 					  struct device *parent,


