Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39373 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYIKQuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 12:50:23 -0400
Date: Thu, 11 Sep 2008 09:50:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
Message-ID: <20080911165011.GA6049@tesla> (sfid-20080911_185028_074791_AD3BD971)
References: <20080910220145.707263000@sipsolutions.net> <18632.55008.411078.289830@gargle.gargle.HOWL> <1221139351.6986.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221139351.6986.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 06:22:31AM -0700, Johannes Berg wrote:
> On Thu, 2008-09-11 at 13:59 +0530, Sujith wrote:
> 
> >  > I'd been talking with Sujith about this one:
> >  > 
> >  >  * mac80211: share STA information with driver
> >  > 
> >  > and decided to just do it; as it stands it's not very useful
> >  > but I expect it to be used soon, if not we can remove the
> >  > EXPORT_SYMBOL again.
> >  > 
> > 
> > This would be very useful for ath9k. Making use of the
> > private area for each STA can enable removal of the node list
> > that is maintained currently.
> 
> I had actually tried
> (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
> but you're using refcounting for the nodes while mac80211 RCU-protects
> them, so I didn't get very far.

Good thing I read RCU docs yesterday.

We should be able to remove ref counts and simply use RCU and
sychronize_rcu() before deletion.

> It needs a bit more effort to make sure
> you don't have node pointers stick around in some tx descriptor after
> mac80211 decides to remove a node (which may very well happen while
> frames are queued)

We can call_rcu() here no, and let the driver deal with what it needs to
prior to deletion?

  Luis
