Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54835 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbCQIYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 04:24:07 -0400
Message-ID: <5507E4A4.9020401@openwrt.org> (sfid-20150317_092413_271349_0D08A34F)
Date: Tue, 17 Mar 2015 09:24:04 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v2 07/10] mac80211: restructure per-rate throughput calculation
 into function
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1423839472-15625-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1423839472-15625-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-13 15:57, Thomas Huehn wrote:
> This patch moves Minstrels and Minstrel-HTs per-rate throughput
> calculation (EWMA(thr)) into a dedicated function to be called.
> Therefore the variable "unsigned int cur_tp" within struct
> "minstrel_rate_stats" becomes obsolete.  and is removed to free
> up its space.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel.c            | 46 +++++++++++------
>  net/mac80211/rc80211_minstrel.h            |  4 +-
>  net/mac80211/rc80211_minstrel_debugfs.c    | 12 ++---
>  net/mac80211/rc80211_minstrel_ht.c         | 79 ++++++++++++++++++------------
>  net/mac80211/rc80211_minstrel_ht.h         |  1 +
>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 12 ++---
>  6 files changed, 94 insertions(+), 60 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index 89db6cf..28de2f7a 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -69,13 +69,34 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>  	return i;
>  }
>  
> +/* return current EMWA throughput */
> +int minstrel_get_tp_avg(struct minstrel_rate *mr)
> +{
> +	int tp_avg, usecs;
> +
> +	usecs = mr->perfect_tx_time;
> +	if (!usecs)
> +		usecs = 1000000;
> +
> +	/* reset thr. below 10% success */
> +	if (mr->stats.prob_ewma < MINSTREL_FRAC(10, 100))
> +		tp_avg = 0;
You don't really need a variable, you can just do return 0 here and
reduce indentation of the line below.

> +	else
> +		tp_avg = MINSTREL_TRUNC(mr->stats.prob_ewma * (100000 / usecs));
> +
> +	return tp_avg;
> +}
> +
> +
> +
>  /* find & sort topmost throughput rates */
>  static inline void
>  minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
>  {
>  	int j = MAX_THR_RATES;
>  
> -	while (j > 0 && mi->r[i].stats.cur_tp > mi->r[tp_list[j - 1]].stats.cur_tp)
> +	while (j > 0 && (minstrel_get_tp_avg(&mi->r[i]) >
> +				minstrel_get_tp_avg(&mi->r[tp_list[j - 1]])))
Indentation seems off.

>  		j--;
>  	if (j < MAX_THR_RATES - 1)
>  		memmove(&tp_list[j + 1], &tp_list[j], MAX_THR_RATES - (j + 1));
> @@ -158,8 +179,7 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
>  {
>  	u8 tmp_tp_rate[MAX_THR_RATES];
>  	u8 tmp_prob_rate = 0;
> -	u32 usecs;
> -	int i;
> +	int i, tmp_cur_tp, tmp_prob_tp;
>  
>  	for (i = 0; i < MAX_THR_RATES; i++)
>  	    tmp_tp_rate[i] = 0;
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 6b07686..2a55f63 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -312,23 +312,23 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
>  }
>  
>  /*
> - * Calculate throughput based on the average A-MPDU length, taking into account
> - * the expected number of retransmissions and their expected length
> + * Return current throughput based on the average A-MPDU length, taking into
> + * account the expected number of retransmissions and their expected length
>   */
> -static void
> -minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
> +int
> +minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate)
>  {
>  	struct minstrel_rate_stats *mrs;
>  	unsigned int nsecs = 0;
> -	unsigned int tmp_prob_ewma;
> +	unsigned int tmp_prob_ewma, tp_avg;
>  
>  	mrs = &mi->groups[group].rates[rate];
>  	tmp_prob_ewma = mrs->prob_ewma;
>  
>  	/* do not account throughput if sucess prob is below 10% */
>  	if (mrs->prob_ewma < MINSTREL_FRAC(10, 100)) {
> -		mrs->cur_tp = 0;
> -		return;
> +		tp_avg = 0;
> +		return tp_avg;
No need for the tp_avg variable.

>  	}
>  
>  	/*
> @@ -344,7 +344,9 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
>  	nsecs += minstrel_mcs_groups[group].duration[rate];
>  
>  	/* prob is scaled - see MINSTREL_FRAC above */
> -	mrs->cur_tp = MINSTREL_TRUNC(1000000 * ((tmp_prob_ewma * 1000) / nsecs));
> +	tp_avg = MINSTREL_TRUNC(100000 * ((tmp_prob_ewma * 1000) / nsecs));
> +
> +	return tp_avg;
>  }
>  
>  /*
