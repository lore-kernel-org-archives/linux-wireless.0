Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:54264 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYLJLyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 06:54:01 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/2] p54: enforce strict tx_queue limits
Date: Wed, 10 Dec 2008 12:54:02 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200812092109.00988.chunkeey@web.de> <493F2BC4.7040201@lwfinger.net>
In-Reply-To: <493F2BC4.7040201@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101254.02064.chunkeey@web.de> (sfid-20081210_125426_127636_0A6E9D3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 03:39:00 Larry Finger wrote:
> Christian Lamparter wrote:
> > The patch fixes an old FIXME in p54pci.c by moving the "queue full" 
> > check into the common library, where we can deal with it properly.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > ---
> > diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> > --- a/drivers/net/wireless/p54/p54common.c	2008-12-09 20:13:56.467888032 +0100
> > +++ b/drivers/net/wireless/p54/p54common.c	2008-12-09 20:49:21.235888230 +0100
> > @@ -889,7 +889,27 @@ static int p54_assign_address(struct iee
> >  		return -EINVAL;
> >  
> >  	spin_lock_irqsave(&priv->tx_queue.lock, flags);
> > +
> >  	left = skb_queue_len(&priv->tx_queue);
> > +	if (unlikely(left >= 28)) {
> > +		/*
> > +		 * The tx_queue is nearly full!
> > +		 * We have throttle normal data traffic, because we must
> > +		 * have a few spare slots for control frames left.
> > +		 */
> > +		ieee80211_stop_queues(dev);
> 
> I do not intend this as a criticism of the patch, but how do the queues get
> restarted after this?
> 

The idea is that p54_free_skb & p54_rx_frame_sent callbacks, which are
called whenever the firmware has finished processing a "device control"
or wifi frames. (And at that point there're atleast 28 pending frames,
so one should eventually get freed unless the firmware crashed!)

These routines unlink the frame form the tx_queue and call
p54_wake_free_queues if there's enough space for a new data frame.

Regards,
	Chr
