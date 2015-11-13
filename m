Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59556 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbbKMQbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:31:45 -0500
Message-ID: <1447432302.3271.18.camel@sipsolutions.net> (sfid-20151113_173150_582131_EFF0E699)
Subject: Re: [RFC v4 5/8] mac80211: generate hw flags from include file
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 17:31:42 +0100
In-Reply-To: <20151113112511.7431eb34@gandalf.local.home>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	 <1447318073-22669-6-git-send-email-johannes@sipsolutions.net>
	 <20151113112511.7431eb34@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 11:25 -0500, Steven Rostedt wrote:

> > +	__DEFINE_HWFLAG(_flg,					
> > 	\
> > +			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_ON)
> > ,	\
> > +			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_OFF
> > ))
> > +#include <net/mac80211-hwflags.h>
> > +#undef DEFINE_HWFLAG
> 
> You learned to use the MACRO force well, young Skywalker.
> 

Heh. Sadly, this breaks the automatic Kconfig dependency tracking,
since it doesn't realize it should have a dependency on
include/config/mac80211/hw/.../{on,off}.h

Not sure what to do about that - I'm tempted to just ignore it.

johannes
