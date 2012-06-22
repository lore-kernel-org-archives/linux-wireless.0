Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:45632 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762563Ab2FVPce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 11:32:34 -0400
Message-ID: <1340379153.31821.21.camel@joe2Laptop> (sfid-20120622_173242_785938_39023724)
Subject: Re: dynamic debug
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>,
	Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 08:32:33 -0700
In-Reply-To: <1340378474.4491.36.camel@jlt3.sipsolutions.net>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
	 <1340375177.31821.7.camel@joe2Laptop>
	 <1340375643.4491.26.camel@jlt3.sipsolutions.net>
	 <1340376114.31821.15.camel@joe2Laptop>
	 <1340378474.4491.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 17:21 +0200, Johannes Berg wrote:
> On Fri, 2012-06-22 at 07:41 -0700, Joe Perches wrote:
> 
> > > > >  That doesn't make any sense at
> > > > > all, and requires teaching everybody new tricks, so I'm basically
> > > > > reverting it for now in favour of pr_info() instead of pr_debug().
> > > > 
> > > > Why not just add #define DEBUG?
> > > 
> > > I guess that works?
> > 
> > That works.
> 
> Are you sure? It doesn't really seem to work ...
> 
> #if defined(CONFIG_DYNAMIC_DEBUG)
> /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
> #define pr_debug(fmt, ...) \
>         dynamic_pr_debug(fmt, ##__VA_ARGS__)
> #elif defined(DEBUG)
> #define pr_debug(fmt, ...) \
>         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> 
> 
> 
> So basically, if you have CONFIG_DYNAMIC_DEBUG, you *still* need to
> enable it with the dynamic debug framework, right?

No.

In dynamic_debug.h, there's a mechanism to enable all
dynamic_pr_debug lines when DEBUG is #defined

#if defined DEBUG
#define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
#else
#define _DPRINTK_FLAGS_DEFAULT 0
#endif


