Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42379 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbZEKTJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 15:09:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 12:09:12 -0700
Date: Mon, 11 May 2009 12:09:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
Message-ID: <20090511190922.GD18696@tesla>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com> <1242033904-25694-4-git-send-email-lrodriguez@atheros.com> <1242036115.3284.15.camel@johannes.local> <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com> <1242068010.3873.46.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1242068010.3873.46.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 11:53:30AM -0700, Johannes Berg wrote:
> On Mon, 2009-05-11 at 11:34 -0700, Luis R. Rodriguez wrote:
> 
> > > Also, __ieee80211_queues_stopped_by_reason is misnamed since it checks
> > > only a single queue. I also think that we can do this much better by
> > > keeping track of the suspend state in a new variable rather than looking
> > > at all the queues; even just checking queue 0 would be sufficient, but I
> > > think a new variable is warranted.
> > 
> > A global variable for going to suspend? Hm, do we have a system wide
> > thing for this instead?
> 
> No, and even then we couldn't use it I think since you can have
> per-device suspend. I was just thinking of a local->variable.

OK thanks will add this.

  Luis
