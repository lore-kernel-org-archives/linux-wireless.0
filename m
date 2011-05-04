Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:65274 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1EDP6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 11:58:11 -0400
Received: by pxi16 with SMTP id 16so1030185pxi.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 08:58:11 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 4 May 2011 17:58:10 +0200
Message-ID: <BANLkTikfM5Xs+RiXe3jb2zdn9SWMPz91zg@mail.gmail.com> (sfid-20110504_175819_288522_51CCD8D5)
Subject: Atheros AR5213A kernel freeze when bringing up interface, using ath5k
From: Gorilla Maguilla <gorilla.maguilla@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel freezes when bringing up and down the interface wlan1

Steps to reproduce:

ifconfig wlan1 up

ifconfig wlan1 down

ifconfig wlan0 up

----hard kernel freeze---

Sometimes takes 2 steps, sometimes takes 3 steps.

Using:

kernel 2.6.38.4 x86_64
madwifi 0.9.4.4136

dmesg output:
[   59.054323] pcmcia_socket pcmcia_socket0: pccard: CardBus card
inserted into slot 0
[   59.054379] pci 0000:05:00.0: [168c:0013] type 0 class 0x000200
[   59.054456] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x0000ffff]
[   59.054721] pci 0000:05:00.0: BAR 0: assigned [mem 0xe3400000-0xe340ffff]
[   59.054735] pci 0000:05:00.0: BAR 0: set to [mem
0xe3400000-0xe340ffff] (PCI address [0xe3400000-0xe340ffff])
[   59.085804] ath5k 0000:05:00.0: enabling device (0000 -> 0002)
[   59.085816] ath5k 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   59.085974] ath5k 0000:05:00.0: registered as 'phy1'
[   59.564355] ath: EEPROM regdomain: 0x60
[   59.564357] ath: EEPROM indicates we should expect a direct regpair map
[   59.564359] ath: Country alpha2 being used: 00
[   59.564360] ath: Regpair used: 0x60
[   59.564437] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[   59.564806] ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
[   59.564808] ath5k phy1: RF2112B 2GHz radio found (0x46)

lspci- v output:
05:00.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+ Wireless Network Adapter (rev 01)
    Subsystem: PROXIM Inc Device 0a40
    Flags: bus master, medium devsel, latency 168, IRQ 18
    Memory at e3400000 (32-bit, non-prefetchable) [size=64K]
    Capabilities: [44] Power Management version 2
    Kernel driver in use: ath5k
    Kernel modules: ath5k, ath_pci

Other People with same problem but different chipsets:

http://www.spinics.net/lists/linux-wireless/msg54555.html
https://bugs.archlinux.org/task/20735?project=0
