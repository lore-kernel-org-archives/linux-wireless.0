Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753668AbcKUMY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:24:28 -0500
Date: Mon, 21 Nov 2016 13:20:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Charles Rose <crose@redhat.com>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20161121122015.GA613@redhat.com> (sfid-20161121_132432_773696_F0A77804)
References: <20160616115315.GB21199@redhat.com>
 <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
 <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
 <20160811122917.GB27059@redhat.com>
 <fc70c75bfcab4e0e932274034b5b4493@SC-EXCH04.marvell.com>
 <20160812081342.GA15538@redhat.com>
 <20160825150626.GA9256@redhat.com>
 <20161114101544.GA13943@redhat.com>
 <2165db278e1c486d8fffbd2db4150481@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2165db278e1c486d8fffbd2db4150481@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Nov 16, 2016 at 06:03:49AM +0000, Amitkumar Karwar wrote:
> > From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> > Sent: Monday, November 14, 2016 3:46 PM
> > To: Amitkumar Karwar
> > Cc: Nishant Sarmukadam; linux-wireless@vger.kernel.org
> > Subject: Re: Problems with mwifiex_pcie firmware activation
> > 
> > On Thu, Aug 25, 2016 at 05:06:26PM +0200, Stanislaw Gruszka wrote:
> > > On Fri, Aug 12, 2016 at 10:13:43AM +0200, Stanislaw Gruszka wrote:
> > > > On Fri, Aug 12, 2016 at 07:17:38AM +0000, Amitkumar Karwar wrote:
> > > > > The problem looks strange. The patch just splits
> > mwifiex_check_fw_status() and increases poll count. It should not have
> > any side-effects.
> > > > > Our code used to check winner status before this patch also.
> > > >
> > > > Ok, I misread the patch. Anyway checking "winner status" seems does
> > > > not work well on some condition and prevent loading firmware into
> > > > device.
> > >
> > > I debug this a bit more on latest wireless-testing-next tree + 3
> > > patches I just posted and debug_mask=0x700000ff.
> > >
> > > On broken system, we do not download FW to device when system is
> > > rebooted, due to PCI-E is not the winner. However if system is
> > powered
> > > OFF and then powered ON, we do FW downloading. Hence download the new
> > > FW into device does not make it work as was my theory.
> > >
> > > In attachments are full dmesgs of good/bad and reboot/power-off-on
> > > cases.
> > >
> > > The difference is that on broken system FW (or HW) do not create new
> > > USB Bluetooth device (1286:2046) and do not report
> > > FIRMWARE_READY_PCIE. Additionally on reboot case there are errors
> > from
> > > USB xhci.
> > 
> > It was discovered that not working device require pcie8897_uapsta.bin
> > firmware from ubuntu package to work:
> 
> What's the difference between working and non-working device?

I can not find anything reasonable. Lspci gives almost the same print.
There is some difference, but I think it comes from from fact that 
working device is enabled and non-working is disabled.

Working:

03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 266
	Region 0: Memory at 90700000 (64-bit, prefetchable) [size=1M]
	Region 2: Memory at 90600000 (64-bit, prefetchable) [size=1M]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/32 Maskable+ 64bit+
		Address: 00000000fee0200c  Data: 4172
		Masking: fffffffe  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 10.000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <1us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR+, OBFF Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [150 v1] Power Budgeting <?>
	Capabilities: [160 v1] Latency Tolerance Reporting
		Max snoop latency: 71680ns
		Max no snoop latency: 71680ns
	Capabilities: [168 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=70us PortTPowerOnTime=10us
	Kernel driver in use: mwifiex_pcie
	Kernel modules: mwifiex_pcie

Non-working:

02:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 90700000 (64-bit, prefetchable) [size=1M]
	Region 2: Memory at 90600000 (64-bit, prefetchable) [size=1M]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/32 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 10.000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <1us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+, LTR+, OBFF Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [150 v1] Power Budgeting <?>
	Capabilities: [160 v1] Latency Tolerance Reporting
		Max snoop latency: 71680ns
		Max no snoop latency: 71680ns
	Capabilities: [168 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
			  PortCommonModeRestoreTime=70us PortTPowerOnTime=10us
	Kernel driver in use: mwifiex_pcie
	Kernel modules: mwifiex_pcie

I also added some extra code to print registers that are used to identify
other PCIE_DEVICE_ID_MARVELL_88W8997 device:

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3c3c4f1..84434ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2921,6 +2921,9 @@ static void mwifiex_pcie_get_fw_name(struct
mwifiex_adapter *adapter)
        case PCIE_DEVICE_ID_MARVELL_88W8897:
                mwifiex_write_reg(adapter, 0x0c58, 0x80c00000);
                mwifiex_read_reg(adapter, 0x0c58, &revision_id);
+               mwifiex_read_reg(adapter, 0x0cd0, &version);
+               mwifiex_read_reg(adapter, 0x0cd4, &magic);
+               printk("%s revision_id 0x%08x version 0x%08x magic 0x%08x\n", __func__, revision_id, version, magic);
                revision_id &= 0xff00;
                switch (revision_id) {
                case PCIE8897_A0:

but prints are the same for non-working and working system:

mwifiex_pcie_get_fw_name revision_id 0x00001430 version 0x00000000 magic 0x00000000

So I'm not sure if device in working and non-working system is different.
Maybe difference is in how device is connected with the rest of the system
or in other hardware parts. Cc Charles, perhaps he can elaborate more about
that.

> > https://launchpad.net/~snappy-dev/+archive/ubuntu/snappy-
> > devices/+sourcepub/5936055/+listing-archive-extra
> > 
> > Device initialize like this then:
> > 
> > [   15.374630] mwifiex_pcie 0000:02:00.0: info: FW download over, size
> > 689624 bytes
> > [   16.101214] mwifiex_pcie 0000:02:00.0: WLAN FW is active
> > [   16.242825] mwifiex_pcie 0000:02:00.0: info: MWIFIEX VERSION:
> > mwifiex 1.0 (15.150.13.p21)
> > [   16.251231] mwifiex_pcie 0000:02:00.0: driver_version = mwifiex 1.0
> > (15.150.13.p21)
> > 
> > I'm not sure where ubuntu get this 15.150.13.p21 version of firmware as
> > it seems it's not present nor in upstream linux-firmware repo not in
> > http://git.marvell.com/?p=mwifiex-firmware.git;a=summary
> > 
> > Anyway could you modify firmware to support this device or modify
> > driver to load 15.150.13.p21 if required and push this F/W image
> > upstream ?
> > 
> 
> Last released firmware is 15.68.7.p77
> http://git.marvell.com/?p=mwifiex-firmware.git;a=commit;h=05e2f3a4acf4174ec507a3464a374ecb1b4ec011
> Could you try with it?

I does not make device on non-workig system work.

> If it doesn't work, we need to investigate what is missing in this compared to 15.150.13.p21 and create new 15.68.7.pXX.

Thanks
Stanislaw
