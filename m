Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47295 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbbGBOtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 10:49:19 -0400
Message-ID: <1435848556.2285.25.camel@sipsolutions.net> (sfid-20150702_164922_856936_23313A77)
Subject: Re: [PATCH 3/3] mac80211: select an AID when creating new mesh STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 02 Jul 2015 16:49:16 +0200
In-Reply-To: <20150702144527.GA3846@localhost> (sfid-20150702_164546_979422_A74C4D1F)
References: <1435843690-2856-1-git-send-email-me@bobcopeland.com>
	 <1435843690-2856-4-git-send-email-me@bobcopeland.com>
	 <1435843898.2285.24.camel@sipsolutions.net>
	 <20150702144527.GA3846@localhost> (sfid-20150702_164546_979422_A74C4D1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 10:45 -0400, Bob Copeland wrote:
> On Thu, Jul 02, 2015 at 03:31:38PM +0200, Johannes Berg wrote:
> > On Thu, 2015-07-02 at 09:28 -0400, Bob Copeland wrote:
> > > 
> > > +	DECLARE_BITMAP(aid_map, IEEE80211_MAX_AID + 1);
> > > 
> > Is there really much point in keeping a long-lived bitmap rather 
> > than
> > iterating the existing stations when adding a new one? It's not 
> > such a
> > frequent operation after all.
> 
> Not really -- I tried it both ways initially, and the bitmap ended up
> with less code and u.mesh was still (slightly) smaller than u.mgd, 
> but I agree it does feel kind of bloaty so I'll prep a version the 
> other way.

I was less worried about the bloat part than the "we're maintaining
this data twice" and corruptions/missing some remove paths etc. That
doesn't seem very likely though since it goes through the common
alloc/destroy path, so I guess it's not a problem.

Whichever you prefer really, I don't really mind.

johannes
