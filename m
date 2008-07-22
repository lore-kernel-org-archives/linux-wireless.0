Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39346 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbYGVASc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 20:18:32 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 3/6] rfkill: document the rfkill struct locking (v2)
Date: Mon, 21 Jul 2008 21:18:19 -0300
Message-Id: <1216685902-9373-4-git-send-email-hmh@hmh.eng.br> (sfid-20080722_021838_499966_71A70199)
In-Reply-To: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder fields in struct rfkill and add comments to make it clear
which fields are protected by rfkill->mutex.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/rfkill.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index c5f6e54..741d1a6 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -68,7 +68,8 @@ enum rfkill_state {
  * @user_claim_unsupported: Whether the hardware supports exclusive
  *	RF-kill control by userspace. Set this before registering.
  * @user_claim: Set when the switch is controlled exlusively by userspace.
- * @mutex: Guards switch state transitions
+ * @mutex: Guards switch state transitions.  It serializes callbacks
+ *	and also protects the state.
  * @data: Pointer to the RF button drivers private data which will be
  *	passed along when toggling radio state.
  * @toggle_radio(): Mandatory handler to control state of the radio.
@@ -89,12 +90,13 @@ struct rfkill {
 	const char *name;
 	enum rfkill_type type;
 
-	enum rfkill_state state;
 	bool user_claim_unsupported;
 	bool user_claim;
 
+	/* the mutex serializes callbacks and also protects
+	 * the state */
 	struct mutex mutex;
-
+	enum rfkill_state state;
 	void *data;
 	int (*toggle_radio)(void *data, enum rfkill_state state);
 	int (*get_state)(void *data, enum rfkill_state *state);
-- 
1.5.6.2

