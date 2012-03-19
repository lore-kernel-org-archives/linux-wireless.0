Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab2CSHwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 03:52:43 -0400
Date: Mon, 19 Mar 2012 08:52:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <moorray@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3/5] rt2x00: rt2800usb: rework txstatus
 code
Message-ID: <20120319075223.GC2251@redhat.com> (sfid-20120319_085247_643595_E15E13BA)
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
 <1331720181-18564-3-git-send-email-sgruszka@redhat.com>
 <20120317175311.1cf09433@north>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120317175311.1cf09433@north>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 17, 2012 at 05:53:11PM +0100, Jakub Kicinski wrote:
> I feel a bit guilty to comment on a patch you have first posted more
> than a week ago and that have already been merged but to jump in with
No problems, it's never too late for code review :-)

> > Make changes on txdone work. Schedule it from
> > rt2800usb_tx_sta_fifo_read_completed() callback when first valid status
> > show up. Check in callback if tx status timeout happens, and schedule
> > work on that condition too. That make possible to remove tx status
> > timeout from generic watchdog. I moved that to rt2800usb.
> 
> Does above mean that you want to check for timeouts in
> rt2800usb_tx_sta_fifo_read_completed? You don't seem to be doing so.
Good catch, I'll post fix shortly.

> > +	if (rt2800usb_txstatus_pending(rt2x00dev) &&
> > +	    test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
> 
> I would put a bang before that test_and...
I don't understand what you mean, perhaps you could post a patch
or provide code snipset here, so I could comment.
 
> > +	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
> > +	       rt2800usb_txstatus_timeout(rt2x00dev)) {
> >  
> > -	rt2800usb_txdone_nostatus(rt2x00dev);
> > +		rt2800usb_txdone(rt2x00dev);
> >  
> > -	/*
> > -	 * The hw may delay sending the packet after DMA complete
> > -	 * if the medium is busy, thus the TX_STA_FIFO entry is
> > -	 * also delayed -> use a timer to retrieve it.
> > -	 */
> > -	if (rt2800usb_txstatus_pending(rt2x00dev))
> > -		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
> > +		rt2800usb_txdone_nostatus(rt2x00dev);
> > +
> > +		/*
> > +		 * The hw may delay sending the packet after DMA complete
> > +		 * if the medium is busy, thus the TX_STA_FIFO entry is
> > +		 * also delayed -> use a timer to retrieve it.
> > +		 */
> > +		if (rt2800usb_txstatus_pending(rt2x00dev))
> > +			rt2800usb_async_read_tx_status(rt2x00dev);
> 
> How is it possible that this call will ever start the timer? The
> reading "thread" won't exit if rt2800usb_txstatus_pending returns true
> and every dma_done will schedule reading itself.

I do not understand your objection here too. If rt2800usb_txstatus_pending()
will return true and if TX_STATUS_READING bit is not set, we will run hrtimer
to read status after 500 micro seconds. We exit the loop if kfifo is empty
and no entry timed out waiting to get corresponding TX status.

Thanks
Stanislaw
