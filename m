Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59994 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZLSAPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 19:15:37 -0500
Received: by bwz27 with SMTP id 27so2519609bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 16:15:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: andreamrl@tiscali.it
In-Reply-To: <4B2C100A.9000507@lwfinger.net>
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	<4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org>
	<4B2C100A.9000507@lwfinger.net>
From: Andrea Merello <andreamrl@tiscali.it>
Date: Sat, 19 Dec 2009 01:15:15 +0100
Message-ID: <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Florian Zumbiehl <florz@florz.de>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

First of all I heve to say that I'm not working on those drivers since
years, so my informations are not up to date.

However since the rtl8187 cards are all "softmac" cards I think that
they will always consume a bit of CPU when they are alive.

This means that all the 802.11 protocol is handled by your CPU and
that the rtl8187 dongle passes all packets to the kernel.
So even if no network traffic is running, management packets are still
handled by the kernel.

As someone told before this management traffic is for examples beacons.

Probably your prism2 card was a so called "fullmac" card. That menas
that all this management stuff can be done on the wifi card without
generating load on the host CPU.

One thing I can say is that the ieee 802.11 protocol allows certains
power save functionalities but, provided that mac80211 / rtl8187
driver support it (and I'm really not sure), this will probably only
reduces power consumption on the USB, not on the host processor.

Well, it may be interesting to do a serious analisys about how much
power is drained by the card when it is up and in RX, when the
mac80211 sends probes, and how much is related to the CPU, however,
because you estimated that the power drain increase is too much for
being directly related to the usb stuff, I think is really possible
that the big problem is related to beacons.

Even if potentially the 802.11 protocol can probably work even without
beacons (even it might seems a contraddiction, I think it is true if
you are NOT using powersave functionality), currently I suspect the
mac80211 wants them in order to calculate network quality (missed
beacon rate) and it might even send more probes (TX is other power
burnt out) if it cannot detect beacons.

Even worse, even if one will modify the mac80211 in order to live
without beacons, I think it can't be told to the rtl8187 to filter out
beacons. The HW can filter out all management frames, but not only
beacons.

This means that, IMHO, there is no way to avoid the CPU work on
rtl8187 when you are connected to a network (unless the network AP is
yours and you reduce beacon interval as someone suggested). Maybe you
can force some powersave mode on the CPU, by scaling the cpu clock
frequency, avoiding taht some "ondemand" policy can rise the clock
when the CPU is loaded (I doubt beacons processing is enough to
trigger this), but If you tracked down that interrupts are the causes
of the CPU don't entering C3 state, I _think_ you can't do much..


So far If you are looking for a card that make you save power, I
suggest you to get a fullmac one.

Andrea


On Sat, Dec 19, 2009 at 12:28 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 12/18/2009 12:59 PM, Florian Zumbiehl wrote:
>>
>> Well, yeah, I meant "payload I care about", of course :-)
>>
>> For comparison, if I plug in and configure my prism2 card to connect
>> to the same AP, power consumption goes up by ~ 2 Watts while idling.
>> Given that it seems to be possible to build a wifi interface (plus driver)
>> that does manage to stay connected on a budget of ~ 2 Watts, I would hope
>> that there is such a thing for USB, too. b-only would be fine, too - it's
>> USB 1.1 only, anyhow.
>
> I have no idea what the relative power consumption is for USB and PCI.
> Certainly, a PCI card can assume a cleaner power source - the USB is
> going to have to do heavier regulation.
>
> One other thing to try is to turn off the LED. Unset
> CONFIG_MAC80211_LEDS in your .config. That should save some power.
>
