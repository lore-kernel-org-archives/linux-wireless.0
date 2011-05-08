Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:50732 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1EHSeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 14:34:23 -0400
Received: by pxi16 with SMTP id 16so3184186pxi.4
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 11:34:22 -0700 (PDT)
Message-ID: <4DC6E229.7060501@lwfinger.net> (sfid-20110508_203426_606809_DD9160C5)
Date: Sun, 08 May 2011 13:34:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYI=?= =?UTF-8?B?ZWNraQ==?=
	<zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/3] ssb/b43(legacy): clean dangling cores workarounds
References: <1304874564-6426-1-git-send-email-zajec5@gmail.com>	 <4DC6CD8C.6080104@lwfinger.net>	 <BANLkTimNHB0mzAnndDeT9CsLKMTSYvLNGw@mail.gmail.com> <1304874969.23124.22.camel@maggie>
In-Reply-To: <1304874969.23124.22.camel@maggie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2011 12:16 PM, Michael Büsch wrote:
> On Sun, 2011-05-08 at 19:11 +0200, Rafał Miłecki wrote:
>> Oh, do you have some device with 2 active cores? Nice :)
>
> I don't think there are any supported multicore devices anyway. Those
> are the very early A-PHY, only. AFAIK.

Yes, I have a Linksys WPC54G Cardbus device that uses b43legacy.

The 'dmesg | egrep "ssb|b43"' output for it is

b43-pci-bridge 0000:06:00.0: PCI INT A -> Link[LNK1] -> GSI 11 (level, low) -> 
IRQ 11
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x02, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x04, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x01, vendor 0x4243)
ssb: Core 3 found: V90 (cc 0x807, rev 0x01, vendor 0x4243)
ssb: Core 4 found: PCI (cc 0x804, rev 0x07, vendor 0x4243)
ssb: Core 5 found: IEEE 802.11 (cc 0x812, rev 0x04, vendor 0x4243)
ssb: Ignoring additional 802.11 core
ssb: chipcommon status is 0x0
ssb: SPROM offset is 0x1000
ssb: SPROM revision 1 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
b43legacy-phy0: Broadcom 4306 WLAN found
b43legacy-phy0 debug: Found PHY: Analog 1, Type 2, Revision 1
b43legacy-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43legacy-phy0 debug: Radio initialized
b43legacy-phy0: Loading firmware version 0x127, patch level 14 (2005-04-18 02:36:27)
b43legacy-phy0 debug: Chip initialized
b43legacy-phy0 debug: 30-bit DMA initialized
b43legacy-phy0 debug: Wireless interface started
b43legacy-phy0 debug: Adding Interface type 2

You can add a Tested-by: and an ACK to the patches.

Larry


