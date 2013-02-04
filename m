Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3BDP2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:28:08 -0500
Message-ID: <1359991708.10311.15.camel@jlt4.sipsolutions.net> (sfid-20130204_162812_484067_B12F0F09)
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Amit Shakya <amit.shakya@stericsson.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Feb 2013 16:28:28 +0100
In-Reply-To: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 16:48 +0530, Amit Shakya wrote:
> In case of multiple virtual interface, if AES is configured on multiple
> interface then there are chances of stored PN corruption, causing traffic
> to stop.

Interesting, nice find.

> In case, ieee80211_rx_handlers processing is going on for skbs received on
> one vif and at the same time, rx aggregation reorder timer expires on
> another vif then sta_rx_agg_reorder_timer_expired is invoked and it will
> push skbs into the single queue (local->rx_skb_queue).
> ieee80211_rx_handlers in the while loop assumes that the skbs are for the
> same TID and same sta. 

This is because of struct ieee80211_rx_data, presumably? IOW, the loop
doesn't really assume it, it's the fact that the loop is called with a
given struct ieee80211_rx_data, right?

> This assumption doesn't hold good in this scenario
> and the PN gets corrupted by PN received in other vif's skb, causing
> traffic to stop due to PN mismatch.
> This can be avoided by comparing source mac addres in received skb's with
> the sta's mac address for which processing is going on, when de-queueing.



> @@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
>  
>  	rx->local->running_rx_handler = true;
>  
> -	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
> +	skb_queue_walk_safe(&rx->local->rx_skb_queue, skb, tmp) {
> +		if (!skb)
> +			break;
> +		hdr = (struct ieee80211_hdr *) skb->data;
> +		/*
> +		* Additional check to ensure that the packets corresponding
> +		* to same sta entry as in rx->sta are de-queued. The queue
> +		* can have different interface packets in case of multiple vifs
> +		*/
> +		if ((rx->sta && hdr) && (ieee80211_is_data(hdr->frame_control))
> +			&& (memcmp(rx->sta->sta.addr, hdr->addr2, ETH_ALEN)))
> +					continue;
> +		__skb_unlink(skb, &rx->local->rx_skb_queue);

Apart from the curious coding style (you don't need any of those extra
parentheses, && should be on the previous line, the if continuation
indented to the opening parenthesis, continue only indented one tab), I
wonder if this could lead to leaking frames here, if the station
disconnects or something while there are frames for it on the queue?
IOW, the "just skip that frame" piece seems a bit questionable.

Christian, is there any reason to not just have the queue be on the
stack, and use a separate spinlock in the local struct to lock out the
unwanted concurrency? It seems to me that should work just as well,
since there are never frames on the rx_skb_queue for very long, right?

johannes

