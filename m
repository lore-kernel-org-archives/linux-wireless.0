Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:43761 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYBTSBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:01:15 -0500
Received: from zoltar.telenet-ops.be (zoltar.telenet-ops.be [195.130.132.57])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id 963836821CF
	for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 19:01:13 +0100 (CET)
Received: from hoboi3bl3.telenet-ops.be (hoboi3bl3.telenet-ops.be [195.130.137.86])
	by zoltar.telenet-ops.be (Postfix) with ESMTP id 26E124068
	for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 19:00:32 +0100 (CET)
Received: from winston.telenet-ops.be (winston.telenet-ops.be [195.130.137.75])
	by hoboi3bl3.telenet-ops.be (8.13.1/8.13.1) with ESMTP id m1KI0Vj3022242
	for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 19:00:31 +0100
Received: from [192.168.2.139] (d54C6CCFC.access.telenet.be [84.198.204.252])
	by winston.telenet-ops.be (Postfix) with ESMTP id 8A7F4A0043
	for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 19:00:31 +0100 (CET)
Message-ID: <47AF79DA.10204@yahoo.co.uk> (sfid-20080220_180121_070641_4FFC2208)
Date: Sun, 10 Feb 2008 23:25:30 +0100
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I followed the guidelines for a bug report.
If there is anything else needed, I'll be happy to do all the testing 
needed.

[1.] One line summary of the problem:
p54usb driver crashes on trying to associate with an ap with the 
CPWUA054 usb adapter

[2.] Full description of the problem/report:
What works:
modprobe p54usb
dmesg (displays my adapter correctly)
ifconfig up wlan0
dmesg (using the right firmware 2.5.6.0)

but trying to associate to my accesspoint (using wpa_supplicant) causes 
a hard-lock up (keyboard leds blinking).
Before locking up it spams loads of 'RX: unknown frame received phy1' 
messages on kmsg/dmesg.

Note that my adapter isn't in the vendor:model id list of the p54 
driver, my patch submitted for that is prob. lost somewhere.
But I'm using islsm with my usb adapters for >1.5 years with no problems.
lsusb lists my device's model/vendor id
Bus 001 Device 002: ID 083a:5501 Accton Technology Corp.

I also tried the wireless-2.6 kernel some months again with the same 
issue, though I had some kernel option on that allowed
me to do a traceback to the failed function, *rx*() i believe (in p54 
itself). I'm not really familiar with kernel debugging but i'll try
to give you the full trace in a couple of days, have to figure out how 
to do it again.
If there is anything else that is useful, I'll be happy to provide it.

[3.] Keywords (i.e., modules, networking, kernel):
wireless, p54 driver

[4.] Kernel version (from /proc/version):
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux barton 2.6.24-gentoo-r2-BARTON #3 PREEMPT Tue Feb 19 20:31:03 CET 
2008 i686 AMD Athlon(tm) XP 2500+ AuthenticAMD GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40.2
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
wireless-tools         29
Modules Loaded         p54usb p54common firmware_class nvidia_agp 
agpgart forcedeth

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
     
[6.] A small shell script or example program which triggers the
     problem (if possible)
/ Specific to hardware

[7.] Environment
/

[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux barton 2.6.24-gentoo-r2-BARTON #3 PREEMPT Tue Feb 19 20:31:03 CET 
2008 i686 AMD Athlon(tm) XP 2500+ AuthenticAMD GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40.2
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
wireless-tools         29
Modules Loaded         p54usb p54common firmware_class nvidia_agp 
agpgart forcedeth

[7.2.] Processor information (from /proc/cpuinfo):
/

[7.3.] Module information (from /proc/modules):
p54usb 12672 0 - Live 0xf8828000
p54common 11136 1 p54usb, Live 0xf8817000
firmware_class 7424 1 p54usb, Live 0xf8814000
nvidia_agp 6428 1 - Live 0xf8825000
agpgart 27056 1 nvidia_agp, Live 0xf881d000
forcedeth 47372 0 - Live 0xf885e000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: nVidia Corporation nForce2 AGP (different version?) 
(rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
    Capabilities: [40] AGP version 3.0
        Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW+ AGP3+ Rate=x4,x8
        Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x4
    Capabilities: [60] HyperTransport: Host or Secondary Interface
        Command: WarmRst+ DblEnd-
        Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
        Link Config: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
        Revision ID: 0.16

00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev c1)
    Subsystem: ASUSTeK Computer Inc. Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a4)
    Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [48] HyperTransport: Slave or Primary Interface
        Command: BaseUnitID=1 UnitCnt=15 MastHost- DefDir-
        Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC+ TXO- <CRCErr=0
        Link Config 0: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
        Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO+ <CRCErr=0
        Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
        Revision ID: 0.00

00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
    Subsystem: ASUSTeK Computer Inc. Unknown device 0c11
    Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 5
    Region 0: I/O ports at c000 [size=32]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a4) (prog-if 10 [OHCI])
    Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at ea004000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a4) (prog-if 10 [OHCI])
    Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin B routed to IRQ 5
    Region 0: Memory at ea005000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a4) (prog-if 20 [EHCI])
    Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin C routed to IRQ 11
    Region 0: Memory at ea000000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [44] Debug port
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Ethernet controller: nVidia Corporation nForce2 Ethernet 
Controller (rev a1)
    Subsystem: ASUSTeK Computer Inc. A7N8X Mainboard onboard nForce2 
Ethernet
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (250ns min, 5000ns max)
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at ea001000 (32-bit, non-prefetchable) [size=4K]
    Region 1: I/O ports at c400 [size=8]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable+ DSel=0 DScale=0 PME-

00:06.0 Multimedia audio controller: nVidia Corporation nForce2 AC97 
Audio Controler (MCP) (rev a1)
    Subsystem: ASUSTeK Computer Inc. nForce2 AC97 Audio Controler (MCP)
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (500ns min, 1250ns max)
    Interrupt: pin A routed to IRQ 5
    Region 0: I/O ports at b000 [size=256]
    Region 1: I/O ports at b400 [size=128]
    Region 2: Memory at ea002000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev 
a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: fff00000-000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-

00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2) (prog-if 
8a [Master SecP PriP])
    Subsystem: ASUSTeK Computer Inc. Unknown device 0c11
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[disabled] [size=8]
    Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[disabled] [size=1]
    Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
    Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
    Region 4: I/O ports at f000 [size=16]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev c1) (prog-if 00 
[Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 240
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
    I/O behind bridge: 0000a000-0000afff
    Memory behind bridge: e8000000-e9ffffff
    Prefetchable memory behind bridge: c0000000-dfffffff
    Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

01:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
    Subsystem: Creative Labs Unknown device 1021
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 240 (500ns min, 5000ns max)
    Interrupt: pin A routed to IRQ 11
    Region 0: I/O ports at 9000 [size=64]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 VGA compatible controller: ATI Technologies Inc RV350 AP [Radeon 
9600] (prog-if 00 [VGA])
    Subsystem: C.P. Technology Co. Ltd PowerColor R96A-C3N
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 255 (2000ns min), Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 5
    Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
    Region 1: I/O ports at a000 [size=256]
    Region 2: Memory at e9000000 (32-bit, non-prefetchable) [size=64K]
    [virtual] Expansion ROM at e8000000 [disabled] [size=128K]
    Capabilities: [58] AGP version 3.0
        Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW+ AGP3+ Rate=x4,x8
        Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.1 Display controller: ATI Technologies Inc RV350 AP [Radeon 9600] 
(Secondary)
    Subsystem: C.P. Technology Co. Ltd Unknown device 2065
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Region 0: Memory at d0000000 (32-bit, prefetchable) [disabled] 
[size=256M]
    Region 1: Memory at e9010000 (32-bit, non-prefetchable) [disabled] 
[size=64K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-


[7.6.] SCSI information (from /proc/scsi/scsi)

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
       
[X.] Other notes, patches, fixes, workarounds:

kind regards,
Ivo
