Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:46497 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZGMWDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:03:33 -0400
Received: from pcfabio.home.lan (151.48.52.216) by cp-out11.libero.it (8.5.107)
        id 4A5A72EE00370128 for linux-wireless@vger.kernel.org; Mon, 13 Jul 2009 23:57:31 +0200
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: p54pci: problems during initialization
Date: Sat, 11 Jul 2009 20:06:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907112006.45731.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a PCMCIA card (3com 3CRWE154G72 v2) which has problems during the 
device initialization phase. I'm using the current wireless.git and the 
firmware included with the working Windows driver (extracted by fwextract).

Sometimes I'm able to get the card working but most of times it doesn't 
complete the initialization. When it works dmesg reports:

pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:03:00.0: reg 10 32bit mmio: [0x000000-0x001fff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
p54pci 0000:03:00.0: enabling device (0000 -> 0002)
p54pci 0000:03:00.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
p54pci 0000:03:00.0: setting latency timer to 64
p54pci 0000:03:00.0: firmware: requesting isl3886pci
phy11: p54 detected a LM86 firmware
phy11: FW rev 2.5.2.0 - Softmac protocol 3.0
phy11: you are using an obsolete firmware. visit 
http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 
2.6.28"!
phy11: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
phy11: hwaddr 00:0e:6a:xx:xx:xx, MAC:isl3890 RF:Frisbee
phy11: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy11::assoc
Registered led device: p54-phy11::tx
Registered led device: p54-phy11::rx
Registered led device: p54-phy11::radio
p54pci 0000:03:00.0: is registered as 'phy11'

When it doesn't work I read:

pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:03:00.0: reg 10 32bit mmio: [0x000000-0x001fff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
p54pci 0000:03:00.0: enabling device (0000 -> 0002)
p54pci 0000:03:00.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
p54pci 0000:03:00.0: setting latency timer to 64
p54pci 0000:03:00.0: firmware: requesting isl3886pci
phy10: p54 detected a LM86 firmware
phy10: FW rev 2.5.2.0 - Softmac protocol 3.0
phy10: you are using an obsolete firmware. visit 
http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 
2.6.28"!
phy10: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
phy10: device does not respond!
p54pci 0000:03:00.0: PCI INT A disabled
p54pci: probe of 0000:03:00.0 failed with error -16
pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0

It seems there is a problem inside the function p54_read_eeprom().

I have also tried with other firmwares available here
  http://daemonizer.de/prism54/prism54-fw/
with the following results:

2.3.2.0.arm - same behaviour
2.4.2.0.arm - same behaviour
2.4.6.0.arm - same behaviour
2.4.8.0.arm - same behaviour
2.4.11.0.arm - same behaviour
2.4.12.0.arm - same behaviour
2.5.2.0.arm - same behaviour
2.5.3.0.arm - same behaviour
2.5.6.0.arm - same behaviour
2.7.0.0.arm - same behaviour
2.12.0.0.arm - same behaviour
2.13.1.0.arm - same behaviour
2.13.8.0.arm - cannot boot firmware, probe error -110
2.13.12.0.arm - cannot boot firmware, probe error -110
2.17.2.0.arm - cannot boot firmware, probe error -110


Any clue?

Fabio
