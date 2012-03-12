Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CLHKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 03:10:39 -0400
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F5A4C83.50009@candelatech.com>
References: <4F57B7E6.1050103@candelatech.com>
	 (sfid-20120307_203301_816701_DF7D4715) <1331189709.3446.1.camel@jlt3.sipsolutions.net>
	 <4F5A4C83.50009@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Mar 2012 08:10:33 +0100
Message-ID: <1331536233.3496.6.camel@jlt3.sipsolutions.net> (sfid-20120312_081043_089472_6CB7C256)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 10:31 -0800, Ben Greear wrote:
> On 03/07/2012 10:55 PM, Johannes Berg wrote:
> > On Wed, 2012-03-07 at 11:32 -0800, Ben Greear wrote:
> >> This is with a somewhat hacked 3.3.0-rc5+.  Just
> >> curious if this is a known problem.
> >>
> >>
> >> Seems very reproducible on my system.
> >>
> >>
> >> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_noti)
> >
> > The warning means you're modifying an interface the driver doesn't (yet)
> > know about.
> >
> > It's odd that you should be running into this on config_beacon() though
> > since that can only execute when the interface is up ... can you print
> > out the interface name in the warning?
> 
> This is still reproducible in 3.3.0-rc6+ from yesterday.
> 
> 
> I create the VAP with this command:
> 
> ./local/sbin/iw phy wiphy0 interface add vap0 type __ap
> 
> 
> vap0:  Failed check-sdata-in-driver check, flags: 0x0

That's it? That doesn't create a warning here, and somehow you're
running into nl80211_set_wiphy() which isn't called if you execute just
that iw command.

johannes

