Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vsmtp3.tin.it ([212.216.176.223]:45613 "EHLO vsmtp3.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917AbbKCVtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 16:49:35 -0500
From: Alberto Mattea <alberto@mattea.info>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Ralink RT5592 5Ghz capability not working
Date: Tue, 03 Nov 2015 22:49:31 +0100
Message-ID: <1559976.kyZSdnd2p4@alby> (sfid-20151103_224938_286642_E7AE15E8)
In-Reply-To: <5025703.zW4b3xGolO@alby>
References: <5638B98F.2080908@gmail.com> <5639281F.3040502@gmail.com> <5025703.zW4b3xGolO@alby>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In data mar 3 novembre 2015 22:44:00, Alberto Mattea ha scritto:
> Hey,
> 
> I didn't have to, it was recognized this way out of the box.
> I had to install an eeprom for the other onboard chip though (5390).
Oh and I just found this in lsmod: 

eeprom_93cx6            1616  1 rt2800pci

So it seems it's getting the eeprom by itself

> 
> In data mar 3 novembre 2015 22:33:19, Gertjan van Wingerde ha scritto:
> > Did you have to install an eeprom file for the RT5592 PCI device?
> > 
> > If yes, this eeprom file could be the problem. As far as I can tell the
> > rt2x00 driver only enables the 2.4 GHz band because it determines that
> > the RF chip doesn't support the 5GHz band. The RF chip is determined
> > from the EEPROM, and is currently read as an RF2820 chip (the message
> > rt2x00_set_rf: Info - RF chipset 0001 detected)
> > 
> > ---
> > Gertjan.
> > 
> > On 11/03/15 22:07, Alberto Mattea wrote:
> > > I found the FCC photos for the RP-N53:
> > > https://apps.fcc.gov/eas/GetApplicationAttachment.html?id=2001985
> > > 
> > > On page 9 there is a photo of the ralink chip, unfortunately very
> > > blurred.
> > > But I also found the photos for the Buffalo WHR-600D (which exhibits the
> > > same behaviour):
> > > https://apps.fcc.gov/eas/GetApplicationAttachment.html?id=1950610
> > > Here (page 12) we can clearly read "RT5692N", and if we look closer
> > > that's
> > > the same number you can see on the RP-N53. That's a model I cannot find
> > > anywhere. So it seems some kind of OEM specific chip.
> > > 
> > > In data mar 3 novembre 2015 11:31:42, hai scritto:
> > >> All signs point to RT5592 not supported by rt2x00 driver... I'm
> > >> guessing they fudged pci id for some internal reasons (maybe even to
> > >> mess with OpenWRT people).
> > >> 
> > >> On Tue, Nov 3, 2015 at 11:09 AM, Alberto Mattea <alberto@mattea.info>
> 
> wrote:
> > >>> My device (the RP-N53) has 2 chips too: the other is integrated in the
> > >>> mt7620 soc and reports itself as
> > >>> 
> > >>> [   14.120000] ieee80211 phy1: rt2x00lib_request_eeprom_file: Info -
> > >>> Loading EEPROM data from 'soc_wmac.eeprom'. [   14.140000] ieee80211
> > >>> phy1: rt2x00_set_rt: Info - RT chipset 5390, rev 0500 detected [
> > >>> 14.150000] ieee80211 phy1: rt2x00_set_rf: Info - RF chipset 7620
> > >>> detected
> > >>> [   14.170000] ieee80211 phy1: Selected rate control algorithm
> > >>> 'minstrel_ht'
> > >>> 
> > >>> it is used for 2.4Ghz only (https://wikidevi.com/wiki/ASUS_RP-N53)
> > >>> Unfortunately opening the RP-N53 appears impossible without voiding
> > >>> the
> > >>> warranty :(>
> > >>> 
> > >>> In data mar 3 novembre 2015 10:32:29, hai scritto:
> > >>>> This is so strange. Asus RT-N56U you mentioned earlier as one of the
> > >>>> examples actually has two separate chips for each band (and one of
> > >>>> them is RT3091) - https://wikidevi.com/wiki/ASUS_RT-N56U
> > >>>> Are you able to take a picture of the chip?
> > >>>> 
> > >>>> On Tue, Nov 3, 2015 at 10:10 AM, Alberto Mattea <alberto@mattea.info>
> > > 
> > > wrote:
> > >>>>> Hey, thanks for your answer. The device definitely isn't a RT3091,
> > >>>>> so
> > >>>>> do
> > >>>>> you think it's some sort of an OEM hybrid? Do you think it would be
> > >>>>> better to report this to the openwrt bugzilla?
> > >>>>> 
> > >>>>> Thanks
> > >>>>> 
> > >>>>> In data mar 3 novembre 2015 14:41:35, Xose Vazquez Perez ha scritto:
> > >>>>>> Alberto Mattea wrote:
> > >>>>>>> this is about the mini-pcie version used in some embedded products
> > >>>>>>> (for example the Buffalo WHR-600D and the Asus RP-N53).
> > >>>>>>> It has an RT5592 chip and the hardware supports both 2.4 and 5Ghz
> > >>>>>>> (5Ghz works with the proprietary driver supplied with the
> > >>>>>>> devices),
> > >>>>>>> but rt2800pci seems to see only the 2.4 Ghz capability.
> > >>>>>> 
> > >>>>>> As far as I know, RT5592 PCIe devices are unsupported by rt2800pci.
> > >>>>>> 
> > >>>>>>> dmesg:
> > >>>>>>> 
> > >>>>>>> [   14.070000] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset
> > >>>>>>> 5592,
> > >>>>>>> rev
> > >>>>>>> 0222 detected [   14.080000] ieee80211 phy0: rt2x00_set_rf: Info -
> > >>>>>>> RF
> > >>>>>>> chipset 0001 detected [   14.100000] ieee80211 phy0: Selected rate
> > >>>>>>> control algorithm 'minstrel_ht' [  134.420000] ieee80211 phy0:
> > >>>>>>> rt2x00lib_request_firmware: Info - Loading firmware file
> > >>>>>>> 'rt2860.bin' [
> > >>>>>>> 134.460000] ieee80211 phy0: rt2x00lib_request_firmware: Info -
> > >>>>>>> Firmware
> > >>>>>>> detected - version: 0.34
> > >>>>>> 
> > >>>>>> Here is the output of a real RT5592 PCIe device with rt2800pci
> > >>>>>> driver(Feb
> > >>>>>> 2013):
> > >>>>>> 
> > >>>>>> phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 5592, rf:
> > >>>>>> 000f,
> > >>>>>> rev:
> > >>>>>> 0222. phy1 -> rt2800_init_eeprom: Error - Invalid RT chipset 0x5592
> > >>>>>> detected. phy1 -> rt2x00lib_probe_dev: Error - Failed to allocate
> > >>>>>> device.
> > >>>>>> 
> > >>>>>>> The weird thing is that in lspci it is reported as an RT3091, due
> > >>>>>>> to
> > >>>>>>> the
> > >>>>>>> 0x3091 pci device id:
> > >>>>>>> 
> > >>>>>>> 01:00.0 Network controller [0280]: Ralink corp. RT3091 Wireless
> > >>>>>>> 802.11n
> > >>>>>>> 1T/2R PCIe [1814:3091]>
> > >>>>>>> 
> > >>>>>>>         Subsystem: Ralink corp. RT3091 Wireless 802.11n 1T/2R PCIe
> > >>>>>>>         [1814:3091]
> > >>>>>>> 
> > >>>>>>> [...]
> > >>>>>> 
> > >>>>>> 06:00.0 Network controller [0280]: Ralink corp. Device [1814:5592]
> > >>>>>> 
> > >>>>>>         Subsystem: ASUSTeK Computer Inc. Device [1043:851a]
> > >>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > >>>>>>         ParErr-
> > >>>>>> 
> > >>>>>> Stepping- SERR+ FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B-
> > >>>>>> ParErr-
> > >>>>>> DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- Latency:
> > >>>>>> 0,
> > >>>>>> Cache Line Size: 64 bytes
> > >>>>>> 
> > >>>>>>         Interrupt: pin A routed to IRQ 11
> > >>>>>>         Region 0: Memory at fe500000 (32-bit, non-prefetchable)
> > >>>>>>         [size=64K]
> > >>>>>>         Capabilities: [40] Power Management version 3
> > >>>>>>         
> > >>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> > >>>>>> 
> > >>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
> > >>>>>> DSel=0
> > >>>>>> DScale=0 PME- Capabilities: [50] MSI: Enable- Count=1/32 Maskable-
> > >>>>>> 64bit+
> > >>>>>> Address: 0000000000000000  Data: 0000
> > >>>>>> 
> > >>>>>>         Capabilities: [70] Express (v2) Endpoint, MSI 00
> > >>>>>>         
> > >>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> > >>>>>>                 L0s
> > >>>>>> 
> > >>>>>> <512ns, L1 unlimited ExtTag- AttnBtn- AttnInd- PwrInd- RBE+
> > >>>>>> FLReset-
> > >>>>>> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> > >>>>>> RlxdOrd-
> > >>>>>> ExtTag- PhantFunc- AuxPwr- NoSnoop- MaxPayload 128 bytes,
> > >>>>>> MaxReadReq
> > >>>>>> 128
> > >>>>>> bytes DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
> > >>>>>> TransPend-
> > >>>>>> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
> > >>>>>> <512ns,
> > >>>>>> L1 <64us ClockPM+ Surprise- LLActRep- BwNot-
> > >>>>>> 
> > >>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> > >>>>>>                 Retrain-
> > >>>>>> 
> > >>>>>> CommClk+ ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt- LnkSta:
> > >>>>>> Speed
> > >>>>>> 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> > >>>>>> ABWMgmt-
> > >>>>>> DevCap2: Completion Timeout: Not Supported, TimeoutDis+ DevCtl2:
> > >>>>>> Completion
> > >>>>>> Timeout: 50us to 50ms, TimeoutDis- LnkCtl2: Target Link Speed:
> > >>>>>> 2.5GT/s,
> > >>>>>> EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB Transmit
> > >>>>>> Margin:
> > >>>>>> Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> > >>>>>> Compliance
> > >>>>>> De-emphasis: -6dB
> > >>>>>> 
> > >>>>>>                 LnkSta2: Current De-emphasis Level: -6dB,
> > >>>>>> 
> > >>>>>> EqualizationComplete-, EqualizationPhase1- EqualizationPhase2-,
> > >>>>>> EqualizationPhase3-, LinkEqualizationRequest- Capabilities: [100
> > >>>>>> v1]
> > >>>>>> Advanced Error Reporting
> > >>>>>> 
> > >>>>>>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> > >>>>>>                 UnxCmplt-
> > >>>>>> 
> > >>>>>> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol- UEMsk:  DLP- SDES- TLP-
> > >>>>>> FCP-
> > >>>>>> CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq-
> > >>>>>> ACSViol-
> > >>>>>> UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> > >>>>>> MalfTLP+
> > >>>>>> ECRC- UnsupReq- ACSViol- CESta:  RxErr- BadTLP- BadDLLP- Rollover-
> > >>>>>> Timeout-
> > >>>>>> NonFatalErr+ CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > >>>>>> NonFatalErr+ AERCap: First Error Pointer: 00, GenCap+ CGenEn-
> > >>>>>> ChkCap+
> > >>>>>> ChkEn- Capabilities: [140 v1] Device Serial Number
> > >>>>>> c1-a5-f3-ff-fe-a9-85-30
> > >>>>>> 
> > >>>>>>> So maybe due to this (i'm not sure), rt2800pci only enables the
> > >>>>>>> 2.4
> > >>>>>>> Ghz
> > >>>>> 
> > >>>>> band support:
> > >>>>>> Your device does not look like a real RT5592 chip.
> > >>>>>> 
> > >>>>>>> All this with kernel 3.18 (openwrt 15.05 Chaos Calmer).
> > >>>>>>> Any ideas?
> > >>>>>> 
> > >>>>>> OpenWrt brings _a lot of_ code out upstream kernel.
> > >>>>>> Who knows what is running.
> > >>>>> 
> > >>>>> --
> > >>>>> To unsubscribe from this list: send the line "unsubscribe
> > >>>>> linux-wireless"
> > >>>>> in the body of a message to majordomo@vger.kernel.org
> > >>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-wireless"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

