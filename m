Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36619 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbANKOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P1DwErJr6O2OGR7Sr12g3-OKYKEBTQ+wSZiSS=NUoCqEw@mail.gmail.com>
References: <1421224274.2012.2.camel@gmail.com>
	<1421224818.2012.4.camel@gmail.com>
	<CANUX_P1DwErJr6O2OGR7Sr12g3-OKYKEBTQ+wSZiSS=NUoCqEw@mail.gmail.com>
Date: Wed, 14 Jan 2015 14:14:46 +0400
Message-ID: <CAFMg4WBnNhVWf8ouFqWVwpbp5TQ0XrxTC_8vvLDSVBemA0N-Kw@mail.gmail.com> (sfid-20150114_111453_491899_17208812)
Subject: Re: [REGRESSION] iwlfiwi with Intel Centrino N1000 won't work with power_save
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Wysocki, Rafael" <rafael@kernel.org>,
	Alex Nik <rage.iz.me@gmail.com>,
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 14, 2015 at 12:53 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Wed, Jan 14, 2015 at 10:40 AM, Igor Gnatenko
> <i.gnatenko.brain@gmail.com> wrote:
>> On Wed, 2015-01-14 at 11:31 +0300, Igor Gnatenko wrote:
>>> Hi,
>>>
>>> I got report from people that on Intel Centrino N1000 wifi won't
>>> work after
>>> updating to 3.17.8. I see in that release Fedora maints enabled
>>> POWERCAP and
>>> INTEL RAPL. We got working wifi only after disabling powersave via
>>> `iw dev wlp2s0 set power_save off`.
>
> What kernel version did you have before?
> BTW - for this device, power save is supposed to be disabled by
> default, but I need to check
3.17.4
>>>
>>> How we can debug this?
>>>
>>> lspci above.
>>>
>>> 02:00.0 Network controller [0280]: Intel Corporation Centrino
>>> Wireless- N 1000 [Condor Peak] [8086:0084]
>>>         Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
>>> [8086:1315]
>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
>>> >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>         Latency: 0, Cache Line Size: 64 bytes
>>>         Interrupt: pin A routed to IRQ 28
>>>         Region 0: Memory at d1500000 (64-bit, non-prefetchable)
>>> [size=8K]
>>>         Capabilities: [c8] Power Management version 3
>>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0+,D1-
>>> ,D2-,D3hot+,D3cold+)
>>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0
>>> PME-
>>>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>                 Address: 00000000fee0800c  Data: 4122
>>>         Capabilities: [e0] Express (v1) Endpoint, MSI 00
>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
>>> L0s
>>> <512ns, L1 unlimited
>>>                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>>> Unsupported-
>>>                 RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>>>                 MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr+ TransPend-
>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s
>>> L1,
>>> Exit Latency L0s <128ns, L1 <32us
>>>                 ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
>>> CommClk+
>>>                 ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>         Capabilities: [100 v1] Advanced Error Reporting
>>>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>>> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>>                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
>>> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
>>> NonFatalErr-
>>>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
>>> NonFatalErr+
>>>                 AERCap: First Error Pointer: 00, GenCap- CGenEn-
>>> ChkCap- ChkEn-
>>>         Capabilities: [140 v1] Device Serial Number 74-e5-0b-ff-ff-
>>> cc-
>>> 82-24
>>>         Kernel driver in use: iwlwifi
>>>         Kernel modules: iwlwifi
>>> --
>>> -Igor Gnatenko
>> CC linux-pm@
>> --
>> -Igor Gnatenko



-- 
-Igor Gnatenko
