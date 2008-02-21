Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.246]:47155 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYBUMoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 07:44:17 -0500
Received: by hs-out-0708.google.com with SMTP id 54so2732193hsz.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 04:44:16 -0800 (PST)
Message-ID: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com> (sfid-20080221_124421_516032_F124240C)
Date: Thu, 21 Feb 2008 12:44:15 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: b43 (H/W 4306 Rev. 03)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per my talk with st3 #bcm-users I have decided you e-mail you with
the details of my problem. I have this card:

02:07.0 Network controller: Broadcom Corporation BCM4306 802.11b/g
Wireless LAN Controller (rev 03)

And whatever I do I can not get it to associate, I have tried with and
without encryption and below are two pastes of dmesg with and without
hwcrypto. I am not alone in this I have other people who have the same
problem and have to use this patch to get the card working on
b43legacy instead (http://url2cut.com?pwI)

no hwcrypto:
ACPI: PCI interrupt for device 0000:02:07.0 disabled
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC4] -> GSI 19 (level,
low) -> IRQ 19
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor 0x4243)
ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4243)
ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4243)
ssb: SPROM revision 1 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:02:07.0
b43-phy4: Broadcom 4306 WLAN found
b43-phy4 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy4 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy4: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
Broadcom 43xx driver loaded [ Features: PLID, Firmware-ID: FW10 ]
bonding: bond0: Adding slave wlan0.
b43-phy4: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy4 debug: Chip initialized
b43-phy4 debug: 30-bit DMA initialized
Registered led device: b43-phy4::tx
Registered led device: b43-phy4::rx
b43-phy4 debug: Wireless interface started
b43-phy4 debug: Adding Interface type 2
bonding: bond0: enslaving wlan0 as an active interface with a down link.
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authentication with AP 00:90:d0:f2:ad:7b timed out
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
b43-phy4: Radio turned off by software
b43-phy4 debug: Removing Interface type 2
b43-phy4 debug: Wireless interface stopped
b43-phy4 debug: DMA-30 0x0200 (RX) max used slots: 1/64
b43-phy4 debug: DMA-30 0x02A0 (TX) max used slots: 0/128
b43-phy4 debug: DMA-30 0x0280 (TX) max used slots: 0/128
b43-phy4 debug: DMA-30 0x0260 (TX) max used slots: 0/128
b43-phy4 debug: DMA-30 0x0240 (TX) max used slots: 0/128
b43-phy4 debug: DMA-30 0x0220 (TX) max used slots: 32/128
b43-phy4 debug: DMA-30 0x0200 (TX) max used slots: 0/128

with hwcrypto:
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [APC4] -> GSI 19 (level,
low) -> IRQ 19
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor 0x4243)
ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4243)
ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4243)
ssb: SPROM revision 1 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:02:07.0
b43-phy3: Broadcom 4306 WLAN found
b43-phy3 debug: Found PHY: Analog 2, Type 2, Revision 2
b43-phy3 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy3: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
bonding: bond0: Adding slave wlan0.
b43-phy3: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy3 debug: Chip initialized
b43-phy3 debug: 30-bit DMA initialized
Registered led device: b43-phy3::tx
Registered led device: b43-phy3::rx
b43-phy3 debug: Wireless interface started
b43-phy3 debug: Adding Interface type 2
bonding: bond0: enslaving wlan0 as an active interface with a down link.
b43-phy3 debug: Using hardware based encryption for keyidx: 0, mac:
ff:ff:ff:ff:ff:ff
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: authentication with AP 00:90:d0:f2:ad:7b timed out
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
b43-phy3: Radio turned off by software
b43-phy3 debug: Disabling hardware based encryption for keyidx: 0,
mac: ff:ff:ff:ff:ff:ff
b43-phy3 debug: Removing Interface type 2
b43-phy3 debug: Wireless interface stopped
b43-phy3 debug: DMA-30 0x0200 (RX) max used slots: 1/64
b43-phy3 debug: DMA-30 0x02A0 (TX) max used slots: 0/128
b43-phy3 debug: DMA-30 0x0280 (TX) max used slots: 0/128
b43-phy3 debug: DMA-30 0x0260 (TX) max used slots: 0/128
b43-phy3 debug: DMA-30 0x0240 (TX) max used slots: 0/128
b43-phy3 debug: DMA-30 0x0220 (TX) max used slots: 32/128
b43-phy3 debug: DMA-30 0x0200 (TX) max used slots: 0/128
