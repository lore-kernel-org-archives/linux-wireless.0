Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:33935 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbeBESXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 13:23:32 -0500
MIME-Version: 1.0
From: Adric Blake <promarbler14@gmail.com>
Date: Mon, 5 Feb 2018 13:23:31 -0500
Message-ID: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com> (sfid-20180205_200902_272671_E2A03CD2)
Subject: B43 driver no longer works in Linux 4.15 (bisected)
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhogan@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the time between Linux 4.15-rc8 and -rc9, my wireless driver, b43,
would no longer load automatically. When I modprobe the b43 (and ssb)
modules, the device still didn't appear in NetworkManager. Comparing
the kernel logs between working (4.14.16-lts) and nonworking (4.15)
kernels reveals that there is zero output from the ssb module, and no
devices recognized by the b43 driver:

Compare:

working:

 kernel: ssb: Found chip with id 0x4312, rev 0x01 and package 0x00
 kernel: ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
 kernel: ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
 kernel: ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
 kernel: ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
 kernel: ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
 kernel: b43-phy0: Broadcom 4312 WLAN found (core revision 15)
 kernel: b43-phy0: Found PHY: Analog 6, Type 5 (LP), Revision 1
 kernel: b43-phy0: Found Radio: Manuf 0x17F, ID 0x2062, Revision 2, Version 0
 kernel: Broadcom 43xx driver loaded [ Features: PNLS ]
 kernel: b43-phy0: Loading firmware version 784.2 (2012-08-15 21:35:19)

vs nonworking, with manual modprobe:

 kernel: platform regulatory.0: Direct firmware load for regulatory.db
failed with error -2
 kernel: cfg80211: failed to load regulatory.db
 kernel: Broadcom 43xx driver loaded [ Features: NLS ]

I had my suspicions at this point, but I had a lull and decided to
bisect it anyways.
I bisected to this "first bad commit:"

commit 58eae1416b804d900014d84feadda7195007cc30
Author: James Hogan <jhogan@kernel.org>
Date:   Mon Jan 15 21:17:14 2018 +0000

    ssb: Disable PCI host for PCI_DRIVERS_GENERIC

    Since commit d41e6858ba58 ("MIPS: Kconfig: Set default MIPS system type
    as generic") changed the default MIPS platform to the "generic"
    platform, which uses PCI_DRIVERS_GENERIC instead of PCI_DRIVERS_LEGACY,
    various files in drivers/ssb/ have failed to build.

    This is particularly due to the existence of struct pci_controller being
    dependent on PCI_DRIVERS_LEGACY since commit c5611df96804 ("MIPS: PCI:
    Introduce CONFIG_PCI_DRIVERS_LEGACY"), so add that dependency to Kconfig
    to prevent these files being built for the "generic" platform including
    all{yes,mod}config builds.

    Fixes: c5611df96804 ("MIPS: PCI: Introduce CONFIG_PCI_DRIVERS_LEGACY")
    Signed-off-by: James Hogan <jhogan@kernel.org>
    Cc: Michael Buesch <m@bues.ch>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Cc: Paul Burton <paul.burton@mips.com>
    Cc: Matt Redfearn <matt.redfearn@imgtec.com>
    Cc: Guenter Roeck <linux@roeck-us.net>
    Cc: linux-wireless@vger.kernel.org
    Cc: linux-mips@linux-mips.org
    Tested-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

:040000 040000 b7b4c5908ec800fbba19a9615049648d488a5771
18d76731ebb799fc1892d01da59d4c268229d51e M    drivers

Since it was just a one-line Kconfig change, i investigated further,
and noted how a dependency change affects the build:

 missing config: SSB_B43_PCI_BRIDGE
 caused by missing dependency config: SSB_PCIHOST_POSSIBLE
 disabling pseudo-config: B43_PCI_AUTOSELECT

 also missing config: CONFIG_SSB_DRIVER_PCICORE
 caused by missing dependency config: SSB_DRIVER_PCICORE_POSSIBLE
 which is missing because of missing dependency config: SSB_PCIHOST
 which is missing because of missing dependency config: SSB_PCIHOST_POSSIBLE
 disabling pseudo-config: B43_PCICORE_AUTOSELECT

The responsible config SSB_PCIHOST_POSSIBLE was disabled because
PCI_DRIVERS_LEGACY is not enabled. The PCI_DRIVERS_LEGACY config
dependency was added by the "bad" commit, which was apparently made to
fix build errors that resulted from a change a year ago. The problem,
as far as I can tell, is that the PCI_DRIVERS_LEGACY config is meant
to enable a MIPS-only API, but then it also disables building for
hardware that is not exclusive to MIPS, thus disabling my driver.

A solution would be to revert that commit, but the commit/kconfig
needs to be fixed....

Anyways, here is my device details from the working kernel, from the
output of lspci -vv

0c:00.0 Network controller: Broadcom Limited BCM4312 802.11b/g LP-PHY (rev 01)
    Subsystem: Dell Wireless 1397 WLAN Mini-Card
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 17
    Region 0: Memory at f69fc000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
    Capabilities: [58] Vendor Specific Information: Len=78 <?>
    Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [d0] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
SlotPowerLimit 6.500W
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <4us, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr+ BadTLP- BadDLLP- Rollover+ Timeout+ NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 14, ECRCGenCap+ ECRCGenEn-
ECRCChkCap+ ECRCChkEn-
            MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
        HeaderLog: 00000000 00000000 00000000 00000000
    Capabilities: [13c v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [160 v1] Device Serial Number 09-5e-5f-ff-ff-b8-00-22
    Capabilities: [16c v1] Power Budgeting <?>
    Kernel driver in use: b43-pci-bridge
    Kernel modules: ssb

Anyways, if it's relevant, those kernels are from Arch Linux.

Hopefully this isn't caught by spam filters this time... Sorry if it
sends twice.
