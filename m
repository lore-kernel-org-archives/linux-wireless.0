Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2FZNl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:41:56 -0400
Message-ID: <1340718113.14634.45.camel@jlt3.sipsolutions.net> (sfid-20120626_154159_460083_554282DD)
Subject: Re: [RFC v3 7/7] mac80211: reuse channels for channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 15:41:53 +0200
In-Reply-To: <1340714242-20032-8-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	 <1340714242-20032-8-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 14:37 +0200, Michal Kazior wrote:

> +static enum nl80211_channel_type
> +ieee80211_calc_chantype(struct ieee80211_local *local,
> +			struct ieee80211_chanctx *ctx)
> +{
> +	struct ieee80211_chanctx_conf *conf = &ctx->conf;
> +	struct ieee80211_sub_if_data *sdata;
> +	enum nl80211_channel_type chantype = NL80211_CHAN_NO_HT;
> +	enum nl80211_channel_type compat;
> +
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		if (!ieee80211_sdata_running(sdata))
> +			continue;
> +		if (sdata->vif.chanctx_conf != conf)
> +			continue;
> +
> +		BUG_ON(!ieee80211_channel_types_are_compatible(
> +				conf->channel_type, chantype, &compat));

Please no BUG_ON, maybe only WARN_ON_ONCE even?

> +		chantype = compat;
> +	}
> +	rcu_read_unlock();
> +
> +	return chantype;
> +}

I don't think I understand this, wouldn't it need some per-vif requested
channel type to work correctly? I don't see any chantype values coming
from the sdata here, so I don't think this could work?

If say vif1 needs ht40+ and vif2 ht20, the channel context will be set
to ht40+, but then if vif1 goes away and you don't know anything about
vif2 at all, then how can this work? The way I see it, your code here
doesn't really do anything, except recalculate that ht40+ is compatible
with ht40+, or something like that? I guess I'm a bit confused, it seems
to me that this cannot work even in theory unless you have per-vif data.


>  static void
>  ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
>  			       struct ieee80211_chanctx *ctx)
> @@ -248,6 +302,8 @@ ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
>  
>  	drv_unassign_vif_chanctx(sdata->local, sdata, ctx);
>  
> +	ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
> +
>  	ctx->refcount--;
>  	sdata->vif.chanctx_conf = NULL;

And then shouldn't you recalc *after* setting chanctx_conf = NULL so you
skip this vif?

johannes

