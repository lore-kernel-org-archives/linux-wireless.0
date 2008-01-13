Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:43427 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbYAMUSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 15:18:24 -0500
Message-ID: <478A707C.3000102@scherping.de> (sfid-20080113_201833_595325_C0F4AC2E)
Date: Sun, 13 Jan 2008 21:11:40 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Romano Giannetti <romanol@upcomillas.es>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing ath5k driver
References: <1200049360.12702.14.camel@rukbat> <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com>
In-Reply-To: <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis schrieb:
> It's a known bug in nic_wakeup, i've fixed it but patch is pending due
> to testing. Problem is that even with that fix RF2425 doesn't tx/rx,
> we are currently working with users to fix 2413/2414 support (radio
> revision 0x56) so it'll take a while (tests etc) before we make this
> work.

Nice to hear that you are working on the "no tx/rx" problem. I am working with several Atheros-based Cardbus NICs for WLAN testing and development at university and unfortunately the card we have chosen to buy a bunch of is affected by this problem.
If I can be of any help in fixing the problem, please mail me! I did not digg into the at5k source code up to now, but I did modify madwifi a lot, so might be able to help investigating the problem.

My setup:

syslog
~~~~~~
Jan 11 11:42:52 merom kernel: pccard: CardBus card inserted into slot 0
Jan 11 11:42:52 merom kernel: PCI: Enabling device 0000:16:00.0 (0000 -> 0002)
Jan 11 11:42:52 merom kernel: ACPI: PCI Interrupt 0000:16:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Jan 11 11:42:52 merom kernel: ath5k_pci 0000:16:00.0: registered as 'phy1'
Jan 11 11:42:52 merom kernel: phy1: Selected rate control algorithm 'simple'
Jan 11 11:42:52 merom kernel: ath5k phy1: Atheros AR5213A chip found (MAC: 0x79, PHY: 0x45)
Jan 11 11:42:52 merom kernel: ath5k phy1: RF2112A 2GHz radio found (0x56)

lspci -n
~~~~~~~~
16:00.0 0200: 168c:0013 (rev 01)

lspci -vvv
~~~~~~~~~~
16:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
	Subsystem: D-Link System Inc D-Link AirPlus DWL-G650 Wireless Cardbus Adapter(rev.C)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c4000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

I am trying the compat-wireless-2.6 build every time something in ath5k seems to have changed, but no solution to the rx/tx problem with this card up to now :-(

The interesting thing is that at http://linuxwireless.org/en/users/Drivers/ath5k 168c:0013 is said to work OK, which it does NOT in my case.

Thank you very much for your work!

Richard

PS: Can you recommend a Dual-Band Atheros Cardbus card (abg) that is known to work fine with ath5k?
