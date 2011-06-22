Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55256 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab1FVNHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:07:54 -0400
Date: Wed, 22 Jun 2011 18:28:54 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110622125853.GA4982@hertz.marvell.com> (sfid-20110622_150758_033437_858E12D2)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308746965.29571.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 05:49:25AM -0700, Johannes Berg wrote:
> On Wed, 2011-06-22 at 18:01 +0530, Yogesh Ashok Powar wrote:
> > > Will work on some other logic.
> > 
> > Following is the complete V2-patch
> > 
> > v2 changes: a) Moved counter++ before __ieee80211_key_replace in
> > 		key_link()
> > 	    b) Moved crypto_tx_tailroom_needed_cnt to sdata resolve
> > 	        issue with multiple sdata instances in hw reset.
> 
> Looks good. Now I'm just worried about memory and compiler barriers that
> may be needed so the counter update doesn't move after anything else...
> Hmm.

I some how feel that synchronize_net may be replaced with
synchronize_rcu and still the race wont happen.

So the new logic would be 
- counter++		<-- Here keys are not added or deleted
			    so rcu readers wont have problem
			    with extra space allocated.

- synchronize_rcu	<-- This will flush existing readers. Again
			    new readers will have no problem with extra
			    space allocated.

Let me know your opinion on this.

Thanks
Yogesh
