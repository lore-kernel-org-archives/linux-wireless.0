Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:35048 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab2CSNNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:13:47 -0400
Date: Mon, 19 Mar 2012 14:13:39 +0100
From: Jakub Kicinski <moorray@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3/5] rt2x00: rt2800usb: rework txstatus
 code
Message-ID: <20120319141339.3596b6d8@north> (sfid-20120319_141357_197592_09FA3D59)
In-Reply-To: <20120319075223.GC2251@redhat.com>
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
	<1331720181-18564-3-git-send-email-sgruszka@redhat.com>
	<20120317175311.1cf09433@north>
	<20120319075223.GC2251@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Mon, 19 Mar 2012 08:52:24 +0100
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> > > +	if (rt2800usb_txstatus_pending(rt2x00dev) &&
> > > +	    test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
> > 
> > I would put a bang before that test_and...
> I don't understand what you mean, perhaps you could post a patch
> or provide code snipset here, so I could comment.

If I understand correctly, status should be read again if there are
pending entries and no one else has set TX_STATUS_READING yet. In that
case return value of test_and_set_bit should be negated. I might be
missing something though.

> > > +	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
> > > +	       rt2800usb_txstatus_timeout(rt2x00dev)) {
> > >  
> > > -	rt2800usb_txdone_nostatus(rt2x00dev);
> > > +		rt2800usb_txdone(rt2x00dev);
> > >  
> > > -	/*
> > > -	 * The hw may delay sending the packet after DMA complete
> > > -	 * if the medium is busy, thus the TX_STA_FIFO entry is
> > > -	 * also delayed -> use a timer to retrieve it.
> > > -	 */
> > > -	if (rt2800usb_txstatus_pending(rt2x00dev))
> > > -		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
> > > +		rt2800usb_txdone_nostatus(rt2x00dev);
> > > +
> > > +		/*
> > > +		 * The hw may delay sending the packet after DMA complete
> > > +		 * if the medium is busy, thus the TX_STA_FIFO entry is
> > > +		 * also delayed -> use a timer to retrieve it.
> > > +		 */
> > > +		if (rt2800usb_txstatus_pending(rt2x00dev))
> > > +			rt2800usb_async_read_tx_status(rt2x00dev);
> > 
> > How is it possible that this call will ever start the timer? The
> > reading "thread" won't exit if rt2800usb_txstatus_pending returns true
> > and every dma_done will schedule reading itself.
> 
> I do not understand your objection here too. If rt2800usb_txstatus_pending()
> will return true and if TX_STATUS_READING bit is not set, we will run hrtimer
> to read status after 500 micro seconds. We exit the loop if kfifo is empty
> and no entry timed out waiting to get corresponding TX status.

Yes, I don't mean that this code is wrong. I just think that
rt2800usb_async_read_tx_status have no chance of actually going past
TX_STATUS_READING check. If every dma_done schedules reading and
reading stops only when all pending entries have their statuses then
call to rt2800usb_async_read_tx_status after we processed statuses is
excessive.

All that said, I haven't tested this hypothesis and may be completely
wrong (again). Also I _don't_ mean that this call should be removed,
just wanted to me sure I understand everything correctly ;-)

  -- Kuba
