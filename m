Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49686 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbaIIQNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 12:13:36 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] mac80211: improve minstrel_ht rate sorting by throughput & probability
From: =?windows-1252?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <540DD981.1040403@openwrt.org>
Date: Tue, 9 Sep 2014 18:13:34 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, ikstream86@gmail.com
Message-Id: <5EC94E0D-E9F7-4704-9152-E7DE2FD0D92C@net.t-labs.tu-berlin.de> (sfid-20140909_181340_716351_6AF6915B)
References: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1408716333-18492-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <540DD981.1040403@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

Thank you for your review. I will send a v2 to fix all issues mentioned.

Greetings Thomas

On 08.09.2014, at 18:29, Felix Fietkau <nbd@openwrt.org> wrote:

> On 2014-08-22 16:05, Thomas Huehn wrote:
>> This patch improves the way minstrel_ht sorts rates according to throughput
>> and success probability. 3 FOR-loops across the entire rate and mcs group set
>> in function minstrel_ht_update_stats() which where used to determine the
>> fastest, second fastest and most robust rate are reduced to 2 FOR-loops.
>> 
>> The sorted list of rates according throughput is extended to the best four
>> rates as we need them in upcoming joint rate and power control. The sorting
>> is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
>> of those 4 best throughput rates in the debugfs file rc-stats is changes to:
>> "A,B,C,D", where A is the fastest rate and D the 4th fastest.
>> 
>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>> Tested-by: Stefan Venz <ikstream86@gmail.com>
>> ---
>> net/mac80211/rc80211_minstrel_ht.c         | 215 ++++++++++++++++-------------
>> net/mac80211/rc80211_minstrel_ht.h         |  17 +--
>> net/mac80211/rc80211_minstrel_ht_debugfs.c |   8 +-
>> 3 files changed, 128 insertions(+), 112 deletions(-)
>> 
>> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
>> index 85c1e74..7f03c01 100644
>> --- a/net/mac80211/rc80211_minstrel_ht.c
>> +++ b/net/mac80211/rc80211_minstrel_ht.c
>> @@ -228,8 +227,47 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
>> 	nsecs += minstrel_mcs_groups[group].duration[rate];
>> 
>> 	/* prob is scaled - see MINSTREL_FRAC above */
>> -	tp = 1000000 * ((prob * 1000) / nsecs);
>> -	mr->cur_tp = MINSTREL_TRUNC(tp);
>> +	mr->cur_tp = 1000000 * ((prob * 1000) / nsecs);
>> +}
>> +
>> +/*
>> + * Find & sort topmost throughput rates
>> + *
>> + * If multiple rates provide equal throughput the sorting is based on their
>> + * current success probability. Higher success probability is preferred among
>> + * MCS groups, CCK rates do not provide aggregation and are therefore at last.
>> + */
>> +static inline void
> You should drop the 'inline'
> 
>> +minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, unsigned int index,
>> +			       unsigned int *tp_list)
>> +{
>> +	int j = MAX_THR_RATES;
>> +	unsigned int cur_group, cur_idx, cur_thr, cur_prob;
>> +	unsigned int tmp_group, tmp_idx;
>> +
>> +	cur_group = index / MCS_GROUP_RATES;
>> +	cur_idx = index % MCS_GROUP_RATES;
>> +	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
>> +	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
>> +	tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
>> +	tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
>> +
>> +
>> +	while (j > 0 && (cur_thr > mi->groups[tmp_group].rates[tmp_idx].cur_tp ||
>> +	       (cur_thr == mi->groups[tmp_group].rates[tmp_idx].cur_tp &&
>> +	       cur_prob > mi->groups[tmp_group].rates[tmp_idx].probability &&
>> +	       cur_group != MINSTREL_CCK_GROUP))) {
> Missing one whitespace in indentation in the above two lines
>> +			j--;
>> +			tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
>> +			tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
> One tab too many.
> I think it would probably make the code more readable if you just do
> while (j > 0) { ... } and move the other checks inside the block.
> 	
> 
>> +	}
>> +
>> +	if (j < MAX_THR_RATES - 1) {
>> +		memmove(&tp_list[j + 1], &tp_list[j], (sizeof(*tp_list) *
>> +		       (MAX_THR_RATES - (j + 1))));
>> +	}
>> +	if (j < MAX_THR_RATES)
>> +		tp_list[j] = index;
>> }
>> 
>> /*
> 
>> @@ -274,24 +312,17 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>> 
>> 		mi->sample_count++;
>> 
>> +		/* (re)Initialize group rate indexes */
>> +		for(j = 0; j < MAX_THR_RATES; j++){
>> +			tmp_group_tp_rate[j] = group;
>> +		}
> You can drop the {} here.
> 
> 
>> @@ -300,82 +331,72 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>> [...]
>> 
>> +	/* try to sample all available rates during each interval */
>> +	mi->sample_count *= 8;
>> +
>> #ifdef CONFIG_MAC80211_DEBUGFS
>> 	/* use fixed index if set */
>> 	if (mp->fixed_rate_idx != -1) {
>> -		mi->max_tp_rate = mp->fixed_rate_idx;
>> -		mi->max_tp_rate2 = mp->fixed_rate_idx;
>> +		for (i = 0; i < 4; i++) {
>> +			mi->max_tp_rate[i] = mp->fixed_rate_idx;
>> +		}
> You can drop the {}
>> 		mi->max_prob_rate = mp->fixed_rate_idx;
>> 	}
>> #endif
>> 
>> +	/* Reset update timer */
>> 	mi->stats_update = jiffies;
>> }
>> 
>> @@ -735,8 +756,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>> 	 * if the link is working perfectly.
>> 	 */
>> 	sample_dur = minstrel_get_duration(sample_idx);
>> -	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate2) &&
>> -	    (mi->max_prob_streams <
>> +	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate[1]) &&
>> +	    (minstrel_mcs_groups[mi->max_tp_rate[0] / MCS_GROUP_RATES].streams <
> Changing the code from checking max_prob_rate streams to max_tp_rate
> streams should be done in a separate change and properly explained.
> 
>> 	     minstrel_mcs_groups[sample_group].streams ||
>> 	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
>> 		if (mr->sample_skipped < 20)
> 
> - Felix

