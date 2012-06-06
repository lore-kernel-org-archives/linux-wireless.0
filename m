Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2FFIir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:38:47 -0400
Message-ID: <1338971925.4513.14.camel@jlt3.sipsolutions.net> (sfid-20120606_103852_552503_3951B7BA)
Subject: Re: [RFC 1/6] mac80211: introduce channel contexts skeleton code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:38:45 +0200
In-Reply-To: <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:
> Channel context are the foundation for
> multi-channel operation.
> 
> Channel contexts are immutable and are re-created
> (or re-used if other interfaces are bound to a
> certain channel) on channel switching.

That makes sense, although I think we may need to have context channel
changing APIs too, later, for things like CSA. We'll also need channel
type changing, see below.

>  /**
> + * struct ieee80211_channel_context - channel context that vifs may be tuned to
> + *
> + * @channel: the channel to tune to
> + * @channel_type: the channel (HT) type
> + * @vif_list: vifs bound to channel context
> + */
> +struct ieee80211_channel_context {
> +	struct ieee80211_channel *channel;
> +	enum nl80211_channel_type channel_type;
> +
> +	struct list_head vif_list;
> +};

I think I'd prefer this struct to be split into mac80211 internal and
driver-visible pieces, like ieee80211_sub_if_data / ieee80211_vif or
ieee80211_local / ieee80211_hw.

> @@ -909,6 +927,9 @@ struct ieee80211_vif {
>  	u8 cab_queue;
>  	u8 hw_queue[IEEE80211_NUM_ACS];
>  
> +	struct ieee80211_channel_context *channel_context;

That makes sense,

> +	struct list_head list;

I'm not sure this does? I have a feeling it should be inside the
internal sub_if_data struct in mac80211 so we can control access to it
and the driver doesn't modify things etc. We would have iteration
functions that also guarantee the right locking.

> +static struct ieee80211_channel_context *
> +ieee80211_find_channel_context(struct ieee80211_local *local,
> +			       struct ieee80211_channel *channel,
> +			       enum nl80211_channel_type channel_type)
> +{
> +	struct ieee80211_channel_context *ctx;
> +	int i;
> +
> +	if (WARN_ON(!channel))
> +		return NULL;
> +
> +	for (i = 0; i < IEEE80211_MAX_CHANNEL_CONTEXTS; i++) {
> +		ctx = &local->channel_contexts[i];

Given my earlier request of having driver-private data inside the
channel context struct, we won't be able to have an array, so we should
have a doubly-linked list instead.

> +		if (ctx->channel != channel)
> +			continue;
> +		if (ctx->channel_type != channel_type)
> +			continue;

I think we need to take compatibility into account here.

If the new channel type is HT_20 and the old one was NO_HT, then we
should reconfigure this context to HT_20 instead of using a new one.
>From a software POV that doesn't matter, but where it maps to hardware
contexts we only have a limited number of them and using just one for
compatible ones is better.

johannes

