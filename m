Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60738 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbYFVPi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:38:58 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 11/12] rfkill: do not allow userspace to override ALL RADIOS OFF
Date: Sun, 22 Jun 2008 12:38:47 -0300
Message-Id: <1214149128-5913-12-git-send-email-hmh@hmh.eng.br> (sfid-20080622_173909_169230_A93F916F)
In-Reply-To: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br>
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
be handled, and must always do the same thing as far as the rfkill system
is concerned: all transmitters are to go *immediately* offline.

For safety, do NOT allow userspace to override EV_SW SW_RFKILL_ALL OFF.  As
long as rfkill-input is loaded, that event will *always* be processed, and
it will *always* force all rfkill switches to disable all wireless
transmitters, regardless of user_claim attribute or anything else.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   29 ++++++++++++++---------------
 net/rfkill/rfkill-input.h |    1 +
 net/rfkill/rfkill.c       |   18 ++++++++++++++++++
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 29c13d3..0fadeed 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -127,21 +127,20 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		switch (code) {
 		case SW_RFKILL_ALL:
 			/* EVERY radio type. data != 0 means radios ON */
-			rfkill_schedule_set(&rfkill_wwan,
-					    (data)? RFKILL_STATE_ON:
-						    RFKILL_STATE_OFF);
-			rfkill_schedule_set(&rfkill_wimax,
-					    (data)? RFKILL_STATE_ON:
-						    RFKILL_STATE_OFF);
-			rfkill_schedule_set(&rfkill_uwb,
-					    (data)? RFKILL_STATE_ON:
-						    RFKILL_STATE_OFF);
-			rfkill_schedule_set(&rfkill_bt,
-					    (data)? RFKILL_STATE_ON:
-						    RFKILL_STATE_OFF);
-			rfkill_schedule_set(&rfkill_wlan,
-					    (data)? RFKILL_STATE_ON:
-						    RFKILL_STATE_OFF);
+			/* handle EPO (emergency power off) through shortcut */
+			if (data) {
+				rfkill_schedule_set(&rfkill_wwan,
+						    RFKILL_STATE_ON);
+				rfkill_schedule_set(&rfkill_wimax,
+						    RFKILL_STATE_ON);
+				rfkill_schedule_set(&rfkill_uwb,
+						    RFKILL_STATE_ON);
+				rfkill_schedule_set(&rfkill_bt,
+						    RFKILL_STATE_ON);
+				rfkill_schedule_set(&rfkill_wlan,
+						    RFKILL_STATE_ON);
+			} else
+				rfkill_epo();
 			break;
 		default:
 			break;
diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
index 4dae500..f63d050 100644
--- a/net/rfkill/rfkill-input.h
+++ b/net/rfkill/rfkill-input.h
@@ -12,5 +12,6 @@
 #define __RFKILL_INPUT_H
 
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
+void rfkill_epo(void);
 
 #endif /* __RFKILL_INPUT_H */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index dd1c3f1..7d07175 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -182,6 +182,24 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 EXPORT_SYMBOL(rfkill_switch_all);
 
 /**
+ * rfkill_epo - emergency power off all transmitters
+ *
+ * This kicks all rfkill devices to RFKILL_STATE_OFF, ignoring
+ * everything in its path but rfkill_mutex.
+ */
+void rfkill_epo(void)
+{
+	struct rfkill *rfkill;
+
+	mutex_lock(&rfkill_mutex);
+	list_for_each_entry(rfkill, &rfkill_list, node) {
+		rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF, 1);
+	}
+	mutex_unlock(&rfkill_mutex);
+}
+EXPORT_SYMBOL_GPL(rfkill_epo);
+
+/**
  * rfkill_force_state - Force the internal rfkill radio state
  * @rfkill: pointer to the rfkill class to modify.
  * @state: the current radio state the class should be forced to.
-- 
1.5.5.4

