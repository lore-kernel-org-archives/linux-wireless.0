Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44601 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaEVOpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:45:52 -0400
Message-ID: <1400769938.4174.29.camel@jlt4.sipsolutions.net> (sfid-20140522_164555_192810_F61A8F18)
Subject: Re: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Thu, 22 May 2014 16:45:38 +0200
In-Reply-To: <1400767676-15994-2-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161507_063110_E183A166)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_161507_063110_E183A166)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
> This new device driver operation will be used for
> channel context reservation and switching.

Heh. Luca just had some very similar code. But that's not necessarily a
bad thing - we can compare :)

> +	int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif **vifs,
> +				  struct ieee80211_chanctx_conf **old_ctx,
> +				  struct ieee80211_chanctx_conf **new_ctx,
> +				  int n_vifs,
> +				  enum ieee80211_chanctx_swmode swmode);

Luca had a struct here with (vif, old, new), I think that makes sense.

> +#define IEEE80211_MAX_NUM_SWITCH_VIFS 8

:-)

That seems artificial though - why not dynamically allocate?

> +static inline int drv_switch_vif_chanctx(struct ieee80211_local *local,
> +					 struct ieee80211_sub_if_data **sdata,
> +					 struct ieee80211_chanctx **old_ctx,
> +					 struct ieee80211_chanctx **new_ctx,
> +					 int n_vifs,
> +					 enum ieee80211_chanctx_swmode swmode)
> +{
> +	struct ieee80211_vif *vifs[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
> +	struct ieee80211_chanctx_conf *old_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
> +	struct ieee80211_chanctx_conf *new_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
> +	int i, ret = 0;

That's a little big for an inline?

> +	if (local->ops->switch_vif_chanctx)
> +		return -EOPNOTSUPP;
> +
> +	for (i = 0; i < n_vifs; i++)
> +		if (!check_sdata_in_driver(sdata[i]))
> +			return -EIO;
> +
> +	for (i = 0; i < n_vifs; i++) {
> +		trace_drv_switch_vif_chanctx(local, sdata[i], old_ctx[i],
> +					     new_ctx[i], n_vifs, swmode, i);

Hmm. This is somewhat ugly since the loop always runs. In theory it's
possible to do this all with dynamic_array() and code in the assign path
of the tracepoint, I think that'd be better. Or even for now just leave
the tracing to have just a subset or something (e.g. at most 2
interfaces)

> +++ b/net/mac80211/main.c
> @@ -502,6 +502,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
>  	if (WARN_ON(i != 0 && i != 5))
>  		return NULL;
>  	use_chanctx = i == 5;
> +	if (WARN_ON(!use_chanctx && ops->switch_vif_chanctx))
> +		return NULL;

I don't think this makes sense - we perfectly handle the case right now
by disconnecting (and not advertising switch to userspace, I guess? if
not we should)

Requiring drivers to implement this just makes things more difficult,
and the channel switch isn't really mandatory spec-wise.

> +		__field(u32, old_control_freq)

I believe there's a macro for a chandef?

johannes

