Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab2BRRjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 12:39:09 -0500
Date: Sat, 18 Feb 2012 18:39:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
Message-ID: <20120218173900.GC11478@redhat.com> (sfid-20120218_183921_267306_7406761A)
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
 <4EB96416.5040700@candelatech.com>
 <1329493491.3786.6.camel@jlt3.sipsolutions.net>
 <4F3E7CA5.7010207@candelatech.com>
 <1329502761.3330.0.camel@jlt3.sipsolutions.net>
 <4F3E9EBE.60602@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F3E9EBE.60602@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2012 at 10:38:54AM -0800, Ben Greear wrote:
> On 02/17/2012 10:19 AM, Johannes Berg wrote:
> >On Fri, 2012-02-17 at 08:13 -0800, Ben Greear wrote:
> >
> >>>Given the auth/assoc redesign that went in now, are you still carrying
> >>>this? Does the redesign address your problem?
> >>
> >>I haven't looked yet...still stuck back on 3.0 kernel for the
> >>most part.
> >>
> >>I should be moving to 3.3 sometime soon, and will see how it works.
> >>
> >>I was thinking that I would ignore the work logic for now and probably
> >>just focus on re-applying the on-channel scan optimization first.
> >>
> >>Are you done, or mostly done with the re-architecture you were working on?
> >
> >Yes, I'm done.
> >
> >>I know you didn't like the scan optimization from before...do you have any
> >>ideas on how it might be done more to your liking?
> >
> >I, umm, don't even remember what that was about :)
> 
> The basic idea is that if the user requests that we only
> scan a single channel, and that channel is the operating channel,
> we should be able to scan without interrupting any other
> packet transmission/reception, and without kicking the NIC to make it go off/on
> channel, etc.
> 
> Basically I had to complicate the scan state machine
> in order to minimize going off-channel (if indeed we are only
> scanning one current channel).
I think no change in scan state machine in needed at all. It could be
simply marked as another type of scan i.e. SCAN_CURRENT_CHAN.
Configure filters at start, send probe request if active, 
add additional flag check in rx_handlers, reconfigure filters
at end.

Stanislaw
