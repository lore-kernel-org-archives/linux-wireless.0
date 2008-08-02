Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41396 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbYHBSLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:10 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/8] rfkill: detect bogus double-registering (v2)
Date: Sat,  2 Aug 2008 15:10:57 -0300
Message-Id: <1217700664-20792-2-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201115_307591_9B847D6F)
In-Reply-To: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Detect and abort with -EEXIST if rfkill_register is called twice on the
same rfkill struct.  And WARN_ON(it) for good measure.

While at it, flag when we are adding the first switch of a type, we will
need that information later.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/rfkill.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 2ec6312..297bfd5 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -533,17 +533,44 @@ static struct class rfkill_class = {
 	.dev_uevent	= rfkill_dev_uevent,
 };
 
+static int rfkill_check_duplicity(const struct rfkill *rfkill)
+{
+	struct rfkill *p;
+	unsigned long seen[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
+
+	memset(seen, 0, sizeof(seen));
+
+	list_for_each_entry(p, &rfkill_list, node) {
+		if (p == rfkill) {
+			WARN_ON(1);
+			return -EEXIST;
+		}
+		set_bit(p->type, seen);
+	}
+
+	/* 0: first switch of its kind */
+	return test_bit(rfkill->type, seen);
+}
+
 static int rfkill_add_switch(struct rfkill *rfkill)
 {
+	int error;
+
 	mutex_lock(&rfkill_mutex);
 
+	error = rfkill_check_duplicity(rfkill);
+	if (error < 0)
+		goto unlock_out;
+
 	rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
 
 	list_add_tail(&rfkill->node, &rfkill_list);
 
+	error = 0;
+unlock_out:
 	mutex_unlock(&rfkill_mutex);
 
-	return 0;
+	return error;
 }
 
 static void rfkill_remove_switch(struct rfkill *rfkill)
-- 
1.5.6.3

