Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:59753 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbcFSDRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 23:17:34 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software queues. 
In-reply-to: Your message of Sat, 18 Jun 2016 21:05:05 +0200.
             <20160618190505.24038-1-toke@toke.dk>
Date: Sat, 18 Jun 2016 23:17:13 -0400
Message-Id: <E1bETEY-0000BM-00@www.xplot.org> (sfid-20160619_051739_098479_35F1962C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




Oh cool.. I will try to understand this patch thoroughly in the next
couple of days.

My patch (both v1 and v2) have one or two bugs (depending on exactly
how you count bugs and/or my confusion) (that I know of).

At first glance my first bug appears to remain in your reworked patch:

>  
> +static struct sk_buff *
> +ath_tid_pull(struct ath_atx_tid *tid)
> +{
> +	struct ath_softc *sc = tid->an->sc;
> +	struct ieee80211_hw *hw = sc->hw;
> +	struct ath_tx_control txctl = {
> +		.txq = tid->txq,
> +		.sta = tid->an->sta,
> +	};
> +	struct sk_buff *skb;
> +	struct ath_frame_info *fi;
> +	int q;
> +
> +	if (!tid->has_queued)
> +		return NULL;
> +
> +	skb = ieee80211_tx_dequeue(hw, container_of((void*)tid, struct ieee80211_txq, drv_priv));
> +	if (!skb) {
> +		tid->has_queued = false;
> +		return NULL;
> +	}
> +
> +	if (ath_tx_prepare(hw, skb, &txctl)) {
> +		ieee80211_free_txskb(hw, skb);
> +		return NULL;
> +	}
> +
> +	q = skb_get_queue_mapping(skb);
> +	if (tid->txq == sc->tx.txq_map[q]) {
> +		fi = get_frame_info(skb);
> +		fi->txq = q;
> +		++tid->txq->pending_frames;
> +	}
> +
> +	return skb;
> + }
> +
> +

The increment of ->pending_frames lacks a corresponding check against
sc->tx.txq_max_pending to see if we've reached the limit.  (Which begs
the question: what to do if it has?)

I discovered this bug doing experiments by trying to turn down the
various /sys/kernel/debug/ieee80211/phy0/ath9k/qlen_* to low numbers
(including as low as one, and then even zero) and found it had no
effect.

OK, so that's one bug.


The second more mysterious bug which I'm still struggling to
understand is why doesn't large values in these ath9k/qlen_* (or more
accurately, given the first bug above, the failure to check these qlen
limit values at all) allow for increased hardware queue bloat (with
observable delay).  I suspect that is because the driver with my patch
to use the new intermediate queues is doing something silly like
failing to have more than one aggregate at a time hooked up in the
hardware transmit queue for transmission.  But I haven't figured out
what is really happening yet.  And this bug (depending on what exactly
it turns out to be) might make the low latency results some of you
have seen somewhat problematic to understand because it might be the
case that with my patch as it is (up to now) there's a flaw that leads
to low latency and gives up some throughput by simply failing to keep
the device busy transmitting packets when there are packets to send.

Fixing this bug might increase latency...  my plan all along has been
to put something in akin to autotuning like we have in bql/dql in
wired network interfaces.  Note the right amount to queue depends on
CPU performance capability in running the driver... that's why it
needs to be autotuned at run time.


But anyway, Toke, between struggling to understand this second bug and
some distractions I neglected to answer your question of almost two
weeks ago when you said:

> What's the symptom of this? As I said I haven't noticed anything, but it
> might be worth looking out for.

So now I've finally tried to answer that question.  Perhaps with your
recent work on this patch your head is loaded with context that might
be helpful in understanding this.

Tomorrow (after I get some sleep) I'm planning on taking a look at
what ath9k looks like with this patch of yours applied and see if that
makes it any easier to figure out what to do about the above bug(s) in
my original patch.

			-Tim Shepard
			 shep@alum.mit.edu
