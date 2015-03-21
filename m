Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48201 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbbCUXVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 19:21:10 -0400
Message-ID: <550DFCD9.7080809@openwrt.org> (sfid-20150322_002153_711073_6399A287)
Date: Sun, 22 Mar 2015 00:20:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v3 08/10] mac80211: add max. lossless throughput per rate
 to rc_stats
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1426613359-31306-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1426613359-31306-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-17 18:29, Thomas Huehn wrote:
> This patch adds the new statistic "maximum possible lossless
> throughput" to Minstrels and Minstrel-HTs rc_stats (in debugfs). This
> enables comprehensive comparison between current per-rate throughput
> and max. achievable per-rate throughput.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel.c            | 10 ++++
>  net/mac80211/rc80211_minstrel.h            |  1 +
>  net/mac80211/rc80211_minstrel_debugfs.c    | 18 ++++---
>  net/mac80211/rc80211_minstrel_ht.c         | 84 ++++++++++++++++--------------
>  net/mac80211/rc80211_minstrel_ht.h         |  4 +-
>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 24 +++++----
>  6 files changed, 83 insertions(+), 58 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index d985227..c2afe51 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -85,6 +85,16 @@ int minstrel_get_tp_avg(struct minstrel_rate *mr)
>  		return MINSTREL_TRUNC(mr->stats.prob_ewma * (100000 / usecs));
>  }
>  
> +/* return max. potential lossless throughput */
> +inline int
> +minstrel_get_tp_max(struct minstrel_rate *mr)
> +{
> +	if (!mr->perfect_tx_time)
> +		return 0;
> +
> +	return 100000 / mr->perfect_tx_time;
> +}
> +
>  /* find & sort topmost throughput rates */
>  static inline void
>  minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
How about merging it with the _avg function, like in minstrel_ht.

> diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
> index 68dce4f..850d352 100644
> --- a/net/mac80211/rc80211_minstrel_ht.h
> +++ b/net/mac80211/rc80211_minstrel_ht.h
> @@ -121,6 +121,8 @@ struct minstrel_ht_sta_priv {
>  
>  void minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
>  void minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta);
> -int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate);
> +int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
> +			   int prob_ewma);
> +int minstrel_ht_get_tp_max(struct minstrel_ht_sta *mi, int group, int rate);
Nonexistant function declaration, please remove it.

- Felix
