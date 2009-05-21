Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbZEUWCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 18:02:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1M7GLR-0006go-0z
	for linux-wireless@vger.kernel.org; Fri, 22 May 2009 00:02:33 +0200
Message-Id: <20090521220104.962925968@sipsolutions.net>
References: <20090521215940.344214804@sipsolutions.net>
Date: Thu, 21 May 2009 23:59:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 2/4] rfkill: add function to query state
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

--- wireless-testing.orig/include/linux/rfkill.h	2009-05-21 21:55:37.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-05-21 21:56:00.000000000 +0200
@@ -225,6 +225,13 @@ void rfkill_set_states(struct rfkill *rf
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
@@ -277,6 +284,11 @@ static inline void rfkill_set_global_sw_
 					      bool blocked)
 {
 }
+
+static inline bool rfkill_blocked(struct rfkill *rfkill)
+{
+	return false;
+}
 #endif /* RFKILL || RFKILL_MODULE */
 
 
--- wireless-testing.orig/net/rfkill/core.c	2009-05-21 21:55:41.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-05-21 21:56:00.000000000 +0200
@@ -862,6 +862,19 @@ void rfkill_destroy(struct rfkill *rfkil
 }
 EXPORT_SYMBOL(rfkill_destroy);
 
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
 
 static int __init rfkill_init(void)
 {

-- 

