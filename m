Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LHJa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:30:27 -0500
Subject: Re: [PATCH v2] mac80211: Purge A-MPDU TX queues before station
 destructions
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <20111208092608.GA4981@hertz.marvell.com>
References: <20111208092608.GA4981@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 10:30:24 +0100
Message-ID: <1323336624.3332.10.camel@jlt3.sipsolutions.net> (sfid-20111208_103033_281864_D5978D72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 14:56 +0530, Yogesh Ashok Powar wrote:
> When a station leaves suddenly while ampdu traffic to that station is still
> running, there is a possibility that the ampdu pending queues are not freed due
> to a race condition leading to memory leaks. In '__sta_info_destroy' when we
> attempt to destroy the ampdu sessions in 'ieee80211_sta_tear_down_BA_sessions',
> the driver calls 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu
> structures (tid_tx) and splice the pending queues and this job gets queued in
> sdata workqueue. However, the sta entry can get destroyed before the above work
> gets scheduled and hence the race.
> 
> Purging the queues and freeing the tid_tx to avoid the leak. The better solution
> would be to fix the race, but that can be taken up in a separate patch.
> 
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> v2: Adding note for driver authors as suggested by Johannes.

Thanks!

> ---
>  net/mac80211/agg-tx.c   |    2 ++
>  net/mac80211/sta_info.c |   25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 7380287..4bb33b8 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -55,6 +55,8 @@
>   * @ampdu_action function will be called with the action
>   * %IEEE80211_AMPDU_TX_STOP. In this case, the call must not fail,
>   * and the driver must later call ieee80211_stop_tx_ba_cb_irqsafe().
> + * Note that the sta can get destroyed before the BA tear down is
> + * complete.
>   */
>  
>  static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index f982352..c6ca9bd 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -851,6 +851,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
>  	struct ieee80211_sub_if_data *sdata;
>  	unsigned long flags;
>  	int ret, i, ac;
> +	struct tid_ampdu_tx *tid_tx;
>  
>  	might_sleep();
>  
> @@ -949,6 +950,30 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
>  	}
>  #endif
>  
> +	/* There could be some memory leaks because of ampdu tx pending queue
> +	 * not being freed before destroying the station info.
> +	 *
> +	 * Make sure that such queues are purged before freeing the station
> +	 * info.
> +	 * TODO: We have to somehow postpone the full destruction
> +	 * until the aggregation stop completes. Refer
> +	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
> +	 */
> +	for (i = 0; i < STA_TID_NUM; i++) {
> +		if (!sta->ampdu_mlme.tid_tx[i])
> +			continue;
> +		tid_tx = sta->ampdu_mlme.tid_tx[i];
> +		if (skb_queue_len(&tid_tx->pending)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
> +				"packets for tid=%d\n",
> +				skb_queue_len(&tid_tx->pending), i);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +			__skb_queue_purge(&tid_tx->pending);
> +		}
> +		kfree_rcu(tid_tx, rcu_head);
> +	}
> +
>  	__sta_info_free(local, sta);
>  
>  	return 0;


