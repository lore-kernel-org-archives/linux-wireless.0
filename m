Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab0JEI3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 04:29:48 -0400
Subject: Re: Lockup with ath5k, rtnl_mutex related?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA6468.3030706@candelatech.com>
References: <4CAA6468.3030706@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:29:46 +0200
Message-ID: <1286267386.3641.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 16:34 -0700, Ben Greear wrote:
> I'm (also) trying to debug an issue with an ath5k system that deadlocks.
> 
> We have sysrq output for the held locks, process backtraces, etc.
> 
> One thing that has me confused is that the locks-held output shows
> a large number of processes owning the rtnl_mutex.  Any idea
> how to tell what process *really* owns it?

Can't really -- the mutex code acquires the lockdep dep_map before it
even manages to lock, so that it can detect recursive locking.

johannes


