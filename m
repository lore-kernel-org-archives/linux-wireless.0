Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab1FVNMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:12:08 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110622125853.GA4982@hertz.marvell.com>
References: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
	 <20110621141017.GC32464@hertz.marvell.com>
	 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
	 <20110621163351.GD32464@hertz.marvell.com>
	 <20110622071743.GA4087@hertz.marvell.com>
	 <20110622123118.GA4800@hertz.marvell.com>
	 <1308746965.29571.1.camel@jlt3.sipsolutions.net>
	 <20110622125853.GA4982@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 15:12:06 +0200
Message-ID: <1308748326.29571.6.camel@jlt3.sipsolutions.net> (sfid-20110622_151212_050684_A61C72A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 18:28 +0530, Yogesh Ashok Powar wrote:
> On Wed, Jun 22, 2011 at 05:49:25AM -0700, Johannes Berg wrote:
> > On Wed, 2011-06-22 at 18:01 +0530, Yogesh Ashok Powar wrote:
> > > > Will work on some other logic.
> > > 
> > > Following is the complete V2-patch
> > > 
> > > v2 changes: a) Moved counter++ before __ieee80211_key_replace in
> > > 		key_link()
> > > 	    b) Moved crypto_tx_tailroom_needed_cnt to sdata resolve
> > > 	        issue with multiple sdata instances in hw reset.
> > 
> > Looks good. Now I'm just worried about memory and compiler barriers that
> > may be needed so the counter update doesn't move after anything else...
> > Hmm.
> 
> I some how feel that synchronize_net may be replaced with
> synchronize_rcu and still the race wont happen.
> 
> So the new logic would be 
> - counter++		<-- Here keys are not added or deleted
> 			    so rcu readers wont have problem
> 			    with extra space allocated.
> 
> - synchronize_rcu	<-- This will flush existing readers. Again
> 			    new readers will have no problem with extra
> 			    space allocated.
> 
> Let me know your opinion on this.

It doesn't really matter -- synchronize_net() is exactly the same as
synchronize_rcu().

What I'm worried about is that there's no memory barrier after the
counter update, so how do we know it cannot happen after
synchronize_rcu()? I think we need something like rcu_assign_pointer()
but I don't see rcu_assign_index() (any more?)

johannes

