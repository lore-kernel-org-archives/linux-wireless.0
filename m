Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59606 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753471AbcHaVGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 17:06:51 -0400
Message-ID: <1472677599.5470.13.camel@sipsolutions.net> (sfid-20160831_230710_820717_3EF1D476)
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 31 Aug 2016 23:06:39 +0200
In-Reply-To: <20160830131548.6014-1-toke@toke.dk> (sfid-20160830_151618_124950_CD061443)
References: <20160824162015.29933-1-toke@toke.dk>
         <20160830131548.6014-1-toke@toke.dk> (sfid-20160830_151618_124950_CD061443)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-08-30 at 15:15 +0200, Toke Høiland-Jørgensen wrote:

> @@ -829,10 +844,16 @@ ieee80211_tx_h_sequence(struct
> ieee80211_tx_data *tx)
>  	 */
>  	if (!ieee80211_is_data_qos(hdr->frame_control) ||
>  	    is_multicast_ether_addr(hdr->addr1)) {
> -		/* driver should assign sequence number */
> -		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
> -		/* for pure STA mode without beacons, we can do it
> */
> -		hdr->seq_ctrl = cpu_to_le16(tx->sdata-
> >sequence_number);
> +		fragnum = 0;
> +		seq = cpu_to_le16(tx->sdata->sequence_number);
> +		skb_queue_walk(&tx->skbs, skb) {
> +			info = IEEE80211_SKB_CB(skb);
> +			hdr = (struct ieee80211_hdr *)skb->data;
> +			/* driver should assign sequence number */
> +			info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
> +			/* for pure STA mode without beacons, we can
> do it */
> +			hdr->seq_ctrl = seq | fragnum++;

I would very much prefer you kept fragnum assignment in the
fragmentation handler.

Also, you just broke this on big endian, please run sparse on your
patches if you don't see these things directly.

> +		if (!fast_tx ||
> +		    !ieee80211_xmit_fast_finish(sta->sdata, sta,
> fast_tx, skb,
> +						false)) {
> +			/* fast xmit was started, but fails to
> finish */
> +			ieee80211_free_txskb(hw, skb);
> +			goto begin;
> +		}

That obviously cannot happen, it can't fail to finish. See the comments
in xmit_fast() and the return values ...

> +static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
> +{
> +	return invoke_tx_handlers_early(tx) ||
> invoke_tx_handlers_late(tx);
> +}

Ugh, please, no, don't be tricky where it's not necessary. Now every
person reading this has to first look up the return type, and then the
return value, and make sure they understand that success is actually
the value 0 ... that's way too much to ask.
 
> +ieee80211_tx_result
> +ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
> +{
> +	struct sk_buff *skb;
> +	ieee80211_tx_result r;
> +
> +	skb_queue_walk(&tx->skbs, skb) {
> +		r = ieee80211_tx_h_michael_mic_add_skb(tx, skb);
> +		if (r != TX_CONTINUE)
> +			return r;
> +	}
> +	return TX_CONTINUE;
> +}

You just broke TKIP completely again. Adding the MMIC and fragmentation
are not commutative operations.

johannes
