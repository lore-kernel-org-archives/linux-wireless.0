Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1ALQiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 11:38:16 -0500
Subject: Re: [RFC 2/2] iwlwifi: use maximum aggregation size
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294849399.3591.34.camel@wwguy-huron>
References: <20110112121322.702618109@sipsolutions.net>
	 <20110112121418.037714947@sipsolutions.net>
	 <1294849399.3591.34.camel@wwguy-huron>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 17:38:57 +0100
Message-ID: <1294850337.3639.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 08:23 -0800, Guy, Wey-Yi wrote:

> > +	lq_cmd->agg_params.agg_frame_cnt_limit =
> > +		sta_priv->max_agg_bufsize ?: LINK_QUAL_AGG_FRAME_LIMIT_DEF;
> 
> at this point, sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit has
> the right value, why not use it?

I wasn't sure it would _always_ have the right value, and if the ucode
would accept 0 before needed -- the ?: construct will use it if
non-zero, and use the default otherwise.

> on the other hand, sta_priv->max_agg_bufsize ==
> sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit
> 
> why need both?

Yeah I guess that would work if we put the init somewhere else, and
didn't change it above in that function -- we need the minimum
calculation to work. This seemed easier to verify to me :-)

> > +		/*
> > +		 * Even though in theory the peer could have different
> > +		 * aggregation reorder buffer sizes for different sessions,
> > +		 * our ucode doesn't allow for that and has a global limit
> > +		 * for each station. Therefore, use the minimum of all the
> > +		 * aggregation sessions and our default value.
> > +		 */
> > +		sta_priv->max_agg_bufsize =
> > +			min(sta_priv->max_agg_bufsize, buf_size);
> > +
> not sure where the "bus_size" come from?

It's a new argument to the function -- see patch 1/2.

johannes

