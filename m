Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3DCMl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:41:29 -0400
Message-ID: <1364992883.8351.32.camel@jlt4.sipsolutions.net> (sfid-20130403_144132_894083_8F470396)
Subject: Re: [PATCH 2/2] mac80211:  Make un-found-rate splat a warn-once.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Apr 2013 14:41:23 +0200
In-Reply-To: <514C7FF6.6070301@candelatech.com>
References: <1363727997-1554-1-git-send-email-greearb@candelatech.com>
	  <1363727997-1554-2-git-send-email-greearb@candelatech.com>
	  (sfid-20130319_222017_355151_860485B7) <1363948082.8238.9.camel@jlt4.sipsolutions.net>
	 <514C7FF6.6070301@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-22 at 08:59 -0700, Ben Greear wrote:
> On 03/22/2013 03:28 AM, Johannes Berg wrote:
> > On Tue, 2013-03-19 at 14:19 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear <greearb@candelatech.com>
> >>
> >> After that, print it out with net_ratelimit.  We saw a system
> >> continually hit this warning, for reasons unknown, and it
> >> seems it bogged the system down enough to make it go OOM.
> >
> > I'm not really sure I like this ... that points to a deeper problem, and
> > this just papers over it while causing more cost in the TX path for all
> > the different checks.
> 
> If I add an 'unlikely' to the initial check, that gets back to the original
> TX path cost, or are you worried about something else?
> 
> I think in most cases we should be using some variation of WARN_ONCE
> in all the places that splat a warning...

Let's just make this WARN_ONCE() then maybe?

johannes

