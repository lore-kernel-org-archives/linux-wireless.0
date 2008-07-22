Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58327 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbYGVASb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 20:18:31 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 4/6] rfkill: mutex fixes
Date: Mon, 21 Jul 2008 21:18:20 -0300
Message-Id: <1216685902-9373-5-git-send-email-hmh@hmh.eng.br> (sfid-20080722_021836_071713_E13F5986)
In-Reply-To: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two mutexes in rfkill:

rfkill->mutex, which protects some of the fields of a rfkill struct, and is
also used for callback serialization.

rfkill_mutex, which protects the global state, the list of registered
rfkill structs and rfkill->claim.

Make sure to use the correct mutex, and to not miss locking rfkill->mutex
even when we already took rfkill_mutex.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index fc3a4fd..ac205ec 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -150,7 +150,7 @@ static void update_rfkill_state(struct rfkill *rfkill)
  * even if the radio is in RFKILL_STATE_HARD_BLOCKED state, so as to
  * give the driver a hint that it should double-BLOCK the transmitter.
  *
- * Caller must have aquired rfkill_mutex.
+ * Caller must have acquired rfkill->mutex.
  */
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state,
@@ -216,8 +216,11 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 	rfkill_states[type] = state;
 
 	list_for_each_entry(rfkill, &rfkill_list, node) {
-		if ((!rfkill->user_claim) && (rfkill->type == type))
+		if ((!rfkill->user_claim) && (rfkill->type == type)) {
+			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill, state, 0);
+			mutex_unlock(&rfkill->mutex);
+		}
 	}
 
 	mutex_unlock(&rfkill_mutex);
@@ -228,7 +231,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
  * rfkill_epo - emergency power off all transmitters
  *
  * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
- * everything in its path but rfkill_mutex.
+ * everything in its path but rfkill_mutex and rfkill->mutex.
  */
 void rfkill_epo(void)
 {
@@ -236,7 +239,9 @@ void rfkill_epo(void)
 
 	mutex_lock(&rfkill_mutex);
 	list_for_each_entry(rfkill, &rfkill_list, node) {
+		mutex_lock(&rfkill->mutex);
 		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
+		mutex_unlock(&rfkill->mutex);
 	}
 	mutex_unlock(&rfkill_mutex);
 }
@@ -372,6 +377,9 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (rfkill->user_claim_unsupported)
+		return -EOPNOTSUPP;
+
 	/*
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
@@ -380,19 +388,17 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	if (error)
 		return error;
 
-	if (rfkill->user_claim_unsupported) {
-		error = -EOPNOTSUPP;
-		goto out_unlock;
-	}
 	if (rfkill->user_claim != claim) {
-		if (!claim)
+		if (!claim) {
+			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill,
 					    rfkill_states[rfkill->type],
 					    0);
+			mutex_unlock(&rfkill->mutex);
+		}
 		rfkill->user_claim = claim;
 	}
 
-out_unlock:
 	mutex_unlock(&rfkill_mutex);
 
 	return error ? error : count;
@@ -521,8 +527,11 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
 {
 	mutex_lock(&rfkill_mutex);
 	list_del_init(&rfkill->node);
-	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
 	mutex_unlock(&rfkill_mutex);
+
+	mutex_lock(&rfkill->mutex);
+	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
+	mutex_unlock(&rfkill->mutex);
 }
 
 /**
-- 
1.5.6.2

