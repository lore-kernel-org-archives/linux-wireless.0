Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab2FVPgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 11:36:41 -0400
Message-ID: <1340379394.4491.37.camel@jlt3.sipsolutions.net> (sfid-20120622_173653_537886_168825EA)
Subject: Re: dynamic debug
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
	Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 17:36:34 +0200
In-Reply-To: <1340379153.31821.21.camel@joe2Laptop>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
	 <1340375177.31821.7.camel@joe2Laptop>
	 <1340375643.4491.26.camel@jlt3.sipsolutions.net>
	 <1340376114.31821.15.camel@joe2Laptop>
	 <1340378474.4491.36.camel@jlt3.sipsolutions.net>
	 <1340379153.31821.21.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 08:32 -0700, Joe Perches wrote:

> > Are you sure? It doesn't really seem to work ...
> > 
> > #if defined(CONFIG_DYNAMIC_DEBUG)
> > /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
> > #define pr_debug(fmt, ...) \
> >         dynamic_pr_debug(fmt, ##__VA_ARGS__)
> > #elif defined(DEBUG)
> > #define pr_debug(fmt, ...) \
> >         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> > 
> > 
> > 
> > So basically, if you have CONFIG_DYNAMIC_DEBUG, you *still* need to
> > enable it with the dynamic debug framework, right?
> 
> No.
> 
> In dynamic_debug.h, there's a mechanism to enable all
> dynamic_pr_debug lines when DEBUG is #defined
> 
> #if defined DEBUG
> #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
> #else
> #define _DPRINTK_FLAGS_DEFAULT 0
> #endif

Hah. Too much indirection I guess.

Thanks.

I'll respin my patches.

johannes

