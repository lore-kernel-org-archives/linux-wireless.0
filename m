Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbZDJDOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 23:14:35 -0400
Date: Thu, 09 Apr 2009 22:14:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rfkill: Fix broken rfkill LED in 2.6.30-rc1
Message-ID: <49deb98b.b3qoCjTA6clRL5zY%Larry.Finger@lwfinger.net> (sfid-20090410_051438_056438_AED94386)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill system fails to issue a LED trigger event when the rfkill state
changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.31 material.

Larry
---

Index: wireless-testing/net/rfkill/rfkill.c
===================================================================
--- wireless-testing.orig/net/rfkill/rfkill.c
+++ wireless-testing/net/rfkill/rfkill.c
@@ -96,6 +96,7 @@ static void update_rfkill_state(struct r
 		}
 		mutex_unlock(&rfkill->mutex);
 	}
+	rfkill_led_trigger(rfkill, rfkill->state);
 }
 
 /**
@@ -136,8 +137,9 @@ static int rfkill_toggle_radio(struct rf
 	oldstate = rfkill->state;
 
 	if (rfkill->get_state && !force &&
-	    !rfkill->get_state(rfkill->data, &newstate))
+	    !rfkill->get_state(rfkill->data, &newstate)) {
 		rfkill->state = newstate;
+	}
 
 	switch (state) {
 	case RFKILL_STATE_HARD_BLOCKED:
@@ -172,6 +174,7 @@ static int rfkill_toggle_radio(struct rf
 	if (force || rfkill->state != oldstate)
 		rfkill_uevent(rfkill);
 
+	rfkill_led_trigger(rfkill, rfkill->state);
 	return retval;
 }
 
@@ -204,6 +207,7 @@ static void __rfkill_switch_all(const en
 			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill, state, 0);
 			mutex_unlock(&rfkill->mutex);
+			rfkill_led_trigger(rfkill, rfkill->state);
 		}
 	}
 }
@@ -256,6 +260,7 @@ void rfkill_epo(void)
 				RFKILL_STATE_SOFT_BLOCKED;
 	}
 	mutex_unlock(&rfkill_global_mutex);
+	rfkill_led_trigger(rfkill, rfkill->state);
 }
 EXPORT_SYMBOL_GPL(rfkill_epo);
 
@@ -358,6 +363,7 @@ int rfkill_force_state(struct rfkill *rf
 		rfkill_uevent(rfkill);
 
 	mutex_unlock(&rfkill->mutex);
+	rfkill_led_trigger(rfkill, rfkill->state);
 
 	return 0;
 }
@@ -520,6 +526,7 @@ static int rfkill_resume(struct device *
 				1);
 
 		mutex_unlock(&rfkill->mutex);
+		rfkill_led_trigger(rfkill, rfkill->state);
 	}
 
 	return 0;
