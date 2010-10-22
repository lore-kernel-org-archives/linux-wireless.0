Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab0JVPBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:01:18 -0400
Date: Fri, 22 Oct 2010 17:04:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] iwlwifi: fix set_tx_power vs scan
Message-ID: <20101022150414.GA5645@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
 <1286983100.10446.1.camel@wwguy-ubuntu>
 <20101014083204.GA2286@redhat.com>
 <20101021131348.GA5654@redhat.com>
 <20101022125628.GA4527@redhat.com>
 <1287758367.18168.1.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287758367.18168.1.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Fri, Oct 22, 2010 at 07:39:27AM -0700, Guy, Wey-Yi wrote:
> > Not true. I have the same problem with vanilla 2.6.36 without any of my
> > patches (further investigation show this is 2.6.34 -> 2.6.35
> > regression). Problem happens only on 5Ghz, that confused me 
> > because NetworkManager in some cases connects to 5Ghz, in others to
> > 2.4Ghz on my system.
> > 
> > Since my patches do not screw up (at least not that thing :) I'm going
> > to repost them, also further bisect this "low ack count detected" issue.
> > 
> 
> the error message indicate "low ack count" received by driver. not sure
> how it happen? is it only happen on 5GHz, or the problem on both band?

Only on 5GHz and iwl 5300:

40:00.0 Network controller [0280]: Intel Corporation Ultimate N WiFi Link 5300 [8086:4235]
	Subsystem: Intel Corporation Device [8086:1001]
	Physical Slot: 3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 91
	Region 0: Memory at f3100000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4193
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-21-6a-ff-ff-6d-18-8e
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

Not reproducible on 2.6.34.7 , 100% reproducible on 2.6.35.7 and 2.6.36 .
I'm going to bisect ... or maybe there is some better way of debug
this problem?

Stanislaw
