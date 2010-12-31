Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62800 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0LaOld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 09:41:33 -0500
Received: by fxm20 with SMTP id 20so11900451fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Dec 2010 06:41:31 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chin Shi Hong <cshong87@gmail.com>
Subject: Re: Get slow speed when using ar9170usb driver.
Date: Fri, 31 Dec 2010 15:41:25 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimYqrqUK2EjnyvkwvsFM+6b7ZMTGjBQrWFT712T@mail.gmail.com> <AANLkTi=c1XvwzJjZx+WH0uSSxn8++CCFJ-pJkxa4MtaQ@mail.gmail.com> <AANLkTikTHecf=yDcUgaJ-2RbzVzX5hpr_xbBTDgtiKeb@mail.gmail.com>
In-Reply-To: <AANLkTikTHecf=yDcUgaJ-2RbzVzX5hpr_xbBTDgtiKeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012311541.25751.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 December 2010 14:40:38 Chin Shi Hong wrote:
> On Thu, Dec 30, 2010 at 9:54 PM, Chin Shi Hong <cshong87@gmail.com> wrote:
> > On Fri, Dec 31, 2010 at 7:27 AM, Christian Lamparter
> > <chunkeey@googlemail.com> wrote:
> >> On Thursday 30 December 2010 16:55:18 Chin Shi Hong wrote:
> >>> Wireless adapter model: TP-LINK WN821NC (USB 300Mbps Wireless N adapter)
> >>> Output of lsusb: Bus 001 Device 007: ID 0cf3:1002 Atheros
> >>> Communications, Inc. TP-Link TL-WN821N v2 [Atheros AR9001U-(2)NG]
> >>> Wireless router: TP-LINK W8960N (300Mbps Wireless N router)
> >>
> >> That's weird, according to TP-Link's website there wasn't any WN821NC
> >> with a WN821N v2. They "only" let you download the driver for
> >> WN821N v3. v3 very different from the previous v2 generation, it has
> >> new chips (AR7015+AR9287?) and needs the ath9k_htc driver.
> >
> > WN821NC is actually WN821N shipped with USB cradle. WN821N itself does
> > not ship with any USB Cradle. The character 'C' in WN821NC mean
> > "Cradle". If you purchase WN821N, you will not get any USB Cradle.
> > But, if you purchase WN821NC, what you get is actually WN821N + USB
> > Cradle.
I went the extra mile. Got the windows driver for WN821NC
and installed it (under wine, if that makes a difference?) and
guess what... it's only for ath9k_htc. So why would TP-Link
sabotage themselves and only provide the wrong driver for all
windows customers?

But anyway, it's your stuff that does not work :D.

> > Are you sure, you didn't get ripped off here and someone else
> >> has "your" v3?
> >
> > According to the information printed at the back of my wireless
> > adapter, it is WN821N v2.
Yeah, I found someone on ebay, flogging cradles with WN821Nv2.

> >>> Driver name ar9170usb
> >>> Linux distro: Ubuntu 10.10 64 bit
> >>> Kernel version: 2.6.35-24-generic
> >>>
> >>> If I use Ndiswrapper + Windows XP driver, I can get full 300Mbps.
> >> Have you measured that (with iperf/netperf)? Or is it just the
> >> "Connection Information" pop-up which simply displays "speed: 300 Mbits" ?
> >
> > The 300Mbps is just "display". But, when I test my speed on Windows XP
> > with jperf, it ever reach maximum 2xxMbps.
"It >N<ever reaches the maximum of 200 Mbps?"

Wasn't there something abour wireless PHY vs. TCP speeds in the
"802.11 capturing project"?

I've been looking around for benchmarks for comparisons
While I did not find anything with a WN821N v2, there is one rather
nice review with several adapters, including a Netgear WN111v2. 
The WN111v2 has definitely the same chip and driver, I can't say
much about the "design" though, but it should be similar as well.

<http://www.smallnetbuilder.com/wireless/wireless-reviews/31089-80211n-adapter-roundup>

Yup, a very bleak picture.

> >>> At the same distance, if I use ar9170usb driver, I can only get
> >>> maximum 54Mbps speed.
> >> That's true. here's ar9170usb wiki page:
> >> <http://wireless.kernel.org/en/users/Drivers/ar9170#features> => working
> >>        "802.11 a/b/g"
> >>
> >> --
> >>
> >> The quickest way around limitations is via backports:
> >> visit <http://wireless.kernel.org/en/users/Download>
> >> and get compat-wireless:
> >>
> > Will try carl9170 again later.
Huh, so have have tried carl9170 before?

> carl9170 not work. Error when trying to run "sudo modprobe carl9170":
> "FATAL: Error inserting carl9170
> (/lib/modules/2.6.35-22-generic/updates/drivers/net/wireless/ath/carl9170/carl9170.ko):
> Invalid argument".
hint: "dmesg" tells you more.

I can only guess that "Invalid argument" actually means in
this context, but it could be related to old/incompatible modules.
Try to reload the ath, mac80211 and cfg80211 modules.

Regards,
	Chr
