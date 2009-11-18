Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49752 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbZKRVMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:12:00 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 13:12:07 -0800
Date: Wed, 18 Nov 2009 13:12:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: move TX status processing to process context
Message-ID: <20091118211201.GJ6581@tux>
References: <1258571772.30511.54.camel@johannes.local> <20091118195339.GB25188@bombadil.infradead.org> <1258574517.30511.61.camel@johannes.local> <20091118202334.GG6581@tux> <1258576479.30511.65.camel@johannes.local> <20091118210654.GI6581@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091118210654.GI6581@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 01:06:54PM -0800, Luis Rodriguez wrote:
> 
> OK, but can't you still have a driver spam mac80211 with a lot of
> ieee80211_tx_status_irqsafe() calls in soft irq context with the final
> skb requiring the tx complete, in that case the queue *will* get stuffed
> and you could potentially free more if so desired.
> 
> Also, if our goal is to just avoid adding the skb if it does not require
> a tx complete and our queue size is too large

Hit send too early, I meant if our goal is to avoid adding the skb
if we've reached our limit why not just ree it immediately instead
of queing it and dequeing it. Wouldn't we even be able to just
return and not bother mac80211 about it at all?

> 
>         if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) &&
>             num + 1 > IEEE80211_TX_STATUS_QUEUE_LIMIT)
		{
>                 dev_kfree_skb_irq(skb);
		return;
	}
>         else
>                 skb_queue_tail(&local->skb_queue)
