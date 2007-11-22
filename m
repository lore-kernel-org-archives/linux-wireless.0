Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17416 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXKVILq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 03:11:46 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 09:12:10 +0100
Cc: bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711220912.10452.hs4233@mail.mn-solutions.de> (sfid-20071122_081201_818890_5F650412)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm on wireless-2.6, branch everything, git commit
7446b6c0e3b18fd2c5f9c406bb20841e6193d058

When I insert a b43 based card, I don't get associated
automatically. This happens:


$ # Insert the card
pccard: CardBus card inserted into slot 0
PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:03:00.0 to 64
ssb: SPROM revision 1 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
b43-phy0: Broadcom 4306 WLAN found
b43-phy0 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy0: Selected rate control algorithm 'simple'

$ ifconfig eth1 up
b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 30-bit DMA initialized
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2

$ iwconfig eth1 essid BLAHMUMPF
HW CONFIG: channel=1 freq=2412 phymode=2
HW CONFIG: channel=2 freq=2417 phymode=2
HW CONFIG: channel=3 freq=2422 phymode=2
HW CONFIG: channel=4 freq=2427 phymode=2
HW CONFIG: channel=5 freq=2432 phymode=2
HW CONFIG: channel=6 freq=2437 phymode=2
HW CONFIG: channel=7 freq=2442 phymode=2
HW CONFIG: channel=8 freq=2447 phymode=2
HW CONFIG: channel=9 freq=2452 phymode=2
HW CONFIG: channel=10 freq=2457 phymode=2
HW CONFIG: channel=11 freq=2462 phymode=2
HW CONFIG: channel=1 freq=2412 phymode=2

$ iwconfig eth1 key s:11111
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: ff:ff:ff:ff:ff:ff

$ iwconfig eth1
eth1      IEEE 802.11g  ESSID:"BLAHMUMPF"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:3131-3131-31
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

As you can see, I'm not associated. However, this sequence used
to work with non-mac80211 based WLAN drivers. However, I can actually
associate if I reverse the essid/key, e.g. first set the key, then
the ssid.


Note that the same happens if I let Debian manage the card. An excerpt
from my /etc/network/interfaces shows:

allow-hotplug eth1
iface eth1 inet static
        address 10.2.1.3
        netmask 255.255.255.0
        wireless-essid BLAHMUMPF
        wireless-key1 s:11111

(the test above has been made completely manually, without this entry)
