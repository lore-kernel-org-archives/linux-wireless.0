Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37182 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbdEEJjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 05:39:23 -0400
Message-ID: <1493977157.2500.2.camel@sipsolutions.net> (sfid-20170505_113955_125252_FEE52B16)
Subject: Re: [PATCH] mac80211: Create ieee80211_if_process_skb from
 ieee80211_iface_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 May 2017 11:39:17 +0200
In-Reply-To: <1493976873.31950.15.camel@perches.com>
References: <401d68b9015dc036589c99a26ef4664000cc821e.1493919003.git.joe@perches.com>
         <1493975178.2500.0.camel@sipsolutions.net>
         <1493976873.31950.15.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-05-05 at 02:34 -0700, Joe Perches wrote:
> On Fri, 2017-05-05 at 11:06 +0200, Johannes Berg wrote:
> > > o Use explicit casts to proper types instead of casts to (void *)
> > >   and have the compiler do the implicit cast
> > 
> > I see no advantage in this, why? All it does is make the code
> > longer,
> > and if anything changes, you have to change it in multiple places
> > now.
> 
> It makes use of the casted to types consistent within net/mac80211
> 
> Here are the current uses.  I changed iface .c to match the others.

Well, OK. I'd rather change the others I guess, don't really see the
point.

> $ grep -P --include=*.[ch] "\((\w++\s*){1,2}\s*\*\).*skb->cb" net/mac80211
> net/mac80211/iface.c:			ra_tid = (void *)&skb->cb;
> net/mac80211/iface.c:			ra_tid = (void *)&skb->cb;
> net/mac80211/iface.c:			rx_agg = (void *)&skb->cb;
> net/mac80211/iface.c:			rx_agg = (void *)&skb->cb;
> net/mac80211/agg-tx.c:	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
> net/mac80211/agg-tx.c:	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
> net/mac80211/agg-rx.c:	rx_agg = (struct ieee80211_rx_agg *) &skb->cb;

It's really just these three that are related to the iface.c ones
anyway.

> net/mac80211/mlme.c:	struct ieee80211_rx_status *rx_status = (void *) skb->cb;
> net/mac80211/mlme.c:	rx_status = (struct ieee80211_rx_status *) skb->cb;
> 

These should be using IEEE80211_SKB_RXCB(skb) :)

johannes
