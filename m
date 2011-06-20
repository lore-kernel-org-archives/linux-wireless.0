Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46620 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1FTV2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 17:28:22 -0400
Message-ID: <4DFFBB6D.4030607@hauke-m.de> (sfid-20110620_232833_440910_F04C156A)
Date: Mon, 20 Jun 2011 23:28:13 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Subject: Re: [RFC v2 00/12] bcma: add support for embedded devices like bcm4716
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de> <BANLkTim5R1ukc5OJQRRpF6EsmzeoL=SUoA@mail.gmail.com>
In-Reply-To: <BANLkTim5R1ukc5OJQRRpF6EsmzeoL=SUoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2011 02:41 AM, Rafał Miłecki wrote:
> Hey Hauke,
> 
> 2011/6/19 Hauke Mehrtens <hauke@hauke-m.de>:
>> This patch series adds support for embedded devices like bcm47xx to
>> bcma. Bcma is used on bcm4716 and bcm4718 SoCs. With these patches my
>> bcm4716 device boots up till it tries to access the flash, because the
>> serial flash chip is unsupported for now, this will be my next task.
>> This adds support for MIPS cores, interrupt configuration and the
>> serial console.
>>
>> These patches are based on ssb code, some patches by George Kashperko
>> and Bernhard Loos and parts of the source code release by ASUS and
>> Netgear for their devices.
>>
>> This was tested on a Netgear WNDR3400, but did not work fully because
>> of serial flash.
>>
>> This is bases on linux-next next-20110616, to which subsystem
>> maintainer should I send these patches later, as it is based on the
>> most recent version of bcma and bcm47xx?
>> I do not have any normal PCIe based wireless device using this bus, so
>> I have not tested it with such a device, it will be nice to hear if it
>> is still working on them.
>> The parallel flash should work so it could be that it will boot on an
>> Asus rt-n16, I have not tested that.
> 
> I'm glad you are still working on it!
> Unfortunately it's really late right now and I'm leaving tomorrow
> (well, today as we passed midnight) for the whole week :( I'm not sure
> if I'll get a chance to review this, not to mention testing against
> any of my PCIe card.

No problem have a look at it when you find some time for it. There are
still some todos and the serial flash chip is also on my list, so I will
not run out of stuff to do. ;-)

> 
>> An Ethernet driver is not included because the Braodcom source code
>> available is not licensed under a GPL compatible license and building a
>> new driver on that based is not possible.
> 
> I wonder if you could write specs for that core, so I could write
> GPL/any driver for it? Is that driver really big?
> 
Now I think this will be the fastest solution. Henry Ptasinski from
Broadcom wanted to make it possible for us to use the Braodcom driver
directly as a base, but talking to all the lawyers and managers at
Braodcom to make this possible takes a lot of time and is not promising.
After this and flash support is in the kernel I will work on the
Ethernet driver.

The driver is not really big so it will not take that long to write a
spec and implement it.

I published my git repo with the modifications integrated into OpenWrt:
https://github.com/hauke/openwrt/tree/bcma-list

Hauke
