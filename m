Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab1D1MAi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 08:00:38 -0400
Date: Thu, 28 Apr 2011 13:59:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] iwlagn: fix "Received BA when not expected"
Message-ID: <20110428115947.GB7030@redhat.com> (sfid-20110428_140041_841578_3358F093)
References: <20110428111011.GA6967@redhat.com>
 <1303990661.3558.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303990661.3558.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 01:37:41PM +0200, Johannes Berg wrote:
> On Thu, 2011-04-28 at 13:10 +0200, Stanislaw Gruszka wrote:
> > Need to use broadcast sta_id for management and multicast frames,
> > otherwise we broke BA session and get messages like that:
> > 
> > "Received BA when not expected"
> > 
> > or (on older kernels):
> > 
> > "BA scd_flow 0 does not match txq_id 10"
> 
> Hmm. Interesting. I believe you, but it's hard.

To be honest, I expected to get explanations from you (perhaps
with better fix) :-) However this one is intended to work on older
kernels, and is tested by me and one other user.

> > -	/* Find index into station table for destination station */
> > -	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
> 
> info->control.sta should be NULL here, at least for multicast frames
> (which never really happen in practise unless you use AP mode). And then
> this should return ctx->bcast_sta_id, just like you use below:
> 
> > +	/* If this frame is broadcast or management, use broadcast station id */
> > +	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
> > +		sta_id = ctx->bcast_sta_id;
> 
> So the reason has to be management frames. But why would those be
> affecting it? They aren't QoS frames, so there should be no influence on
> BA handling at all. This is a bit odd.
>
> 
> Maybe we should make it clear here that it's about non-data frames and
> remove the multicast check since that ought to be handled in the other
> path?

We call iwl_sta_modify_sleep_tx_count(priv, sta_id, 1); for any frame
as long as some other conditions are true.

Also multicast frames are important. When we send data and multicast
frame we probably modify 

priv->stations[sta_id].tid[tid]

with wrong sta_id (other station with unicast address), what make related
aggregation data wrong for that other station.

Stanislaw
