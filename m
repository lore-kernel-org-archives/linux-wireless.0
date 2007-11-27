Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49061 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754827AbXK0VW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 16:22:28 -0500
Message-ID: <474C8A8E.6070404@lwfinger.net> (sfid-20071127_212232_659807_35AC6DEF)
Date: Tue, 27 Nov 2007 15:22:22 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de> <474C77E7.9030202@lwfinger.net> <200711272120.44575.mb@bu3sch.de>
In-Reply-To: <200711272120.44575.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 27 November 2007 21:02:47 Larry Finger wrote:
> Is the switch properly polled and is the status change properly reported upstream?
> If yes, you might want to check (add printk to rfkill code) if the LED
> is properly triggered.

I know that b43_rfkill_poll() is being called as I can see the ENABLED/DISABLED messages in the log.
I'll have to work my way through the things it calls.

> I'm wondering who causes this deadlock. "registered" should be false if
> we are called back from rfkill_initialize, so it should return early before
> the lock.

The following code has the competing lock:

static int rfkill_toggle_radio(struct rfkill *rfkill,
                                enum rfkill_state state)
{
        int retval;

        retval = mutex_lock_interruptible(&rfkill->mutex);
        if (retval)
                return retval;

        if (state != rfkill->state) {
                retval = rfkill->toggle_radio(rfkill->data, state);
                if (!retval) {
                        rfkill->state = state;
                        rfkill_led_trigger(rfkill, state);
                }
        }

        mutex_unlock(&rfkill->mutex);
        return retval;
}

Larry
