Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab2FVOsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:48:41 -0400
Message-ID: <1340376516.4491.34.camel@jlt3.sipsolutions.net> (sfid-20120622_164845_295845_C93B2F33)
Subject: Re: dynamic debug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
	Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 16:48:36 +0200
In-Reply-To: <1340376114.31821.15.camel@joe2Laptop>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
	 <1340375177.31821.7.camel@joe2Laptop>
	 <1340375643.4491.26.camel@jlt3.sipsolutions.net>
	 <1340376114.31821.15.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 07:41 -0700, Joe Perches wrote:

> > > > Joe's conversion of mac80211 to pr_debug() was pretty much a disaster,
> > > 
> > > First I've heard of it.
> > 
> > Well I guess you didn't have the pleasure of having to work with bug
> > reporters whose mac80211 messages suddenly completely disappeared ...
> 
> Nor it seems the pleasure of interaction with a maintainer
> that forwards notices like this.

I told you before that I didn't like you wholesale converting it. I
might have been more open to it if you'd actually let me work on it and
convert some printk(KERN_DEBUG, ... to pr_info(). Now I'm stuck in a
situation where a lot of people will no longer see the messages they
expect, and I have to walk them through new, unexpected steps to make
them show up if I'm debugging a problem.

And heck, it's not even predictable since dynamic debug could be turned
on or off too.

> >  Doesn't really make a difference though. In reality,
> > most messages should be KERN_INFO anyway, so for those that aren't
> > hidden behind extra Kconfig options, we should use pr_info().
> 
> Why?  Aren't these then possibly some mixture of errors or
> notices or info level messages?

Yes, I believe that they are, but since you assumed that all KERN_DEBUG
messages were essentially useless by converting them to off-by-default,
I'm now changing it to assuming they're useful by converting them to
pr_info, we can change them back later.

However, most messages that aren't hidden behind Kconfig options are
actually useful, even if they were printed at KERN_DEBUG before.

johannes

