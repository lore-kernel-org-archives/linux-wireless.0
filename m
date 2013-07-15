Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43874 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755675Ab3GOMuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:50:52 -0400
Message-ID: <1373892651.2062.11.camel@joe-AO722> (sfid-20130715_145056_402763_9A13C883)
Subject: Re: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference
 issue
From: Joe Perches <joe@perches.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	krzysiek@podlesie.net
Date: Mon, 15 Jul 2013 05:50:51 -0700
In-Reply-To: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
References: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-15 at 14:35 +0200, Felix Fietkau wrote:
> When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
> the assignment further down, after the rate_control_send_low call.
> 
> Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
> Cc: stable@vger.kernel.org # 3.10
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Why should this be marked for stable?

It's a local reference only, it's not used.

It's like suggesting that all the initialized
automatics should not be set until after
rate_control_set_low is called.

> ---
>  net/mac80211/rc80211_minstrel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index ac7ef54..e6512e2 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -290,7 +290,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
>  	struct minstrel_rate *msr, *mr;
>  	unsigned int ndx;
>  	bool mrr_capable;
> -	bool prev_sample = mi->prev_sample;
> +	bool prev_sample;
>  	int delta;
>  	int sampling_ratio;
>  
> @@ -314,6 +314,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
>  			(mi->sample_count + mi->sample_deferred / 2);
>  
>  	/* delta < 0: no sampling required */
> +	prev_sample = mi->prev_sample;
>  	mi->prev_sample = false;
>  	if (delta < 0 || (!mrr_capable && prev_sample))
>  		return;



