Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52462 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0JGVwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:52:08 -0400
Message-ID: <4CAE4101.2020600@candelatech.com>
Date: Thu, 07 Oct 2010 14:52:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
In-Reply-To: <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 02:31 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 7, 2010 at 12:27 PM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>> On Thu, 2010-10-07 at 12:22 -0700, Ben Greear wrote:
>>
>>> After reboot, and re-run of the script,
>>> I saw this in the logs, and shortly after,
>>> the SLUB poison warning dumped to screen.
>>>
>>> Maybe those DMA errors are serious?
>>
>>> ath: Failed to stop TX DMA in 100 msec after killing last frame
>>> ath: Failed to stop TX DMA. Resetting hardware!
>>
>> That's TX DMA, it can hardly result in invalid memory writes like the
>> ones you've been seeing.
>>
>> I'm still convinced something is wrong with ath9k RX DMA, as you've seen
>> the contents of frames written to already freed memory regions. Since I
>> don't know anything about ath9k, you should probably not rely on me
>> though :-)
>
> I'm on this now. Lets play.
>
> I had to remove  /lib/udev/rules.d/75-persistent-net-generator.rules
> to avoid Ubuntu trying to remember the device names and it creating
> stax_rename names.

Right, we disable udev for 'sta*' devices.

> I just ran your script with some modifications. You can find it here:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/poo.pl

Can you post your kernel .config somewhere, and confirm which
kernel you are using?

Also, what ath9k NIC, platform, etc?

We see the problem on two different systems (haven't tried more).  I can
figure out the brands of the NICs if that helps, and have included
lspci information below.

I've uploaded my kernel config to here:
http://www.candelatech.com/~greearb/ctwl_kernel.cfg


* Dual core Intel Pentium-D 32-bit
   2GB RAM
   Fedora 13 (but with custom compiled top-of-tree iw, hostap, libnl
   Atheros NIC: from lspci -vv:
    08:01.0 Network controller: Atheros Communications Inc. AR922X Wireless Network Adapter (rev 01)
	Subsystem: Device 0777:4002
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B+ DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at d0300000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=100mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: ath9k

*  Dual-core Intel Atom, 32-bit
    1GB RAM
    Fedora 13 (custom compiled top-of-tree iw, hostap, libnl)
    Atheros mini-pcie NIC, from lspci -vv:
     03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Device 0777:4e05
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at febf0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM unknown, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [90] MSI-X: Enable- Count=1 Masked-
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntrySize=0
		Arb:	Fixed- WRR32- WRR64- WRR128- 100ns- onfig- - - TableOffset=0
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256- Fixed- RR32-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k
	Kernel modules: ath9k

>
> I then ran:
>
> for i in $(seq 0 31) ; do sudo dhclient seq$i; done
>
> It took about 10 minutes to get IP addresses for all interfaces but it
> got there eventually. Odd enough I was unable to ping the AP from any
> interface though. Not sure what that was about. But I got no oops, no
> slub dump. All I got was some more delba warnings which seems to
> indicate we haven't caught all the cases for its use:

If you just create one or two interfaces, can you ping as expected?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

