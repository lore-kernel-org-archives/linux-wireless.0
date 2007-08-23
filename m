Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frosty.hhs.nl ([145.52.2.15]:57428 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbXHWLgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 07:36:54 -0400
Received: from exim (helo=frosty)
	by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IOAzc-0001da-7K
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 13:36:52 +0200
Received: from [145.52.8.13] (port=50588 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IOAzb-0001dK-0Y
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 13:36:51 +0200
Message-ID: <46CD6E5F.9040601@hhs.nl>
Date: Thu, 23 Aug 2007 13:24:15 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708200244.22841.chunkeey@web.de> <46C94844.3080505@hhs.nl> <200708201351.45575.chunkeey@web.de>
In-Reply-To: <200708201351.45575.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Monday, 20. August 2007, Hans de Goede wrote:
>> Chr wrote:
>>> On Tuesday, 14. August 2007, Hans de Goede wrote:
>>>
>>> Hans,
>>>
>>> Any updates?
>> Erm, did you not receive my long mail with all kinda logs attached in logs.tar.gz?
>>
> yes I got the logs... but maybe you haven't seen my reply:
> http://www.spinics.net/lists/linux-wireless/msg04658.html
> 

I indeed didn't see that, probably because I'm not on the list. Here are some 
answers to your questions:

 > > > 1. Which p54 firmware do you use? (It "must" be 2.7.0.0 for pci/cardbus)
 > > 2.4.12.0, extracted from the window driver for my card, any later version
 > > will cause the driver to fail to load with: "Error cannot read eeprom!"

 > uhh, that's a pity... Well, I'm thinking about to get the FW then. The
 > problem is that I don't have the necessary equipment "here" for debugging (I
 > am abroad with my old laptop and a minipci prism54 card...)
 >
 > Anyway, could you please verify that the firmware at
 > http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.4.12.0.arm is the same
 > one you have? Or does it "differ"?

I'm at work atm, but I did verify that my 2.4.12.0 matched 2.4.12.0 available 
from the firmware site linked to from the prism54 wiki.

I can verify that your link matches too if you want, but it porbably will.


 >
 > > 2. What's your "average" txrate and Link Signal Level / Link Quality with 
and without the patches.
 > >    (see iwconfig)
 > See attached logs
 >
Your average speed is in the very low MBit/s and your normal Link Signal Level 
is only about
40/100 (~ -80 dbm! ) ?! (The equation is roughly (rssi / 2) - 100 = dbm)

Something is fishy: take a look at the "not working" scan-13-6.  Signal level 
is about 62/100
(~ -69 dbm! => much better! Did you move the laptop, or is this high value 
really reproducible?)

I'm afraid that my reception quality varies wildly. I don't know why, I'll try 
to configure a different channel on the AP the next time I do some testing.

 > > 3. what brand/type of AP do you have?
 > A davolink DV-201AMR its an embedded Linux device using the BCM6348 chipset,

hmm, a embedded linux? do you have a ssh/telnet access to the router? Maybe the
syslogs / dmesg gives us a "hint" why it won't connect.

I'm afraid its provisioned by my ISP , and I only have access to some crippled 
web interface, I really need to kick the ISP and ask them to give me the source 
and stuff, as they are oblidged under the GPL.

(BTW: does your router really only support the weak WEP encryptions?)
No it also supports 128 bit, but when first settings things up I had trouble 
getting that working. This has been working reasonably for me, so I didn't 
change it. The firmware can also do wpa, but the webinterface I'm stuck behind 
doesn't allow this (GRRRR).

 > k. Do you have another wifi card that can perform wifi sniffs? (just as an
 > option)

I can get my hands on a full mac prism pci card, but I'll first try your patches.

----

Replying to other mail in one go:

Chr wrote:
 > I made two patches:
 >
 > the p54-pull-padding.diff should finally fix the rate algorithm for 
"everyone" and as
 > a bonus for developers: it adds a printk for the firmware revision p54 is using.
 >

Cool I'll give this a try tonight, I really wanted to try it sooner, but ...

 > p54-remove-qos.diff (must be applied on top of p54-pull-padding.diff) is 
_only_ for
 > Hans...  It removes/reverts QoS/WME/WMM/IEEE802.11e features.
 >

Hmm, could this be made conditionally on the firmware revision perhaps? I don't 
like having to patch my kernel every update, and more importantly, my card is a 
pretty popular el cheapo sitecom, which are stacked by the dozen by every 
computershop in town, so it would be nice if this worked out of the box.

I'll try to see if 2.5.2.0 will work with my card, I think I've tried before 
but you never know, will 2.5.2.0 be good enough for the QoS/WME/WMM/IEEE802.11e 
features?

Maybe it would be an idea to dump the eeprom from the driver with the 2.4.12.0 
firmware, and then fake the eeprom in the driver using newer firmware to see if 
the eeprom reading is the only problem with newer firmware and my card ?

Thanks & Regards,

Hans


