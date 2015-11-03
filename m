Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vsmtp14.tin.it ([212.216.176.118]:58197 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbKCLwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 06:52:03 -0500
From: Alberto Mattea <alberto@mattea.info>
To: Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Ralink RT5592 5Ghz capability not working
Date: Tue, 03 Nov 2015 12:51:56 +0100
Message-ID: <2434011.UmOuFgqSqA@alby> (sfid-20151103_125209_746562_43F49A12)
In-Reply-To: <CAAnMG+OrVa8VBQjAeaNDSo42e+KeYr2AidnCT2z2Hf69ZLgoVQ@mail.gmail.com>
References: <1536816.BKcYzaDQTT@alby> <CAAnMG+OrVa8VBQjAeaNDSo42e+KeYr2AidnCT2z2Hf69ZLgoVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, thanks for your answer. I'm completely sure the hardware supports 5Ghz: 
with the proprietary ralink driver it works. As you can see from the dmesg, 
the board actually has a RT5592, not a RT3091. So I think the board has only 
the pci device id of the RT3091, and that is confusing the rt2800pci driver, 
making it assume it is a 2.4GHz device.

What do you think? Thanks

In data lun 2 novembre 2015 21:51:32, Alexis Green ha scritto:
> Looks like this device is BGN only (at least it is detected as such by
> lspci) - https://wikidevi.com/wiki/Ralink_RT3091_Reference_Design. You'll
> probably want something like this instead -
> http://www.amazon.com/HP-RALINK-RT3592-Wireless-BlueTooth/dp/B00AARTZ40
> 
> On Mon, Nov 2, 2015 at 1:39 PM, Alberto Mattea <alberto@mattea.info> wrote:
> > Hello,
> > this is about the mini-pcie version used in some embedded products (for
> > example the Buffalo WHR-600D and the Asus RP-N53).
> > It has an RT5592 chip and the hardware supports both 2.4 and 5Ghz (5Ghz
> > works with the proprietary driver supplied with the devices), but
> > rt2800pci
> > seems to see only the 2.4 Ghz capability.
> > 
> > dmesg:
> > 
> > [   14.070000] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5592, rev
> > 0222 detected
> > [   14.080000] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0001
> > detected
> > [   14.100000] ieee80211 phy0: Selected rate control algorithm
> > 'minstrel_ht'
> > [  134.420000] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading
> > firmware file 'rt2860.bin'
> > [  134.460000] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware
> > detected - version: 0.34
> > 
> > The weird thing is that in lspci it is reported as an RT3091, due to the
> > 0x3091 pci device id:
> > 
> > 01:00.0 Network controller [0280]: Ralink corp. RT3091 Wireless 802.11n
> > 1T/2R PCIe [1814:3091]
> > 
> >         Subsystem: Ralink corp. RT3091 Wireless 802.11n 1T/2R PCIe
> > 
> > [1814:3091]
> > 
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > 
> > ParErr- Stepping- SERR- FastB2B- DisINTx-
> > 
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > 
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> >         Latency: 0, Cache Line Size: 80 bytes
> >         Interrupt: pin A routed to IRQ 4
> >         Region 0: Memory at 20000000 (32-bit, non-prefetchable) [size=64K]
> >         Region 1: Memory at <unassigned> (32-bit, non-prefetchable)
> > 
> > [size=2]
> > 
> >         Region 2: Memory at <unassigned> (32-bit, non-prefetchable)
> > 
> > [size=2]
> > 
> >         Region 3: Memory at <unassigned> (32-bit, non-prefetchable)
> > 
> > [size=2]
> > 
> >         Region 4: Memory at <unassigned> (32-bit, non-prefetchable)
> > 
> > [size=2]
> > 
> >         Region 5: Memory at <unassigned> (32-bit, non-prefetchable)
> > 
> > [size=2]
> > 
> >         Expansion ROM at <unassigned> [disabled] [size=2]
> >         Capabilities: [40] Power Management version 3
> >         
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> > 
> > PME(D0+,D1-,D2-,D3hot+,D3cold-)
> > 
> >                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
> >         
> >         Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
> >         
> >                 Address: 0000000000000000  Data: 0000
> >         
> >         Capabilities: [70] Express (v2) Endpoint, MSI 00
> >         
> >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> > 
> > unlimited, L1 unlimited
> > 
> >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> >                 
> >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> > 
> > Unsupported-
> > 
> >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
> >                 
> >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > 
> > TransPend-
> > 
> >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> > 
> > Exit Latency L0s <512ns, L1 <64us
> > 
> >                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
> >                 
> >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> >                 
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 
> >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > 
> > DLActive- BWMgmt- ABWMgmt-
> > 
> >                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+,
> > 
> > LTR-, OBFF Not Supported
> > 
> >                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > 
> > LTR-, OBFF Disabled
> > 
> >                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> > 
> > SpeedDis-
> > 
> >                          Transmit Margin: Normal Operating Range,
> > 
> > EnterModifiedCompliance- ComplianceSOS-
> > 
> >                          Compliance De-emphasis: -6dB
> >                 
> >                 LnkSta2: Current De-emphasis Level: -6dB,
> > 
> > EqualizationComplete-, EqualizationPhase1-
> > 
> >                          EqualizationPhase2-, EqualizationPhase3-,
> > 
> > LinkEqualizationRequest-
> > 
> >         Capabilities: [100 v1] Advanced Error Reporting
> >         
> >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > 
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 
> >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > 
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 
> >                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > 
> > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > 
> >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > 
> > NonFatalErr-
> > 
> >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > 
> > NonFatalErr+
> > 
> >                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> > 
> > ChkEn-
> > 
> >         Capabilities: [140 v1] Device Serial Number
> >         08-68-35-ff-fe-60-a8-86
> >         Kernel driver in use: rt2800pci
> > 
> > So maybe due to this (i'm not sure), rt2800pci only enables the 2.4 Ghz
> > band support:
> > 
> > # iw phy0 info
> > Wiphy phy0
> > 
> >         max # scan SSIDs: 4
> >         max scan IEs length: 2257 bytes
> >         Retry short limit: 7
> >         Retry long limit: 4
> >         Coverage class: 0 (up to 0m)
> >         Available Antennas: TX 0 RX 0
> >         
> >         Supported interface modes:
> >                  * IBSS
> >                  * managed
> >                  * AP
> >                  * AP/VLAN
> >                  * WDS
> >                  * monitor
> >                  * mesh point
> >         
> >         Band 1:
> >                 Capabilities: 0x272
> >                 
> >                         HT20/HT40
> >                         Static SM Power Save
> >                         RX Greenfield
> >                         RX HT20 SGI
> >                         RX HT40 SGI
> >                         RX STBC 2-streams
> >                         Max AMSDU length: 3839 bytes
> >                         No DSSS/CCK HT40
> >                 
> >                 Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
> >                 Minimum RX AMPDU time spacing: 2 usec (0x04)
> >                 HT RX MCS rate indexes supported: 0-15, 32
> >                 TX unequal modulation not supported
> >                 HT TX Max spatial streams: 1
> >                 HT TX MCS rate indexes supported may differ
> >                 
> >                 Frequencies:
> >                         * 2412 MHz [1] (20.0 dBm)
> >                         * 2417 MHz [2] (20.0 dBm)
> >                         * 2422 MHz [3] (20.0 dBm)
> >                         * 2427 MHz [4] (20.0 dBm)
> >                         * 2432 MHz [5] (20.0 dBm)
> >                         * 2437 MHz [6] (20.0 dBm)
> >                         * 2442 MHz [7] (20.0 dBm)
> >                         * 2447 MHz [8] (20.0 dBm)
> >                         * 2452 MHz [9] (20.0 dBm)
> >                         * 2457 MHz [10] (20.0 dBm)
> >                         * 2462 MHz [11] (20.0 dBm)
> >                         * 2467 MHz [12] (20.0 dBm)
> >                         * 2472 MHz [13] (20.0 dBm)
> >                         * 2484 MHz [14] (disabled)
> >         
> >         valid interface combinations:
> >                  * #{ managed, AP, mesh point } <= 8,
> >                  
> >                    total <= 8, #channels <= 1
> >         
> >         HT Capability overrides:
> >                  * MCS: ff ff ff ff ff ff ff ff ff ff
> >                  * maximum A-MSDU length
> >                  * supported channel width
> >                  * short GI for 40 MHz
> >                  * max A-MPDU length exponent
> >                  * min MPDU start spacing
> > 
> > All this with kernel 3.18 (openwrt 15.05 Chaos Calmer).
> > Any ideas?
> > 
> > Thanks
> > 
> > Alberto Mattea
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

