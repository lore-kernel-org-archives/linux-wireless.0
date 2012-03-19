Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2CSNDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:03:10 -0400
Subject: Re: [RFC] mac80211: fix possible tid_rx->reorder_timer use after
 free
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
References: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 14:03:08 +0100
Message-ID: <1332162188.3359.33.camel@jlt3.sipsolutions.net> (sfid-20120319_140315_064637_786D2F10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 13:50 +0100, Stanislaw Gruszka wrote:
> Is possible that we arm tid_rx->reorder_timer after del_timer_sync(). To
> fix: first wait for RCU grace period finish and then delete timer. Timer
> will not be armed again as rcu_dereference(sta->ampdu_mlme.tid_rx[tid])
> will return NULL.
> 
> Debug object detected problem with the following warning:
> ODEBUG: free active (active state 0) object type: timer_list hint: sta_rx_agg_reorder_timer_expired+0x0/0xf0 [mac80211]
> 
> Bug report (with full warning):
> https://bugzilla.redhat.com/show_bug.cgi?id=804007
> 
> Reported-by: "jan p. springer" <jsd@igroup.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  net/mac80211/agg-rx.c   |    8 ++++----
>  net/mac80211/sta_info.h |    1 -
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 1068f66..2c1223e 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -43,10 +43,8 @@
>  #include "ieee80211_i.h"
>  #include "driver-ops.h"
>  
> -static void ieee80211_free_tid_rx(struct rcu_head *h)
> +static void ieee80211_free_tid_rx(struct tid_ampdu_rx *tid_rx)
>  {
> -	struct tid_ampdu_rx *tid_rx =
> -		container_of(h, struct tid_ampdu_rx, rcu_head);
>  	int i;
>  
>  	for (i = 0; i < tid_rx->buf_size; i++)
> @@ -90,10 +88,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  		ieee80211_send_delba(sta->sdata, sta->sta.addr,
>  				     tid, WLAN_BACK_RECIPIENT, reason);
>  
> +	synchronize_rcu();
> +
>  	del_timer_sync(&tid_rx->session_timer);
>  	del_timer_sync(&tid_rx->reorder_timer);
>  
> -	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
> +	ieee80211_free_tid_rx(tid_rx);

Hmmm. That synchronize_rcu() could become rather expensive. I've been
trying to reduce our use of synchronize_rcu() now.

I was checking if we could move the timer deletions into
ieee80211_free_tid_rx since call_rcu runs from another softirq, but I'm
not really sure -- the timer softirq could be running on another CPU?

johannes

