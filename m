Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40808 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdFVAC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 20:02:57 -0400
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170621235022.25362-1-johannes@sipsolutions.net>
 <20170621235022.25362-3-johannes@sipsolutions.net>
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com> (sfid-20170622_020315_396259_A8B9A090)
Date: Wed, 21 Jun 2017 17:02:51 -0700
MIME-Version: 1.0
In-Reply-To: <20170621235022.25362-3-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2017 04:50 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some drivers may want to also use the TXQ abstraction with
> non-data packets that need powersave buffering, so add a
> hardware flag to allow this.
>
> Change ath9k/ath10k to use these by dequeuing the frames
> immediately and invoking the normal TX path for them.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -154,8 +154,24 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
>  {
>  	struct ath_softc *sc = hw->priv;
>  	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> -	struct ath_atx_tid *tid = (struct ath_atx_tid *) queue->drv_priv;
> -	struct ath_txq *txq = tid->txq;
> +	struct ath_atx_tid *tid;
> +	struct ath_txq *txq;
> +
> +	if (unlikely(queue->tid == IEEE80211_NUM_TIDS)) {
> +		struct sk_buff *skb = ieee80211_tx_dequeue(hw, queue);
> +		struct ieee80211_tx_control control = {
> +			.sta = queue->sta,
> +		};
> +
> +		if (WARN_ON(!skb))
> +			return;
> +
> +		ath9k_tx(hw, &control, skb);
> +		return;
> +	}

I think a comment for the above code block would be warranted (and for ath10k as well).

I guess this is the part about dequeueing the frames immediately?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
