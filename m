Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38511 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab2EGQdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 12:33:45 -0400
Received: by lbbgm6 with SMTP id gm6so3565395lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 09:33:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA7DEC8.5040506@fold.natur.cuni.cz>
References: <4FA7DEC8.5040506@fold.natur.cuni.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 May 2012 09:33:23 -0700
Message-ID: <CAErSpo7pDQiMhfiZw_eG_8StuYJMU5wXQN7aWT=7yhsukStGcA@mail.gmail.com> (sfid-20120507_183351_350500_E1596A5B)
Subject: Re: 3.4-rc5: Oops in run_timer_softirq()
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
	linux-wireless@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 7, 2012 at 7:40 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Hi,
>  I have enabled my wifi in the Dell Vostro 3550 laptop by the hardware button combination
> Fn+F2 and disabled it back again after few seconds. The following crash happened, and is
> quite reproducible. Is that to be fixed by the patch in
> "Re: Suspicious RCU usage in mac80211" thread from this email list?

Did you mean linux-wireless (cc'd)?  I don't see any PCI issue here.

> [  385.231175] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  385.231226] IP: [<          (null)>]           (null)
> [  385.231245] PGD 0
> [  385.231257] Oops: 0010 [#1] SMP
> [  385.231273] CPU 3
> [  385.231283] Modules linked in: iwlwifi i2c_i801 usb_storage
> [  385.231308]
> [  385.231317] Pid: 0, comm: swapper/3 Not tainted 3.4.0-rc5-default #5 Dell Inc. Vostro 3550/0JGC48
> [  385.231350] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
> [  385.231383] RSP: 0018:ffff88041fb83e78  EFLAGS: 00010286
> [  385.231402] RAX: ffff88041fb83eb0 RBX: 0000000000000100 RCX: 0000000000000838
> [  385.231426] RDX: ffff88041fb83eb0 RSI: dead000000200200 RDI: 0000000000000000
> [  385.231449] RBP: ffff88041fb83ef0 R08: ffff88041fb83eb8 R09: 0000000000000001
> [  385.231480] R10: 0000000000000400 R11: ffffffff816074a5 R12: ffff88040f3b8000
> [  385.231503] R13: ffff88040f3c1fd8 R14: ffff88041fb83eb0 R15: 0000000000000000
> [  385.231526] FS:  0000000000000000(0000) GS:ffff88041fb80000(0000) knlGS:0000000000000000
> [  385.231552] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  385.231570] CR2: 0000000000000000 CR3: 0000000001913000 CR4: 00000000000407e0
> [  385.231592] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  385.231614] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  385.231638] Process swapper/3 (pid: 0, threadinfo ffff88040f3c0000, task ffff88040f3bd350)
> [  385.231663] Stack:
> [  385.231673]  ffffffff81083f91 ffff88040f3c1fd8 ffff88040f3b9c20 ffff88040f3b9820
> [  385.231702]  ffff88040f3b9420 ffff88040f3b9020 0000000000000000 ffff88041fb83eb0
> [  385.231730]  ffff88041fb83eb0 ffffffff81043e21 ffffffff8190c088 ffff88040f3c1fd8
> [  385.231759] Call Trace:
> [  385.231770]  <IRQ>
> [  385.231784]  [<ffffffff81083f91>] ? run_timer_softirq+0x191/0x223
> [  385.231806]  [<ffffffff81043e21>] ? lapic_next_event+0x10/0x14
> [  385.231827]  [<ffffffff8107fbcc>] __do_softirq+0x83/0x10d
> [  385.231846]  [<ffffffff810ae18f>] ? tick_program_event+0x1f/0x21
> [  385.231869]  [<ffffffff815e2a8c>] call_softirq+0x1c/0x30
> [  385.231889]  [<ffffffff8102e042>] do_softirq+0x33/0x69
> [  385.231907]  [<ffffffff8107fe05>] irq_exit+0x3f/0x9a
> [  385.231926]  [<ffffffff8104417c>] smp_apic_timer_interrupt+0x77/0x85
> [  385.231948]  [<ffffffff815e2307>] apic_timer_interrupt+0x67/0x70
> [  385.231967]  <EOI>
> [  385.231979]  [<ffffffff8109a149>] ? wake_up_process+0x10/0x12
> [  385.231999]  [<ffffffff810aebce>] ? tick_nohz_idle_exit+0x135/0x13c
> [  385.232020]  [<ffffffff81033fcd>] cpu_idle+0x78/0x7f
> [  385.232039]  [<ffffffff815daf6b>] start_secondary+0x18f/0x193
> [  385.232057] Code:  Bad RIP value.
> [  385.232075] RIP  [<          (null)>]           (null)
> [  385.232093]  RSP <ffff88041fb83e78>
> [  385.232107] CR2: 0000000000000000
> [  385.232309] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, -vsync)
> [  385.593328] ---[ end trace e3eed09b44fc9be3 ]---
>
>
>
> 09:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030 (rev 34)
>        Subsystem: Intel Corporation Centrino Wireless-N 1030 BGN
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 53
>        Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=8K]
>        Capabilities: [c8] Power Management version 3
>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee003f8  Data: 0000
>        Capabilities: [e0] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
>                        ClockPM+ Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>        Capabilities: [140 v1] Device Serial Number 4c-80-93-ff-ff-15-e6-c7
>        Kernel driver in use: iwlwifi
>        Kernel modules: iwlwifi
> 00: 86 80 8a 00 06 00 10 00 34 00 80 02 10 00 00 00
> 10: 04 00 e0 f7 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 25 53
> 30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
> d0: 05 e0 81 00 f8 03 e0 fe 00 00 00 00 00 00 00 00
> e0: 10 00 01 00 c0 8e 00 10 00 08 19 00 11 ec 06 00
> f0: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
>
>
> Thanks,
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
