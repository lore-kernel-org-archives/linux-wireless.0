Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38942 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbcA1Sw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 13:52:59 -0500
Subject: Re: KASAN splal in minstrel_ht_update_stats()
To: Konstantin Khlebnikov <koct9i@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <CALYGNiNyJhSaVnE35qS6UCGaSb2Dx1_i5HcRavuOX14oTz2P+w@mail.gmail.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56AA637A.6030407@openwrt.org> (sfid-20160128_195308_068152_88553B3A)
Date: Thu, 28 Jan 2016 19:52:42 +0100
MIME-Version: 1.0
In-Reply-To: <CALYGNiNyJhSaVnE35qS6UCGaSb2Dx1_i5HcRavuOX14oTz2P+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-15 06:23, Konstantin Khlebnikov wrote:
> Jan 10 17:56:25 hamm kernel: [184374.378842]
> ==================================================================
> Jan 10 17:56:25 hamm kernel: [184374.379001] BUG: KASAN:
> slab-out-of-bounds in minstrel_ht_update_stats.isra.7+0x6e1/0x9e0
[...]
> ==================================================================
> 
> out-of-bound in
> 
> if (mrs->prob_ewma > mg->rates[mg->max_group_prob_rate].prob_ewma)
>              mg->max_group_prob_rate = index;
> 
> 
> 
> Fix should be something like this:
> 
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -414,15 +414,16 @@ minstrel_ht_set_best_prob_rate(struct
> minstrel_ht_sta *mi, u16 index)
>             (max_tp_group != MINSTREL_CCK_GROUP))
>                 return;
> 
> +       max_gpr_group = mg->max_group_prob_rate / MCS_GROUP_RATES;
> +       max_gpr_idx = mg->max_group_prob_rate % MCS_GROUP_RATES;
> +       max_gpr_prob = mi->groups[max_gpr_group].rates[max_gpr_idx].prob_ewma;
> +
>         if (mrs->prob_ewma > MINSTREL_FRAC(75, 100)) {
>                 cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx,
>                                                     mrs->prob_ewma);
>                 if (cur_tp_avg > tmp_tp_avg)
>                         mi->max_prob_rate = index;
> 
> -               max_gpr_group = mg->max_group_prob_rate / MCS_GROUP_RATES;
> -               max_gpr_idx = mg->max_group_prob_rate % MCS_GROUP_RATES;
> -               max_gpr_prob =
> mi->groups[max_gpr_group].rates[max_gpr_idx].prob_ewma;
>                 max_gpr_tp_avg = minstrel_ht_get_tp_avg(mi, max_gpr_group,
>                                                         max_gpr_idx,
>                                                         max_gpr_prob);
> @@ -431,7 +432,7 @@ minstrel_ht_set_best_prob_rate(struct
> minstrel_ht_sta *mi, u16 index)
>         } else {
>                 if (mrs->prob_ewma > tmp_prob)
>                         mi->max_prob_rate = index;
> -               if (mrs->prob_ewma >
> mg->rates[mg->max_group_prob_rate].prob_ewma)
> +               if (mrs->prob_ewma > max_gpr_prob)
>                         mg->max_group_prob_rate = index;
>         }
>  }
Fix looks correct, but does not apply (line wrapped). Please resubmit
with a proper description and your Signed-off-by.

Thanks,

- Felix
