Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:51381 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbXGWWHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2007 18:07:38 -0400
Message-ID: <46A5269F.5050504@debian.org>
Date: Tue, 24 Jul 2007 01:07:27 +0300
From: Faidon Liambotis <paravoid@debian.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
References: <20070722131751.GA3009@void.cube.gr> <1185124453.3100.49.camel@mj>
In-Reply-To: <1185124453.3100.49.camel@mj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[I'm adding Jouni to Cc to help us :)]

Pavel Roskin wrote:
> On Sun, 2007-07-22 at 16:17 +0300, Faidon Liambotis wrote:
>> Since v2.6.14, Prism 2/2.5/3 devices are better supported using the HostAP
>> driver, which was made to work with these exclusively.
>> Having the same IDs supported by orinoco too confuses users who have both
>> drivers compiled in or as modules who expect hostap to drive the device.
>>
>> Telling users to echo to /sys/bus/pci/drivers/*/unbind and bind is not
>> exactly user-friendly.
>>
>> Create an option to disable support for Prism devices in orinoco driver which
>> disabled the IDs for the PCMCIA module and creates a Kconfig dependency for
>> the Prism PCI modules.
> 
> NAK.
> 
> Nortel cards consist of a bridge and a PCMCIA card with Symbol firmware.
> Their PCI IDs (0x126c:0x8030 and 0x1562:0x0001) are in hostap_plx, but I
> really doubt that hostap_plx would even be able to initialize those
> cards properly, given the fact that it lacks Nortel specific code (look
> for "118" in orinoco_nortel and hostap_plx).
> 
> And even if hostap_plx could initialize the hardware, it would not be
> able to use it.  Support for Agere and Symbol firmware in Hostap is
> rudimentary at best.  It would not even be able to set WEP.
OK.
I merely compared the PCI IDs. If you're right, hostap claims that it 
can support devices it can't. We should remove these...

> In any case, since your changes are meant to cut support for Prism to
> firmware from Orinoco, it's wrong deceive users and cut support for
> Symbol firmware based devices instead.
> 
> If you want to pursue this approach, it would be logical to also have an
> option for hostap to remove support for non-Prism devices.  Better yet,
> it should be removed unconditionally, since it's known to be broken,
> unlike support for Prism devices in Orinoco.
> 
> Now let's consider PLX bridges.  There is a great variety of them, and
> some of them were sold to be used with Orinoco branded cards, i.e. with
> Agere firmware.  Some were sold with Prism based cards.  3com branded
> cards were likely shipped with cards using Symbol firmware.
> 
> It is possible to classify the PCMCIA card by using the PCMCIA
> configuration space available through the PLX bridge, but the driver
> would be loaded by then.
> 
> In case of TMD cards, even PCMCIA configuration space is not available,
> so the firmware can only be identified by its version.
> 
> Only in case of true PCI cards, orinoco_pci supports the same cards are
> hostap_pci.
> 
> I think we should consider other approaches:
> 
> 1) Be careful and only cut the IDs for the devices definitely known to
> have been sold with Prism based cards.  In the came time, cut support
> for Agere and Symbol based devices from hostap.
> 
> 2) Add code to Orinoco to hand over the devices found to have Prism
> firmware to hostap.  The device would be deinitialized and the bus
> specific hostap driver (e.g. hostap_plx) would be called the way it's
> called by the kernel then the device ID matches.
> 
> 3) Make Orinoco use hostap backend for the cards found to have Prism
> firmware, i.e. bypass hostap's bus specific modules.  That would require
> quite a lot of impedance matching, but it should be possible.
> 
> The later approach is perhaps the most ambitious, but I think it's in
> the Linux spirit of integrating the drivers rather than keeping them as
> separate blobs.
To be honest, I can't imagine people actively working on either of the 
two drivers. The hardware isn't being sold anymore and the technology 
(.11b) is two generations behind. And it's not like the drivers aren't 
working.
OTOH, I'm not watching closely, so may be I'm far off. You know better :)

So, I'll sent, if you agree, a patch that only disables orinoco_pci and 
the PCMCIA IDs. If you know more (a specific ID of a PLX that can 
definitely work with hostap) please say so.
I'll let Jouni comment on the Agere and Symbol rip from hostap.

As for the other solutions, I have none of good knowledge of the 
drivers,  time or motivation for something like that.

I think we should find a solution for now and leave the big plans for 
when/if they happen.

Regards,
Faidon
