Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:6341 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842Ab1H3GoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:44:04 -0400
Date: Tue, 30 Aug 2011 08:41:38 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20110830064137.GA4719@ecki> (sfid-20110830_084407_915849_C962BBD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
 <CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
 <CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Mon, Aug 29, 2011 at 08:42:33PM +0530, Mohammed Shafi wrote:
>
> >> But still, the interrupts come. Note that according to
> >> /proc/interrupts, the IRQ line is not shared with any other device.
> >> I did not manage to determine which interrupt it is exactly,
> >> because the device is not in a ready state (SC_OP_INVALID is set)
> >> when they happen (in either scenario that triggers the IRQ storm).
> >> And SC_OP_INVALID is cleared only much later in ath9k_start.
> >>
> >> So, I am at a loss. Any ideas?
> >
> > please provide the lspci -vvvxx.

Please see below.

> >> also looking at
> >> /sys/kernel/debug/ieee80211/phy0/ath9k$ sudo cat interrupt.

Those interrupt counters are always zero, because ath_isr never
gets to the point where it would gather statistics. The interrupt
routine exits right at the start, because SC_OP_INVALID is still
set.

        if (sc->sc_flags & SC_OP_INVALID)
                return IRQ_NONE;

By the time the invalid flag is cleared, the IRQ line has long
since been disabled, due to 10000 spurios interrupts during less
than 500 ms.

> > hi, i think this will help, please get the message sudo modprobe ath9k
> > debug=0xffffffff.
> > few fatal PCI interrupt messages are based on ATH_DEBUG_ANY.

Whenever I did that in the past, it just added lots of PDADC debug
messages.

> we can also try to disable MIB interrupts though its handled properly
> now in ath9k
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-09-25/0001-ath9k-disable-MIB-interrupts-to-fix-interrupt-storm.patch

But I am already disabling all interrupts by setting the mask to 0.
Unless there are some non-maskable ones?

I wonder if the device is in some crashed state at this point. Is
it possible to reset the device in ath_pci_probe?

> a recent commit, not sure this will help suspend/resume
>
> commit 0682c9b52bf51fbc67c4e79fcbdadcf70bd600f8
> Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Date:   Sat Aug 13 10:28:09 2011 +0530
>
>    ath9k: Fix rx overrun interrupt storm

For the same reason as above, this patch does not touch any code
that would get executed.

> > also this additional information might help:
> > in case have you seen this is happening in 32 bit also ?

I have never had a 32-bit system on this machine.

> > is this happening in wireless-testing  Linux 3.1-rc3 ? or the latest
> > compat wireless?

I think I tried last week, but I can try again.

> > i did some preliminary testing, not able to recreate it. will try
> > further.thanks!

Thanks for trying. Did you turn off network manager? As I described
here, it can make the bug go away.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=39112#c5

Clemens
---

02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: AzureWave Device 1089
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at d2c00000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
	Capabilities: [170 v1] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k
00: 8c 16 2b 00 07 00 10 00 01 00 80 02 10 00 00 00
10: 04 00 c0 d2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3b 1a 89 10
30: 00 00 00 00 40 00 00 00 00 00 00 00 03 01 00 00
