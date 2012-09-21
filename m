Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38452 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907Ab2IUCwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 22:52:17 -0400
Message-Id: <1348195935.21813.140661130714053.0302A2E4@webmail.messagingengine.com> (sfid-20120921_045223_424965_B0635A0D)
From: Luiz Carlos Ramos <lramos.prof@yahoo.com.br>
To: Sujith Manoharan <c_manoha@qualcomm.com>, lramos.prof@yahoo.com.br
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <207925.414c4261696d4941414f4f6255467379697735635131766f663355@popretr.messagingengine.com>
References: <1348073684.14711.140661130028433.035E90DC@webmail.messagingengine.com>
 <207925.414c4261696d4941414f4f6255467379697735635131766f663355@popretr.messagingengine.com>
 <20571.12875.594812.396218@gargle.gargle.HOWL>
Subject: Re: Atheros AR9485 receiving error -5 in init
Date: Thu, 20 Sep 2012 23:52:15 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, here it goes!

I opted to attach only the part which refers to the AR9485. If you'd
need the rest, feel free to ask me.

As the adapter seems to be a PCI (or PCI-e) device, I omitted the lsusb
-v output.

It is also provided the output of lshw, which shows some information
about I/O space. In fact, I don't know if that information is accurate
or relevant, but it is not shown in lspci -vvv.

Hope it can help.

Thanks,

Luiz


--- lspci -vvv -s 04:00.0 ----------------------------------
04:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless
Network Adapter (rev 01)
	Subsystem: Samsung Electronics Co Ltd Device 4105
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
	ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
	<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 1020 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fea00000 (64-bit, non-prefetchable)
	[size=512K]
	Expansion ROM at fea80000 [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
		PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
		unlimited, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
		Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop-
			MaxPayload 16384 bytes, MaxReadReq 16384 bytes
		DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
		TransPend-
		LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
		Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled-
		Retrain- CommClk+
			ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
		DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
		SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range,
			 EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
		UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
		UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
		UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
		NonFatalErr-
		CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
		NonFatalErr+
		AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
		ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:    Fixed- WRR32- WRR64- WRR128-
		Ctrl:   ArbSelect=Fixed
		Status: InProgress-
		VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
		RejSnoopTrans-
			Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
			WRR256-
			Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status: NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number
	00-00-00-00-00-00-00-00
	Kernel modules: ath9k

------------------------------------------------------------
--- lshw ---------------------------------------------------
       *-pci:3
             description: PCI bridge
             product: Advanced Micro Devices [AMD]
             vendor: Advanced Micro Devices [AMD]
             physical id: 15
             bus info: pci@0000:00:15.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pci pm pciexpress msi ht normal_decode
             bus_master cap_list
             configuration: driver=pcieport
             resources: irq:16 memory:fea00000-feafffff
           *-network UNCLAIMED
                description: Network controller
                product: AR9485 Wireless Network Adapter
                vendor: Atheros Communications Inc.
                physical id: 0
                bus info: pci@0000:04:00.0
                version: 01
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
                configuration: latency=0
                resources: iomemory:ffffffff0-fffffffef
                memory:fea00000-fea7ffff memory:fea80000-fea8ffff

------------------------------------------------------------


On Thu, Sep 20, 2012, at 12:12, Sujith Manoharan wrote:
> Luiz Ramos wrote:
> > Hello,
> > 
> > Recently I changed the laptop, and there's something wrong with the new
> > Wifi adapter, which is an Atheros AR9485. Now, when I do modprobe ath9k,
> > a message like this is registered in dmesg:
> > 
> >   ath9k: probe of 0000:04:00.0 failed with error -5
> > 
> > The OS installed in that machine is a Slackware 13.37 with the stock
> > kernel. I've tried, following some google research, using the
> > compatibility backport kit. I've downloaded some versions, but now I
> > stick with compat-wireless-3.5.3-2-sn in order to eliminate variables.
> > 
> > After some turns, I've put some printk() in
> > drivers/net/wireless/ath/ath9k/hw.c, and my final conclusion is that the
> > time is running out in the routine ath_hw_wait() when waiting for the
> > register 0x7044 have some value, like showed by one message raised by
> > one of the printk() inserted in the code:
> > 
> >   ath9k_hw_wait(): ret=0(timeout (100000 us) on reg 0x7044: 0xffffffff &
> >   0x0000000f != 0x00000002)
> 
> Can you attach the output of lspci -vv and lsusb -v ?
> 
> Sujith
> 
-- 
  Luiz Carlos Ramos
  luizzramos@imap.cc

