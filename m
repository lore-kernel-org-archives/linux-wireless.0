Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab0BPAnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 19:43:07 -0500
Date: Mon, 15 Feb 2010 19:55:46 -0500
From: Josef Bacik <josef@redhat.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH] rt2800pci: actually handle tx interrupts
Message-ID: <20100216005545.GA3510@dhcp231-156.rdu.redhat.com>
References: <20100215185933.GA12592@localhost.localdomain> <201002160048.38387.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201002160048.38387.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 12:48:38AM +0100, Ivo van Doorn wrote:
> Hi,
> 
> > 1) We don't handle _any_ of the DMA_DONE interrupts, so we don't actually remove
> > any of the entries when the card tells us we are done.  This is easy enough to
> > fix.
> 
> Yes, but your fix is removing the handler INT_SOURCE_CSR_TX_FIFO_STATUS
> which probably should still be handled anyway.
> 
> > 2) Turns out we are depending on the TX_STA_FIFO register on the card to give us
> > per-tx statistics, but it appears to only be a sort of global statistic thing
> > that doesn't even work most of the time.  I seperated out all of the TX_STA_FIFO
> > reading stuff and either TX_STA_FIFO_VALID would be 0,
> > TX_STA_FIFO_TX_ACK_REQUIRED would be 0, or TX_STA_FIFO_WCID would be 254, which
> > is way higher than the queue limit.  So basically it gives us crap statistics.
> 
> I am not seeing this check in the code, only the complete removal of the TX_STA_FIFO handling.
>

Yeah sorry I wired up a whole lot of code to check the values of TX_STA_FIFO and
it turned out to never produce anything usefull, so I just killed it.  I'll put
it back to handle INT_SOURCE_CSR_TX_FIFO_STATUS.
 
> > Looking through RaLinks driver it doesn't seem there is a way to get per-tx
> > statistics, so you can't really tell if the tx failed or not.  So I've fixed
> > rt2800pci_txdone to just say the tx succeeded and call rt2x00lib_txdone and be
> > done with it.  I'm sure this is horribly wrong, but looking at the RaLink driver
> > doesn't seem to indicate anyway to fail/retry a particular packet, so I'm not
> > sure if there is anything else that can be done.
> 
> Returning success is bogus, it must return status unknown just like the USB drivers do.
> It is up to rt2x00lib to determine if that should resolve to success or not (at the moment
> it will resolve to success).
> 

Oh ok sounds good, I'll do that.  Thanks,

Josef
