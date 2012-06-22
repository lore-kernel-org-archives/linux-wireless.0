Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33316 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590Ab2FVO0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:26:18 -0400
Message-ID: <1340375177.31821.7.camel@joe2Laptop> (sfid-20120622_162621_665280_54BE3A97)
Subject: Re: dynamic debug
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Cc: Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 07:26:17 -0700
In-Reply-To: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
References: <1340367797.4491.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 14:23 +0200, Johannes Berg wrote:
> Joe, Jim, Jason,
> 
> Joe's conversion of mac80211 to pr_debug() was pretty much a disaster,

First I've heard of it.

> now people have to first select what they want in Kconfig, and then
> still enable dynamic debug in debugfs...

This doesn't parse for me.
Please illustrate further.

>  That doesn't make any sense at
> all, and requires teaching everybody new tricks, so I'm basically
> reverting it for now in favour of pr_info() instead of pr_debug().

Why not just add #define DEBUG?

> I'd actually not mind using pr_debug() if it meant we could get rid of
> all the Kconfig symbols, but that's not possible.
> 
> The biggest problem here really is that the dynamic debug infrastructure
> lets us enable messages at runtime, which is great, but the granularity
> is useless since you only have these possibilities:

What I think dyn_debug needs is a mask/level control.
so you can do the equivalent of
	echo val > /somewhere
to control the tested against value

see: https://lkml.org/lkml/2011/8/21/128



