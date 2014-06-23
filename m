Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45865 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbaFWNEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:07 -0400
Message-ID: <1403528633.4418.27.camel@jlt4.sipsolutions.net> (sfid-20140623_152553_521190_2861E62C)
Subject: Re: [PATCH v10 1/5] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Mon, 23 Jun 2014 15:03:53 +0200
In-Reply-To: <1403009938-1084-2-git-send-email-michal.kazior@tieto.com> (sfid-20140617_150650_201157_FD1D4907)
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	 <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
	 <1403009938-1084-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140617_150650_201157_FD1D4907)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, I was going to apply this, but then I ran sparse & smatch :-)

On Tue, 2014-06-17 at 14:58 +0200, Michal Kazior wrote:

> -	curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
> +	curr_ctx = ieee80211_vif_get_chanctx(sdata);
> +	if (curr_ctx && local->use_chanctx && !local->ops->switch_vif_chanctx)
> +		return -ENOTSUPP;

curr_ctx can be NULL?

>  	new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
>  	if (!new_ctx) {
> +		if (ieee80211_can_create_new_chanctx(local)) {
>  			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
> +			if (IS_ERR(new_ctx))
> +				return PTR_ERR(new_ctx);
>  		} else {
> +			if ((curr_ctx->replace_state ==
> +			     IEEE80211_CHANCTX_WILL_BE_REPLACED) ||

then this crashes?

> +	if (local->use_chanctx) {
> +		vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
> +		if (vif_chsw) {

clearly you didn't test this? :)

> +			err = -ENOMEM;
> +			goto err;
> +		}
> +
> +		i = 0;
> +		list_for_each_entry(ctx, &local->chanctx_list, list) {
> +			if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
> +				continue;
> +
> +			if (WARN_ON(!ctx->replace_ctx))
> +				return -EINVAL;

This also leaks "vif_chsw".

johannes


