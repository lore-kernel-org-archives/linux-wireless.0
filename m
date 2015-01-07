Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbbAGNh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:37:56 -0500
Message-ID: <1420637871.3407.10.camel@sipsolutions.net> (sfid-20150107_143759_361227_F44D63FB)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 07 Jan 2015 14:37:51 +0100
In-Reply-To: <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com> (sfid-20150107_143425_279464_1C23BEE0)
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
	 <1420541514.1966.16.camel@sipsolutions.net>
	 <CA+XVXfeFWbVLCpebTQpv9FZPaDUEt1NJ6GpnyRoZ1UG91nMymw@mail.gmail.com>
	 (sfid-20150107_143425_279464_1C23BEE0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 15:34 +0200, Arik Nemtsov wrote:

> > I'm not convinced this is the right thing to do. When checking for the
> > current wdev that it can use a channel, then it seems that it's own
> > current BSS connection (if any) shouldn't actually be taken into account
> > - ergo the lock shouldn't have to be taken, that interface should be
> > excluded from the "can beacon due to concurrent check" anyway.
> 
> We have a couple of checks we want to add in the pipeline that also
> need "this" wdev in the concurrent check, so I'd prefer to avoid this.

Why would you need to check "this" wdev when doing something for "this"
wdev? Seems odd? But I'm willing to learn :)

> Unless we treat the exclude_wdev as "already locked wdev", which I
> think is unglier than what I do here.

Yeah that doesn't seem right, agree.

> > Also, the only reason this can happen anyway is when you call "can
> > beacon" for a station interface - which seems nonsensical. Given that
> 
> This is not true. This happens with current code for a p2p-go
> interface during channel validity checks in reg.c.

Not sure I see this? The only thing doing wdev locking is
cfg80211_go_permissive_chan(), no? And that only for station interfaces.

johannes

