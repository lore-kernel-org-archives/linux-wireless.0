Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2C1TN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:13:28 -0400
Message-ID: <1332962004.3479.42.camel@jlt3.sipsolutions.net> (sfid-20120328_211331_640646_2506EA30)
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Bryan Phillippe <Bryan.Phillippe@watchguard.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 28 Mar 2012 21:13:24 +0200
In-Reply-To: <4F73620D.507@candelatech.com>
References: <4F57B7E6.1050103@candelatech.com>
	  <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>
	  <4F735EF5.3010708@candelatech.com>
	 <1332961193.3479.40.camel@jlt3.sipsolutions.net>
	 <4F73620D.507@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 12:10 -0700, Ben Greear wrote:
> On 03/28/2012 11:59 AM, Johannes Berg wrote:
> > On Wed, 2012-03-28 at 11:56 -0700, Ben Greear wrote:
> >> On 03/07/2012 11:45 AM, Bryan Phillippe wrote:
> >>>
> >>> Yes, it's a known problem.  It's very reproducible for me on a non-hacked 3.3-rc1 as well: changing from AP to client mode, or setting up multiple APs, or changing from 2.4Ghz to 5Ghz all seem to trigger this warning with various stack traces.
> >>
> >> I'm still seeing this and related warnings on 3.3.0.  At least some
> >> of them comes from calls the 'hostapd' process makes (I printed
> >> current->comm in the warning).
> >>
> >> I am not having luck writing a simple script that reproduce this,
> >> but my application that creates a VAP and bunch of virtual station
> >> hits it every time on startup.
> >>
> >> Bryan:  Do you have a simple script that reproduces this problem?
> >>
> >> Johannes:  Any ideas on likely causes of this problem?  Might help
> >> me zero in on the problem quicker...
> >
> > Hm. Maybe this is the problem?
> >
> > http://p.sipsolutions.net/d432de678ae3ff17.txt
> 
> I don't see any code that matches that in 3.3.0 (nothing with nl80211_start_ap, for instance)

ah, well, it's set_beacon there or so

johannes

