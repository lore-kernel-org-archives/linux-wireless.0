Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46662
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbXK1OMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 09:12:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
Date: Wed, 28 Nov 2007 15:11:21 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711272120.44575.mb@bu3sch.de> <474C8A8E.6070404@lwfinger.net>
In-Reply-To: <474C8A8E.6070404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711281511.22788.mb@bu3sch.de> (sfid-20071128_141249_869681_E589767E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007 22:22:22 Larry Finger wrote:
> > I'm wondering who causes this deadlock. "registered" should be false if
> > we are called back from rfkill_initialize, so it should return early before
> > the lock.
> 
> The following code has the competing lock:
> 
> static int rfkill_toggle_radio(struct rfkill *rfkill,
>                                 enum rfkill_state state)
> {
>         int retval;
> 
>         retval = mutex_lock_interruptible(&rfkill->mutex);
>         if (retval)
>                 return retval;
> 
>         if (state != rfkill->state) {
>                 retval = rfkill->toggle_radio(rfkill->data, state);
>                 if (!retval) {
>                         rfkill->state = state;
>                         rfkill_led_trigger(rfkill, state);
>                 }
>         }
> 
>         mutex_unlock(&rfkill->mutex);
>         return retval;
> }

So it's a lock dependency between rfkill->mutex and wl->mutex?
So, now comes the question that really matters. Who is the caller
of rfkill_toggle_radio, in the case where it crashes?

-- 
Greetings Michael.
