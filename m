Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34410
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbXK1Qu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:50:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: fix double-mutex-locking
Date: Wed, 28 Nov 2007 17:49:34 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200711281749.34572.mb@bu3sch.de> (sfid-20071128_165103_199442_B31804DD)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_toggle_radio is called from functions where
rfkill->mutex is already aquired.

Remove the lock from rfkill_toggle_radio() and add it to
the only calling function that calls it without the lock held.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-11-20 19:09:35.000000000 +0100
+++ wireless-2.6/net/rfkill/rfkill.c	2007-11-28 17:09:55.000000000 +0100
@@ -60,11 +60,7 @@ static void rfkill_led_trigger(struct rf
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state)
 {
-	int retval;
-
-	retval = mutex_lock_interruptible(&rfkill->mutex);
-	if (retval)
-		return retval;
+	int retval = 0;
 
 	if (state != rfkill->state) {
 		retval = rfkill->toggle_radio(rfkill->data, state);
@@ -74,7 +70,6 @@ static int rfkill_toggle_radio(struct rf
 		}
 	}
 
-	mutex_unlock(&rfkill->mutex);
 	return retval;
 }
 
@@ -158,12 +153,13 @@ static ssize_t rfkill_state_store(struct
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (mutex_lock_interruptible(&rfkill->mutex))
+		return -ERESTARTSYS;
 	error = rfkill_toggle_radio(rfkill,
 			state ? RFKILL_STATE_ON : RFKILL_STATE_OFF);
-	if (error)
-		return error;
+	mutex_unlock(&rfkill->mutex);
 
-	return count;
+	return error ? error : count;
 }
 
 static ssize_t rfkill_claim_show(struct device *dev,

-- 
Greetings Michael.
