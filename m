Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27393 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYG3Hxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 03:53:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, rschneiderman@yahoo.com
Subject: Re: broadcom 4306 rev. 3 uses b43 instead of b43legacy
Date: Wed, 30 Jul 2008 09:53:33 +0200
References: <346184.16399.qm@web52404.mail.re2.yahoo.com>
In-Reply-To: <346184.16399.qm@web52404.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807300953.33588.hs4233@mail.mn-solutions.de> (sfid-20080730_095344_149992_22AD74C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Is this known bug? I can see my wireless network using wlist
> wlan0 scan.

This card (which seems to be a 4306 rev 3 like yours), works for me:

03:00.0 Network controller [0280]: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
        Subsystem: Melco Inc Unknown device [1154:0324]
        Flags: bus master, fast devsel, latency 64, IRQ 11
        Memory at 5c000000 (32-bit, non-prefetchable) [size=8K]

I'm currently associated via WPA2 to an AP.


Inserting the card:

pccard: CardBus card inserted into slot 0
b43-pci-bridge 0000:03:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:03:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
b43-phy0: Broadcom 4306 WLAN found
phy0: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]

Associating:

firmware: requesting b43/ucode5.fw
firmware: requesting b43/pcm5.fw
firmware: requesting b43/b0g0initvals5.fw
firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2417
phy0: HW CONFIG: freq=2422
phy0: HW CONFIG: freq=2427
phy0: HW CONFIG: freq=2432
phy0: HW CONFIG: freq=2437
phy0: HW CONFIG: freq=2442
phy0: HW CONFIG: freq=2447
phy0: HW CONFIG: freq=2452
phy0: HW CONFIG: freq=2457
phy0: HW CONFIG: freq=2462
phy0: HW CONFIG: freq=2412
phy0: HW CONFIG: freq=2437
phy0: HW CONFIG: freq=2437
eth1: authenticate with AP 00:13:19:80:da:30
eth1: authenticated
eth1: associate with AP 00:13:19:80:da:30
eth1: RX AssocResp from 00:13:19:80:da:30 (capab=0x11 status=0 aid=2)
eth1: associated
phy0: Allocated STA 00:13:19:80:da:30
phy0: Inserted STA 00:13:19:80:da:30
eth1: switched to short barker preamble (BSSID=00:13:19:80:da:30)
eth1: switched to long barker preamble (BSSID=00:13:19:80:da:30)



> How do I make it use the b43legacy

This is for a different card / firmware. Please refer to
http://wireless.kernel.org/en/users/Drivers/b43 for more
information. There's a section there "bcm43xx, b43legacy, b43,
softmac,... the full story". b43legacy won't solve your problem.


> I'm using opensuse 11 and have compiled the latest code and it
> is still not working. This worked BTW, in 10.2 and 10.3 with no
> problems and the card is currently working in vista (ugh).

Then it's a SuSE-Problem and you should ask your vendor.

However, you wrote "I compiled latest code" without specifing
what "latest" is. I'm using almost-latest-code (tm), e.g. I used
for my test wireless-testing, git describe
"v2.6.26-rc9-14207-ga520bdb".
