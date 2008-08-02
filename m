Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59864 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbYHBSLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 14:11:13 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 4/8] rfkill: introduce RFKILL_STATE_MAX
Date: Sat,  2 Aug 2008 15:11:00 -0300
Message-Id: <1217700664-20792-5-git-send-email-hmh@hmh.eng.br> (sfid-20080802_201117_517492_96813577)
In-Reply-To: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While it is interesting to not add last-enum-markers because it allows gcc
to warn us of switch() statements missing a valid state, we really should
be handling memory corruption on a rfkill state with default clauses,
anyway.

So add RFKILL_STATE_MAX and use it where applicable.  It makes for safer
code in the long run.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/rfkill.h |    1 +
 net/rfkill/rfkill.c    |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e92d8e9..4cd64b0 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -49,6 +49,7 @@ enum rfkill_state {
 	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
 	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
 	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
+	RFKILL_STATE_MAX,		/* marker for last valid state */
 };
 
 /*
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 5320210..ea872e5 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -201,6 +201,8 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 		 * BLOCK even a transmitter that is already in state
 		 * RFKILL_STATE_HARD_BLOCKED */
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (force || state != rfkill->state) {
@@ -234,6 +236,9 @@ static void __rfkill_switch_all(const enum rfkill_type type,
 {
 	struct rfkill *rfkill;
 
+	if (unlikely(state >= RFKILL_STATE_MAX))
+		return;
+
 	rfkill_global_states[type].current_state = state;
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if ((!rfkill->user_claim) && (rfkill->type == type)) {
@@ -329,9 +334,7 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 {
 	enum rfkill_state oldstate;
 
-	if (state != RFKILL_STATE_SOFT_BLOCKED &&
-	    state != RFKILL_STATE_UNBLOCKED &&
-	    state != RFKILL_STATE_HARD_BLOCKED)
+	if (unlikely(state >= RFKILL_STATE_MAX))
 		return -EINVAL;
 
 	mutex_lock(&rfkill->mutex);
@@ -735,6 +738,8 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 		return -EINVAL;
 	if (rfkill->type >= RFKILL_TYPE_MAX)
 		return -EINVAL;
+	if (rfkill->state >= RFKILL_STATE_MAX)
+		return -EINVAL;
 
 	snprintf(dev->bus_id, sizeof(dev->bus_id),
 		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
-- 
1.5.6.3

