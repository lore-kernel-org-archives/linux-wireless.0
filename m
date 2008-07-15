Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46663 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478AbYGOTcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 15:32:14 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/4] rfkill: document rfkill_force_state as required
Date: Tue, 15 Jul 2008 16:32:04 -0300
Message-Id: <1216150327-10904-2-git-send-email-hmh@hmh.eng.br> (sfid-20080715_213218_409507_50207C83)
In-Reply-To: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the rfkill class does work with just get_state(), it doesn't work
well on devices that are subject to external events that cause rfkill state
changes.

Document that rfkill_force_state() is required in those cases.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 Documentation/rfkill.txt |   20 ++++++++++++++++----
 net/rfkill/rfkill.c      |    7 ++++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 0843ed0..1f924e4 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -390,9 +390,10 @@ rfkill lines are inactive, it must return RFKILL_STATE_SOFT_BLOCKED if its soft
 rfkill input line is active.  Only if none of the rfkill input lines are
 active, will it return RFKILL_STATE_UNBLOCKED.
 
-If it doesn't implement the get_state() hook, it must make sure that its calls
-to rfkill_force_state() are enough to keep the status always up-to-date, and it
-must do a rfkill_force_state() on resume from sleep.
+Since the device has a hardware rfkill line, it IS subject to state changes
+external to rfkill.  Therefore, the driver must make sure that it calls
+rfkill_force_state() to keep the status always up-to-date, and it must do a
+rfkill_force_state() on resume from sleep.
 
 Every time the driver gets a notification from the card that one of its rfkill
 lines changed state (polling might be needed on badly designed cards that don't
@@ -422,13 +423,24 @@ of the hardware is unknown), or read-write (where the hardware can be queried
 about its current state).
 
 The rfkill class will call the get_state hook of a device every time it needs
-to know the *real* current state of the hardware.  This can happen often.
+to know the *real* current state of the hardware.  This can happen often, but
+it does not do any pooling, so it is not enough on hardware that is subject
+to state changes outside of the rfkill subsystem.
+
+Therefore, calling rfkill_force_state() when a state change happens is
+mandatory when the device has a hardware rfkill line, or when something else
+like the firmware could cause its state to be changed without going through the
+rfkill class.
 
 Some hardware provides events when its status changes.  In these cases, it is
 best for the driver to not provide a get_state hook, and instead register the
 rfkill class *already* with the correct status, and keep it updated using
 rfkill_force_state() when it gets an event from the hardware.
 
+rfkill_force_state() must be used on the device resume handlers to update the
+rfkill status, should there be any chance of the device status changing during
+the sleep.
+
 There is no provision for a statically-allocated rfkill struct.  You must
 use rfkill_allocate() to allocate one.
 
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 7a560b7..022fe50 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -252,7 +252,12 @@ EXPORT_SYMBOL_GPL(rfkill_epo);
  * a notification by the firmware/hardware of the current *real*
  * state of the radio rfkill switch.
  *
- * It may not be called from an atomic context.
+ * Devices which are subject to external changes on their rfkill
+ * state (such as those caused by a hardware rfkill line) MUST
+ * have their driver arrange to call rfkill_force_state() as soon
+ * as possible after such a change.
+ *
+ * This function may not be called from an atomic context.
  */
 int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 {
-- 
1.5.6.2

