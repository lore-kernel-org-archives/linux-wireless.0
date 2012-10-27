Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50223 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2J0SNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2012 14:13:25 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so4147529vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2012 11:13:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50896EA9.2090607@hauke-m.de>
References: <1351183169-13392-1-git-send-email-hauke@hauke-m.de>
	<CACna6rwYraTcddRHUh-5a_cQ4QkLiUKrLO5FYvnMneTtWpYEwg@mail.gmail.com>
	<50896EA9.2090607@hauke-m.de>
Date: Sat, 27 Oct 2012 20:13:24 +0200
Message-ID: <CADGCtVSQEthQCkcqChs1FDfoCDrJh7UOj+y6z-N+PXQATr+mkw@mail.gmail.com> (sfid-20121027_201336_298507_F91479E3)
Subject: Re: [PATCH 1/2] ssb: add PCI ID 0x4350
From: Aitor Cuartango <aitor.cuartango@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you need more information about the device let me know.

With the last openwrt's trunk i can create a wifi network but only in b/g mode.

I've test editing manually /etc/config/wireless  and change :
        option hwmode '11g'
with
        option hwmode '11ng'

but it does not starts, perhaps i need to do more changes in this file...


Thanks all!
aitor


2012/10/25 Hauke Mehrtens <hauke@hauke-m.de>:
> On 10/25/2012 06:47 PM, Rafał Miłecki wrote:
>> 2012/10/25 Hauke Mehrtens <hauke@hauke-m.de>:
>>> 14e4:4350 is found on a Broadcom BCM43222.
>>
>> Huh, I expected BCM43222 to be BCMA based, interesting. Could you
>> provide ssb log for scanning (cores listing) and PHY&RADIO info?
>>
>
> It is not my device, but Aitor found it, here are the details:
> http://comments.gmane.org/gmane.comp.embedded.openwrt.user/2031
>
> Here is the log you requested, without the patches:
> ...
> b43-pci-bridge 0000:00:02.0: setting latency timer to 64
> ssb: Found chip with id 0xA8D6, rev 0x00 and package 0x08
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x1E, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x10, vendor 0x4243)
> ssb: Core 2 found: PCI (cc 0x804, rev 0x0E, vendor 0x4243)
> ssb: chipcommon status is 0x40040
> ssb: Found rev 2 PMU (capabilities 0x044C3002)
> ssb: ERROR: PLL init unknown for device A8D6
> ssb: ERROR: PMU resource config unknown for device A8D6
> ssb: SPROM offset is 0x1000
> ssb: SPROM revision 8 detected.
> b43-phy0: Broadcom 43222 WLAN found (core revision 16)
> ssb: Sonics Silicon Backplane found on PCI device 0000:00:02.0
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> ...
>
> Hauke
