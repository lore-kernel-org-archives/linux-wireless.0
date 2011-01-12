Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38745 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1ALQrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 11:47:51 -0500
Subject: Re: [RFC 2/2] iwlwifi: use maximum aggregation size
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294850337.3639.28.camel@jlt3.sipsolutions.net>
References: <20110112121322.702618109@sipsolutions.net>
	 <20110112121418.037714947@sipsolutions.net>
	 <1294849399.3591.34.camel@wwguy-huron>
	 <1294850337.3639.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Wed, 12 Jan 2011 08:46:46 -0800
Message-Id: <1294850806.20725.18.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, 2011-01-12 at 08:38 -0800, Johannes Berg wrote:
> On Wed, 2011-01-12 at 08:23 -0800, Guy, Wey-Yi wrote:
> 
> > > +	lq_cmd->agg_params.agg_frame_cnt_limit =
> > > +		sta_priv->max_agg_bufsize ?: LINK_QUAL_AGG_FRAME_LIMIT_DEF;
> > 
> > at this point, sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit has
> > the right value, why not use it?
> 
> I wasn't sure it would _always_ have the right value, and if the ucode
> would accept 0 before needed -- the ?: construct will use it if
> non-zero, and use the default otherwise.
> 
> > on the other hand, sta_priv->max_agg_bufsize ==
> > sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit
> > 
> > why need both?
> 
> Yeah I guess that would work if we put the init somewhere else, and
> didn't change it above in that function -- we need the minimum
> calculation to work. This seemed easier to verify to me :-)
> 
> > > +		/*
> > > +		 * Even though in theory the peer could have different
> > > +		 * aggregation reorder buffer sizes for different sessions,
> > > +		 * our ucode doesn't allow for that and has a global limit
> > > +		 * for each station. Therefore, use the minimum of all the
> > > +		 * aggregation sessions and our default value.
> > > +		 */
> > > +		sta_priv->max_agg_bufsize =
> > > +			min(sta_priv->max_agg_bufsize, buf_size);
> > > +
> > not sure where the "bus_size" come from?
> 
> It's a new argument to the function -- see patch 1/2.
> 
I don't think I have patch 1/2

Here is what I have
[RFC2/2]iwlwifi: use maximum aggregation size
[RFC2/2]iwlwifi: advertise max aggregate size

Wey


