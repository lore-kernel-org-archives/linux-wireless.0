Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44429 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3KMVUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 16:20:53 -0500
Message-ID: <5283ED31.1050606@openwrt.org> (sfid-20131113_222055_461365_9CA44903)
Date: Wed, 13 Nov 2013 22:20:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: minstrel_ht: fix rates selection
References: <1384364460-4452-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1384364460-4452-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-13 18:41, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When initializing rates selections starting indexes upon stats update,
> the minstrel_sta->max_* rates should be 'group * MCS_GROUP_RATES + i'
> not 'i'. This affects settings where one of the peers does not support
> any of the rates of the group 0 (i.e. when ht_cap.mcs.rx_mask[0] == 0).
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 88c932e..6c173a2 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -390,7 +390,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>  					mg->max_prob_rate = i;
>  				if (!mi_rates_valid) {
>  					mi->max_tp_rate = mi->max_tp_rate2 =
> -						mi->max_prob_rate = i;
> +						mi->max_prob_rate =
> +						group * MCS_GROUP_RATES + i;
How about moving the 'index = ...' line further up and using that
instead of duplicating it?

- Felix

