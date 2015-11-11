Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47213 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbbKKPGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 10:06:01 -0500
Message-ID: <1447254355.2276.20.camel@sipsolutions.net> (sfid-20151111_160624_955242_0EA4A748)
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Date: Wed, 11 Nov 2015 16:05:55 +0100
In-Reply-To: <20151111094516.07d5d1d5@gandalf.local.home>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	 <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	 <1447201345.2475.15.camel@coelho.fi>
	 <1447227472.2276.7.camel@sipsolutions.net>
	 <20151111083430.1e77c329@gandalf.local.home>
	 <1447249156.2276.17.camel@sipsolutions.net>
	 <20151111091859.55f6a4fd@gandalf.local.home>
	 <1447252142.2276.19.camel@sipsolutions.net>
	 <20151111094516.07d5d1d5@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-11 at 09:45 -0500, Steven Rostedt wrote:
> 
> config FLAG_ALL_SET
>   default y
>   depends on MY_DRIVER_1 && !MY_DRIVER_2 && ... && MY_DRIVER_N

Right. But then I have to list all the drivers, which is rather
annoying. I'd have to add more magic so that you somehow can't build
without adding the driver to the list or so.

I think adding this "counter" thing wouldn't actually be too hard, I'm
not sure it's *worth* changing Kconfig for it, but I'll try later.

johannes
