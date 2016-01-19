Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:34200 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbcASPoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 10:44:10 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: johannes@sipsolutions.net
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jprvita@endlessm.com,
	linux@endlessm.com
Subject: [PATCH 8/8] rfkill: Factor common code
Date: Tue, 19 Jan 2016 10:42:43 -0500
Message-Id: <1453218163-31998-9-git-send-email-jprvita@endlessm.com> (sfid-20160119_164740_450845_D1A5193D)
In-Reply-To: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
References: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Factor all assignments to rfkill_global_states[].cur to
rfkill_update_global_state(), and also make accesses to
rfkill_global_states[].cur go through rfkill_get_global_sw_state().

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 0b9d5bf..ae3d15a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -300,6 +300,19 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
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
 
@@ -317,15 +330,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
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
@@ -877,7 +882,7 @@ static void rfkill_sync_work(struct work_struct *work)
 	rfkill = container_of(work, struct rfkill, sync_work);
 
 	mutex_lock(&rfkill_global_mutex);
-	cur = rfkill_global_states[rfkill->type].cur;
+	cur = rfkill_get_global_sw_state(rfkill->type);
 	rfkill_set_block(rfkill, cur);
 	mutex_unlock(&rfkill_global_mutex);
 }
@@ -1116,15 +1121,8 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 
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
@@ -1213,10 +1211,8 @@ static struct miscdevice rfkill_miscdev = {
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

