Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:32879 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbcBHPlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 10:41:45 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH 5/9] rfkill: Factor rfkill_global_states[].cur assignments
Date: Mon,  8 Feb 2016 10:41:32 -0500
Message-Id: <1454946096-9752-6-git-send-email-jprvita@endlessm.com> (sfid-20160208_164737_297915_02E683EA)
In-Reply-To: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Factor all assignments to rfkill_global_states[].cur into a single
function rfkill_update_global_state().

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 56d79cb..8b96869 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -302,6 +302,19 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
 		rfkill_event(rfkill);
 }
 
+static void rfkill_update_global_state(enum rfkill_type type, bool blocked)
+{
+	int i;
+
+	if (type != RFKILL_TYPE_ALL) {
+		rfkill_global_states[type].cur = blocked;
+		return;
+	}
+
+	for (i = 0; i < NUM_RFKILL_TYPES; i++)
+		rfkill_global_states[i].cur = blocked;
+}
+
 #ifdef CONFIG_RFKILL_INPUT
 static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
 
@@ -319,15 +332,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
 {
 	struct rfkill *rfkill;
 
-	if (type == RFKILL_TYPE_ALL) {
-		int i;
-
-		for (i = 0; i < NUM_RFKILL_TYPES; i++)
-			rfkill_global_states[i].cur = blocked;
-	} else {
-		rfkill_global_states[type].cur = blocked;
-	}
-
+	rfkill_update_global_state(type, blocked);
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if (rfkill->type != type && type != RFKILL_TYPE_ALL)
 			continue;
@@ -1164,15 +1169,8 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&rfkill_global_mutex);
 
-	if (ev.op == RFKILL_OP_CHANGE_ALL) {
-		if (ev.type == RFKILL_TYPE_ALL) {
-			enum rfkill_type i;
-			for (i = 0; i < NUM_RFKILL_TYPES; i++)
-				rfkill_global_states[i].cur = ev.soft;
-		} else {
-			rfkill_global_states[ev.type].cur = ev.soft;
-		}
-	}
+	if (ev.op == RFKILL_OP_CHANGE_ALL)
+		rfkill_update_global_state(ev.type, ev.soft);
 
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if (rfkill->idx != ev.idx && ev.op != RFKILL_OP_CHANGE_ALL)
@@ -1261,10 +1259,8 @@ static struct miscdevice rfkill_miscdev = {
 static int __init rfkill_init(void)
 {
 	int error;
-	int i;
 
-	for (i = 0; i < NUM_RFKILL_TYPES; i++)
-		rfkill_global_states[i].cur = !rfkill_default_state;
+	rfkill_update_global_state(RFKILL_TYPE_ALL, !rfkill_default_state);
 
 	error = class_register(&rfkill_class);
 	if (error)
-- 
2.5.0

