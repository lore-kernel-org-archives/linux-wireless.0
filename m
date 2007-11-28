Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58840
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbXK1QOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:14:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
Date: Wed, 28 Nov 2007 17:13:02 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711281511.22788.mb@bu3sch.de> <474D83BF.7000102@lwfinger.net>
In-Reply-To: <474D83BF.7000102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711281713.02919.mb@bu3sch.de> (sfid-20071128_161453_800970_1755387C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 November 2007 16:05:35 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > So it's a lock dependency between rfkill->mutex and wl->mutex?
> > So, now comes the question that really matters. Who is the caller
> > of rfkill_toggle_radio, in the case where it crashes?
> >
> 
> Here is the full dump. It looks to me as if b43_rfkill_soft_toggle() calls rfkill_handler(), which
> calls rfkill_toggle_radio() and it is calling b43_rfkill_soft_toggle(). I'd call that a loop.

I think it's a different bug. The backtrace seems corrupted.

Can you try this patch? There is some circular locking in rfkill.

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
