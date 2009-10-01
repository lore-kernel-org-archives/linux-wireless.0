Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:30733 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZJAUej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 16:34:39 -0400
Received: by fg-out-1718.google.com with SMTP id 22so215372fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 13:34:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Thu, 1 Oct 2009 22:34:32 +0200
Cc: Malte Gell <malte.gell@gmx.de>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com
References: <200910011654.10963.chunkeey@googlemail.com> <3ace41890910011106p2609e928ycbc930a75ae2fb98@mail.gmail.com>
In-Reply-To: <3ace41890910011106p2609e928ycbc930a75ae2fb98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910012234.33182.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 October 2009 20:06:35 Hin-Tak Leung wrote:
> On Thu, Oct 1, 2009 at 3:54 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On 2009-10-01 06:32 AM, Malte Gell wrote:
> >>I first noticed the LEDs are confused,
> > no, the LED colors are not _confused_ at all.
> > This is simply different on.... well, you know: on a per-device base!
> >
> > For example: The Netgear uses a single bi-color LED for their WNDA3100 stick.
> > It glows blue or/and orange depending on the selected band and current
> > operation mode and state...
> >
> > No idea why they didn't stick to the usual red/green mix.
> > Maybe because someone told the hw-devs about the existence of
> > red/green colorblind people??!
> >
> > The original vendor driver (located: drivers/staging/otus/80211core/ledmgr.c)
> > goes to great lengths to describe what's behind the variety of
> > blinking signals. Which is nice, if you like expensive light shows...
> 
> This is just based on my brief look at the relevant code itself - I
> think the driver actually enumerates how many LEDs the device has, so
> the ONLY_ONE_LED construct is a bit bogus. Also I think the
> 0x0846:0x9001 is Malte's with swapped LEDs, not ONLY_ONE?
?

0x0846:0x9001 is a Netgear WN111 v2.
(one LED reference: otus' ledmgr.c ~line 547)

and AFAIK: Malte uses an AVM FRITZ!WLAN Stick N (2.4?).

> I had a look when Malte first wrote about the swap - the code
> basically just do assoc/data-tx in enumeration order (first LED found
> is assoc, 2nd is tx, which make sense if some variant only have a
> LED).
Depends. I think it's more important to have some sort of an "an activity LED"
than a connection indicator, because most desktops-guis nowadays have lots
of fancy applets which are constantly monitoring your connection status and
start to bark as soon as it changes...

BTW: my laptop (with an IWL 5300) only has one LED assigned for wlan as well.
But, someone had the genius idea to put the activity LED into _inverted_
mode when the connection is established. It stays on after association
and flashes under TX activity... This is nice, but it has a downside:
two trigger _drive_ one LED => no real exclusive access anymore.
If you want to reassign the LEDs the clueless user has to be aware about
this trigger dependency, or he see some _blinking interference_.

> As for the color - it is probably just a matter of commercial
> interests (if they can get a particular color from a source cheaper)
unlikely, the bi-color LED is a super bright one.

> or simply variety to catch some customers - as you say, some *do* like
> expensive light shows, and there is a market for it and money to be
> made that way.
:-D

well to be fair, I think they tried to implement some sort of
complex blinking language code. You can tell apart if
the device is idling/scanning/connected/sending in the 5GHz or 2GHz
band just by looking at the blue and orange rhythms...
(maybe this visual feedback is indeed easier to comprehend for the generic
customer than any hard and honest numbers)

But back to the topic: 
This elaborate morse code is clearly way beyond the scope and
abilities of ledclass. I think we should really stick to the
simple rule: one trigger corresponds to only one physical LED.

> Anyway, I am just writing regarding the ONLY_ONE_LED construct and its
> association with 0x0846:0x9001 ...
hmm, not sure what I should do here...
Do you think the driver should simply ignore the lack of a second LED (color)?
Or is it just that the ONLY_ONE_LED construct sounds really lame
and needs a more cunning name?

Regards,
	Chr
