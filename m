Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030875Ab0B0VI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 16:08:56 -0500
Date: Sat, 27 Feb 2010 13:08:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <201002271836.04673.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.1002271301430.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain> <201002271836.04673.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 27 Feb 2010, Michael Buesch wrote:
> 
> Please check if the following patch makes any difference.

No difference. 

> Also please show me the result of the printks.

I get

	b43-pci-bridge 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
	b43-pci-bridge 0000:08:00.0: setting latency timer to 64
	dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
	ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
	ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
	ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
	ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
	ssb: Found rev 1 PMU (capabilities 0x02A62F01)
**	PMU res init 4312/4322
	ssb: SPROM revision 8 detected.
	ssb: Sonics Silicon Backplane found on PCI device 0000:08:00.0
	cfg80211: Calling CRDA to update world regulatory domain
	  alloc irq_desc for 22 on node -1
	  alloc kstat_irqs on node -1
	...
	b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
**	Set LDO 4312
**	Set LDO paref
	b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
	...
	b43-phy0 debug: Adding Interface type 2
	ADDRCONF(NETDEV_UP): wlan0: link is not ready
	b43-phy0 ERROR: Fatal DMA error: 0x00000800, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
	b43-phy0 ERROR: This device does not support DMA on your system. Please use PIO instead.
	b43-phy0 ERROR: CONFIG_B43_FORCE_PIO must be set in your kernel configuration.
	b43-phy0: Controller RESET (DMA error) ...
	...
	b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
**	Set LDO 4312
**	Set LDO paref
	b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.

for the new printks.

			Linus
