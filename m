Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53927 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752597Ab2G0SIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 14:08:10 -0400
Message-ID: <1343412489.1982.10.camel@joe2Laptop> (sfid-20120727_200826_861009_E5975D8E)
Subject: Re: [RFC 03/20] mac80211: add drv_* wrappers for channel contexts
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 27 Jul 2012 11:08:09 -0700
In-Reply-To: <1343387816-9414-4-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1343387816-9414-4-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:16 +0200, Johannes Berg wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
[]
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
[]
> @@ -866,4 +866,50 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
[]
> +static inline void drv_add_chanctx(struct ieee80211_local *local,
> +				   struct ieee80211_chanctx *ctx)
> +{
> +	if (local->ops->add_chanctx)
> +		local->ops->add_chanctx(&local->hw, &ctx->conf);

Perhaps these repeated function names should be some macro
to avoid typos or copy/paste errors.

Maybe something like:

#define local_op(func, ...)				\
do {							\
	if (local->ops->func)				\
		local->ops->func(##__VA_ARGS__);	\
} while (0)

So the uses become:

	local_op(add_chanctx, &local->hw, &ctx->conf);

> +static inline void drv_remove_chanctx(struct ieee80211_local *local,
> +				      struct ieee80211_chanctx *ctx)
> +{
> +	if (local->ops->remove_chanctx)
> +		local->ops->remove_chanctx(&local->hw, &ctx->conf);

	local_op(remove_chanctx, &local->hw, &ctx->conf);

etc...


