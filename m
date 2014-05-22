Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44650 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbaEVOvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:51:55 -0400
Message-ID: <1400770304.4174.34.camel@jlt4.sipsolutions.net> (sfid-20140522_165158_255978_B9705BEB)
Subject: Re: [PATCH v6 2/6] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Thu, 22 May 2014 16:51:44 +0200
In-Reply-To: <1400767676-15994-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161508_316022_7A7F59AA)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_161508_316022_7A7F59AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:

> This introduces a special hook
> ieee80211_vif_chanctx_reservation_complete(). This
> is currently an empty stub and will be filled in
> by AP/STA CSA code. This is required to implement
> 2-step CSA finalization.

I really don't see any value in this - just put it into the patch
implementing it?

> + *	The callback is optional for channel context based drivers but is
> + *	required to support channel switching. The callback and can sleep.

That probably belongs to the previous patch, but isn't even true there
or here afaict.

> +static int
> +ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
> +				    struct ieee80211_chanctx *ctx,
> +				    const struct cfg80211_chan_def *chandef)
> +{
> +	struct ieee80211_sub_if_data *sdata, *tmp;
> +	struct ieee80211_chanctx *new_ctx;
> +	u32 changed = 0;
> +	int err;
> +
> +	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	if (!ieee80211_chanctx_all_reserved_vifs_ready(local, ctx))
> +		return 0;
> +
> +	if (ieee80211_chanctx_num_assigned(local, ctx) !=
> +	    ieee80211_chanctx_num_reserved(local, ctx)) {
> +		wiphy_info(local->hw.wiphy,
> +			   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
> +		err = -EBUSY;
> +		goto err;
>  	}

I don't think I understand that condition, it's it possible to switch
from two vifs using two channels to both using a single third one?

> +	ieee80211_recalc_chanctx_chantype(local, new_ctx);
> +	ieee80211_recalc_smps_chanctx(local, new_ctx);
> +	ieee80211_recalc_chanctx_min_def(local, new_ctx);

vs.

> -	ieee80211_recalc_chanctx_chantype(local, ctx);
> -	ieee80211_recalc_smps_chanctx(local, ctx);
> -	ieee80211_recalc_radar_chanctx(local, ctx);
> -	ieee80211_recalc_chanctx_min_def(local, ctx);

Did I miss something? Maybe it would be good to squeeze in that patch
that made a recalc_all() function to call all of these.

johannes

