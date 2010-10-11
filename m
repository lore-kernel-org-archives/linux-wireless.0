Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab0JKKA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 06:00:58 -0400
Subject: Re: [PATCH 2/4] wl1271: Fix TX starvation
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Ido Yariv <ido@wizery.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286791018.11177.484.camel@wimaxnb.nmp.nokia.com>
References: <1286786936-20544-1-git-send-email-ido@wizery.com>
	 <1286786936-20544-3-git-send-email-ido@wizery.com>
	 <1286791018.11177.484.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 12:00:56 +0200
Message-ID: <1286791256.3634.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 12:56 +0300, Juuso Oikarinen wrote:

> > @@ -537,6 +533,17 @@ static void wl1271_irq_work(struct work_struct *work)
> >  			    (wl->tx_results_count & 0xff))
> >  				wl1271_tx_complete(wl);
> >  
> > +			/* Check if any tx blocks were freed */
> > +			if ((wl->tx_blocks_available > prev_tx_blocks) &&
> > +					!skb_queue_empty(&wl->tx_queue)) {
> > +				/*
> > +				 * In order to avoid starvation of the TX path,
> > +				 * call the work function directly.
> > +				 */
> > +				cancel_work_sync(&wl->tx_work);
> 
> Hmm, isn't this causing a theoretical potential for a dead-lock? The
> tx_work could be waiting in mutex-lock already when cancel_work_sync is
> called, in which case cancel_work_sync would lock forever.
> 
> IIRC the irq_work and tx_work currently run in the same queue, so this
> may work with the current driver. Smells like a hazard anyway, and
> changing the workqueues for each work could easily lead to dead locks
> here. So at minimum I'd like to see it documented in the comment why
> this cannot cause a deadlock.

It should still cause a lockdep warning which you may want to avoid ...
and unless I'm looking at the wrong driver, this is in an irqs disabled
section which is wrong as well.

johannes

