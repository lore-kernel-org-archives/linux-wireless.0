Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab0JDNOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:14:42 -0400
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:14:40 +0200
Message-ID: <1286198080.3620.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:

> @@ -936,7 +936,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>  
>  	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
>  
> -	ifmgd->associated = NULL;
>  	memset(ifmgd->bssid, 0, ETH_ALEN);
>  
>  	/*

You need to read this comment and the one below it :-)

> @@ -513,6 +513,19 @@ ieee80211_associate(struct ieee80211_work *wk)
>  {
>  	struct ieee80211_sub_if_data *sdata = wk->sdata;
>  	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	bool associated;
> +
> +	mutex_lock(&ifmgd->mtx);
> +	associated = !!ifmgd->associated;
> +	mutex_unlock(&ifmgd->mtx);
> +
> +	if (associated) {
> +		printk(KERN_DEBUG "%s: delaying association with %pM as "
> +		       "we are still associated",
> +		       sdata->name, wk->filter_ta);
> +		goto wait;
> +	}
>  
>  	wk->assoc.tries++;
>  	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
> @@ -534,6 +547,7 @@ ieee80211_associate(struct ieee80211_work *wk)
>  	       sdata->name, wk->filter_ta, wk->assoc.tries);
>  	ieee80211_send_assoc(sdata, wk);
>  
> +wait:
>  	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
>  	run_again(local, wk->timeout);

But you'll be staying off-channel for the wait period, so what does this
really help?

johannes

