Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2IJKXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 06:23:31 -0400
Message-ID: <1347272641.4272.1.camel@jlt4.sipsolutions.net> (sfid-20120910_122338_773437_5D863413)
Subject: Re: kernel 3.5.2/amd64: iwlwifi 0000:03:00.0: failed to allocate
 pci memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Marc MERLIN <marc@merlins.org>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, netdev@ger.kernel.org
Date: Mon, 10 Sep 2012 12:24:01 +0200
In-Reply-To: <1347130641.11167.0.camel@jlt4.sipsolutions.net> (sfid-20120908_205654_374994_2998A2BE)
References: <20120908161038.GF3347@merlins.org>
	 <1347122927.1234.849.camel@edumazet-glaptop>
	 <20120904003014.GB6287@merlins.org> <20120908170128.GK3347@merlins.org>
	 (sfid-20120908_190214_109241_625AC686) <1347130641.11167.0.camel@jlt4.sipsolutions.net>
	 (sfid-20120908_205654_374994_2998A2BE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-09-08 at 20:57 +0200, Johannes Berg wrote:

> > [856806.497959]  [<ffffffff810cf54c>] warn_alloc_failed+0x117/0x12c
> > [856806.497963]  [<ffffffff810d23af>] __alloc_pages_nodemask+0x6e3/0x792
> > [856806.497969]  [<ffffffff812b7f41>] ? pfn_to_dma_pte+0x116/0x15e
> > [856806.497976]  [<ffffffff810ff58b>] alloc_pages_current+0xcd/0xee
> > [856806.497979]  [<ffffffff810cecca>] __get_free_pages+0x9/0x45
> > [856806.497982]  [<ffffffff812ba67d>] intel_alloc_coherent+0x84/0xe7
> > [856806.497986]  [<ffffffff81085cf8>] ? arch_local_irq_save+0x15/0x1b
> > [856806.497999]  [<ffffffffa0b84afc>] iwl_ucode_callback+0xa49/0xc0d [iwlwifi]
> 
> Yes, unfortunately we need a whole bunch of contiguous memory to load
> the firmware.
> 
> > Any ideas?
> 
> Nothing we can do from the driver side, I'm afraid.

Turns out I was wrong. Here's a patch you can test. Note that we still
need a lot of DMA-coherent memory for other things, but at least for the
firmware image we don't.

http://p.sipsolutions.net/11ea33b376a5bac5.txt

johannes

