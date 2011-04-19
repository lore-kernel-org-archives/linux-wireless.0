Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:55902 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1DSK2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 06:28:52 -0400
Date: Tue, 19 Apr 2011 12:31:44 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 2/4] mwl8k: Add timestamp information for tx packets
Message-ID: <20110419103144.GM1897@wantstofly.org>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
 <1303191772-4299-2-git-send-email-nishants@marvell.com>
 <20110419075404.GK1897@wantstofly.org>
 <1303207700.20919.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303207700.20919.32.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 03:38:20PM +0530, Nishant Sarmukadam wrote:

> > > Timestamp tx packets using a HW micro-second timer.
> > > This timestamp will be compared to the current timestamp
> > > in the hardware and if the difference is greater than 500ms,
> > > the packet will be dropped.
> > 
> > Why don't you do this entirely in the firmware?
> > 
> > When a packet is put into the TX ring by the host, give it a timestamp
> > of zero.
> > 
> > When the firmware gets a TX interrupt, have it walk the TX ring from
> > the last TX entry where a timestamp was written to (i.e. keep a separate
> > index for this), and timestamp all TX ring entries that are marked as
> > being FW OWNED but don't have a timestamp yet (and update your index).
> > 
> > Then when the time comes to process the TX packet (i.e. it has reached
> > the head of the TX queue), compare the timestamp with the current time.
> 
> Since firmware cannot access host memory directly, it needs additional
> dma operations to read all descriptors, then check the ownership bit and
> update the timestamp for the descriptors. It can easily take about 1us
> per descriptor for this and it can hit the peak throughput by about
> 2.5%.

That DMA needs to happen anyway, whether you have the host timestamp
the packets or not, so this doesn't seem to be an applicable argument.


> Also, when the firmware is processing the packets from the host tx
> queues, it keeps the host interrupt for tx packets disabled to avoid
> unnecessary interruptions. Hence, the timestamp in the firmware can
> deviate from when the packet was queued in the host queue. 

Right, but that is an (easily fixable?) implementation detail, and not
a reason for why this fundamentally cannot work.


> > As an added bonus, this'll also work over USB/SPI/whatever other bus
> > type where you cannot read some H/W microsecond timestamp register
> > directly like you can on PCI(e) -- which sticks out like a sore thumb
> > because it goes around the clean command / ring based host<->firmware
> > interface.
> 
> We agree that this approach will not work without additional changes
> for non-PCI devices. However, we do not foresee such devices being
> supported by mwl8k in the near future.  

It's still an ugly layering violation, IMHO.  But if MRVL is OK with it...
