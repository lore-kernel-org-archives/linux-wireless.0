Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39292 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYIKRLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:11:08 -0400
Date: Thu, 11 Sep 2008 10:10:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
Message-ID: <20080911171059.GB6049@tesla> (sfid-20080911_191126_996649_D4BD3DEC)
References: <20080910220145.707263000@sipsolutions.net> <18632.55008.411078.289830@gargle.gargle.HOWL> <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla> <1221151995.6986.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221151995.6986.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 09:53:15AM -0700, Johannes Berg wrote:
> On Thu, 2008-09-11 at 09:50 -0700, Luis R. Rodriguez wrote:
> 
> > > I had actually tried
> > > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
> > > but you're using refcounting for the nodes while mac80211 RCU-protects
> > > them, so I didn't get very far.
> > 
> > Good thing I read RCU docs yesterday.
> 
> Heh.
> 
> > We should be able to remove ref counts and simply use RCU and
> > sychronize_rcu() before deletion.
> 
> Well you don't get to control deletion then, that's another thing.

Does it matter? Our driver won't care as long as the entry still exists.
Just as with stale routing tables, does it matter if we keep thinking we
have a node for a few moments later?

> > > It needs a bit more effort to make sure
> > > you don't have node pointers stick around in some tx descriptor after
> > > mac80211 decides to remove a node (which may very well happen while
> > > frames are queued)
> > 
> > We can call_rcu() here no, and let the driver deal with what it needs to
> > prior to deletion?
> 
> The driver already gets notified via sta_notify() that the sta is about
> to be deleted, it must make sure that no matter what sort of references
> it kept, the sta will not be accessed after that sta_notify call.

Ah good point. Then what is the issue?

  Luis
