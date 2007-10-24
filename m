Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4274 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568AbXJXOJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 10:09:10 -0400
Date: Wed, 24 Oct 2007 09:48:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: [RFC] mac80211: no missing key complaint if frame may not be
	for us
Message-ID: <20071024134855.GA3435@tuxdriver.com> (sfid-20071024_151029_925688_BC12B460)
References: <1193175981828-git-send-email-linville@tuxdriver.com> <1193216455.5715.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193216455.5715.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 24, 2007 at 11:00:55AM +0200, Johannes Berg wrote:
> On Tue, 2007-10-23 at 17:46 -0400, John W. Linville wrote:
> 
> > +		/* if there are multiple SSIDs on this BSSID, the frame may
> > +		   not be for us anyway; so, check that either the frame is
> > +		   unicast or that we are not in managed mode before
> > +		   complaining about a missing key */
> > +		if ((!is_multicast_ether_addr(hdr->addr1) ||
> > +		     rx->sdata->type != IEEE80211_IF_TYPE_STA) &&
> > +		    net_ratelimit())
> 
> I think this and the other patch looks good, though I'm not entirely
> sure about the !STA test yet. I suppose though !STA means that we're in
> some way an AP and then we're the only one sending real multicast
> traffic.
> 
> Is it worth keeping this message at all?

I considered removing it, and that may be the best bet.  Still, I
thought it might be worth yelling about it in at least some instances.

Along those lines, the !STA check was there because that was the
only case I knew might not be worth complaining about.  For example,
an IBSS should not be reusing a BSSID for multiple SSIDs...right?
Heck, maybe that isn't any crazier than doing the same thing in an
infrastructure network...

Well, what do you think?  Leave it as-is?  Leave only the !multicast
check?  Or remove the message completely?

John
-- 
John W. Linville
linville@tuxdriver.com
