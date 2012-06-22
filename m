Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab2FVOeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:34:13 -0400
Message-ID: <1340375643.4491.26.camel@jlt3.sipsolutions.net> (sfid-20120622_163425_866853_3BD695DC)
Subject: Re: dynamic debug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
	Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 16:34:03 +0200
In-Reply-To: <1340375177.31821.7.camel@joe2Laptop>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
	 <1340375177.31821.7.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 07:26 -0700, Joe Perches wrote:
> On Fri, 2012-06-22 at 14:23 +0200, Johannes Berg wrote:
> > Joe, Jim, Jason,
> > 
> > Joe's conversion of mac80211 to pr_debug() was pretty much a disaster,
> 
> First I've heard of it.

Well I guess you didn't have the pleasure of having to work with bug
reporters whose mac80211 messages suddenly completely disappeared ...

> > now people have to first select what they want in Kconfig, and then
> > still enable dynamic debug in debugfs...
> 
> This doesn't parse for me.
> Please illustrate further.

mac80211 has Kconfig selectors for a bunch of verbose debug options. Now
you turn them on, but the messages still don't occur, you have to also
enable dynamic debug. This extra step not make any sense to most people
and I agree -- having fine-grained compile-time options only to have to
enable a coarse-grained runtime option seems odd.

I'd much rather have a coarse-grained Kconfig option (for those people
who want to save the binary size) and then allow enabling pieces at
runtime -- see below.

> >  That doesn't make any sense at
> > all, and requires teaching everybody new tricks, so I'm basically
> > reverting it for now in favour of pr_info() instead of pr_debug().
> 
> Why not just add #define DEBUG?

I guess that works? Doesn't really make a difference though. In reality,
most messages should be KERN_INFO anyway, so for those that aren't
hidden behind extra Kconfig options, we should use pr_info(). For those
that are, it doesn't really make a difference?

> > I'd actually not mind using pr_debug() if it meant we could get rid of
> > all the Kconfig symbols, but that's not possible.
> > 
> > The biggest problem here really is that the dynamic debug infrastructure
> > lets us enable messages at runtime, which is great, but the granularity
> > is useless since you only have these possibilities:
> 
> What I think dyn_debug needs is a mask/level control.
> so you can do the equivalent of
> 	echo val > /somewhere
> to control the tested against value
> 
> see: https://lkml.org/lkml/2011/8/21/128

Yeah, that sounds about right. I think having names rather than bitmaps
would be more user-friendly, and with a bit of magic it could also use
jump_level instead of "var & bit" which is even more efficient.

johannes

