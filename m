Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55572 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2FHLcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 07:32:15 -0400
Received: by ghrr11 with SMTP id r11so1130963ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 04:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD1023D.4040604@broadcom.com>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-14-git-send-email-hauke@hauke-m.de> <4FCF2AF1.8020200@broadcom.com>
 <4FD0B062.1080606@hauke-m.de> <4FD1023D.4040604@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Fri, 8 Jun 2012 13:31:53 +0200
Message-ID: <CAOiHx==hhFUgMYiiUy_XZR9K=Ao76OjLu0MSkMopUDuVmOpvdw@mail.gmail.com> (sfid-20120608_133220_422652_6A4C60C3)
Subject: Re: [PATCH 13/18] brcmsmac: add some workarounds for other chips again
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	brudley@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 June 2012 21:34, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/07/2012 03:45 PM, Hauke Mehrtens wrote:
>> On 06/06/2012 12:03 PM, Arend van Spriel wrote:
>>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>>> This adds some workarounds for the BCM4716, BCM47162, BCM43421, BCM5357
>>>> and BCM6362 to the phy code again. This patch reverts the following
>>>
>>> Has brcmsmac been tested for all these chips? At this moment I do not
>>> have any bandwidth to do that. I am not too comfortable adding this code
>>> without having some testing coverage. It was the reason to remove the
>>> snippets from brcmsmac.
>> I have just tested BCM4716 and BCM5357, BCM5357 is not working. ;-)
>> I do not have all the devices to test this and for the BCM6362 some
>> infrastructure code is still missing.
>> The adding of the BCM5357 is part of my start adding support for that
>> chip, which is not complete. As the device detection code in brcmsmac
>> is not changed in this commit, no more devices are detected by brcmsmac
>> now. I talked to Jonas Gorski about the BCM6362 and he thinks about
>> adding support for that device to the Linux kernel in some time.
>
> Yes. Jonas tested brcmsmac on bcm6362 host during our mainlining days.

Wait, no, I didn't. It was bcm6328 with an external pcie connected
bcm4313, so not really anything special there.

BCM6362 (and BCM63168) is a totally different beast; its wifi is
integrated into the SoC connected through its internal UBUS. It has an
hardwired erom which is almost parsable through the bcma erom parsing
routines, but it lacks the AMBA extended registers present in real
bcma devices, and all cores are controlled through the wlan shim core.
Also it is completely big endian (as bcm63xx is big endian).

I hacked bcma to properly parse the erom and translate the amba
register accesses to the appropriate wlan shim registers (which was
rather easy, since the register layout is very similar, and there are
only three amba registers actually used), which made bcma successfully
detect three cores (chipcommon, ieee80211 and wlan shim). I "tested"
it with b43, but it supports neither the core rev nor the radio (iirc
0x2057). I did not try brcmsmac, since it didn't even use bcma at that
time. It probably needs some more special handling, as there is an OTP
core present, and my gut feeling says the wifi driver needs/uses it,
but since I don't have sources for the proprietary driver I can't
really check this ;).

TL;DR: BCM6362 isn't real bcma, so it's unlikely the bcma code will
ever see it (unless the translation hacks get accepted ;). Feel free
to drop any BCM6362 handling here.

@Arend: Which probably also means that brcm{s,f]mac will likely never
support it, right? :-/


Jonas
