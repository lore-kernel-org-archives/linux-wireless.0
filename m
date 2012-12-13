Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LMXOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:14:06 -0500
Message-ID: <1355440468.9463.39.camel@jlt4.sipsolutions.net> (sfid-20121214_001410_689637_FDCE95E0)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 00:14:28 +0100
In-Reply-To: <1355440328.9463.38.camel@jlt4.sipsolutions.net> (sfid-20121214_001151_563824_D883E843)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
	 <1355159190.8083.1.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VCiPXwUGO+KZmi4Bhd5PvUwwUscnQ0F3xtd5FurEDN-A@mail.gmail.com>
	 (sfid-20121213_233433_174271_005A45D4) <1355438798.9463.32.camel@jlt4.sipsolutions.net>
	 (sfid-20121213_234623_873499_9A8D5A6A) <1355440328.9463.38.camel@jlt4.sipsolutions.net>
	 (sfid-20121214_001151_563824_D883E843)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 00:12 +0100, Johannes Berg wrote:

> > > Looks good, the get_wiphy_regdom() change above seemed like it'd
> > > belong on a separate patch though.
> > 
> > Humm, yeah, wtf. That belongs into the RCU change.
> 
> No actually it doesn't, though I could make it a separate patch with the
> reg.c changes except for adding reg_check_bandwidth(), but that'd only
> be something like "prepare to be able to use rcu protection for
> freq_reg_info", I think I'll keep it this way but add some description.

Added this:

    To do this modify freq_reg_info() to be callable with
    RCU protection and use that, acquiring the mutex isn't
    possible for this function.

johannes

