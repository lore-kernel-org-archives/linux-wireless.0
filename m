Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752242AbYCVKaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 06:30:02 -0400
From: Helge Deller <deller@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: ath5k aborts wireless connections
Date: Sat, 22 Mar 2008 11:29:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803221129.59090.deller@gmx.de> (sfid-20080322_103021_736336_B367382E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the ath5k driver was included in 2.6.25-rc* I've tried it several times, 
but the driver seems pretty unstable in keeping the wireless connection to my router.

Machine is a HP NC6000 Laptop with built-in AR5212 wifi card. 
lspci reports:
2:04.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
        Subsystem: Compaq Computer Corporation Unknown device 00e5
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at 90080000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>

After modprobing ath5k, dmesg reports with 2.6.25-rc6:

ACPI: PCI Interrupt Link [C0C6] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [C0C6] -> GSI 11 (level, low) -> IRQ 11
ath5k_pci 0000:02:04.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213 chip found (MAC: 0x56, PHY: 0x41)
ath5k phy0: RF5111 5GHz radio found (0x17)
ath5k phy0: RF2111 2GHz radio found (0x23)
udev: renamed network interface wlan0 to wlan1
wlan1: Initial auth_alg=0
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x471 status=0 aid=1)
wlan1: associated

Everything is OK and I'm connected. 00:50:18:3b:2b:04 is my router.

Around 2-5 minutes later the driver suddenly disconnects and syslog reports the following messages.
Since then, ath5k will not reconnect any longer to the router.

wlan1: invalid Michael MIC in data frame from 00:15:0c:e1:c0:96
wlan1: invalid Michael MIC in data frame from 00:15:0c:e1:c0:96
wlan1: RX disassociation from 00:50:18:3b:2b:04 (reason=1)
wlan1: disassociated
wlan1: deauthenticate(reason=14)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX deauthentication from 00:50:18:3b:2b:04 (reason=9)
wlan1: deauthenticated
wlan1: RX protected frame, but have no key
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: association with AP 00:50:18:3b:2b:04 timed out
wlan1: Initial auth_alg=0
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: association with AP 00:50:18:3b:2b:04 timed out
wlan1: Initial auth_alg=0
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: association with AP 00:50:18:3b:2b:04 timed out
wlan1: RX protected frame, but have no key
wlan1: Initial auth_alg=0
wlan1: authenticate with AP 00:50:18:3b:2b:04
wlan1: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan1: authenticated
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: associate with AP 00:50:18:3b:2b:04
wlan1: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x451 status=1 aid=1)
wlan1: AP denied association (code=1)
wlan1: association with AP 00:50:18:3b:2b:04 timed out


On the other side, with a Prism54 wifi cardbus card everything works 100% reliable with the same kernel:

PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [C0C3] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:03:00.0 to 64
p54: LM86 firmware
p54: FW rev 2.7.0.0 - Softmac protocol 4.1
phy0: Selected rate control algorithm 'simple'
phy0: hwaddr 00:04:e2:b3:7e:91, isl3890
Loaded prism54 driver, version 1.2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:50:18:3b:2b:04
wlan0: RX authentication from 00:50:18:3b:2b:04 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:50:18:3b:2b:04
wlan0: RX AssocResp from 00:50:18:3b:2b:04 (capab=0x471 status=0 aid=1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:50:18:3b:2b:04)

Any ideas ?

Helge
