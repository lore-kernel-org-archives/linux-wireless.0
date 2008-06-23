Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58277 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762171AbYFWUXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:23:19 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 11/13] rfkill: drop current_state from tasks in rfkill-input
Date: Mon, 23 Jun 2008 17:23:06 -0300
Message-Id: <1214252588-30723-12-git-send-email-hmh@hmh.eng.br> (sfid-20080623_222329_803588_709EAF09)
In-Reply-To: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabien Crespel <fabien@crespel.net>

The whole current_state thing seems completely useless and a source of
problems in rfkill-input, since state comparison is already done in rfkill,
and rfkill-input is more than likely to become out of sync with the real
state.

Signed-off-by: Fabien Crespel <fabien@crespel.net>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 29c13d3..d285f9a 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -30,27 +30,15 @@ struct rfkill_task {
 	spinlock_t lock; /* for accessing last and desired state */
 	unsigned long last; /* last schedule */
 	enum rfkill_state desired_state; /* on/off */
-	enum rfkill_state current_state; /* on/off */
 };
 
 static void rfkill_task_handler(struct work_struct *work)
 {
 	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
-	enum rfkill_state state;
 
 	mutex_lock(&task->mutex);
 
-	/*
-	 * Use temp variable to fetch desired state to keep it
-	 * consistent even if rfkill_schedule_toggle() runs in
-	 * another thread or interrupts us.
-	 */
-	state = task->desired_state;
-
-	if (state != task->current_state) {
-		rfkill_switch_all(task->type, state);
-		task->current_state = state;
-	}
+	rfkill_switch_all(task->type, task->desired_state);
 
 	mutex_unlock(&task->mutex);
 }
@@ -94,7 +82,6 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
 		.mutex = __MUTEX_INITIALIZER(n.mutex),	\
 		.lock = __SPIN_LOCK_UNLOCKED(n.lock),	\
 		.desired_state = RFKILL_STATE_ON,	\
-		.current_state = RFKILL_STATE_ON,	\
 	}
 
 static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
-- 
1.5.5.4

