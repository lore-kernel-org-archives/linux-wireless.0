Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34714 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506AbYGQV47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 17:56:59 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 5/4] rfkill: query EV_SW states when rfkill-input connects to a input device
Date: Thu, 17 Jul 2008 18:56:54 -0300
Message-Id: <1216331814-31802-1-git-send-email-hmh@hmh.eng.br> (sfid-20080717_235707_915418_1F637472)
In-Reply-To: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Every time a new input device that is capable of one of the rfkill EV_SW
events (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must
check the switch state and take action.

Otherwise, we will ignore the initial switch state.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 Sorry, I forgot to send in this one as well.  It is the last of the fixes
 I have for 2.6.27, so far.

 net/rfkill/rfkill-input.c |   45 ++++++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 8aa8227..9203124 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -109,6 +109,25 @@ static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
 static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
 
+static void rfkill_schedule_evsw_rfkillall(int state)
+{
+	/* EVERY radio type. data != 0 means radios ON */
+	/* handle EPO (emergency power off) through shortcut */
+	if (state) {
+		rfkill_schedule_set(&rfkill_wwan,
+				    RFKILL_STATE_UNBLOCKED);
+		rfkill_schedule_set(&rfkill_wimax,
+				    RFKILL_STATE_UNBLOCKED);
+		rfkill_schedule_set(&rfkill_uwb,
+				    RFKILL_STATE_UNBLOCKED);
+		rfkill_schedule_set(&rfkill_bt,
+				    RFKILL_STATE_UNBLOCKED);
+		rfkill_schedule_set(&rfkill_wlan,
+				    RFKILL_STATE_UNBLOCKED);
+	} else
+		rfkill_schedule_epo();
+}
+
 static void rfkill_event(struct input_handle *handle, unsigned int type,
 			unsigned int code, int data)
 {
@@ -132,21 +151,7 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 	} else if (type == EV_SW) {
 		switch (code) {
 		case SW_RFKILL_ALL:
-			/* EVERY radio type. data != 0 means radios ON */
-			/* handle EPO (emergency power off) through shortcut */
-			if (data) {
-				rfkill_schedule_set(&rfkill_wwan,
-						    RFKILL_STATE_UNBLOCKED);
-				rfkill_schedule_set(&rfkill_wimax,
-						    RFKILL_STATE_UNBLOCKED);
-				rfkill_schedule_set(&rfkill_uwb,
-						    RFKILL_STATE_UNBLOCKED);
-				rfkill_schedule_set(&rfkill_bt,
-						    RFKILL_STATE_UNBLOCKED);
-				rfkill_schedule_set(&rfkill_wlan,
-						    RFKILL_STATE_UNBLOCKED);
-			} else
-				rfkill_schedule_epo();
+			rfkill_schedule_evsw_rfkillall(data);
 			break;
 		default:
 			break;
@@ -154,6 +159,13 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 	}
 }
 
+static void rfkill_handle_evsw(const unsigned long *swbit,
+				const unsigned long *sw)
+{
+	if (test_bit(SW_RFKILL_ALL, swbit))
+		rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL, sw));
+}
+
 static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
 			  const struct input_device_id *id)
 {
@@ -176,6 +188,9 @@ static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
 	if (error)
 		goto err_unregister_handle;
 
+	if (test_bit(EV_SW, &dev->evbit))
+		rfkill_handle_evsw(&dev->swbit[0], &dev->sw[0]);
+
 	return 0;
 
  err_unregister_handle:
-- 
1.5.6.2

