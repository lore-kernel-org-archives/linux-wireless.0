Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2FIIK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:10:58 -0400
Message-ID: <1339229456.4539.9.camel@jlt3.sipsolutions.net> (sfid-20120609_101104_929135_D2F3E71F)
Subject: Re: [PATCH v2] minstrel_ht: enable frame aggregation for fixed rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Date: Sat, 09 Jun 2012 10:10:56 +0200
In-Reply-To: <1339141443-10135-1-git-send-email-sylvain.roger.rieunier@gmail.com>
References: <1339141443-10135-1-git-send-email-sylvain.roger.rieunier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 09:44 +0200, Sylvain Roger Rieunier wrote:
> when i was trying fixed rate in minstrel_ht, frame aggregation
> was not working. so i fix it.

Please explain in the commit log why it was broken and how the fix
works, rather than just saying "I fix[ed] it"

> Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 2d1acc6..342ec71 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -626,8 +626,11 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	/* use fixed index if set */
> -	if (mp->fixed_rate_idx != -1)
> -		sample_idx = mp->fixed_rate_idx;
> +	if (mp->fixed_rate_idx != -1) {
> +		mi->max_tp_rate = mp->fixed_rate_idx;
> +		mi->max_tp_rate2 = mp->fixed_rate_idx;
> +		sample_idx = -1;
> +	}
>  #endif
>  
>  	if (sample_idx >= 0) {


