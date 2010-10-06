Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45753 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0JFUaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 16:30:11 -0400
Date: Wed, 6 Oct 2010 16:21:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
Message-ID: <20101006202106.GL2472@tuxdriver.com>
References: <201010061200.54364.chunkeey@googlemail.com>
 <201010061220.50800.chunkeey@googlemail.com>
 <1286361705.3655.121.camel@jlt3.sipsolutions.net>
 <201010061343.23463.chunkeey@googlemail.com>
 <1286365578.3655.187.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286365578.3655.187.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 01:46:18PM +0200, Johannes Berg wrote:
> On Wed, 2010-10-06 at 13:43 +0200, Christian Lamparter wrote:
> 
> > > Basically the thing is that until your patch, the data in the struct
> > > didn't actually need locking because it was accessed by the RX path only
> > > which is not concurrent.
> > > 
> > I see. So basically all rx handlers are affected by these rx->sta races.
> > 
> > John, can you please revert (or at least drop from the upcoming 2.6.37-rcX cycle):
> > 
> > (mac80211: fix release_reorder_timeout in scan)
> > mac80211: fix rcu-unsafe pointer dereference
> > mac80211: AMPDU rx reorder timeout timer
> > (mac80211: remove unused rate function parameter)
> > mac80211: put rx handlers into separate functions
> 
> I think it's probably easier to fix than to revert now? There are only a
> handful of fields, and it seemed to me that most of them can easily be
> moved under the reorder lock.

I would prefer a fix on top rather than a series of reverts...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
