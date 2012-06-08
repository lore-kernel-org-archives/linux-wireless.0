Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43135 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2FHRtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:49:55 -0400
Received: by gglu4 with SMTP id u4so1471297ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 10:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD22E59.5020302@broadcom.com>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-14-git-send-email-hauke@hauke-m.de> <4FCF2AF1.8020200@broadcom.com>
 <4FD0B062.1080606@hauke-m.de> <4FD1023D.4040604@broadcom.com>
 <CAOiHx==hhFUgMYiiUy_XZR9K=Ao76OjLu0MSkMopUDuVmOpvdw@mail.gmail.com> <4FD22E59.5020302@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Fri, 8 Jun 2012 19:49:33 +0200
Message-ID: <CAOiHx=nLd_KPWpUZ3LyZx7-_3oeMPG5KEvmSvU6jyB89E12g7A@mail.gmail.com> (sfid-20120608_194958_822712_B5CF0169)
Subject: Re: [PATCH 13/18] brcmsmac: add some workarounds for other chips again
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	brudley@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 June 2012 18:54, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/08/2012 01:31 PM, Jonas Gorski wrote:
>> 0x2057). I did not try brcmsmac, since it didn't even use bcma at that
>> time. It probably needs some more special handling, as there is an OTP
>> core present, and my gut feeling says the wifi driver needs/uses it,
>> but since I don't have sources for the proprietary driver I can't
>> really check this ;).
>
> brcmsmac had OTP code, but I added OTP processing to BCMA. It is daily
> tested on powerpc64 so that should work.

Maybe it isn't needed by the wifi, though it has a bit that says
whether wifi is available. The wifi driver itself seems to include an
sprom for bcm6362 though, so it's likely a red herring.

>> TL;DR: BCM6362 isn't real bcma, so it's unlikely the bcma code will
>> ever see it (unless the translation hacks get accepted ;). Feel free
>> to drop any BCM6362 handling here.
>>
>> @Arend: Which probably also means that brcm{s,f]mac will likely never
>> support it, right? :-/
>
> What silicon backplane does it have? Sonics? I tried to look it up, but
> did not find the info.

It's neither bcma nor ssb, but ubus, the bcm63xx silicon backplane.
You should find the appropriate ub_scan, ub_flag, etc functions in the
proprietary driver as the third backplane type supported by it. The
public parts only have them as empty functions, but still reference
them.

> Do you know the chip revision of your bcm6362?

IIRC b0 (haven't booted it in the last few weeks, currently busy with
bcm6328 stuff - one chip at a time ;). Since recent bcm63xx LDKs
removed the a0 register layouts it looks like the a0 revision never
actually made it into a product.


Jonas
