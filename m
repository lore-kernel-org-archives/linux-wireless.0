Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33486 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbcBVQhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 11:37:05 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCHv2 08/10] rfkill: Use switch to demux userspace operations
Date: Mon, 22 Feb 2016 11:36:39 -0500
Message-Id: <1456159001-20307-9-git-send-email-jprvita@endlessm.com> (sfid-20160222_174031_995539_D97785FB)
In-Reply-To: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using a switch to handle different ev.op values in rfkill_fop_write()
makes the code easier to extend, as out-of-range values can always be
handled by the default case.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 50b538b..04d7fa1 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1185,6 +1185,7 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 {
 	struct rfkill *rfkill;
 	struct rfkill_event ev;
+	int ret = 0;
 
 	/* we don't need the 'hard' variable but accept it */
 	if (count < RFKILL_EVENT_SIZE_V1 - 1)
@@ -1199,29 +1200,32 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 	if (copy_from_user(&ev, buf, count))
 		return -EFAULT;
 
-	if (ev.op != RFKILL_OP_CHANGE && ev.op != RFKILL_OP_CHANGE_ALL)
-		return -EINVAL;
-
 	if (ev.type >= NUM_RFKILL_TYPES)
 		return -EINVAL;
 
 	mutex_lock(&rfkill_global_mutex);
 
-	if (ev.op == RFKILL_OP_CHANGE_ALL)
+	switch (ev.op) {
+	case RFKILL_OP_CHANGE_ALL:
 		rfkill_update_global_state(ev.type, ev.soft);
-
-	list_for_each_entry(rfkill, &rfkill_list, node) {
-		if (rfkill->idx != ev.idx && ev.op != RFKILL_OP_CHANGE_ALL)
-			continue;
-
-		if (rfkill->type != ev.type && ev.type != RFKILL_TYPE_ALL)
-			continue;
-
-		rfkill_set_block(rfkill, ev.soft);
+		list_for_each_entry(rfkill, &rfkill_list, node)
+			if (rfkill->type == ev.type ||
+			    ev.type == RFKILL_TYPE_ALL)
+				rfkill_set_block(rfkill, ev.soft);
+		break;
+	case RFKILL_OP_CHANGE:
+		list_for_each_entry(rfkill, &rfkill_list, node)
+			if (rfkill->idx == ev.idx && rfkill->type == ev.type)
+				rfkill_set_block(rfkill, ev.soft);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
+
 	mutex_unlock(&rfkill_global_mutex);
 
-	return count;
+	return ret ? ret : count;
 }
 
 static int rfkill_fop_release(struct inode *inode, struct file *file)
-- 
2.5.0

