Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57240 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0LSU7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 15:59:21 -0500
Received: by qwa26 with SMTP id 26so2222800qwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Dec 2010 12:59:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0DE870.2050503@free.fr>
References: <4D0DE870.2050503@free.fr>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 19 Dec 2010 21:58:59 +0100
Message-ID: <AANLkTik5uML3gSD5aJE8CPwew8G5shp9BJgGUK608jTp@mail.gmail.com>
Subject: Re: Wireless channel stuck to -1 on mon0 (fix patch submission)
To: CalimeroTeknik <calimeroteknik@free.fr>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a known problem, that has basically been WONTFIXed a while
ago. I highly disagree with the reasoning, but the decision ultimately
rests on Johannes. In the meantime, check patches.aircrack-ng.org for
a workaround.

Johannes: I know that you consider reporting the actual channel of the
PHY to be "confusing to users" when running with multiple virtual
PHYs, but apparently this is what most users expect. Perhaps it
*should* be implemented after all.

On Sun, Dec 19, 2010 at 12:11 PM, CalimeroTeknik <calimeroteknik@free.fr> wrote:
> [1.] One line summary of the problem:
> I can't change the channel of mon0 which is stuck to -1
>
> [2.] Full description of the problem/report:
> iwconfig mon0 channel 10 gives no error but the channel stays to -1
>
> [3.] Keywords (i.e., modules, networking, kernel):
> Wifi modules used :
> iwlagn                336809  0
> iwlcore                89975  1 iwlagn
> mac80211              199020  2 iwlagn,iwlcore
> cfg80211              139093  3 iwlagn,iwlcore,mac80211
>
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> Linux version 2.6.37-rc6-mainline (root@m50vn) (gcc version 4.5.2 (GCC)
> ) #1 SMP PREEMPT Sat Dec 18 15:50:20 CET 2010
> nota bene : compiled in *fake*root.
> [4.2.] Kernel .config file:
> attached.
>
> [5.] Most recent kernel version which did not have the bug:
> It worked on 2.6.33 and didn't work on 2.6.36
>
> [6.] Output of Oops.. message (if applicable) with symbolic information
>     resolved (see Documentation/oops-tracing.txt)
> None.
>
> [7.] A small shell script or example program which triggers the
>     problem (if possible)
> airmon-ng start wlan0
> airodump-ng --channel 1 mon0
>
> You'll notice that despite any attempt of changing the channel, it stays
> to -1.
> [8.] Environment
> [8.1.] Software (add the output of the ver_linux script here)
> [8.2.] Processor information (from /proc/cpuinfo):
> cpu family    : 6
> model        : 23
> model name    : Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
>
> [8.3.] Module information (from /proc/modules):
> iwlagn 336809 0 - Live 0xffffffffa0317000
> iwlcore 89975 1 iwlagn, Live 0xffffffffa01a2000
> mac80211 199020 2 iwlagn,iwlcore, Live 0xffffffffa02c6000
> cfg80211 139093 3 iwlagn,iwlcore,mac80211, Live 0xffffffffa01c4000
>
> [8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> attached.
>
> [8.5.] PCI information ('lspci -vvv' as root)
> 03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
>    Subsystem: Intel Corporation PRO/Wireless 5100AGN Network Connection
>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 0, Cache Line Size: 32 bytes
>    Interrupt: pin A routed to IRQ 50
>    Region 0: Memory at fdffe000 (64-bit, non-prefetchable) [size=8K]
>    Capabilities: [c8] Power Management version 3
>        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>        Address: 00000000fee0300c  Data: 41c1
>    Capabilities: [e0] Express (v1) Endpoint, MSI 00
>        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 unlimited
>            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>            MaxPayload 128 bytes, MaxReadReq 128 bytes
>        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
> TransPend-
>        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <128ns, L1 <32us
>            ClockPM+ Surprise- LLActRep- BwNot-
>        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>    Capabilities: [100 v1] Advanced Error Reporting
>        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>        CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>    Capabilities: [140 v1] Device Serial Number 00-21-5d-ff-ff-9a-71-9c
>    Kernel driver in use: iwlagn
>    Kernel modules: iwlagn
>
> complete lspci -vvv attached.
>
> [X] : Patch proposal
> This patch is *very* small and corrects the bug, so I think it could be
> included in final 2.6.37.
> http://patches.aircrack-ng.org/channel-negative-one-maxim.patch
>
> Thanks for reading, and keep up the good work !
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
