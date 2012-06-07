Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46200 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab2FGLv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 07:51:29 -0400
Message-ID: <4FD095B8.9040505@openwrt.org> (sfid-20120607_135142_120648_CD238779)
Date: Thu, 07 Jun 2012 13:51:20 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] minstrel_ht: enable frame aggregation for fixed rate
References: <1339065870-11507-1-git-send-email-sylvain.roger.rieunier@gmail.com>
In-Reply-To: <1339065870-11507-1-git-send-email-sylvain.roger.rieunier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-07 12:44 PM, Sylvain Roger Rieunier wrote:
> when i was trying fixed rate in minstrel_ht, frame aggregation
> was not working. so i fix it
> 
> Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2d1acc6..0e502d7 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -626,8 +626,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	/* use fixed index if set */
> -	if (mp->fixed_rate_idx != -1)
> -		sample_idx = mp->fixed_rate_idx;
> +	if (mp->fixed_rate_idx != -1) {
> +		if(sample_idx >= 0) {
> +			sample_idx = mp->fixed_rate_idx;
> +		} else {
> +			mi->max_tp_rate =  mp->fixed_rate_idx;	
> +		}
> +	}
I'd recommend setting sample_idx to -1 here.

- Felix
