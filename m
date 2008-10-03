Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59360 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbYJCUPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:15:55 -0400
Date: Fri, 3 Oct 2008 16:58:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH] rfkill: update LEDs for all state changes
Message-ID: <20081003195805.GC32618@khazad-dum.debian.net> (sfid-20081003_221558_536914_16DBC9E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LED state was not being updated by rfkill_force_state(), which
will cause regressions in wireless drivers that had old-style rfkill
support and are updated to use rfkill_force_state().

The LED state was not being updated when a change was detected through
the rfkill->get_state() hook, either.

Move the LED trigger update calls into notify_rfkill_state_change(),
where it should have been in the first place.  This takes care of both
issues above.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: stable@kernel.org
---

This change is needed on 2.6.27 and 2.6.28.  It is likely too late to
get it in 2.6.27 before it is released, but it should be queued for
2.6.27.y after it gets into 2.6.28.

 net/rfkill/rfkill.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index ea0dc04..f949a48 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -125,6 +125,7 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
 
 static void notify_rfkill_state_change(struct rfkill *rfkill)
 {
+	rfkill_led_trigger(rfkill, rfkill->state);
 	blocking_notifier_call_chain(&rfkill_notifier_list,
 			RFKILL_STATE_CHANGED,
 			rfkill);
@@ -217,10 +218,8 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 			rfkill->state = state;
 	}
 
-	if (force || rfkill->state != oldstate) {
-		rfkill_led_trigger(rfkill, rfkill->state);
+	if (force || rfkill->state != oldstate)
 		notify_rfkill_state_change(rfkill);
-	}
 
 	return retval;
 }
-- 
1.5.6.5

