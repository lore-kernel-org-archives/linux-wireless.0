Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55306 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbCQIcc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 04:32:32 -0400
Message-ID: <5507E69D.3080001@openwrt.org> (sfid-20150317_093324_381991_EA48BB53)
Date: Tue, 17 Mar 2015 09:32:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH v2 08/10] mac80211: add max. lossless throughput per rate
 to rc_stats
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1423839472-15625-9-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1423839472-15625-9-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-02-13 15:57, Thomas Huehn wrote:
> This patch adds the new statistic "maximum possible lossless
> throughput" to Minstrels and Minstrel-HTs rc_stats (in debugfs). This
> enables comprehensive comparison between current per-rate throughput
> and max. achievable per-rate throughput.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel.c            | 12 ++++++++++++
>  net/mac80211/rc80211_minstrel.h            |  1 +
>  net/mac80211/rc80211_minstrel_debugfs.c    | 18 +++++++++++-------
>  net/mac80211/rc80211_minstrel_ht.c         | 19 +++++++++++++++++++
>  net/mac80211/rc80211_minstrel_ht.h         |  1 +
>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 20 ++++++++++++--------
>  6 files changed, 56 insertions(+), 15 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index 28de2f7a..42dfef8 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -87,7 +87,19 @@ int minstrel_get_tp_avg(struct minstrel_rate *mr)
>  	return tp_avg;
>  }
>  
> +/* return max. potential lossless throughput */
> +int minstrel_get_tp_max(struct minstrel_rate *mr)
> +{
> +	int tp_max, usecs;
>  
> +	usecs = mr->perfect_tx_time;
> +	if (!usecs)
> +		usecs = 1000000;
> +
> +	tp_max = 100000 / usecs;
> +
> +	return tp_max;
> +}
This should probably be an inline function, and you can remove the
tp_max variable as well.
By the way, in the case of !usecs, the result (100000 / 1000000) will be
0, so you can simplify the logic.


>  /* find & sort topmost throughput rates */
>  static inline void
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2a55f63..b62b04e 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -350,6 +350,25 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate)
>  }
>  
>  /*
> + * Return max. potential lossless throughput based on the average A-MPDU
> + */
> +int
> +minstrel_ht_get_tp_max(struct minstrel_ht_sta *mi, int group, int rate)
> +{
> +	unsigned int nsecs = 0;
> +	unsigned int tp_max;
> +
> +	if (group != MINSTREL_CCK_GROUP)
> +		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
> +
> +	nsecs += minstrel_mcs_groups[group].duration[rate];
> +	tp_max = 100000000 / nsecs;
> +
> +	return tp_max;
> +}
I don't like duplication of the throughput metric - gets annoying if we
ever decide to tweak it. How about unifying this with
minstrel_ht_get_tp_avg by passing in the prob value as a parameter.

- Felix
