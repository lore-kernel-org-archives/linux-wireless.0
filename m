Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38318 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab2FYVhD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 17:37:03 -0400
Message-ID: <4FE8D9F7.7070707@hauke-m.de> (sfid-20120625_233708_296803_6BBA5A50)
Date: Mon, 25 Jun 2012 23:36:55 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net> <4FE88E1A.9050202@hauke-m.de> <1340654635.3413.19.camel@gnutoo-hplaptop> <4FE8C89E.8040607@hauke-m.de> <CACna6rxOrCYxonUEkDPFJ4c8CbGm1JEqghF1gBvnSyLCLJ0xDA@mail.gmail.com>
In-Reply-To: <CACna6rxOrCYxonUEkDPFJ4c8CbGm1JEqghF1gBvnSyLCLJ0xDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 11:25 PM, Rafał Miłecki wrote:
> 2012/6/25 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 06/25/2012 10:03 PM, Denis 'GNUtoo' Carikli wrote:
>>> On Mon, 2012-06-25 at 18:13 +0200, Hauke Mehrtens wrote:
>>>> Add support for more chips, including (near term) BCM43227, BCM43228,
>>>> and BCM4331. Support for additional new chips to follow.
>>> What about the BCM43231?
>>> There was some plans about it:
>>> http://lists.infradead.org/pipermail/b43-dev/2012-January/002297.html
>>>
>>> But the thread ends and then it seem that nothing was achieved.
>>>
>>> I've a BCM43231:
>>> Bus 001 Device 008: ID 0846:9020 NetGear, Inc. WNA3100(v1) Wireless-N
>>> 300 [Broadcom BCM43231]
>>>
>>> Are there some wireless kernels developers in Italy or in France that
>>> would accept a bcm43231 card in exchange of working on a driver?
>>>
>>> Denis.
>>
>> I just found a driver for "Dongle BUS interface for USB, SDIO, SPI,
>> etc." which seams to also support the BCM43231 licensed under a
>> permissive license in the GPL source tar of the ASUS RT-AC66U. [0] I
>> haven't found the firmware for that specific device, but someone could
>> try to get that driver running with a normal Linux kernel. I am also
>> interested in that as I have a USB device in my router not supported by
>> brcmfmac.
>> Currently I do not have time for that, but I will probably have a closer
>> look into that driver soon.
>>
>> Hauke
>>
>> [0] asuswrt/release/src-rt-6.x/shared/dbus*
> 
> I suspect 0846:9020 can be *not* a BCM43231. I discovered some other
> chipset on this USB dongle when hacking it with brcmfmac. If I
> remember correctly it was 4322. Sounds a little weird, as we already
> know softmac BCM4322 with N-PHY, I don't know if there is any relation
> between softmac 4322 and fullmac 4322.

I have two BCM4322 soldered on a board of a router (Linksys WRT610N V1)
and connected via PCI to the main Chip (BCM4705/BCM4785). My BCM4322 has
a ARM Cortex M3 core, a USB host core, a PCI and a PCIe core in addition
to the "normal cores". My BCM4322 is running as a softmac device and is
supported by b43 and ssb, 2.4 Ghz wifi is working.

This chip is probably capable of running in softmac mode on a PCI or
PCIe card or in fullmac mode in a USB dongle, at least that's my
explanation for the ARM core on this device.

Hauke
