Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0117.outbound.protection.outlook.com ([157.56.112.117]:39072
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbbIXHHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 03:07:13 -0400
Date: Thu, 24 Sep 2015 14:52:40 +0800
From: Daniel J Blueman <daniel@numascale.com>
Subject: Re: BCM4331 intermittent connectivity
To: <linux-wlan-client-support-list@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	FrankyLin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
CC: <linux-wireless@vger.kernel.org>
Message-ID: <1443077560.1799.1@outlook-emeawest.office365.com> (sfid-20150924_090730_062697_8517FC11)
In-Reply-To: <1431155435.27681.0@cpanel21.proisp.no>
References: <1428841870.17774.1@cpanel21.proisp.no>
	<1431155435.27681.0@cpanel21.proisp.no>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 9, 2015 at 3:10 PM, Daniel J Blueman <daniel@numascale.com> 
wrote:
> After gathering more data, we find this lockout issue occurs only on
> 5GHz networks, and on average with 15 hours of association (high
> variance). We see wl_timer consuming ~19% system time in ksoftirq [1]
> and no association or scan data. Soft-blocking and unblocking the
> interface allows reassociation.
> 
> Please let me know how I can help you (Broadcom) reproduce the issue
> there, since it hurts the usability of your products, and the users.

This issue has been in play for the last years and is still present in 
Ubuntu 15.10 (which ships the same Broadcom wl driver SVN rev as 
above), and all other linux distros, as they use this driver. Rarely, I 
have also seen system lockups ~5s after the wireless drops as a 
consequence of the driver spinning in wl_timer.

Since the same binary will affect other Broadcom wireless chipsets, 
this issue has significant impact. What data can I help provide to 
reproduce this issue there?

Daniel

> -- [1]
> 
> PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
> COMMAND
>   3 root      20   0       0      0      0 S  18.9  0.0   0:10.83
> ksoftirqd/0
> 
> 
> On Sun, Apr 12, 2015 at 8:31 PM, Daniel J Blueman
> <daniel@numascale.com> wrote:
>>  Dear Broadcom,
>> 
>>  I've been experiencing intermittent connectivity issues with your
>>  BCM4331 hardware [1] on the current 6.30.223.248 (r487574) driver 
>> for
>>  linux. I have observed the issue on a number of stable kernels all
>>  the way up to 3.19.3 mainline.
>> 
>>  When the issue occurs, wireless connectivity is lost and cannot be
>>  reestablished. Bringing the interface down and up, or soft-blocking
>>  and unblocking it do not allow reconnection; only a reboot solves
>>  this. During that time my system shows 200-500ms delays (eg moving
>>  the desktop cursor); the latency is shown in powertop [2].
>> 
>>  The issue has occurred across all 2.4GHz and 5GHz, WPA2, WEP,
>>  preshared key and IEEE 802.1X connection parameters; it occurs once
>>  every few days of use, but is of significant impact due to forcing
>>  reboot.
>> 
>>  What information will help you reproduce it in your lab? I tried the
>>  open-source drivers available for this hardware, but they are
>>  feature-incomplete, so I have to solicit your help here.
>> 
>>  Many thanks,
>>   Daniel
>> 
>>  -- [1]
>> 
>>  04:00.0 Network controller: Broadcom Corporation BCM4331
>>  802.11a/b/g/n (rev 02)
>>  	Subsystem: Apple Inc. AirPort Extreme
>>  	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>>  Stepping- SERR- FastB2B- DisINTx-
>>  	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>  <TAbort- <MAbort- >SERR- <PERR- INTx-
>>  	Latency: 0, Cache Line Size: 256 bytes
>>  	Interrupt: pin A routed to IRQ 17
>>  	Region 0: Memory at c1900000 (64-bit, non-prefetchable) [size=16K]
>>  	Capabilities: [40] Power Management version 3
>>  		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>>  PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>  		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
>>  	Capabilities: [58] Vendor Specific Information: Len=78 <?>
>>  	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>>  		Address: 0000000000000000  Data: 0000
>>  	Capabilities: [d0] Express (v1) Endpoint, MSI 00
>>  		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1
>>  unlimited
>>  			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>  		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>  			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>  			MaxPayload 128 bytes, MaxReadReq 512 bytes
>>  		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
>> TransPend-
>>  		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
>> Latency
>>  L0s <4us, L1 <64us
>>  			ClockPM+ Surprise- LLActRep+ BwNot-
>>  		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
>>  			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>>  		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
>>  BWMgmt- ABWMgmt-
>>  	Capabilities: [100 v1] Advanced Error Reporting
>>  		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>>  MalfTLP- ECRC- UnsupReq- ACSViol-
>>  		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
>>  MalfTLP- ECRC- UnsupReq- ACSViol-
>>  		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
>>  MalfTLP+ ECRC- UnsupReq- ACSViol-
>>  		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>  		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>  		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
>>  	Capabilities: [13c v1] Virtual Channel
>>  		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
>>  		Arb:	Fixed- WRR32- WRR64- WRR128-
>>  		Ctrl:	ArbSelect=Fixed
>>  		Status:	InProgress-
>>  		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>  			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>  			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>  			Status:	NegoPending- InProgress-
>>  	Capabilities: [160 v1] Device Serial Number 73-cd-b1-ff-ff-13-b8-f6
>>  	Capabilities: [16c v1] Power Budgeting <?>
>>  	Kernel driver in use: wl
>> 
>>  -- [2]
>> 
>>  $ sudo powertop
>>  Summary: 176.3 wakeups/second,  11.5 GPU ops/seconds, 0.0 VFS 
>> ops/sec
>>  and 128.8% CPU use
>> 
>>                 Usage       Events/s    Category       Description
>>             810.5 ms/s      0.00        Timer          wl_timer
>>             428.5 ms/s      0.00        Interrupt      [1]
>>  timer(softirq)
>>               1.6 ms/s      42.6        Process
>>  /usr/bin/gnome-shell
>>               3.3 ms/s      20.4        Process        gnome-terminal
>>              92.4 µs/s      20.0        Process        [rcu_sched]
>>             243.3 µs/s      18.7        Timer
>>  tick_sched_timer
>>  ...
>>  --
>>  Daniel J Blueman
>>  Principal Software Engineer, Numascale

