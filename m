Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3EGOWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:22:20 -0400
Message-ID: <1367936535.8328.56.camel@jlt4.sipsolutions.net> (sfid-20130507_162237_432101_9FD0CB89)
Subject: Re: [RFC 01/12] mac80211: track and share mesh BSSes among
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 07 May 2013 16:22:15 +0200
In-Reply-To: <20130507140835.GD1438@localhost> (sfid-20130507_160953_266299_87301F8E)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 <1367548442-8229-2-git-send-email-thomas@cozybit.com>
	 <1367933862.8328.18.camel@jlt4.sipsolutions.net>
	 <20130507140835.GD1438@localhost> (sfid-20130507_160953_266299_87301F8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-07 at 10:08 -0400, Bob Copeland wrote:
> On Tue, May 07, 2013 at 03:37:42PM +0200, Johannes Berg wrote:
> > Ok this is big ... Let me tackle it patch by patch I guess :-)
> > 
> > > +struct mesh_local_bss {
> > 
> > > +	bool can_share;
> > 
> > Does that even make sense? I mean, wouldn't you simply not link/create
> > such an entry if the given vif can't share?
> 
> We could do that, but as written mpath table now wants an mbss pointer
> in either case.  Seemed more straight-forward to just always require
> it even though the structures are kind of pointless for unshared vifs.

But why even add it to the global list if you only need it locally?

Anyway I guess it doesn't matter, just seemed a bit odd.

johannes

