Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab1D1Lhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 07:37:48 -0400
Subject: Re: [PATCH wireless-2.6] iwlagn: fix "Received BA when not
 expected"
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110428111011.GA6967@redhat.com>
References: <20110428111011.GA6967@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:37:41 +0200
Message-ID: <1303990661.3558.3.camel@jlt3.sipsolutions.net> (sfid-20110428_133751_772868_CCD82590)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 13:10 +0200, Stanislaw Gruszka wrote:
> Need to use broadcast sta_id for management and multicast frames,
> otherwise we broke BA session and get messages like that:
> 
> "Received BA when not expected"
> 
> or (on older kernels):
> 
> "BA scd_flow 0 does not match txq_id 10"

Hmm. Interesting. I believe you, but it's hard.

> -	/* Find index into station table for destination station */
> -	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);

info->control.sta should be NULL here, at least for multicast frames
(which never really happen in practise unless you use AP mode). And then
this should return ctx->bcast_sta_id, just like you use below:

> +	/* If this frame is broadcast or management, use broadcast station id */
> +	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
> +		sta_id = ctx->bcast_sta_id;

So the reason has to be management frames. But why would those be
affecting it? They aren't QoS frames, so there should be no influence on
BA handling at all. This is a bit odd.

Maybe we should make it clear here that it's about non-data frames and
remove the multicast check since that ought to be handled in the other
path?

johannes

