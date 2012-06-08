Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3810 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab2FHQzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 12:55:03 -0400
Message-ID: <4FD22E59.5020302@broadcom.com> (sfid-20120608_185508_124209_F7CD3879)
Date: Fri, 8 Jun 2012 18:54:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>, linville@tuxdriver.com,
	brudley@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/18] brcmsmac: add some workarounds for other
 chips again
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-14-git-send-email-hauke@hauke-m.de>
 <4FCF2AF1.8020200@broadcom.com> <4FD0B062.1080606@hauke-m.de>
 <4FD1023D.4040604@broadcom.com>
 <CAOiHx==hhFUgMYiiUy_XZR9K=Ao76OjLu0MSkMopUDuVmOpvdw@mail.gmail.com>
In-Reply-To: <CAOiHx==hhFUgMYiiUy_XZR9K=Ao76OjLu0MSkMopUDuVmOpvdw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2012 01:31 PM, Jonas Gorski wrote:
> On 7 June 2012 21:34, Arend van Spriel <arend@broadcom.com> wrote:
>> On 06/07/2012 03:45 PM, Hauke Mehrtens wrote:
>>> On 06/06/2012 12:03 PM, Arend van Spriel wrote:
>>>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>>>> This adds some workarounds for the BCM4716, BCM47162, BCM43421, BCM5357
>>>>> and BCM6362 to the phy code again. This patch reverts the following
>>>>
>>>> Has brcmsmac been tested for all these chips? At this moment I do not
>>>> have any bandwidth to do that. I am not too comfortable adding this code
>>>> without having some testing coverage. It was the reason to remove the
>>>> snippets from brcmsmac.
>>> I have just tested BCM4716 and BCM5357, BCM5357 is not working. ;-)
>>> I do not have all the devices to test this and for the BCM6362 some
>>> infrastructure code is still missing.
>>> The adding of the BCM5357 is part of my start adding support for that
>>> chip, which is not complete. As the device detection code in brcmsmac
>>> is not changed in this commit, no more devices are detected by brcmsmac
>>> now. I talked to Jonas Gorski about the BCM6362 and he thinks about
>>> adding support for that device to the Linux kernel in some time.
>>
>> Yes. Jonas tested brcmsmac on bcm6362 host during our mainlining days.
> 
> Wait, no, I didn't. It was bcm6328 with an external pcie connected
> bcm4313, so not really anything special there.

Yes. I know it was with external card connected through PCIe. Did not
recall exactly which BCM63xx you used for big-endian mips test.

> 0x2057). I did not try brcmsmac, since it didn't even use bcma at that
> time. It probably needs some more special handling, as there is an OTP
> core present, and my gut feeling says the wifi driver needs/uses it,
> but since I don't have sources for the proprietary driver I can't
> really check this ;).

brcmsmac had OTP code, but I added OTP processing to BCMA. It is daily
tested on powerpc64 so that should work.

> TL;DR: BCM6362 isn't real bcma, so it's unlikely the bcma code will
> ever see it (unless the translation hacks get accepted ;). Feel free
> to drop any BCM6362 handling here.
> 
> @Arend: Which probably also means that brcm{s,f]mac will likely never
> support it, right? :-/

What silicon backplane does it have? Sonics? I tried to look it up, but
did not find the info.

Do you know the chip revision of your bcm6362?

Gr. AvS

