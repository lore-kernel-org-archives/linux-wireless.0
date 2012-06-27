Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2121 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab2F0HuC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 03:50:02 -0400
Message-ID: <4FEABB1B.90005@broadcom.com> (sfid-20120627_095018_584877_19C957C6)
Date: Wed, 27 Jun 2012 09:49:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in
 MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net>
 <4FE88E1A.9050202@hauke-m.de>
 <1340654635.3413.19.camel@gnutoo-hplaptop>
 <4FE8C89E.8040607@hauke-m.de>
 <CACna6rxOrCYxonUEkDPFJ4c8CbGm1JEqghF1gBvnSyLCLJ0xDA@mail.gmail.com>
 <4FE8D9F7.7070707@hauke-m.de>
In-Reply-To: <4FE8D9F7.7070707@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 11:36 PM, Hauke Mehrtens wrote:
>> I suspect 0846:9020 can be *not* a BCM43231. I discovered some other
>> > chipset on this USB dongle when hacking it with brcmfmac. If I
>> > remember correctly it was 4322. Sounds a little weird, as we already
>> > know softmac BCM4322 with N-PHY, I don't know if there is any relation
>> > between softmac 4322 and fullmac 4322.

The BCM43231 dongle is indeed bcm4322. Not sure whether the chip
revisions are different.

> I have two BCM4322 soldered on a board of a router (Linksys WRT610N V1)
> and connected via PCI to the main Chip (BCM4705/BCM4785). My BCM4322 has
> a ARM Cortex M3 core, a USB host core, a PCI and a PCIe core in addition
> to the "normal cores". My BCM4322 is running as a softmac device and is
> supported by b43 and ssb, 2.4 Ghz wifi is working.
> 
> This chip is probably capable of running in softmac mode on a PCI or
> PCIe card or in fullmac mode in a USB dongle, at least that's my
> explanation for the ARM core on this device.

The chip has some redundant cores. Which these are indeed depends on the
type of host interface used. It is a trade-off between this and spin a
separate chip.

However, in case of USB it is not a fullmac driver model and not in
softmac driver model either. It has a different functional split of mac
functionality between host and firmware. This is also true for the
bcm43236 v2. Also this model has been abandoned for new devices.

This would need a cfg80211 driver duplicating mac80211 functionality or
wish the mac80211 offload features match the functional split nicely.
Internally we have looked at the mac80211 offloads and concluded it was
not. Hence we decided to only support softmac and fullmac driver models.

Gr. AvS


