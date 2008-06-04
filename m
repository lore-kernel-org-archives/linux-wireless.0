Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51853 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYFDDKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:22 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 03/12] rfkill: handle SW_RFKILL_ALL events
Date: Wed,  4 Jun 2008 00:10:08 -0300
Message-Id: <1212549017-30144-4-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051032_639083_7F7E172C)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Teach rfkill-input how to handle SW_RFKILL_ALL events (new name for the
SW_RADIO event).

SW_RFKILL_ALL is an absolute enable-or-disable command that is tied to all
radios in a system.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e4b051d..9d6c925 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -55,6 +55,22 @@ static void rfkill_task_handler(struct work_struct *work)
 	mutex_unlock(&task->mutex);
 }
 
+static void rfkill_schedule_set(struct rfkill_task *task,
+				enum rfkill_state desired_state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->lock, flags);
+
+	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
+		task->desired_state = desired_state;
+		task->last = jiffies;
+		schedule_work(&task->work);
+	}
+
+	spin_unlock_irqrestore(&task->lock, flags);
+}
+
 static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
 	unsigned long flags;
@@ -87,9 +103,9 @@ static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
 
 static void rfkill_event(struct input_handle *handle, unsigned int type,
-			unsigned int code, int down)
+			unsigned int code, int data)
 {
-	if (type == EV_KEY && down == 1) {
+	if (type == EV_KEY && data == 1) {
 		switch (code) {
 		case KEY_WLAN:
 			rfkill_schedule_toggle(&rfkill_wlan);
@@ -106,6 +122,26 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		default:
 			break;
 		}
+	} else if (type == EV_SW) {
+		switch (code) {
+		case SW_RFKILL_ALL:
+			/* EVERY radio type. data != 0 means radios ON */
+			rfkill_schedule_set(&rfkill_wimax,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_uwb,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_bt,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_wlan,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			break;
+		default:
+			break;
+		}
 	}
 }
 
@@ -168,6 +204,11 @@ static const struct input_device_id rfkill_ids[] = {
 		.evbit = { BIT_MASK(EV_KEY) },
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
 	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
+		.evbit = { BIT(EV_SW) },
+		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
+	},
 	{ }
 };
 
-- 
1.5.5.3

