Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50029 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbZKRVPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:15:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 13:15:27 -0800
Date: Wed, 18 Nov 2009 13:15:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: move TX status processing to process context
Message-ID: <20091118211521.GK6581@tux>
References: <1258571772.30511.54.camel@johannes.local> <20091118195339.GB25188@bombadil.infradead.org> <1258574517.30511.61.camel@johannes.local> <20091118202334.GG6581@tux> <1258576479.30511.65.camel@johannes.local> <20091118210654.GI6581@tux> <1258578682.30511.82.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1258578682.30511.82.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 01:11:22PM -0800, Johannes Berg wrote:
> On Wed, 2009-11-18 at 13:06 -0800, Luis R. Rodriguez wrote:
> 
> > OK, but can't you still have a driver spam mac80211 with a lot of
> > ieee80211_tx_status_irqsafe() calls in soft irq context with the final
> > skb requiring the tx complete, in that case the queue *will* get stuffed
> > and you could potentially free more if so desired.
> 
> But it'll get stuffed one by one, and we free them as we stuff the
> queue, so it can't ever loop :)

Ah yes, I see... :)

> > Also, if our goal is to just avoid adding the skb if it does not require
> > a tx complete and our queue size is too large
> > 
> > 	if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
> > 	    num + 1 > IEEE80211_TX_STATUS_QUEUE_LIMIT)
> > 		dev_kfree_skb_irq(skb);
> > 	else
> > 		skb_queue_tail(&local->skb_queue)
> 
> No, we actually want to drop the older ones in that case.

Got it.. some info added behind this logic might help.

> > > However ... right now we never use _any_ unreliable at all, but I
> > > suspect we will want to change that again at some point.
> > 
> > Just curious -- what would be a use case for that?
> 
> Any time we don't need TX status for rate control it'd be OK to drop
> frames that we don't need the status for. For example the hw-rc case my
> patch from yesterday introduced.

Oh, haven't gotten to TX just yet, thanks this will probaby help.

  Luis
