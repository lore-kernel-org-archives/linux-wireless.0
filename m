Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:64942 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1DUHbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 03:31:48 -0400
Date: Thu, 21 Apr 2011 09:34:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 2/4] mwl8k: Add timestamp information for tx packets
Message-ID: <20110421073439.GV1897@wantstofly.org>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
 <1303191772-4299-2-git-send-email-nishants@marvell.com>
 <20110419075404.GK1897@wantstofly.org>
 <1303207700.20919.32.camel@localhost.localdomain>
 <20110419103144.GM1897@wantstofly.org>
 <1303218401.21371.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303218401.21371.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 06:36:41PM +0530, Nishant Sarmukadam wrote:

> > > > > Timestamp tx packets using a HW micro-second timer.
> > > > > This timestamp will be compared to the current timestamp
> > > > > in the hardware and if the difference is greater than 500ms,
> > > > > the packet will be dropped.
> > > > 
> > > > Why don't you do this entirely in the firmware?
> > > > 
> > > > When a packet is put into the TX ring by the host, give it a timestamp
> > > > of zero.
> > > > 
> > > > When the firmware gets a TX interrupt, have it walk the TX ring from
> > > > the last TX entry where a timestamp was written to (i.e. keep a separate
> > > > index for this), and timestamp all TX ring entries that are marked as
> > > > being FW OWNED but don't have a timestamp yet (and update your index).
> > > > 
> > > > Then when the time comes to process the TX packet (i.e. it has reached
> > > > the head of the TX queue), compare the timestamp with the current time.
> > > 
> > > Since firmware cannot access host memory directly, it needs additional
> > > dma operations to read all descriptors, then check the ownership bit and
> > > update the timestamp for the descriptors. It can easily take about 1us
> > > per descriptor for this and it can hit the peak throughput by about
> > > 2.5%.
> > 
> > That DMA needs to happen anyway, whether you have the host timestamp
> > the packets or not, so this doesn't seem to be an applicable argument.
> 
> Currently, firmware downloads a small fixed number of descriptors at a
> given time from any tx queue as it does not have memory to download all
> the descriptors from a host queue.
> 
> Assume that the total tx buffers available in firmware is X and host tx
> queue size is 2X and that the host queue is completely backlogged. In
> this case, the firmware needs to download the descriptors from the head
> of the host queue to transmit corresponding packets and it needs to
> download the descriptors at the tail of the host queue to timestamp
> them. But, firmware cannot transmit the packets associated with
> descriptors from the tail since there are packets in host queue which
> were queued earlier to these packets. This effectively results in each
> descriptor being downloaded twice - once for timestamp and once for
> transmission.

Point taken, but if the firmware has N buffers in its H/W TX ring,
does the host really need to have 2N buffers in its F/W TX ring?

There is another issue in that mwl8k H/W reports that a packet has been
transmitted OK even before the packet is attempted to be transmitted
(i.e. firmware marks the packet as transmitted as soon as the DMA for
the packet data completes), which sounds like a good candidate for
fixing at the same time.


> This will significantly affect the peak throughput performance.

Does that mean that you've implemented this and tried it out? :-)
