Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab0KKBBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 20:01:15 -0500
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
In-Reply-To: <4CDB2488.4040802@candelatech.com>
References: <4CDB2488.4040802@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 17:02:36 -0800
Message-ID: <1289437356.3748.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't really see any deadlock here... hmm. Tejun, do you see anything
wrong with the "locking" in workq stuff here?

Something is holding the RTNL, and a bunch of other things are trying to
acquire it. We don't really know who's holding it and who's acquiring it
though.

> Nov 10 14:54:33 localhost kernel: Showing all locks held in the system:
> Nov 10 14:54:33 localhost kernel: 3 locks held by kworker/0:0/4:
> Nov 10 14:54:33 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11

This comes in from schedule_work() IIRC.

> Nov 10 14:54:33 localhost kernel: 1 lock held by ntpd/1675:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11

ntpd holding/acquiring rtnl

...
> Nov 10 14:54:33 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11

another schedule_work() acquiring/holding RTNL.

> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6438:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070f78c>] netlink_dump+0x3a/0x16a
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6441:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6442:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by iwconfig/6443:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6444:
> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11

bunch of other things trying / holding ...

The other things I snipped seem completely orthogonal...

johannes

