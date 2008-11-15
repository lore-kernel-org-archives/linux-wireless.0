Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53732 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYKOXex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 18:34:53 -0500
Received: by ey-out-2122.google.com with SMTP id 6so777437eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 15:34:51 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rt2x00: Don't switch off LED on initialization
Date: Sun, 16 Nov 2008 00:34:45 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200811160008.51235.IvDoorn@gmail.com> <200811160025.25678.mb@bu3sch.de>
In-Reply-To: <200811160025.25678.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811160034.46520.IvDoorn@gmail.com> (sfid-20081116_003504_802800_E178AE13)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 November 2008, Michael Buesch wrote:
> On Sunday 16 November 2008 00:08:50 Ivo van Doorn wrote:
> > When we switch off the LEDS during initialization
> > we kill rt73usb from proper functioning. The immediate
> > result after the first LED command are MCU failures
> > and a complete breakdown of TX/RX.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2x00leds.c |    6 ------
> >  1 files changed, 0 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
> > index 66c61b1..68f4e0f 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00leds.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
> > @@ -111,12 +111,6 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
> >  	led->led_dev.name = name;
> >  	led->led_dev.brightness = LED_OFF;
> >  
> > -	/*
> > -	 * Ensure the LED is off, it might have been enabled
> > -	 * by the hardware when the device was powered on.
> > -	 */
> > -	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
> > -
> >  	retval = led_classdev_register(device, &led->led_dev);
> >  	if (retval) {
> >  		ERROR(rt2x00dev, "Failed to register led handler.\n");
> 
> But you know that a brightness_set event can trigger right after the dev
> was registered?
> So a random LED event at the right time can kill the rt device?

If the user manages to trigger the event right after registration
yes, then it might be possible (Note that the leds aren't controlled by any triggers,
neither RFKill nor mac80211 triggers are attached to the rt2x00 leds).
This is a quick hack, to get the device working by default again.
I still have to research why exactly the device dies when LED is switched off
in an early initialization state.

But for the rare occasions the user might trigger the LED too early,
the user just has to plugin the device again. 

Ivo
