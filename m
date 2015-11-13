Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59547 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981AbbKMQan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:30:43 -0500
Message-ID: <1447432236.3271.17.camel@sipsolutions.net> (sfid-20151113_173050_348594_03F967BB)
Subject: Re: [RFC v4 3/8] mac80211: use static keys for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 17:30:36 +0100
In-Reply-To: <20151113112236.0303675a@gandalf.local.home>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	 <1447318073-22669-4-git-send-email-johannes@sipsolutions.net>
	 <20151113112236.0303675a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 11:22 -0500, Steven Rostedt wrote:

> This sure could use a comment.
> 
>  on = 0, off = 0,  -1 + (0^0) * (1 + 0) = -1
>  on = 0, off = 1,  -1 + (0^1) * (1 + 0) = 0
>  on = 1, off = 0,  -1 + (1^0) * (1 + 1) = 1
>  on = 1, off = 1,  -1 + (1^1) * (1 + 1) = -1
> 
> The I would also state:
> 
>   -1 means to simply use if logic (no jump labels/static keys)
>    0 means to use jump label to off
>    1 means to use jump label to on

Yeah, fair enough :)

FWIW, I changed my mind and redid all of this without the jump labels,
just actually eliding the code completely if possible. I've put it in
the hwflags-elide branch in my mac80211-next tree:
https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/log/?h=hwflags-elide

johannes
