Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967773;
	b=cD5OZGnYXPh+UY7QhXPg2Q8z1oukBDAqAn1uR9owiZ1Lt4EVOjIEst/fyV8DPpFC9mvh
	 70kAU5do5AVgd9JJzd5DugTj7/cx5P3HIgsfUCQRo55ZzkupYTcXw6y8gHBr3lTnMkgZL
	 oD2i3YvoqJV5un0UODc6BBv7+4W6Nq4U6NIKutFF71hX86PZxnqw1arL9SWwP60grQiMs
	 tKo6xbkwh9+E86kt0WzVbJGWOmDgBeuF3CHcC+Q/udFrijSmVNUHGsfLxClV1uzi5LO4G
	 pmUG18VDHnFDd4Uyw5tqxIcEf1KoQVkSXcTC07HqHa3d3Tdwlsj4pXHireYXPjE9pwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967773;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=1ID7gQ/1XwVoL4Geed/y9imS4zlTBuBX0PUANOjaPiY=;
	b=Aw1cl0EPBO/KrOS92rMFezkU2D2DYH2Ylbw2uU7iy06MtnPmns74rEJg0JWtIUx/Sh8u
	 Pqx5CfJUvXrj5LLU5pXs+5hw48h2PciHAeW4K8sjpCbO2yz1uxEaLHrGuaT+ds6QzFp7y
	 E9KUuXEEcc5lmxiJ80MoEA+2iFJwBzCnfVBIW8uZF9lpgg8XgxZkAxybgik0K82twYwHK
	 hVPtPYzEtr0zapr0it8peT/9dd5CNpGpD0tdrLD0nFysYEvAYDQZGXzG7SXXtvVnC7SXk
	 OFuL8xOlD/1CKTBEe1e5CqfaGOEco42XODMvZRg8RKHtgij2KhdcQjlc2nOqB7IF0mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A4606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 12:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 352A4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 13/30] wifi: mac80211: don't apply CoDel to PS-buffered
 frames
In-Reply-To: <20261102203831.1058362-45-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
 <20261102203831.1058362-45-johannes@sipsolutions.net>
Date: Fri, 06 Nov 2026 13:22:42 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87cxsip2st.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Frames for sleeping stations remain on the TXQs now, applying
> CoDel to them would start dropping them due to a long wait on
> dequeue, but for PS STAs they will be on the queues for a while.
> Bypass CoDel while a STA is sleeping and for a while (10s) or
> when the queue drains after it wakes up, and for frames that
> were enqueued after the wakeup as well, which really is the
> common case.
>
> Assisted-by: LLM
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |  7 +++++
>  net/mac80211/sta_info.c    |  6 ++++-
>  net/mac80211/tx.c          | 52 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 5045144641a4..cb947341fee6 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -978,6 +978,7 @@ enum txq_info_flags {
>  	IEEE80211_TXQ_AMPDU,
>  	IEEE80211_TXQ_NO_AMSDU,
>  	IEEE80211_TXQ_DIRTY,
> +	IEEE80211_TXQ_PS_BACKLOG,
>  };
>  
>  /**
> @@ -990,6 +991,9 @@ enum txq_info_flags {
>   * @schedule_order: used with ieee80211_local->active_txqs
>   * @schedule_round: counter to prevent infinite loops on TXQ scheduling
>   * @flags: TXQ flags from &enum txq_info_flags
> + * @ps_backlog_end: with %IEEE80211_TXQ_PS_BACKLOG, indicates when
> + *	the station woke up, i.e. frames before this were just queued
> + *	due to powersave
>   * @txq: the driver visible part
>   */
>  struct txq_info {
> @@ -1003,6 +1007,7 @@ struct txq_info {
>  	struct sk_buff_head frags;
>  
>  	unsigned long flags;
> +	codel_time_t ps_backlog_end;
>  
>  	/* keep last! */
>  	struct ieee80211_txq txq;
> @@ -2724,6 +2729,8 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
>  			struct txq_info *txq, int tid);
>  struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
>  						struct txq_info *txqi);
> +void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
> +				    struct txq_info *txqi);

The variable above is called ps_backlog_end, the function is called
ps_backlog_start. Seems a tad confusing? :)


>  void ieee80211_txq_purge(struct ieee80211_local *local,
>  			 struct txq_info *txqi);
>  void ieee80211_purge_sta_txqs(struct sta_info *sta);
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 51504f57128f..8d79e532b109 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1889,10 +1889,14 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>  	/* this can be called in process context, e.g. for mesh */
>  	local_bh_disable();
>  	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
> +		struct txq_info *txqi;
> +
>  		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
>  			continue;
>  
> -		schedule_and_wake_txq(local, to_txq_info(sta->sta.txq[i]));
> +		txqi = to_txq_info(sta->sta.txq[i]);
> +		ieee80211_txq_ps_backlog_start(local, txqi);
> +		schedule_and_wake_txq(local, txqi);
>  	}
>  	local_bh_enable();
>  
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 0bd324a4d4cb..856018cdb617 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1380,6 +1380,55 @@ static void codel_drop_func(struct sk_buff *skb,
>  	ieee80211_free_txskb(hw, skb);
>  }
>  
> +/* bypass codel since PS can last a long time */
> +static bool ieee80211_txq_codel_bypass(struct txq_info *txqi,
> +				       const struct fq_flow *flow)
> +{
> +	struct sta_info *sta;
> +	struct sk_buff *skb;
> +
> +	if (!txqi->txq.sta)
> +		return false;
> +
> +	sta = container_of(txqi->txq.sta, struct sta_info, sta);
> +	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
> +	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
> +	    test_sta_flag(sta, WLAN_STA_PS_DELIVER))
> +		return true;
> +
> +	if (likely(!test_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags)))
> +		return false;
> +
> +	/*
> +	 * Stop treating as backlog after it cleared or after 1s
> +	 * (the latter to avoid time wrap and issues from that).
> +	 */
> +#define IEEE80211_TXQ_MAX_PS_BACKLOG	MS2TIME(MSEC_PER_SEC)
> +
> +	if (!txqi->tin.backlog_packets ||
> +	    codel_time_after(codel_get_time(),
> +			     (codel_time_t)(txqi->ps_backlog_end +
> +					    IEEE80211_TXQ_MAX_PS_BACKLOG))) {
> +		clear_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags);
> +		return false;
> +	}
> +
> +	skb = skb_peek(&flow->queue);
> +	return skb && codel_time_before(codel_skb_time_func(skb),
> +					txqi->ps_backlog_end);
> +}
> +
> +void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
> +				    struct txq_info *txqi)
> +{
> +	spin_lock_bh(&local->fq.lock);
> +	if (txqi->tin.backlog_packets) {
> +		txqi->ps_backlog_end = codel_get_time();
> +		set_bit(IEEE80211_TXQ_PS_BACKLOG, &txqi->flags);

We should probably clear the codel variables here as well? Otherwise, if
CoDel was already in a dropping state when this happens, that can carry
over to after the bypass ends.

-Toke
