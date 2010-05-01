Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44396 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0EAQFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 12:05:01 -0400
Received: by fxm10 with SMTP id 10so1027550fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 09:04:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100501121706.GA32719@frolo.macqel>
References: <20100419115329.GA5306@frolo.macqel> <20100419150050.GA28290@frolo.macqel>
	<20100419150627.GA10680@srcf.ucam.org> <20100424054210.GA23836@frolo.macqel>
	<20100424152107.GA13417@srcf.ucam.org> <20100424195630.GA15053@frolo.macqel>
	<20100424200218.GA16084@srcf.ucam.org> <20100425195058.GA12916@frolo.macqel>
	<4BD4A1D8.8000203@lwfinger.net> <20100501121706.GA32719@frolo.macqel>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 1 May 2010 18:04:38 +0200
Message-ID: <AANLkTilElb7tiCVbqSQ5FNi36fibiAhUSbWzGlbQhwXY@mail.gmail.com>
Subject: Re: BCM4312 802.11b/g LP-PHY (rev 01) dma & led problems
To: Philippe De Muyter <phdm@macqel.be>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 2:17 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> This is a followup on my attempt to use b43 (now from 2.6.34-rc6) on
> a HP Pavilion dv6-1300sb.
>
> With 2.6.34-rc6, I have not had any boot problem (blocking around ssb/b43)
> so far.
>
> But, dma mode gives an error (like before) and driver now switches
> automatically to PIO mode (new).
>
>        [   89.830222] device mon0 entered promiscuous mode
>        [  101.965896] NOHZ: local_softirq_pending 08
>        [  101.969431] NOHZ: local_softirq_pending 08
>        [  101.972230] NOHZ: local_softirq_pending 08
>        [  101.975041] NOHZ: local_softirq_pending 08
>        [  101.977771] NOHZ: local_softirq_pending 08
>        [  101.984651] NOHZ: local_softirq_pending 08
>        [  101.988808] NOHZ: local_softirq_pending 08
>        [  101.991562] NOHZ: local_softirq_pending 08
>        [  101.994363] NOHZ: local_softirq_pending 08
>        [  101.997116] NOHZ: local_softirq_pending 08
>        [  111.816257] hpet1: lost 1 rtc interrupts
>        [  112.131040] hpet1: lost 1 rtc interrupts
>        [  112.133343] hpet1: lost 1 rtc interrupts
>        [  112.135528] hpet1: lost 1 rtc interrupts
>        [  112.137722] hpet1: lost 1 rtc interrupts
>        [  112.139911] hpet1: lost 1 rtc interrupts
>        [  112.142089] hpet1: lost 1 rtc interrupts
>        [  112.146370] hpet1: lost 1 rtc interrupts
>        [  112.150637] hpet1: lost 1 rtc interrupts
>        [  112.152849] hpet1: lost 1 rtc interrupts
>        [  113.100932] b43-phy0 ERROR: Fatal DMA error: 0x00000000, 0x00000800, 0x00000000, 0x00000000, 0x00000000, 0x00000000
>        [  113.100949] b43-phy0 ERROR: This device does not support DMA on your system. Please use PIO instead.
>        [  113.100957] b43-phy0: Controller RESET (DMA error) ...
>        [  113.336119] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
>        [  118.853353] b43-phy0: Controller restarted
>
> During the switch, the led switches from blue to red and returns to blue
> after some seconds.  Touching the led switches the hardware blocking on
> and off, but the led color does not change.
>
> I then tried with the broadcom supplied hybrid driver, and there the
> touch/led functionality works as expected : led is red whenever
> I touch the button (enabling hardware blocking) or when I issue
> a rfkill block 0 (enabling software blocking).  Led is blue only when
> both blocking are disabled.  But, hybrid driver does not give monitor
> functionality :( (and of course, also no injection).
>        [10703.172776] wl: module license 'unspecified' taints kernel.
>        [10703.172791] Disabling lock debugging due to kernel taint
>        [10703.174286] wl: Unknown symbol lib80211_get_crypto_ops
>        [10778.692746] lib80211: common routines for IEEE802.11 drivers
>        [10778.692759] lib80211_crypt: registered algorithm 'NULL'
>        [10783.823152] wl 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>        [10783.823188] wl 0000:02:00.0: setting latency timer to 64
>        [10783.921236] lib80211_crypt: registered algorithm 'TKIP'
>        [10783.921623] eth1: Broadcom BCM4315 802.11 Hybrid Wireless Controller 5.60.48.36
>
> Any idea on what I could do to debug more / fix the dma and led problems ?

Nothing, unfortunately. We are working on this issue; apparently some
workarounds are missing from our PCI-E init implementation.

>
> Philippe
>
> Here the output of lspci -nvv for that chip :
>
> linux-m1ew:~ # lspci -nvv -s 02:00.0
> 02:00.0 0280: 14e4:4315 (rev 01)
>        Subsystem: 103c:1508
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at d9000000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
>        Capabilities: [58] Vendor Specific Information: Len=78 <?>
>        Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [d0] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
>                        ClockPM+ Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
>        Capabilities: [13c v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                        Status: NegoPending- InProgress-
>        Capabilities: [160 v1] Device Serial Number 00-00-00-ff-ff-00-ff-ff
>        Capabilities: [16c v1] Power Budgeting <?>
>        Kernel driver in use: b43-pci-bridge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
