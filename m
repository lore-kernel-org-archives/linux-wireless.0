Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56723 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab1FDNOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 09:14:45 -0400
Message-ID: <4DEA2FC1.2030104@gmail.com> (sfid-20110604_151454_067997_16A8F2E3)
Date: Sat, 04 Jun 2011 15:14:41 +0200
From: =?UTF-8?B?Tmljb2xhcyBkZSBQZXNsb8O8YW4=?=
	<nicolas.2p.debian@gmail.com>
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: iwlagn: Random "Time out reading EEPROM".
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

 From time to time, my Intel Wifi adapter fail on cold boot, with the following in dmesg:

[    7.442634] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[    7.442636] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    7.442701] iwlagn 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.442708] iwlagn 0000:05:00.0: setting latency timer to 64
[    7.442788] iwlagn 0000:05:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    7.455547] iwlagn 0000:05:00.0: Time out reading EEPROM[0]
[    7.455611] iwlagn 0000:05:00.0: Unable to init EEPROM
[    7.455678] iwlagn 0000:05:00.0: PCI INT A disabled
[    7.455685] iwlagn: probe of 0000:05:00.0 failed with error -110

After "modprobe -r iwlagn ; modprobe iwlagn" or after a reboot, everything work fine:

[  346.332166] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[  346.332169] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[  346.332225] iwlagn 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  346.332234] iwlagn 0000:05:00.0: setting latency timer to 64
[  346.332277] iwlagn 0000:05:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[  346.365739] iwlagn 0000:05:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  346.365787]   alloc irq_desc for 33 on node -1
[  346.365788]   alloc kstat_irqs on node -1
[  346.365804] iwlagn 0000:05:00.0: irq 33 for MSI/MSI-X
[  346.449989] phy0: Selected rate control algorithm 'iwl-agn-rs'

This happens using 2.6.32-5 from Debian. I didn't had the opportunity to reproduce it using recent 
kernel, but it occurs too rarely to conclude anything.

I had a look at the git log, without finding something that seems related to this problem. Does this 
ring a bell for someone?

	Nicolas.

05:00.0 Network controller: Intel Corporation WiFi Link 5100
         Subsystem: Intel Corporation WiFi Link 5100 AGN
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 33
         Region 0: Memory at d6d00000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [c8] Power Management version 3
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee0300c  Data: 41c9
         Capabilities: [e0] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
                         ClockPM+ Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- 
UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
         Capabilities: [140 v1] Device Serial Number 00-22-fb-ff-ff-28-46-c8
         Kernel driver in use: iwlagn

