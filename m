Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1GSKQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 06:16:20 -0400
Subject: Re: [PATCH] mac80211: check sta_info_get() return value
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311070482-20120-1-git-send-email-eliad@wizery.com> (sfid-20110719_121427_009298_CCE08D48)
References: <1311070482-20120-1-git-send-email-eliad@wizery.com>
	 (sfid-20110719_121427_009298_CCE08D48)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 12:16:17 +0200
Message-ID: <1311070577.24078.5.camel@jlt3.sipsolutions.net> (sfid-20110719_121623_581626_3788310C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 13:14 +0300, Eliad Peller wrote:
> ieee80211_stop_rx_ba_session() was calling sta_info_get()
> without rcu locking, and the return value was not
> checked.
> This resulted in the following panic:
> 
> [<bf05726c>] (ieee80211_stop_rx_ba_session+0x0/0x60 [mac80211])
> [<bf0abd94>] (wl1271_event_handle+0x0/0xdc8 [wl12xx])
> [<bf0a7308>] (wl1271_irq+0x0/0x4a0 [wl12xx])
> [<c00c40a8>] (irq_thread+0x0/0x254)
> [<c00a7398>] (kthread+0x0/0x8c)

Thanks.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/agg-rx.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index ebadb9a..fd1aaf2 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -104,14 +104,22 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
>  				  const u8 *addr)
>  {
>  	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> -	struct sta_info *sta = sta_info_get(sdata, addr);
> +	struct sta_info *sta;
>  	int i;
>  
> +	rcu_read_lock();
> +	sta = sta_info_get(sdata, addr);
> +	if (!sta) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
>  	for (i = 0; i < STA_TID_NUM; i++)
>  		if (ba_rx_bitmap & BIT(i))
>  			set_bit(i, sta->ampdu_mlme.tid_rx_stop_requested);
>  
>  	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
>  


