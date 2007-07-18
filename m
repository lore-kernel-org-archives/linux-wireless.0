Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4328 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXGRSdQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 14:33:16 -0400
Date: Wed, 18 Jul 2007 14:13:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211/bcm43xx deadlock
Message-ID: <20070718181347.GD6625@tuxdriver.com>
References: <1182848382.3830.5.camel@johannes.berg> <200706261617.45713.mb@bu3sch.de> <1182937106.4769.10.camel@johannes.berg> <200706271448.58087.mb@bu3sch.de> <1182953184.4769.24.camel@johannes.berg> <1182954090.4769.28.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182954090.4769.28.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2007 at 04:21:30PM +0200, Johannes Berg wrote:
> On Wed, 2007-06-27 at 16:06 +0200, Johannes Berg wrote:
> 
> > I'm not convinced this is the same thing, the deadlock here is simply
> > that something running on the workqueue is trying to rtnl_lock() while
> > flushing the workqueue is done under rtnl.
> 
> Looking again, Michael agrees that this is not the same deadlock he's
> talking about, so back to the drawing board.
> 
> I shall be trying to add lockdep support for this sort of thing, but
> until then how can we fix this? What exactly does the rtnl protect in
> ieee80211_sta_config_auth?

I didn't see an answer here.  Before we remove it, I'd prefer to know
what we thought we were protecting in the first place. :-)

John

P.S.  Don't get me wrong -- less "big kernel lock" usage is probably
better...
-- 
John W. Linville
linville@tuxdriver.com
