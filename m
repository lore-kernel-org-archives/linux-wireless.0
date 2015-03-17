Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54827 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbCQMw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:52:28 -0400
Message-ID: <1426596745.1985.47.camel@sipsolutions.net> (sfid-20150317_135231_691136_F7D07E54)
Subject: Re: [PATCH v3] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 13:52:25 +0100
In-Reply-To: <55081851.4030105@openwrt.org>
References: <1426587719-99940-1-git-send-email-nbd@openwrt.org>
	 <1426591453.1985.40.camel@sipsolutions.net> <55081851.4030105@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 13:04 +0100, Felix Fietkau wrote:

> >> @@ -1090,10 +1119,25 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
[...]
> >> +			drv_wake_tx_queue(local, txqi);
> >> +		}
> >> +	}
> > 
> > This could be an interesting race. If you wake the queue, and then the
> > station goes to sleep again before the driver had a chance to pull
> > frames, what happens? Should the driver be responsible for this? But you
> > don't have "unwake_tx_queue", so maybe you should not return any frame
> > from the dequeue in such a case?
> The driver is responsible for making sure that any queue of a sleeping
> sta is not scheduled.

Right but you're asking it to wake up the queue here, and if it goes to
sleep again quickly the driver might not have realized soon enough?

I guess the device would filter the frames though so it's probably not a
big deal, but could be interesting.

> >> +	struct txq_info *txqi;
> > 
> > Hm, so, internally you allocate one big thing and externally to the
> > driver you have a per-TID array.
> > 
> > Why not just remove this pointer, and keep only the per-TID array? You'd
> > have to do a bit more container_of() but I don't think that's a big
> > deal? Plus you can't really use this anyway since you can't index it,
> > i.e. you cannot say sta->txqi[t] since the size doesn't match up.
> Will do

Actually freeing it might be interesting then?

OTOH, you could just allocate each one separately as well, there's
little to be gained from doing a bigger allocation for all of them.

> > Doesn't this become awkward with powersave handling for bufferable mgmt
> > frames? They'd be stored on the per-station non-txq queues, but then the
> > wakeup handling needs to see which ones to take first? Having these on
> > the txqs might make that part easier?
> I guess I'll change it to throw bufferable mgmt frames in the txq as well.
> 
> > OTOH, I guess it would make building A-MPDUs or even A-MSDUs far more
> > complicated, so I guess it's a reasonable tradeoff.

Yeah I'm not so sure it's a great idea though since it's certainly
easier to do other things like A-MSDU/A-MPDU with only (QoS-)data frames
here.

Since, as you mentioned on IRC, you're also thinking about a sort of
fastpath I think then we should restrict that to only data frames and
not worry about any mgmt frames for such a fastpath.

> >> +	atomic_dec(&sdata->txqs_len[ac]);
> >> +	if (__netif_subqueue_stopped(sdata->dev, ac))
> >> +		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
> > 
> > Do you really want to do that unconditionally? There could be a lot of
> > frames on the queue still, or even on other station queues?
> Unconditionally? ieee80211_propagate_queue_wake checks the per-sdata txq
> limit.

Oh, right, I missed that part.

> > Anyway - overall I think this looks pretty good. What we discussed in
> > Ottawa was that we should perhaps forego the whole qdisc and netdev
> > queue start/stop and just do something like the qdisc would do in the
> > layer of these queues, although then we'd have to first convert every
> > driver or make this layer mandatory in some other way. That's something
> > we should explore here I think.
> I agree. Figuring out what tx queue scheduling should look like for
> devices with firmware based aggregation is going to be interesting
> though...

Yeah, though we're possibly also going to be moving in the direction of
having hardware queues managed closer to the stations, so that the
firmware could do better fairness between stations.

johannes

