Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2C2Giz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 02:38:55 -0400
Message-ID: <1333003130.3611.0.camel@jlt3.sipsolutions.net> (sfid-20120329_083859_430782_E553B7B4)
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Bryan Phillippe <Bryan.Phillippe@watchguard.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 29 Mar 2012 08:38:50 +0200
In-Reply-To: <4F736A5A.4030408@candelatech.com>
References: <4F57B7E6.1050103@candelatech.com>
	   <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>
	   <4F735EF5.3010708@candelatech.com>
	  <1332961193.3479.40.camel@jlt3.sipsolutions.net>
	  <4F73620D.507@candelatech.com>
	 <1332962004.3479.42.camel@jlt3.sipsolutions.net>
	 <4F736A5A.4030408@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 12:45 -0700, Ben Greear wrote:
> On 03/28/2012 12:13 PM, Johannes Berg wrote:
> > On Wed, 2012-03-28 at 12:10 -0700, Ben Greear wrote:
> >> On 03/28/2012 11:59 AM, Johannes Berg wrote:
> 
> >>> Hm. Maybe this is the problem?
> >>>
> >>> http://p.sipsolutions.net/d432de678ae3ff17.txt
> >>
> >> I don't see any code that matches that in 3.3.0 (nothing with nl80211_start_ap, for instance)
> >
> > ah, well, it's set_beacon there or so
> >
> > johannes
> 
> 
> I tried this patch, but it still spews (see below)

> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x26/0x2b [mac80211]()

>   [<c04263d1>] warn_slowpath_common+0x65/0x7a
>   [<f96a28d1>] ? check_sdata_in_driver+0x26/0x2b [mac80211]
>   [<c042644a>] warn_slowpath_fmt+0x26/0x2a
>   [<f96a28d1>] check_sdata_in_driver+0x26/0x2b [mac80211]
>   [<f96a3438>] ieee80211_set_txq_params+0x97/0xec [mac80211]

but now it's coming from elsewhere, see this patch?

http://p.sipsolutions.net/b8506c9d7ce8a119.txt

johannes

