Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:52082 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYHXTaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 15:30:25 -0400
From: Chr <chunkeey@web.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 1/2] p54: take tx_queue's lock in rx_frame_sent
Date: Sun, 24 Aug 2008 21:32:48 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
References: <200808240315.07032.chunkeey@web.de> <48B1874F.2050005@lwfinger.net> <200808241955.05666.mb@bu3sch.de>
In-Reply-To: <200808241955.05666.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808242132.49004.chunkeey@web.de> (sfid-20080824_213030_071820_186608F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 August 2008 19:55:05 Michael Buesch wrote:
> On Sunday 24 August 2008 18:07:43 Larry Finger wrote:
> > Chr wrote:
> > > p54_rx_frame_sent will alter the tx_queue. Therefore we should hold
> > > the lock to protect against concurrent p54_assign_address calls.
> > >
> > > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > > ---
> > > hmm,
> > >
> > > (looking at [GIT]: Networking debate)
> > > linux-next. since there is no known regression that this patch could
> > > possibly fix... ---
> > > diff -Nurp a/drivers/net/wireless/p54/p54common.c
> > > b/drivers/net/wireless/p54/p54common.c ---
> > > a/drivers/net/wireless/p54/p54common.c	2008-08-23 21:13:37.000000000
> > > +0200 +++ b/drivers/net/wireless/p54/p54common.c	2008-08-24
> > > 02:11:35.000000000 +0200 @@ -432,7 +432,9 @@ static void
> > > p54_rx_frame_sent(struct iee
> > >  	struct memrecord *range = NULL;
> > >  	u32 freed = 0;
> > >  	u32 last_addr = priv->rx_start;
> > > +	unsigned long flags;
> > >
> > > +	spin_lock_irqsave(&priv->tx_queue.lock, flags);
> > >  	while (entry != (struct sk_buff *)&priv->tx_queue) {
> > >  		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
> > >  		range = (void *)info->driver_data;
> > > @@ -453,6 +455,8 @@ static void p54_rx_frame_sent(struct iee
> > >
> > >  			last_addr = range->end_addr;
> > >  			__skb_unlink(entry, &priv->tx_queue);
> > > +			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
> > > +
> > >  			memset(&info->status, 0, sizeof(info->status));
> > >  			entry_hdr = (struct p54_control_hdr *) entry->data;
> > >  			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
> > > @@ -470,12 +474,14 @@ static void p54_rx_frame_sent(struct iee
> > >  			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
> > >  			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
> > >  			ieee80211_tx_status_irqsafe(dev, entry);
> > > -			break;
> > > +			goto out;
> > >  		} else
> > >  			last_addr = range->end_addr;
> > >  		entry = entry->next;
> > >  	}
> > > +	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
> > >
> > > +out:
> > >  	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
> > >  	    sizeof(struct p54_control_hdr))
> > >  		p54_wake_free_queues(dev);
> >
> > I have a question about this. The code is OK, but I wonder if it might
> > not be clearer if the spin_unlock_irqrestore() in the second hunk were
> > deleted, and the label for "out" in the third hunk were moved up one
> > statement. That way the matching lock/unlock pair would be more obvious.
>
> Well, that way a lot more code is inside of the critical section.
> I'd say it's worth the "obfuscation", as this is a hotpath.
indeed... that's what I thought would be a better trade-off between
- formal / function correctness
- (locking) guide-lines conformance
- (patch-)size

But yes, originally I planned to spend a extra empty line right about the 
spin_unlock_irqrestore (the one inside the _while_ block), for
"eye friendliness"...

but I stuffed that on a second thought. I thought this extra
empty line would be waste of valuable resources, maybe someone
would complain about the amount of "cheese holes" in the code ;-).

Regards,
	Chr
