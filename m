Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36200 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbbAGNqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:46:37 -0500
Message-ID: <1420638389.3407.13.camel@sipsolutions.net> (sfid-20150107_144641_061239_6374EC4F)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 07 Jan 2015 14:46:29 +0100
In-Reply-To: <CA+XVXfezPYoyEv-HVq_Xy9HHyRKeqDZMxOWDXLTQMHprkbM0ng@mail.gmail.com> (sfid-20150107_144300_510345_41B9CB16)
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
	 <1420541514.1966.16.camel@sipsolutions.net>
	 <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com>
	 <1420637871.3407.10.camel@sipsolutions.net>
	 <CA+XVXfezPYoyEv-HVq_Xy9HHyRKeqDZMxOWDXLTQMHprkbM0ng@mail.gmail.com>
	 (sfid-20150107_144300_510345_41B9CB16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 15:42 +0200, Arik Nemtsov wrote:
> On Wed, Jan 7, 2015 at 3:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2015-01-07 at 15:34 +0200, Arik Nemtsov wrote:
> >
> >> > I'm not convinced this is the right thing to do. When checking for the
> >> > current wdev that it can use a channel, then it seems that it's own
> >> > current BSS connection (if any) shouldn't actually be taken into account
> >> > - ergo the lock shouldn't have to be taken, that interface should be
> >> > excluded from the "can beacon due to concurrent check" anyway.
> >>
> >> We have a couple of checks we want to add in the pipeline that also
> >> need "this" wdev in the concurrent check, so I'd prefer to avoid this.
> >
> > Why would you need to check "this" wdev when doing something for "this"
> > wdev? Seems odd? But I'm willing to learn :)
> 
> There's some convoluted regulatory logic where if this GO (or any
> other) are operating on this GO_CONCURRENT (and not indoor-only)
> channel, then it may continue in its operation even after the STA that
> operated concurrently has disconnected.

Uh, ok, not sure I have that yet...

> >
> >> > Also, the only reason this can happen anyway is when you call "can
> >> > beacon" for a station interface - which seems nonsensical. Given that
> >>
> >> This is not true. This happens with current code for a p2p-go
> >> interface during channel validity checks in reg.c.
> >
> > Not sure I see this? The only thing doing wdev locking is
> > cfg80211_go_permissive_chan(), no? And that only for station interfaces.
> 
> cfg80211_go_permissive_chan is called from cfg80211_reg_can_beacon,
> currently only for GO interfaces, but for STA also in the future
> (hopefully).
> The latter is called during channel validity checks for GO.

Ok.

Should I just apply the patch as it is then?

johannes

