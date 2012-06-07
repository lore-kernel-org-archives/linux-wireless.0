Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44569 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2FGOGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 10:06:31 -0400
Message-ID: <4FD0B565.4090809@openwrt.org> (sfid-20120607_160635_192753_5946C7D6)
Date: Thu, 07 Jun 2012 16:06:29 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] minstrel_ht: enable frame aggregation for fixed rate
References: <1339077677-5836-1-git-send-email-sylvain.roger.rieunier@gmail.com>
In-Reply-To: <1339077677-5836-1-git-send-email-sylvain.roger.rieunier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-07 4:01 PM, Sylvain Roger Rieunier wrote:
> Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2d1acc6..e2aa93e 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -626,8 +626,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	/* use fixed index if set */
> -	if (mp->fixed_rate_idx != -1)
> -		sample_idx = mp->fixed_rate_idx;
> +	if (mp->fixed_rate_idx != -1) {
> +		mi->max_tp_rate = mp->fixed_rate_idx;
> +		sample_idx = -1;
> +	}
>  #endif
I just noticed another issue, you should prevent minstrel_ht from
setting up the alternate retry chains if fixed rate is set, otherwise it
won't always use the rate you configured.

- Felix
