Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYIKRcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:32:02 -0400
Date: Thu, 11 Sep 2008 10:31:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
Message-ID: <20080911173153.GC6049@tesla> (sfid-20080911_193206_330163_52790A02)
References: <20080910220145.707263000@sipsolutions.net> <18632.55008.411078.289830@gargle.gargle.HOWL> <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla> <1221151995.6986.33.camel@johannes.berg> <20080911171059.GB6049@tesla> <1221153199.6986.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221153199.6986.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 10:13:19AM -0700, Johannes Berg wrote:
> On Thu, 2008-09-11 at 10:10 -0700, Luis R. Rodriguez wrote:
> 
> > > The driver already gets notified via sta_notify() that the sta is about
> > > to be deleted, it must make sure that no matter what sort of references
> > > it kept, the sta will not be accessed after that sta_notify call.
> > 
> > Ah good point. Then what is the issue?
> 
> Well, mostly that ath9k right now assumes it controls the lifetime, and
> it won't do that afterwards, so since I didn't want to read all of the
> code I failed to change it that way because I didn't know where node
> pointers are kept. It's not a huge issue really, but the lifetime
> management change is somewhat involved, I think.

Sure, it just needs a review.

  Luis

