Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0IOMMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 08:12:14 -0400
Subject: Re: [RFC] mac80211: avoid recalc_idle in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1284551772-18574-1-git-send-email-rmanoharan@atheros.com>
References: <1284551772-18574-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 14:12:10 +0200
Message-ID: <1284552730.7705.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 17:26 +0530, Rajkumar Manoharan wrote:
> ath9k is not receiving frames in monitor mode after the commit 34d4bc.
> The problem is mac80211 sets IEEE80211_CONF_IDLE in __ieee80211_recalc_idle
> at ieee80211_do_open. Due to this, ath9k disables the radio.
> 
> The above said commit sets SDATA_STATE_RUNNING after __ieee80211_recalc_idle.
> IMHO avoiding __ieee80211_recalc_idle in monitor mode looks better
> than moving SDATA_STATE_RUNNING set before __ieee80211_recalc_idle.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/iface.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index c1cc200..2bec319 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -310,9 +310,11 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
>  	if (sdata->flags & IEEE80211_SDATA_PROMISC)
>  		atomic_inc(&local->iff_promiscs);
>  
> -	mutex_lock(&local->mtx);
> -	hw_reconf_flags |= __ieee80211_recalc_idle(local);
> -	mutex_unlock(&local->mtx);
> +	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> +		mutex_lock(&local->mtx);
> +		hw_reconf_flags |= __ieee80211_recalc_idle(local);
> +		mutex_unlock(&local->mtx);
> +	}

Hmm, that doesn't seem right, wouldn't it be idle to start with?

johannes

