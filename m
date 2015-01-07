Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36209 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbbAGNuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:50:20 -0500
Message-ID: <1420638611.3407.14.camel@sipsolutions.net> (sfid-20150107_145022_838895_79F0BC76)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 07 Jan 2015 14:50:11 +0100
In-Reply-To: <CA+XVXffmhz969NFRTyvKxJjBtHat-aO+GOCSo_MfJROCiWqQ7g@mail.gmail.com> (sfid-20150107_144913_204913_20AF85C1)
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
	 <1420541514.1966.16.camel@sipsolutions.net>
	 <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com>
	 <1420637871.3407.10.camel@sipsolutions.net>
	 <CA+XVXfezPYoyEv-HVq_Xy9HHyRKeqDZMxOWDXLTQMHprkbM0ng@mail.gmail.com>
	 <1420638389.3407.13.camel@sipsolutions.net>
	 <CA+XVXffmhz969NFRTyvKxJjBtHat-aO+GOCSo_MfJROCiWqQ7g@mail.gmail.com>
	 (sfid-20150107_144913_204913_20AF85C1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 15:48 +0200, Arik Nemtsov wrote:
> >
> >> >
> >> >> > Also, the only reason this can happen anyway is when you call "can
> >> >> > beacon" for a station interface - which seems nonsensical. Given that
> >> >>
> >> >> This is not true. This happens with current code for a p2p-go
> >> >> interface during channel validity checks in reg.c.
> >> >
> >> > Not sure I see this? The only thing doing wdev locking is
> >> > cfg80211_go_permissive_chan(), no? And that only for station interfaces.
> >>
> >> cfg80211_go_permissive_chan is called from cfg80211_reg_can_beacon,
> >> currently only for GO interfaces, but for STA also in the future
> >> (hopefully).
> >> The latter is called during channel validity checks for GO.
> >
> > Ok.
> >
> > Should I just apply the patch as it is then?
> 
> It fixes a real existing deadlock, so I think so, yea.

Is it needed on 3.19?

johannes

