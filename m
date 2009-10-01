Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:47633 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbZJAXSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 19:18:39 -0400
Received: by fxm27 with SMTP id 27so536349fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 16:18:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Fri, 2 Oct 2009 01:18:26 +0200
Cc: Malte Gell <malte.gell@gmx.de>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com
References: <200910011654.10963.chunkeey@googlemail.com> <200910012234.33182.chunkeey@googlemail.com> <3ace41890910011424g3711ffbap2d4057776f10b6d8@mail.gmail.com>
In-Reply-To: <3ace41890910011424g3711ffbap2d4057776f10b6d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910020118.27545.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 October 2009 23:24:59 Hin-Tak Leung wrote:
> On Thu, Oct 1, 2009 at 9:34 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Thursday 01 October 2009 20:06:35 Hin-Tak Leung wrote:
> >> On Thu, Oct 1, 2009 at 3:54 PM, Christian Lamparter
> >> <chunkeey@googlemail.com> wrote:
> >> > On 2009-10-01 06:32 AM, Malte Gell wrote:
> >> >>I first noticed the LEDs are confused,
> >> > no, the LED colors are not _confused_ at all.
> >> > This is simply different on.... well, you know: on a per-device base!
> >> >
> >> > For example: The Netgear uses a single bi-color LED for their WNDA3100 stick.
> >> > It glows blue or/and orange depending on the selected band and current
> >> > operation mode and state...
> >> >
> >> > No idea why they didn't stick to the usual red/green mix.
> >> > Maybe because someone told the hw-devs about the existence of
> >> > red/green colorblind people??!
> >> >
> >> > The original vendor driver (located: drivers/staging/otus/80211core/ledmgr.c)
> >> > goes to great lengths to describe what's behind the variety of
> >> > blinking signals. Which is nice, if you like expensive light shows...
> >>
> >> This is just based on my brief look at the relevant code itself - I
> >> think the driver actually enumerates how many LEDs the device has, so
> >> the ONLY_ONE_LED construct is a bit bogus. Also I think the
> >> 0x0846:0x9001 is Malte's with swapped LEDs, not ONLY_ONE?
> > ?
> >
> > 0x0846:0x9001 is a Netgear WN111 v2.
> > (one LED reference: otus' ledmgr.c ~line 547)
> >
> > and AFAIK: Malte uses an AVM FRITZ!WLAN Stick N (2.4?).
> 
> I just remember the ID from Malte's ndiswrapper-list posting.
indeed, he must have bought a WN111 v2 as well?!
but just in case he's trying to use the WN111 driver:
This may not work, AVM FRITZ!WLAN is not 100% compatible with
most other AR9170 variants and could refuse to work properly with
other 3rd party drivers.

> It is not unthinkable of a rebranded device, or even vendor abusing the
> system a bit and put out a device which is subtly different with the
> same ids.
yes, I've heard of such cases.
But in all of them a reseller simply _borrowed_ the usb VID of
the hardware manufacture (e.g Ralink/Atheros) and not from
other resellers.

I hope you agree with me on this occasion that we don't have
to be paranoid about pid/vid collisions, unless someone
can prove that he got a genuine ar9170 with a bi-color LED/two LEDs
which identifies itself as WN111 v2.
> >> I had a look when Malte first wrote about the swap - the code
> >> basically just do assoc/data-tx in enumeration order (first LED found
> >> is assoc, 2nd is tx, which make sense if some variant only have a
> >> LED).
> > Depends. I think it's more important to have some sort of an "an activity LED"
> > than a connection indicator, because most desktops-guis nowadays have lots
> > of fancy applets which are constantly monitoring your connection status and
> > start to bark as soon as it changes...
> >
> > BTW: my laptop (with an IWL 5300) only has one LED assigned for wlan as well.
> > But, someone had the genius idea to put the activity LED into _inverted_
> > mode when the connection is established. It stays on after association
> > and flashes under TX activity... This is nice, but it has a downside:
> > two trigger _drive_ one LED => no real exclusive access anymore.
> > If you want to reassign the LEDs the clueless user has to be aware about
> > this trigger dependency, or he see some _blinking interference_.
> >
> >> As for the color - it is probably just a matter of commercial
> >> interests (if they can get a particular color from a source cheaper)
> > unlikely, the bi-color LED is a super bright one.
> >
> >> or simply variety to catch some customers - as you say, some *do* like
> >> expensive light shows, and there is a market for it and money to be
> >> made that way.
> > :-D
> >
> > well to be fair, I think they tried to implement some sort of
> > complex blinking language code. You can tell apart if
> > the device is idling/scanning/connected/sending in the 5GHz or 2GHz
> > band just by looking at the blue and orange rhythms...
> > (maybe this visual feedback is indeed easier to comprehend for the generic
> > customer than any hard and honest numbers)
> >
> > But back to the topic:
> > This elaborate morse code is clearly way beyond the scope and
> > abilities of ledclass. I think we should really stick to the
> > simple rule: one trigger corresponds to only one physical LED.
> >
> >> Anyway, I am just writing regarding the ONLY_ONE_LED construct and its
> >> association with 0x0846:0x9001 ...
> > hmm, not sure what I should do here...
> > Do you think the driver should simply ignore the lack of a second LED (color)?
> > Or is it just that the ONLY_ONE_LED construct sounds really lame
> > and needs a more cunning name?
>
> Hmm, I mean the ONLY_ONE_LED config should not be a compiled in config
> associated with an vid/pid, but dynamically determined from the
> enumeration.
dynamically determined? how?
Neither the EEPROM, nor any hw/fw register contain any information about
the number of available LEDs on the platform. The only feasible clue
comes from the devices' usb descriptors (=> VID and PID).

> In the case of only one LED, the it sounds quite neat to represent
> both assciation status and transmission status by blinking pattern
> :-).
It is... but the logic which programs the GPIOs is nowhere to be found
inside the driver... I think the vendor implemented it somewhere
deep inside the embedded controller (firmware).
And the card, driver, ledclass and userspace is unaware of this and
treats it as two independent things => this is BAD.

Let me explain (why this is BAD), just take this topic as a example:
Malte (our eagle-eyed user) discovered that his LEDs don't flash the
same way as with a customized vendor driver.
In his attempt to fix is issue, he could inadvertently break the
configuration of others...

And there's no denying here, at some point, we all had to
suffer from similar situations which are knows as the 
fallout of -rc1 kernels. :-D

> But one of them should take priority in case of conflict, and in this
> regard it seems that you and I disagree on which should be.
hmm, when I think about it: the only (proper) way to accomplish this feat 
would be to extend the LED(class), so it can have several different triggers
at the same time... 

(or as an alternative: implement trigger filters. So some LEDs can only
be used with a specific trigger event.
however, there is a possibility that this might to more harm than good.)

Regards,
	Chr
