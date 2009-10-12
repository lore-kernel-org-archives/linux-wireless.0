Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:44170 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZJLNfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 09:35:32 -0400
Received: by qw-out-2122.google.com with SMTP id 9so551875qwb.37
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 06:34:25 -0700 (PDT)
Message-ID: <4AD3305E.5010308@gmail.com>
Date: Mon, 12 Oct 2009 08:34:22 -0500
From: Quintin Pitts <geek4linux@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
References: <4AD1EBA7.904@gmail.com> <4AD1FA5E.1010201@lwfinger.net> <4AD273B2.5000607@gmail.com> <200910121057.10381.chunkeey@googlemail.com>
In-Reply-To: <200910121057.10381.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon Oct 12 2009 03:57:10 GMT-0500 (CDT), Christian Lamparter wrote:
> On Monday 12 October 2009 02:09:22 Quintin Pitts wrote:
>> On Sun Oct 11 2009 10:31:42 GMT-0500 (CDT), Larry Finger wrote:
>>> On 10/11/2009 09:28 AM, Quintin Pitts wrote:
>>> As I understand it, this patch is to fix the driver to work around
>>> firmware errors. If that is correct, please state that clearly. If
>>> only partially correct, then indicate which parts are to fix firmware
>>> errors, and which are to fix driver errors. Has your analysis included
>>> thinking about where the driver might delay to avoid firmware problems.
>> I think Christian has hit the nail on the head.
>> Mostly flaky hardware or implementation (it8152 pci bridge) when pushed.
> 
> hmm, flaky hardware or simply incomplete linux support.
> you've said that it works with win ce,
> so I suppose the code is missing some important bits.
> 
> e.g.:
> 
> 00:06.0 Network controller: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
> Subsystem: Intersil Corporation Device 0000
> Flags: bus master, medium devsel, latency 56, IRQ 217
> 
> by the looks of it, something could wrong with the latency timer value.
> (what's lspci -vvnnxxx output for the card?)

00:06.0 Network controller [0280]: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] [1260:3886] (rev 01)
	Subsystem: Intersil Corporation Device [1260:0000]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 56 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 217
	Region 0: Memory at 11000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: prism54, p54pci
00: 60 12 86 38 06 01 90 02 01 00 80 02 08 38 00 00
10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 08 00 00 60 12 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 d9 01 0a 1c
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 01 fe
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

After the driver is up with the p54-latency patch:

00:06.0 Network controller [0280]: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] [1260:3886] (rev 01)
	Subsystem: Intersil Corporation Device [1260:0000]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 80 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 217
	Region 0: Memory at 11000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: p54pci
	Kernel modules: prism54, p54pci
00: 60 12 86 38 16 01 98 02 01 00 80 02 08 50 00 00
10: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 08 00 00 60 12 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 d9 01 0a 1c
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 01 fe
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

> 
> I've attached a minimal patch which c&p some latency-timer related logic
> from the original prism54 driver code to p54pci.
> Can you please give this a try?

Still same weird results with p54-latency patch.  Triggering my condition
statements. under a 3 minute iperf test.

p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: index > ring_index diff *index=176894 devidx=176640 hostidx=
176901 ring_limit=8 Returning call!                                             
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!                   
p54p_check_rx_ring: rx_ring len/flags has address - skipping!     

> I don't have a p54pci available for testing right now.
> 
> Regards,
> 	Chr

Thanks,

Quintin.
