Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726850AbeILB6x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 21:58:53 -0400
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
To: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8bea4cfc-4b16-7c7c-3e9a-5b6684b47345@infradead.org> (sfid-20180911_225829_635281_A71D337B)
Date: Tue, 11 Sep 2018 13:57:45 -0700
MIME-Version: 1.0
In-Reply-To: <1536651177.3224.106.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/11/18 12:32 AM, Johannes Berg wrote:
> On Mon, 2018-09-10 at 19:17 -0700, Randy Dunlap wrote:
>> Hi,
>>
>> Any ideas?
> 
> Hmm. Is this new?

I can't be sure.  I've been having problems booting this laptop for a few
weeks now but haven't tracked it down yet.

>> 2018-09-10T18:47:54.532837-07:00 dragon kernel: [   31.472371] kernel BUG at ../kernel/dma/swiotlb.c:521!
> 
>         nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
> 	[...]
> 	BUG_ON(!nslots)
> 
>> 2018-09-10T18:47:54.613655-07:00 dragon kernel: [   31.490325]  swiotlb_alloc+0x88/0x170
>> 2018-09-10T18:47:54.613656-07:00 dragon kernel: [   31.490329]  ? __kmalloc+0x1cc/0x200
>> 2018-09-10T18:47:54.613657-07:00 dragon kernel: [   31.491652]  iwl_pcie_txq_alloc+0x1d4/0x3b0 [iwlwifi]
> 
> There are two calls to dma_alloc_coherent() here, should those even hit
> swiotlb? The sizes of those should be
>  * 256 x 128 (32k)
>  * 32 x 256 (8k) [TFH, unlikely to be the case here]
>  * 256 x 256 (65k) [TFH]
>  * 32 x 64 (2k)
>  * 256 x 64 (16k)
> 
> 
> IO_TLB_SHIFT is 11, so we get 2k alignment, so even the smallest size
> (32*64) should result in nslots being 1?
> 
> In fact, unless the driver passed *ZERO* as the size, this should never
> happen (hence the BUG_ON), since ALIGN() would take care of rounding up
> any smaller allocation here.
> 
> Presumably you can reproduce this pretty easily (and I don't know what
> specific model of NIC you have etc.), so perhaps you can do something
> like this?

The wireless NIC is Condor Peak:

04:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000 [Condor Peak]
	Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at c2600000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0800c  Data: 4162
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [140 v1] Device Serial Number 74-e5-0b-ff-ff-2d-dc-28
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi



sigh.  I can reproduce it without the patch:

> https://p.sipsolutions.net/aa0dccd7a60fe176.txt

but with that patch, it just hangs after about 25 seconds of booting
(slow hard drive, not SSD).

I'll try some other ways.

-- 
~Randy
