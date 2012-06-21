Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2FUNY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:24:27 -0400
Message-ID: <1340285064.4489.24.camel@jlt3.sipsolutions.net> (sfid-20120621_152429_570624_8D3B15F6)
Subject: Re: [RFC v2 1/7] mac80211: introduce channel contexts skeleton code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 15:24:24 +0200
In-Reply-To: <1340280216-18807-2-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
	 <1340280216-18807-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 14:03 +0200, Michal Kazior wrote:

> +++ b/include/net/mac80211.h
> @@ -143,6 +143,41 @@ struct ieee80211_low_level_stats {
>  	unsigned int dot11RTSSuccessCount;
>  };
>  
> +
> +/**
> + * enum ieee80211_chanctx_mode - channel context configuration mode
> + *
> + * @IEEE80211_CHANCTX_SHARED: channel context may be used by
> + *	multiple interfaces
> + * @IEEE80211_CHANCTX_EXCLUSIVE: channel context can be used
> + *	only by a single interface. This can be used for example for
> + *	non-fixed channel IBSS.
> + */
> +enum ieee80211_chanctx_mode {
> +	IEEE80211_CHANCTX_SHARED,
> +	IEEE80211_CHANCTX_EXCLUSIVE
> +};

Does the driver ever care about this? It seems mostly internal to
determine what's going on?


> + * @chanctx_conf: channel context vif is bound to, may be NULL

Maybe say "will be %NULL before the interface is assigned to a channel
context" or so?

> +	INIT_LIST_HEAD(&ctx->interfaces);

Is there really a need for this list? It seems only moderately less
efficient to iterate all interfaces and filter by channel context, and
that's probably easier to maintain?

> +static void
> +__ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_chanctx_conf *conf = sdata->vif.chanctx_conf;
> +	struct ieee80211_chanctx *ctx =
> +			container_of(conf, struct ieee80211_chanctx, conf);
> +
> +	if (!conf)
> +		return;
> +
> +	ieee80211_unassign_vif_chanctx(sdata, ctx);
> +	if (list_empty(&ctx->interfaces))
> +		ieee80211_free_chanctx(ctx);
> +}

Ah, ok. So I guess there's a good use for the list at least here.

johannes

