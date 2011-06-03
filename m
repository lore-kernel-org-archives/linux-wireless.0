Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FCU6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 16:58:49 -0400
Subject: Re: rfkill deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: duaneg@dghda.com
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <20110603160049.GA8767@kereru>
References: <20110603160049.GA8767@kereru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 22:58:47 +0200
Message-ID: <1307134727.3800.12.camel@jlt3.sipsolutions.net> (sfid-20110603_225853_212522_DD615BCA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 17:00 +0100, duaneg@dghda.com wrote:
> Hi there,
> 
> I'm getting a deadlock with 3.0.0-rc1:
> 
> Jun  3 12:06:20 kereru kernel: =======================================================
> Jun  3 12:06:20 kereru kernel: [ INFO: possible circular locking dependency detected ]
> Jun  3 12:06:20 kereru kernel: 3.0.0-rc1-00049-g1fa7b6a #57
> Jun  3 12:06:20 kereru kernel: -------------------------------------------------------
> Jun  3 12:06:20 kereru kernel: kworker/0:1/4525 is trying to acquire lock:
> Jun  3 12:06:20 kereru kernel: (&rdev->mtx){+.+.+.}, at: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
> Jun  3 12:06:20 kereru kernel: 
> Jun  3 12:06:20 kereru kernel: but task is already holding lock:
> Jun  3 12:06:20 kereru kernel: (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff8164dcef>] cfg80211_rfkill_set_block+0x4f/0xa0
> Jun  3 12:06:20 kereru kernel: 
> Jun  3 12:06:20 kereru kernel: which lock already depends on the new lock.

This is caused by Luca's scheduled scan changes. The reason is that
cfg80211_rfkill_set_block holds devlist_mtx, but then he added
cfg80211_lock_rdev(rdev); to NETDEV_GOING_DOWN, which is of course
invoked by dev_close() in cfg80211_rfkill_set_block(). Thus, the
problem. Not sure what to do to solve it, I'll let him sort it out :)

johannes

