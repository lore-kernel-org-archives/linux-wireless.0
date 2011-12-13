Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39384 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1LMUaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:30:24 -0500
Date: Tue, 13 Dec 2011 15:25:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: split addba retries in time
Message-ID: <20111213202516.GB2613@tuxdriver.com> (sfid-20111213_213027_735294_62E8F4DA)
References: <1323162576.4696.4.camel@jlt3.sipsolutions.net>
 <1323402221-9869-1-git-send-email-mar.kolya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1323402221-9869-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 08, 2011 at 10:43:41PM -0500, Nikolay Martynov wrote:
>   Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
> requests. When this limit is reached aggregation is turned off for
> given TID permanently. This doesn't seem right: three requests is
> not that much, some 'blackout' can happen, but effect of it affects
> whole connection indefinitely.
>   This patch increases number of retries to 15. Also, when there have
> been 3 or more retries it splits further retries apart by 15 seconds
> instead of sending them in very short period of time.
> 
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  net/mac80211/agg-tx.c   |   19 +++++++++++++++++++
>  net/mac80211/sta_info.h |    6 +++++-
>  2 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 7380287..7060c8f 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -390,6 +390,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
>  #endif
>  
>  	spin_lock_bh(&sta->lock);
> +	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
>  	sta->ampdu_mlme.addba_req_num[tid]++;
>  	spin_unlock_bh(&sta->lock);
>  
> @@ -490,6 +491,24 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  		goto err_unlock_sta;
>  	}
>  
> +	/*
> +	 * if we have tried more than HT_AGG_BURST_RETRIES times we
> +	 * will spread our requests in time to avoid stalling connection
> +	 * for too long
> +	 */
> +	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_BURST_RETRIES &&
> +	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
> +			HT_AGG_RETRIES_PERIOD)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "BA request denied - "
> +		       "waiting a grace period after %d failed requests "
> +		       "on tid %u\n",
> +		       sta->ampdu_mlme.addba_req_num[tid], tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +		ret = -EBUSY;
> +		goto err_unlock_sta;
> +	}
> +
>  	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>  	/* check if the TID is not in aggregation flow already */
>  	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {

  CC [M]  net/mac80211/agg-tx.o
net/mac80211/agg-tx.c: In function ‘ieee80211_start_tx_ba_session’:
net/mac80211/agg-tx.c:474:6: warning: comparison of distinct pointer types lacks a cast

No new warnings, please!

> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 1a14fab..c8578eb 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -75,7 +75,9 @@ enum ieee80211_sta_info_flags {
>  
>  #define STA_TID_NUM 16
>  #define ADDBA_RESP_INTERVAL HZ
> -#define HT_AGG_MAX_RETRIES		0x3
> +#define HT_AGG_MAX_RETRIES		15
> +#define HT_AGG_BURST_RETRIES		3
> +#define HT_AGG_RETRIES_PERIOD		(15 * HZ)
>  
>  #define HT_AGG_STATE_DRV_READY		0
>  #define HT_AGG_STATE_RESPONSE_RECEIVED	1
> @@ -171,6 +173,7 @@ struct tid_ampdu_rx {
>   * @tid_tx: aggregation info for Tx per TID
>   * @tid_start_tx: sessions where start was requested
>   * @addba_req_num: number of times addBA request has been sent.
> + * @last_addba_req_time: timestamp of the last addBA request.
>   * @dialog_token_allocator: dialog token enumerator for each new session;
>   * @work: work struct for starting/stopping aggregation
>   * @tid_rx_timer_expired: bitmap indicating on which TIDs the
> @@ -190,6 +193,7 @@ struct sta_ampdu_mlme {
>  	struct work_struct work;
>  	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
>  	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
> +	unsigned int last_addba_req_time[STA_TID_NUM];
>  	u8 addba_req_num[STA_TID_NUM];
>  	u8 dialog_token_allocator;
>  };
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
