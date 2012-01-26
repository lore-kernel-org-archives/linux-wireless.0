Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2AZVdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 16:33:49 -0500
Date: Thu, 26 Jan 2012 15:33:44 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20120126213344.GC14465@ubuntu-macmini> (sfid-20120126_223400_350032_F10226C3)
References: <4EE7B85E.3070802@lwfinger.net>
 <20111213212606.GB30788@thinkpad-t410>
 <4EE82CC6.2030307@lwfinger.net>
 <20111214162333.GB19410@thinkpad-t410>
 <4EE8D150.8090100@lwfinger.net>
 <20111214164902.GD19410@thinkpad-t410>
 <4EE8D5A1.7040600@lwfinger.net>
 <20111214171234.GE19410@thinkpad-t410>
 <4EE8E035.90501@lwfinger.net>
 <20111214175804.GG19410@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111214175804.GG19410@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 11:58:04AM -0600, Seth Forshee wrote:
> On Wed, Dec 14, 2011 at 11:43:17AM -0600, Larry Finger wrote:
> > Seth,
> > 
> > As expected, my RTL8188SE came right up.
> > 
> > The lspci -nnv details for my card are
> > 
> > 06:00.0 0280: 10ec:8176 (rev 01)
> >         Subsystem: 10ec:8176
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR+ FastB2B- DisINTx-
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> > >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0, Cache Line Size: 64 bytes
> >         Interrupt: pin A routed to IRQ 21
> >         Region 0: I/O ports at 4000 [size=256]
> >         Region 2: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
> >         Capabilities: <access denied>
> >         Kernel driver in use: rtl8192ce
> > 
> > Does yours also have 10ec:8176 as the PCI ID?
> 
> Yes.
> 
> 07:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
> 	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8184]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at 2000 [size=256]
> 	Region 2: Memory at f0100000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: rtl8192ce
> 	Kernel modules: rtl8192ce

Sorry for the long silence on this, I was busy with some other things.
But I've been playing with it again this week and uncovered some new
information regarding the failures.

I noticed the other day that the rtl8188ce was no longer having trouble
associating with this AP. After playing around in the router settings I
discovered that it works fine so long as the router isn't on channel 1.
So then I configured my other router to use channel 1, and then I
started seeing problems with that router as well.

I also tried the rtl8192ce driver from Realtek's website, and I'm having
better luck with that driver.

Seth
