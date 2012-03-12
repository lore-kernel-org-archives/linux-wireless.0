Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2CLQth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 12:49:37 -0400
Received: by yhmm54 with SMTP id m54so2751720yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 09:49:36 -0700 (PDT)
Message-ID: <4F5E291D.8090809@lwfinger.net> (sfid-20120312_174941_172094_E684C69E)
Date: Mon, 12 Mar 2012 11:49:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: althaser <althaser@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Linux Kernel /staging/rtl8192e network module
References: <CAD=6cZrpC9WhoEZyespjt69LFR2Ay5vW5mSLojzY4cmrm-jPaQ@mail.gmail.com>
In-Reply-To: <CAD=6cZrpC9WhoEZyespjt69LFR2Ay5vW5mSLojzY4cmrm-jPaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 10:39 AM, althaser wrote:
> Dear Larry,
>
> I don't know if you are the right person to report this bug, but if you can
> report to the right place I would be grateful.
>
> ATM, the module rtl8192e (r8192e_pci.ko) isn't auto-loaded into the kernel.
> It is rtl8192se, but this module doesn't work with rtl8192e board.
>
> The right module should be r8192e_pci.
>
> I have:
>
> # lspci -vvv
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8192E/RTL8192SE
> Wireless LAN Controller (rev 01)
> Subsystem: Askey Computer Corp. Device 7160
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR+ FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort-
>  >SERR- <PERR- INTx-
> Interrupt: pin A routed to IRQ 16
> Region 0: I/O ports at 3000 [size=256]
> Region 1: Memory at f0700000 (32-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
> DevCap:MaxPayload 256 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> DevCtl:Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta:CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
> LnkCap:Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
> ClockPM+ Surprise- LLActRep- BwNot-
> LnkCtl:ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta:Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta:DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
> UEMsk:DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
> UESvrt:DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC-
> UnsupReq- ACSViol-
> CESta:RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> CEMsk:RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap:First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> Capabilities: [140 v1] Virtual Channel
> Caps:LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb:Fixed- WRR32- WRR64- WRR128-
> Ctrl:ArbSelect=Fixed
> Status:InProgress-
> VC0:Caps:PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb:Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl:Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
> Status:NegoPending- InProgress-
> Capabilities: [160 v1] Device Serial Number ea-db-a7-fe-ff-b6-26-00
>
>
> $ lshal
> udi = '/org/freedesktop/Hal/devices/pci_10ec_8192'
>    info.parent = '/org/freedesktop/Hal/devices/pci_8086_3b42'  (string)
>    info.product = 'RTL8192E/RTL8192SE Wireless LAN Controller'  (string)
>    info.subsystem = 'pci'  (string)
>    info.udi = '/org/freedesktop/Hal/devices/pci_10ec_8192'  (string)
>    info.vendor = 'Realtek Semiconductor Co., Ltd.'  (string)
>    linux.hotplug_type = 2  (0x2)  (int)
>    linux.subsystem = 'pci'  (string)
>    linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1c.0/0000:03:00.0'  (string)
>    pci.device_class = 2  (0x2)  (int)
>    pci.device_protocol = 0  (0x0)  (int)
>    pci.device_subclass = 128  (0x80)  (int)
>    pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1c.0/0000:03:00.0'
>   (string)
>    pci.product = 'RTL8192E/RTL8192SE Wireless LAN Controller'  (string)
>    pci.product_id = 33170  (0x8192)  (int)
>    pci.subsys_product_id = 29024  (0x7160)  (int)
>    pci.subsys_vendor = 'Askey Computer Corp.'  (string)
>    pci.subsys_vendor_id = 5199  (0x144f)  (int)
>    pci.vendor = 'Realtek Semiconductor Co., Ltd.'  (string)
>    pci.vendor_id = 4332  (0x10ec)  (int)
>
> running 3.2.9 kernel version

This is not a bug. There are two kinds of devices that have PCI ID 10ec:8192, 
and therefore 2 drivers. During the bus scan, it is possible that both of the 
drivers will be loaded. Each of them tests the PCI revision ID. If it is 0x10, 
then rtl8192se is the correct driver, whereas if it is 0x01, then r8192e_pci is 
needed. Kernel 3.2.9 contains the code for these tests.

If the correct driver is loaded first, then the second will never be tested; 
however, if the wrong one is first, then it will still be in memory, but it will 
be inactive and have no devices attached to it. That is likely the case with 
your system.

Is driver r8192e_pci generated for your kernel? What does 'modinfo r8192e_pci' 
show? A number of distros make the decision not to generate many modules from 
the staging tree. Perhaps yours is one of them.

Larry

