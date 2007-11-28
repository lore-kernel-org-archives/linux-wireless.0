Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60572
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbXK1QaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:30:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Simple 'fix' for radio switch LED regression
Date: Wed, 28 Nov 2007 17:29:04 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <474d8b73.cCPCkkSQe1GIVt4H%Larry.Finger@lwfinger.net> <200711281652.05627.mb@bu3sch.de> <474D94ED.6050403@lwfinger.net>
In-Reply-To: <474D94ED.6050403@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200711281729.04505.mb@bu3sch.de> (sfid-20071128_163024_002049_E47D29D5)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 November 2007 17:18:53 Larry Finger wrote:
> Michael Buesch wrote:
> > On Wednesday 28 November 2007 16:38:27 Larry Finger wrote:
> >> Since addition of the rfkill callback, the LED associated with the off/on
> >> switch on the radio has not worked because essential data in the rfkill
> >> structure is missing. When that problem was fixed, difficulties in circular
> >> locking surfaced. This patch fixes part of the regression in that the LED
> >> is turned on if the radio switch is on at startup. Adding the code to toggle
> >> the LED with the switch will be more involved and would likely miss the 2.6.24
> >> window.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> ---
> >>
> >> John and Michael,
> >>
> >> I was able to get the full functionality working, but with two significant
> >> problems: (1) the LED toggled only with a switch off-on sequence, not with
> >> each switch change and (2) the module would no longer unload cleanly due to
> >> circular locking. I will be essentually off-line after today, and I hope that
> >> this hack, which will make the LED appear to work correctly, can be pushed
> >> into 2.6.24 as it is a fix, but has minimal code impact. Nearly all of the
> >> changes are needed just to make the LED on routine available to startup.
> >> Furthermore, I'm certain these changes will be needed when the complete fix
> >> is available.
> > 
> > That completely shortcuts the "behaviour" logic.
> > This patch trades one bug for another.
> > It will get other people upset, because their LEDs don't work as expected anymore.
> > 
> > This is not a showstopper bug and there is no need to introduce dirty
> > fixes that trade one bug for another.
> > I'm pretty sure that this patch will break LEDs on my asus card. I didn't
> > try that, though.
> 
> Please try the patch at least enough to see if it breaks the LEDs on your card. I don't think it
> will.

There's no need to try this.
Let's summerize what we have and what your patch does:

We have a _nonconstant_ mapping of LEDs to LED behaviours. This mapping
is done in the SPROM or in a special function which takes card types
and revisions and assigns the behaviour to the LED.
So the rfkill LED could be _any_ LED in the LED iospace.

What your patch does now is to hardcode the LED to LED index 1 with
an activelow capability. Why LED 1? Why activelow? Because this is the
case in your particular type of b43 card.

My asus card has two LEDs. One has a "link is up, aka associated" and a
"transmitting data" LED. I don't know from the top of my head which
indices those LEDs are, but let's simply assume they are index 0 and 1.
(Remember this mapping is random and specific to the hardware).

So what we do is poke with some random LED.
Also, I'm pretty sure that these LEDs on my card are activehigh. So
if your patch is applied to such a card it will and up with a "nonworking"
LED. That's what we wanted to fix in the first place, right? ;)

-- 
Greetings Michael.
