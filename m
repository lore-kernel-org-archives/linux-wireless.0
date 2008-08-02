Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55578 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbYHBSLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:13 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 6/8] rfkill: use the new WARN()
Date: Sat,  2 Aug 2008 15:11:02 -0300
Message-Id: <1217700664-20792-7-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201119_084163_4C71F8D4)
In-Reply-To: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch use of WARN_ON(1) to the new WARN() macro.  Do this on a separate
patch to make rfkill backports easier on trees like wireless-compat.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index d5f95cb..88368c4 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -204,7 +204,9 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 		 * RFKILL_STATE_HARD_BLOCKED */
 		break;
 	default:
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: illegal state %d passed as parameter "
+			"to rfkill_toggle_radio\n", state);
 		return -EINVAL;
 	}
 
@@ -240,7 +242,9 @@ static void __rfkill_switch_all(const enum rfkill_type type,
 	struct rfkill *rfkill;
 
 	if (unlikely(state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX)) {
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: illegal state %d or type %d passed as "
+			"parameter to __rfkill_switch_all\n", state, type);
 		return;
 	}
 
@@ -341,7 +345,9 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 
 	BUG_ON(!rfkill);
 	if (unlikely(state >= RFKILL_STATE_MAX)) {
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: illegal state %d passed as parameter "
+			"to rfkill_force_state\n", state);
 		return -EINVAL;
 	}
 
@@ -600,7 +606,9 @@ static int rfkill_check_duplicity(const struct rfkill *rfkill)
 
 	list_for_each_entry(p, &rfkill_list, node) {
 		if (p == rfkill) {
-			WARN_ON(1);
+			WARN(1, KERN_WARNING
+				"rfkill: illegal attempt to register "
+				"an already registered rfkill struct\n");
 			return -EEXIST;
 		}
 		set_bit(p->type, seen);
@@ -671,7 +679,9 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
 	struct device *dev;
 
 	if (type >= RFKILL_TYPE_MAX) {
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: illegal type %d passed as parameter "
+			"to rfkill_allocate\n", type);
 		return NULL;
 	}
 
@@ -751,7 +761,9 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 		     !rfkill->toggle_radio ||
 		     rfkill->type >= RFKILL_TYPE_MAX ||
 		     rfkill->state >= RFKILL_STATE_MAX)) {
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: attempt to register a "
+			"badly initialized rfkill struct\n");
 		return -EINVAL;
 	}
 
@@ -827,7 +839,9 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 	if (type >= RFKILL_TYPE_MAX ||
 	    (state != RFKILL_STATE_SOFT_BLOCKED &&
 	     state != RFKILL_STATE_UNBLOCKED)) {
-		WARN_ON(1);
+		WARN(1, KERN_WARNING
+			"rfkill: illegal state %d or type %d passed as "
+			"parameter to rfkill_set_default\n", state, type);
 		return -EINVAL;
 	}
 
-- 
1.5.6.3

