Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:36669 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762246Ab2FVOlz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:41:55 -0400
Message-ID: <1340376114.31821.15.camel@joe2Laptop> (sfid-20120622_164202_031785_08031C57)
Subject: Re: dynamic debug
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>,
	Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 07:41:54 -0700
In-Reply-To: <1340375643.4491.26.camel@jlt3.sipsolutions.net>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
	 <1340375177.31821.7.camel@joe2Laptop>
	 <1340375643.4491.26.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 16:34 +0200, Johannes Berg wrote:
> On Fri, 2012-06-22 at 07:26 -0700, Joe Perches wrote:
> > On Fri, 2012-06-22 at 14:23 +0200, Johannes Berg wrote:
> > > Joe, Jim, Jason,
> > > 
> > > Joe's conversion of mac80211 to pr_debug() was pretty much a disaster,
> > 
> > First I've heard of it.
> 
> Well I guess you didn't have the pleasure of having to work with bug
> reporters whose mac80211 messages suddenly completely disappeared ...

Nor it seems the pleasure of interaction with a maintainer
that forwards notices like this.

> > > now people have to first select what they want in Kconfig, and then
> > > still enable dynamic debug in debugfs...
> > 
> > This doesn't parse for me.
> > Please illustrate further.
> 
> mac80211 has Kconfig selectors for a bunch of verbose debug options. Now
> you turn them on, but the messages still don't occur, you have to also
> enable dynamic debug. This extra step not make any sense to most people
> and I agree -- having fine-grained compile-time options only to have to
> enable a coarse-grained runtime option seems odd.
> 
> I'd much rather have a coarse-grained Kconfig option (for those people
> who want to save the binary size) and then allow enabling pieces at
> runtime -- see below.
> 
> > >  That doesn't make any sense at
> > > all, and requires teaching everybody new tricks, so I'm basically
> > > reverting it for now in favour of pr_info() instead of pr_debug().
> > 
> > Why not just add #define DEBUG?
> 
> I guess that works?

That works.

>  Doesn't really make a difference though. In reality,
> most messages should be KERN_INFO anyway, so for those that aren't
> hidden behind extra Kconfig options, we should use pr_info().

Why?  Aren't these then possibly some mixture of errors or
notices or info level messages?


