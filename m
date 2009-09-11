Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:17599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZIKGSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 02:18:43 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1825061fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 23:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA9B46E.8020100@canonical.com>
References: <4AA9B46E.8020100@canonical.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 11 Sep 2009 08:18:26 +0200
Message-ID: <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com>
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power PHY
To: Bryan Wu <bryan.wu@canonical.com>
Cc: mb@bu3sch.de, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This chip works (though not quite "supported", that is, can't
guarantee that it will work for you, and speed is not up to par with
wl_hybrid) in wireless-testing. It should also work in
compat-wireless, though compat-wireless is having problems with 64-bit
DMA lately (probably also affects the G-PHY 4311/02). Specifically,
the Dell 1397 (half-mini version of the 1395) and the HP 459263-002
are known to work.

On Fri, Sep 11, 2009 at 4:22 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Dear Michael and Stefano,
>
> I have a project which integrate Broadcom Wifi chip. But the mainline b43 still does not support this chip, because it has Low Power PHY.
>
> Here is my lspci -vvnn output for this device:
> ------
> 07:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g [14e4:4315] (rev 01)
>        Subsystem: Dell Device [1028:000c]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 17
>        Region 0: Memory at f0100000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>        Capabilities: [58] Vendor Specific Information <?>
>        Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [d0] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
>                        ClockPM+ Suprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>        Kernel driver in use: b43-pci-bridge
>        Kernel modules: ssb
> ------
>
> Do you guys know how to support this device in 2.6.31 kernel? Need I backport some code from wireless-testing? I enabled the PHY_LP config manually in 2.6.31 kernel and b43 driver recognized the hardware wifi device, but it still
> does not work at all.
>
> Or there is no choice but Broadcom's STA driver? I do not like such non-GPL stuff.
>
> Thanks a lot
> --
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.138-1617-6545 Mobile
> Ubuntu Kernel Team | Hardware Enablement Team
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
