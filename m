Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0KRSxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:53:45 -0500
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4CE4D41F.1080005@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>
	 <4CDDAA3B.9090007@candelatech.com>
	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>
	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
	 <4CE292F7.4090200@kernel.org>
	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>
	 <4CE396A9.1050908@kernel.org>
	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>
	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>
	 <4CE4D41F.1080005@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 08:59:45 -0800
Message-ID: <1290099585.3801.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 08:22 +0100, Tejun Heo wrote:

> > But why is this unreliable and/or high latency anyway?
> 
> Oh, no, it's not unreliable or high latency on workqueue side.  It's
> just error prone for its users.  As there is only single executino
> resource by definition, any single work can stall the whole queue and
> it also is easy to create a deadlock by introducing circular
> dependency.  For example, mac80211 uses system wq for restart work and
> that's to avoid grabbing rtnl_lock from a work as that will introduce
> a deadlock, right?  If you use non-ordered workqueues, you don't need
> to worry about those artificial dependencies.

Ok, that makes sense then. I thought you were saying there was some
intrinsic issue with this! I do know about the issues, but we do have to
process some things in the right order here so I'd rather be aware of
those issues than have to deal with reordering and/or our own queueing.

> > It used to be just fine .. maybe this is one of the cases where we
> > should actually be using a dedicated thread ...
> 
> Oh, trust me, that won't change anything.  If there's a bug in
> workqueue (I don't think this is the case here tho), let's fix it.  If
> mac80211 is somehow tripping a deadlock around single execution
> resource, let's fix the culprit.  Okay?  At this point, all we need is
> a proper task dump to see who's holding what where.

I agree completely -- just misunderstood you there!

johannes

