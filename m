Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:7144 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXJULcc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 07:32:32 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org
Subject: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Sun, 21 Oct 2007 13:16:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710211316.06772.elendil@planet.nl> (sfid-20071021_123235_625638_8FAAA0DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just gave the new ath5k driver a go, but it fails for me with:
pccard: CardBus card inserted into slot 0
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
ath5k_pci 0000:02:00.0: can't get channels

I did a git fetch of wireless/everything branch:
$ git describe
v2.6.23-469-g4bcbd55

Modules were loaded automatically: mac80211 and ath5k.

I was hoping for a better result as [1] lists my PCI ID as "OK", but maybe
that is for the PCI version and not the PCMCIA one?
The card works well with the madwifi driver (see below).

The host system is a Toshiba Satellite A40 laptop (i386, Mobile Pentium 4)
running Debian unstable.

I can't help with coding, but am willing to test. Feel free ask for any
additional info you need. Please CC me as I'm not subscribed.

[1] http://linuxwireless.org/en/users/Drivers/ath5k

Cheers,
Frans Pop

>From lspci -nn:
01:0b.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support [1179:0617] (rev 33)
02:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5212 802.11abg NIC [168c:0013] (rev 01)

>From lspci -vv:
01:0b.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support (rev 33)
        Subsystem: Toshiba America Info Systems Unknown device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at cff00000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=01, secondary=02, subordinate=02, sec-latency=0
        Memory window 0: 28000000-2bfff000 (prefetchable)
        Memory window 1: 30000000-33fff000
        I/O window 0: 0000c000-0000c0ff
        I/O window 1: 0000c400-0000c4ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
        16-bit legacy interface ports at 0001

02:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
        Subsystem: Global Sun Technology Inc Unknown device 7103
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 30000000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>

Output of dmesg with 2.6.18 and madwifi driver:
pccard: CardBus card inserted into slot 0
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 169
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
wifi0: mac 5.9 phy 4.3 radio 4.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
wifi0: Atheros 5212: mem=0x2e000000, irq=169
ath0: no IPv6 routers present
