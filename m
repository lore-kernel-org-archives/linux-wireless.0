Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57043 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaI2Sve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 14:51:34 -0400
Message-ID: <5429AA1B.6030305@openwrt.org> (sfid-20140929_205137_814867_96F69CB1)
Date: Mon, 29 Sep 2014 20:51:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz@NSS2
References: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com> <54294687.1030307@openwrt.org> <20140929135805.GA28368@magnum.frso.rivierawaves.com>
In-Reply-To: <20140929135805.GA28368@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-29 15:58, Karl Beldan wrote:
> You mean having a common hardcoded value for both ?
Yes. And at the same time also getting rid of #if tests for it.

> After 4441e8e9 the minstrel rate indexes have to be u8-s and having this
> common param > 2 would require something like:
> 
> {{{
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 41522c7..c3d9136 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -346,8 +364,8 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
>   * MCS groups, CCK rates do not provide aggregation and are therefore at last.
>   */
>  static void
> -minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
> -                              u8 *tp_list)
> +minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
> +                              u16 *tp_list)
>  {
>         int cur_group, cur_idx, cur_thr, cur_prob;
>         int tmp_group, tmp_idx, tmp_thr, tmp_prob;
> @@ -384,7 +402,7 @@ minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
>   * Find and set the topmost probability rate per sta and per group
>   */
>  static void
> -minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u8 index)
> +minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
>  {
>         struct minstrel_mcs_group_data *mg;
>         struct minstrel_rate_stats *mr;
> @@ -427,8 +445,8 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u8 index)
>   */
>  static void
>  minstrel_ht_assign_best_tp_rates(struct minstrel_ht_sta *mi,
> -                                u8 tmp_mcs_tp_rate[MAX_THR_RATES],
> -                                u8 tmp_cck_tp_rate[MAX_THR_RATES])
> +                                u16 tmp_mcs_tp_rate[MAX_THR_RATES],
> +                                u16 tmp_cck_tp_rate[MAX_THR_RATES])
>  {
>         unsigned int tmp_group, tmp_idx, tmp_cck_tp, tmp_mcs_tp;
>         int i;
> @@ -492,8 +510,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>         struct minstrel_mcs_group_data *mg;
>         struct minstrel_rate_stats *mr;
>         int group, i, j;
> -       u8 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
> -       u8 tmp_cck_tp_rate[MAX_THR_RATES], index;
> +       u16 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
> +       u16 tmp_cck_tp_rate[MAX_THR_RATES], index;
> 
>         if (mi->ampdu_packets > 0) {
>                 mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
> diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
> index 7856062..354e076 100644
> --- a/net/mac80211/rc80211_minstrel_ht.h
> +++ b/net/mac80211/rc80211_minstrel_ht.h
> @@ -57,8 +57,8 @@ struct minstrel_mcs_group_data {
>         u16 supported;
> 
>         /* sorted rate set within a MCS group*/
> -       u8 max_group_tp_rate[MAX_THR_RATES];
> -       u8 max_group_prob_rate;
> +       u16 max_group_tp_rate[MAX_THR_RATES];
> +       u16 max_group_prob_rate;
> 
>         /* MCS rate statistics */
>         struct minstrel_rate_stats rates[MCS_GROUP_RATES];
> @@ -75,8 +75,8 @@ struct minstrel_ht_sta {
>         unsigned int avg_ampdu_len;
> 
>         /* overall sorted rate set */
> -       u8 max_tp_rate[MAX_THR_RATES];
> -       u8 max_prob_rate;
> +       u16 max_tp_rate[MAX_THR_RATES];
> +       u16 max_prob_rate;
> 
>         /* time of last status update */
>         unsigned long stats_update;
> }}}
> 
> With this I could not advertise the patch overhead-less when not setting
> MAC80211_RC_MINSTREL_VHT, too invasive for a simple step to feel the
> limits of the present implementation and a way to test vht tx path.
> 
> But maybe that's not what you had in mind for MINSTREL_*_MAX_STREAMS ?
I think the overhead of this is insignificant enough to justify getting
rid of some #if spaghetti. It should probably be posted as a separate
patch though, to simplify review.

- Felix
