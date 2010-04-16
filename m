Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab0DPURt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 16:17:49 -0400
Subject: Re: [RFC PATCH] mac80211: Prevent running sta_cleanup timer
 unnecessarily
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1271403308-23416-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1271403308-23416-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271403308-23416-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 22:17:40 +0200
Message-ID: <1271449060.4184.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 10:35 +0300, Juuso Oikarinen wrote:
> The sta_cleanup timer is used to periodically expire buffered frames from the
> tx buf. The timer is executing periodically, regardless of the need for it.
> This is wasting resources.
> 
> Fix this simply by not restarting the sta_cleanup timer if the tx buffer was
> empty. Restart the timer when there is some more tx-traffic.
> 
> Cc: Janne Ylälehto <janne.ylalehto@nokia.com>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  net/mac80211/sta_info.c |   13 ++++++++++---
>  net/mac80211/tx.c       |    7 +++++++
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index ff0eb94..3de7a22 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -575,7 +575,7 @@ static int sta_info_buffer_expired(struct sta_info *sta,
>  }
>  
> 
> -static void sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
> +static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
>  					     struct sta_info *sta)
>  {
>  	unsigned long flags;
> @@ -583,7 +583,7 @@ static void sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
>  	struct ieee80211_sub_if_data *sdata;
>  
>  	if (skb_queue_empty(&sta->ps_tx_buf))
> -		return;
> +		return false;
>  
>  	for (;;) {
>  		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
> @@ -608,6 +608,8 @@ static void sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
>  		if (skb_queue_empty(&sta->ps_tx_buf))
>  			sta_info_clear_tim_bit(sta);
>  	}
> +
> +	return true;
>  }
>  
>  static int __must_check __sta_info_destroy(struct sta_info *sta)
> @@ -755,15 +757,20 @@ static void sta_info_cleanup(unsigned long data)
>  {
>  	struct ieee80211_local *local = (struct ieee80211_local *) data;
>  	struct sta_info *sta;
> +	bool timer_needed = false;
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sta, &local->sta_list, list)
> -		sta_info_cleanup_expire_buffered(local, sta);
> +		if (sta_info_cleanup_expire_buffered(local, sta))
> +			timer_needed = true;
>  	rcu_read_unlock();
>  
>  	if (local->quiescing)
>  		return;
>  
> +	if (!timer_needed)
> +		return;
> +
>  	local->sta_cleanup.expires =
>  		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
>  	add_timer(&local->sta_cleanup);
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 2cb7726..e2aa972 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -429,6 +429,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
>  	struct sta_info *sta = tx->sta;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> +	struct ieee80211_local *local = tx->local;
>  	u32 staflags;
>  
>  	if (unlikely(!sta ||
> @@ -476,6 +477,12 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
>  		info->control.vif = &tx->sdata->vif;
>  		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>  		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
> +
> +		if (!timer_pending(&local->sta_cleanup))
> +			mod_timer(&local->sta_cleanup,
> +				  round_jiffies(jiffies +
> +						STA_INFO_CLEANUP_INTERVAL));
> +

Why bother to check !timer_pending?

johannes

