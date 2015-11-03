Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33002 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbbKCNll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 08:41:41 -0500
Received: by wmeg8 with SMTP id g8so84828331wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 05:41:40 -0800 (PST)
To: Alberto Mattea <alberto@mattea.info>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Ralink RT5592 5Ghz capability not working
Message-ID: <5638B98F.2080908@gmail.com> (sfid-20151103_144145_358913_B665DB3D)
Date: Tue, 3 Nov 2015 14:41:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alberto Mattea wrote:

> this is about the mini-pcie version used in some embedded products
> (for example the Buffalo WHR-600D and the Asus RP-N53).
> It has an RT5592 chip and the hardware supports both 2.4 and 5Ghz
> (5Ghz works with the proprietary driver supplied with the devices),
> but rt2800pci seems to see only the 2.4 Ghz capability.

As far as I know, RT5592 PCIe devices are unsupported by rt2800pci.

> dmesg:
> 
> [   14.070000] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5592, rev 0222 detected
> [   14.080000] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0001 detected
> [   14.100000] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [  134.420000] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2860.bin'
> [  134.460000] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.34

Here is the output of a real RT5592 PCIe device with rt2800pci driver(Feb 2013):

phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 5592, rf: 000f, rev: 0222.
phy1 -> rt2800_init_eeprom: Error - Invalid RT chipset 0x5592 detected.
phy1 -> rt2x00lib_probe_dev: Error - Failed to allocate device.

> The weird thing is that in lspci it is reported as an RT3091, due to the 0x3091 pci device id:
> 
> 01:00.0 Network controller [0280]: Ralink corp. RT3091 Wireless 802.11n 1T/2R PCIe [1814:3091]
>         Subsystem: Ralink corp. RT3091 Wireless 802.11n 1T/2R PCIe [1814:3091]
> [...]

06:00.0 Network controller [0280]: Ralink corp. Device [1814:5592]
        Subsystem: ASUSTeK Computer Inc. Device [1043:851a]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fe500000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Device Serial Number c1-a5-f3-ff-fe-a9-85-30

> So maybe due to this (i'm not sure), rt2800pci only enables the 2.4 Ghz band support:

Your device does not look like a real RT5592 chip.

> All this with kernel 3.18 (openwrt 15.05 Chaos Calmer).
> Any ideas?

OpenWrt brings _a lot of_ code out upstream kernel.
Who knows what is running.
