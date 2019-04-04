Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130B9C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 05:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9DD206C0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 05:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bHDRsnj+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PbakNJI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfDDFAI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 01:00:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfDDFAI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 01:00:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE2DE60790; Thu,  4 Apr 2019 05:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554354006;
        bh=y2cVx19pkQTLDBgwfDjoZ8DcT0qTy44Kcp8vjst7nxc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHDRsnj+wKvkwrUoi4Od4A/eSArtSfhU+a1S3DxtN6UOG0KiHsl7H98GCZ0hOKg7X
         IsWCa3GO2+mJui9gXO7Ye3YmVeQ2BJ0nB/v/gdmWINNvWbTmxuwt9j7UyBrE31M6gm
         XQlSizL2SsDdQGRXZxYEyoWpYu0JuvTQQ88rzXt8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 000D06049C;
        Thu,  4 Apr 2019 05:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554354005;
        bh=y2cVx19pkQTLDBgwfDjoZ8DcT0qTy44Kcp8vjst7nxc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PbakNJI0C8jaaawKKwhHQHMP0CtoyzNsIusN1UUwc4a/vrriU7/AUdhk13h5mQtPj
         Of6wL8MlTn0FZllMkFjwSTgsa5AMgAELec6aztyP4PS1HpPcKObqdwvgekzNfyGTWw
         rqAapnudcOTjqchzhjuxcQTcggq5oizCBF2Dl9qQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 04 Apr 2019 13:00:04 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime
 scheduler
In-Reply-To: <20190215170512.31512-1-toke@redhat.com>
References: <20190215170512.31512-1-toke@redhat.com>
Message-ID: <753b328855b85f960ceaf974194a7506@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
> This switches the airtime scheduler in mac80211 to use a virtual 
> time-based
> scheduler instead of the round-robin scheduler used before. This has a
> couple of advantages:
> 
> - No need to sync up the round-robin scheduler in firmware/hardware 
> with
>   the round-robin airtime scheduler.
> 
> - If several stations are eligible for transmission we can schedule 
> both of
>   them; no need to hard-block the scheduling rotation until the head of 
> the
>   queue has used up its quantum.
> 
> - The check of whether a station is eligible for transmission becomes
>   simpler (in ieee80211_txq_may_transmit()).
> 
> The drawback is that scheduling becomes slightly more expensive, as we 
> need
> to maintain an rbtree of TXQs sorted by virtual time. This means that
> ieee80211_register_airtime() becomes O(logN) in the number of currently
> scheduled TXQs. However, hopefully this number rarely grows too big 
> (it's
> only TXQs currently backlogged, not all associated stations), so it
> shouldn't be too big of an issue.
> 
> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
> ieee80211_sta *pubsta, u8 tid,
>  {
>  	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>  	struct ieee80211_local *local = sta->sdata->local;
> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>  	u8 ac = ieee80211_ac_from_tid(tid);
> -	u32 airtime = 0;
> +	u64 airtime = 0, weight_sum;
> +
> +	if (!txq)
> +		return;
> 
>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>  		airtime += tx_airtime;
>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>  		airtime += rx_airtime;
> 
> +	/* Weights scale so the unit weight is 256 */
> +	airtime <<= 8;
> +
>  	spin_lock_bh(&local->active_txq_lock[ac]);
> +
>  	sta->airtime[ac].tx_airtime += tx_airtime;
>  	sta->airtime[ac].rx_airtime += rx_airtime;
> -	sta->airtime[ac].deficit -= airtime;
> +
> +	weight_sum = local->airtime_weight_sum[ac] ?: sta->airtime_weight;
> +
> +	local->airtime_v_t[ac] += airtime / weight_sum;
Hi Toke,

Please ignore the previous two broken emails regarding this new proposal 
from me.

It looks like local->airtime_v_t acts like a Tx criteria. Only the 
stations with less airtime than that are valid for Tx. That means there 
are situations, like 50 clients, that some of the stations can be used 
to Tx when putting next_txq in the loop. Am I right?

> +	sta->airtime[ac].v_t += airtime / sta->airtime_weight;
Another question. Any plan for taking v_t overflow situation into 
consideration? u64 might be enough for low throughput products but not 
sure for high end products. Something like below for reference:

     u64 prev = sta->airtime[ac].v_t;
     u64 current = prev + airtime_v_t;

      if (current < prev)
          iterate every rb node to substact the rb_first's vt


> +	ieee80211_resort_txq(&local->hw, txq);
> +
>  	spin_unlock_bh(&local->active_txq_lock[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_sta_register_airtime);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 05647d835894..4b901a2a998e 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -130,11 +130,12 @@ enum ieee80211_agg_stop_reason {
>  /* Debugfs flags to enable/disable use of RX/TX airtime in scheduler 
> */
>  #define AIRTIME_USE_TX		BIT(0)
>  #define AIRTIME_USE_RX		BIT(1)
> +#define AIRTIME_GRACE 500 /* usec of grace period before reset */
> 
>  struct airtime_info {
>  	u64 rx_airtime;
>  	u64 tx_airtime;
> -	s64 deficit;
> +	u64 v_t;
>  };
> 
>  struct sta_info;
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 61c7ea9de2cc..8e125df8ade0 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1449,7 +1449,7 @@ void ieee80211_txq_init(struct
> ieee80211_sub_if_data *sdata,
>  	codel_vars_init(&txqi->def_cvars);
>  	codel_stats_init(&txqi->cstats);
>  	__skb_queue_head_init(&txqi->frags);
> -	INIT_LIST_HEAD(&txqi->schedule_order);
> +	RB_CLEAR_NODE(&txqi->schedule_order);
> 
>  	txqi->txq.vif = &sdata->vif;
> 
> @@ -1493,9 +1493,7 @@ void ieee80211_txq_purge(struct ieee80211_local 
> *local,
>  	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
>  	spin_unlock_bh(&fq->lock);
> 
> -	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
> -	list_del_init(&txqi->schedule_order);
> -	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
> +	ieee80211_unschedule_txq(&local->hw, &txqi->txq);
>  }
> 
>  void ieee80211_txq_set_params(struct ieee80211_local *local)
> @@ -3640,126 +3638,191 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 
> ac)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> +	struct rb_node *node = local->schedule_pos[ac];
>  	struct txq_info *txqi = NULL;
> +	bool first = false;
> 
>  	lockdep_assert_held(&local->active_txq_lock[ac]);
> 
> - begin:
> -	txqi = list_first_entry_or_null(&local->active_txqs[ac],
> -					struct txq_info,
> -					schedule_order);
> -	if (!txqi)
> +	if (!node) {
> +		node = rb_first_cached(&local->active_txqs[ac]);
> +		first = true;
> +	} else
> +		node = rb_next(node);
> +
> +	if (!node)
>  		return NULL;
> 
> +	txqi = container_of(node, struct txq_info, schedule_order);
> +
>  	if (txqi->txq.sta) {
>  		struct sta_info *sta = container_of(txqi->txq.sta,
>  						struct sta_info, sta);
> 
> -		if (sta->airtime[txqi->txq.ac].deficit < 0) {
> -			sta->airtime[txqi->txq.ac].deficit +=
> -				sta->airtime_weight;
> -			list_move_tail(&txqi->schedule_order,
> -				       &local->active_txqs[txqi->txq.ac]);
> -			goto begin;
> +		if (sta->airtime[ac].v_t > local->airtime_v_t[ac]) {
> +			if (first)
> +				local->airtime_v_t[ac] = sta->airtime[ac].v_t;
> +			else
> +				return NULL;
>  		}
>  	}
> 
> 
> -	if (txqi->schedule_round == local->schedule_round[ac])
> -		return NULL;
> -
> -	list_del_init(&txqi->schedule_order);
> -	txqi->schedule_round = local->schedule_round[ac];
> +	local->schedule_pos[ac] = node;
>  	return &txqi->txq;
>  }
>  EXPORT_SYMBOL(ieee80211_next_txq);
> 
> -void ieee80211_return_txq(struct ieee80211_hw *hw,
> +static void __ieee80211_insert_txq(struct rb_root_cached *root,
> +				   struct txq_info *txqi, u8 ac)
> +{
> +	struct rb_node **new = &root->rb_root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct txq_info *__txqi;
> +	bool leftmost = true;
> +
> +	while (*new) {
> +		parent = *new;
> +		__txqi = rb_entry(parent, struct txq_info, schedule_order);
> +
> +		if (!txqi->txq.sta) {
> +			/* new txqi has no sta - insert to the left */
> +			new = &parent->rb_left;
> +		} else if (!__txqi->txq.sta) {
> +			/* existing txqi has no sta - insert to the right */
> +			new = &parent->rb_right;
> +			leftmost = false;
> +		} else {
> +			struct sta_info *old_sta = container_of(__txqi->txq.sta,
> +								struct sta_info,
> +								sta);
> +			struct sta_info *new_sta = container_of(txqi->txq.sta,
> +								struct sta_info,
> +								sta);
> +
> +			if (new_sta->airtime[ac].v_t <= old_sta->airtime[ac].v_t)
> +				new = &parent->rb_left;
> +			else {
> +				new = &parent->rb_right;
> +				leftmost = false;
> +			}
> +
> +		}
> +	}
> +
> +	rb_link_node(&txqi->schedule_order, parent, new);
> +	rb_insert_color_cached(&txqi->schedule_order, root, leftmost);
> +}
> +
> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			    struct ieee80211_txq *txq)
> +	__acquires(txq_lock) __releases(txq_lock)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +	u8 ac = txq->ac;
> +
> +	spin_lock_bh(&local->active_txq_lock[ac]);
> +
> +	if (!RB_EMPTY_NODE(&txqi->schedule_order))
> +		goto out;
> +
> +	if (txq->sta) {
> +		struct sta_info *sta = container_of(txq->sta,
> +						    struct sta_info, sta);
> +
> +		local->airtime_weight_sum[ac] += sta->airtime_weight;
> +		if (local->airtime_v_t[ac] > AIRTIME_GRACE)
> +			sta->airtime[ac].v_t = max(local->airtime_v_t[ac] - AIRTIME_GRACE,
> +						   sta->airtime[ac].v_t);
> +	}
> +
> +	__ieee80211_insert_txq(&local->active_txqs[ac], txqi, ac);
> +
> + out:
> +	spin_unlock_bh(&local->active_txq_lock[ac]);
> +}
> +EXPORT_SYMBOL(ieee80211_schedule_txq);
> +
> +void ieee80211_resort_txq(struct ieee80211_hw *hw,
>  			  struct ieee80211_txq *txq)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  	struct txq_info *txqi = to_txq_info(txq);
> +	u8 ac = txq->ac;
> +
> +	if (!RB_EMPTY_NODE(&txqi->schedule_order)) {
> +		rb_erase_cached(&txqi->schedule_order,
> +				&local->active_txqs[ac]);
> +		RB_CLEAR_NODE(&txqi->schedule_order);
> +		__ieee80211_insert_txq(&local->active_txqs[ac], txqi, ac);
> +	}
> +}
> +
> +static void __ieee80211_unschedule_txq(struct ieee80211_hw *hw,
> +				       struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +	u8 ac = txq->ac;
> 
>  	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
> 
> -	if (list_empty(&txqi->schedule_order) &&
> -	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets)) {
> -		/* If airtime accounting is active, always enqueue STAs at the
> -		 * head of the list to ensure that they only get moved to the
> -		 * back by the airtime DRR scheduler once they have a negative
> -		 * deficit. A station that already has a negative deficit will
> -		 * get immediately moved to the back of the list on the next
> -		 * call to ieee80211_next_txq().
> -		 */
> -		if (txqi->txq.sta &&
> -		    wiphy_ext_feature_isset(local->hw.wiphy,
> -					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
> -			list_add(&txqi->schedule_order,
> -				 &local->active_txqs[txq->ac]);
> -		else
> -			list_add_tail(&txqi->schedule_order,
> -				      &local->active_txqs[txq->ac]);
> +	if (RB_EMPTY_NODE(&txqi->schedule_order))
> +		return;
> +
> +	if (txq->sta) {
> +		struct sta_info *sta = container_of(txq->sta,
> +						    struct sta_info, sta);
> +
> +		local->airtime_weight_sum[ac] -= sta->airtime_weight;
>  	}
> +
> +	rb_erase_cached(&txqi->schedule_order,
> +			&local->active_txqs[txq->ac]);
> +	RB_CLEAR_NODE(&txqi->schedule_order);
>  }
> -EXPORT_SYMBOL(ieee80211_return_txq);
> 
> -void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> -			    struct ieee80211_txq *txq)
> +void ieee80211_unschedule_txq(struct ieee80211_hw *hw,
> +			      struct ieee80211_txq *txq)
>  	__acquires(txq_lock) __releases(txq_lock)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> 
>  	spin_lock_bh(&local->active_txq_lock[txq->ac]);
> -	ieee80211_return_txq(hw, txq);
> +	__ieee80211_unschedule_txq(hw, txq);
>  	spin_unlock_bh(&local->active_txq_lock[txq->ac]);
>  }
> -EXPORT_SYMBOL(ieee80211_schedule_txq);
> +
> +void ieee80211_return_txq(struct ieee80211_hw *hw,
> +			  struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +
> +	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
> +
> +	if (!RB_EMPTY_NODE(&txqi->schedule_order) &&
> +	    (skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets))
> +		__ieee80211_unschedule_txq(hw, txq);
> +}
> +EXPORT_SYMBOL(ieee80211_return_txq);
> 
>  bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>  				struct ieee80211_txq *txq)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> -	struct txq_info *iter, *tmp, *txqi = to_txq_info(txq);
> +	struct txq_info *txqi = to_txq_info(txq);
>  	struct sta_info *sta;
>  	u8 ac = txq->ac;
> 
>  	lockdep_assert_held(&local->active_txq_lock[ac]);
> 
>  	if (!txqi->txq.sta)
> -		goto out;
> -
> -	if (list_empty(&txqi->schedule_order))
> -		goto out;
> -
> -	list_for_each_entry_safe(iter, tmp, &local->active_txqs[ac],
> -				 schedule_order) {
> -		if (iter == txqi)
> -			break;
> -
> -		if (!iter->txq.sta) {
> -			list_move_tail(&iter->schedule_order,
> -				       &local->active_txqs[ac]);
> -			continue;
> -		}
> -		sta = container_of(iter->txq.sta, struct sta_info, sta);
> -		if (sta->airtime[ac].deficit < 0)
> -			sta->airtime[ac].deficit += sta->airtime_weight;
> -		list_move_tail(&iter->schedule_order, &local->active_txqs[ac]);
> -	}
> +		return true;
> 
>  	sta = container_of(txqi->txq.sta, struct sta_info, sta);
> -	if (sta->airtime[ac].deficit >= 0)
> -		goto out;
> -
> -	sta->airtime[ac].deficit += sta->airtime_weight;
> -	list_move_tail(&txqi->schedule_order, &local->active_txqs[ac]);
> -
> -	return false;
> -out:
> -	if (!list_empty(&txqi->schedule_order))
> -		list_del_init(&txqi->schedule_order);
> -
> -	return true;
> +	return (sta->airtime[ac].v_t <= local->airtime_v_t[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_txq_may_transmit);
> 
> @@ -3769,7 +3832,6 @@ void ieee80211_txq_schedule_start(struct
> ieee80211_hw *hw, u8 ac)
>  	struct ieee80211_local *local = hw_to_local(hw);
> 
>  	spin_lock_bh(&local->active_txq_lock[ac]);
> -	local->schedule_round[ac]++;
>  }
>  EXPORT_SYMBOL(ieee80211_txq_schedule_start);
> 
> @@ -3778,6 +3840,7 @@ void ieee80211_txq_schedule_end(struct
> ieee80211_hw *hw, u8 ac)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> 
> +	local->schedule_pos[ac] = NULL;
>  	spin_unlock_bh(&local->active_txq_lock[ac]);
>  }
>  EXPORT_SYMBOL(ieee80211_txq_schedule_end);

-- 
Yibo
