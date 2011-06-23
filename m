Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:38745 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759214Ab1FWLBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 07:01:37 -0400
Date: Thu, 23 Jun 2011 14:01:25 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use configured rates for assoc request
Message-ID: <20110623110125.GA5233@jm.kir.nu> (sfid-20110623_130141_198248_BBE6F955)
References: <1308752817.29571.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308752817.29571.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 04:26:57PM +0200, Johannes Berg wrote:
> When mac80211 connects to an AP, it will advertise
> all rates that it supports, but only the subset that
> the AP also supports. Userspace can, however, ask
> that only a subset of rates be used, so advertise
> only that subset. The rates that the user asked for
> must all be supported by the hardware, and the set
> that we advertise to the AP will also be restricted
> to rates the the AP also supports.

I agree that we need this functionality. However, there are some
potential issues with the way it is implemented here, so I think we
should drop this patch for now based on irc discussion and figure out a
better way of handling this configuration.

> +	/*
> +	 * Userspace may restrict the locally supported rates
> +	 * by setting up this; the default will be all rates
> +	 * that the HW supports.
> +	 */
> +	rate_mask = sdata->rc_rateidx_mask[wk->chan->band];

The problem with this is that rc_rateidx_mask is used to mask TX rates,
not supported rates. There may be use for being able to pick a subset of
rates for TX, but still allow the other end to transmit at other rates.
This gets especially problematic if one of the basic rates is masked
from TX rates (the association will get rejected). It may be cleanest to
add a separate rate mask to indicate supported rates and use it to build
the {,ext}supp rates elements.

-- 
Jouni Malinen                                            PGP id EFC895FA
