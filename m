Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42121 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXLGAOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 19:14:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix radio LED problem
Date: Fri, 7 Dec 2007 01:12:35 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474dfe58.85Rcj/BwOPxQm8eE%Larry.Finger@lwfinger.net> <200711291958.45631.mb@bu3sch.de> <47588E37.4080400@lwfinger.net>
In-Reply-To: <47588E37.4080400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712070112.35515.mb@bu3sch.de> (sfid-20071207_001419_116334_412E205A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 December 2007 01:05:11 Larry Finger wrote:
> Sorry it has taken so long to answer, but I am traveling.
> 
> Michael Buesch wrote:
> > On Thursday 29 November 2007 00:48:40 Larry Finger wrote:
> > 
> >> @@ -2802,6 +2800,13 @@ static int b43_op_config(struct ieee8021
> >>        out_unlock_mutex:
> >>  	mutex_unlock(&wl->mutex);
> >>  
> >> +	/* if a LED is devoted to the radio and the switch is on, send
> >> +	 * KEY_WLAN press/release keystrokes */
> >> +	if (!err && dev->radio_hw_enable && &dev->led_radio) {
> >                                             ^^^^^^^^^^^^^^^
> > This condition is always true.
> 
> It looks to me that the code uses the contents of the LED section of the SPROM to initialize
> dev->led_radio. Can we be certain that the initialization will always be done?

I think you didn't quite understand what I tried to say.
Let's give a more obvious example:

int a;
if (&a) {
	/* This is always true, as (&a) can't be a NULL pointer. */
}

Your condition above can never be false. (in practice)
I guess you tried to check if a radio led exists.
I'd suggest you do
if (... && dev->led_radio.dev)

The code in led.c does also assume that the LED is used, if struct b43_led->dev was
assigned to something non-NULL. So I think that kind of check would be OK.
But it might need an additional comment if done here outside of the led.c context.

> >> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 1);
> >> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 0);
> >> +	}
> >> +
> > 
> > Anyway, sending a key event here seems pretty bogus. The comment
> > doesn't really say anything useful why this is needed.
> 
> If a key event (down/up) is not sent, the LED remains off. This location may not be the best place,
> but it is needed someplace, otherwise the switch must be cycled off/on to get the LED on.

So I guess we should do this at initialization and not in the config callback.

-- 
Greetings Michael.
