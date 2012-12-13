Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2LMR6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 12:58:42 -0500
Message-ID: <1355421541.9463.8.camel@jlt4.sipsolutions.net> (sfid-20121213_185845_790863_F58C9E7B)
Subject: Re: Add a new work-queue for destructing stations?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 13 Dec 2012 18:59:01 +0100
In-Reply-To: <50CA1470.4030107@candelatech.com> (sfid-20121213_184629_945929_240FAE82)
References: <50CA1470.4030107@candelatech.com>
	 (sfid-20121213_184629_945929_240FAE82)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 09:46 -0800, Ben Greear wrote:
> As previously posted, there can be cases where the RTNL is held for a
> very long time when trying to do the:  flush_workqueue(local->workqueue);
> in mac80211_do_stop because there are lots of 'slow' work-items queued up.
> 
> I'd like to work on making this faster...
> 
> My first idea is to add a second work-queue to the 'local' for high-priority
> items that can be executed independently from the current local->workqueue,
> and put the free_sta_rcu work() in that queue.
> 
> I'm guessing that to be safe, the do_stop() code would need to selectively
> purge any work items in the local->workqueue that relate to the sdata
> being destroyed, as well.  I'm not sure how possible that would be...

I don't think that's easy, but you're welcome to try. The
free_sta_work() function references the sdata so it absolutely must run
at this point.

The only/easiest thing that seems vaguely safe would be a per-vif
workqueue for this? But that's really annoying too, since it needs an
extra thread etc.

johannes

