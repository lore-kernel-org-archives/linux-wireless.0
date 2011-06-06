Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41728 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab1FFGX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 02:23:59 -0400
Received: by ewy2 with SMTP id 2so2563129ewy.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2011 23:23:57 -0700 (PDT)
Subject: Re: rfkill deadlock
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: duaneg@dghda.com, linux-wireless@vger.kernel.org
In-Reply-To: <1307134727.3800.12.camel@jlt3.sipsolutions.net>
References: <20110603160049.GA8767@kereru>
	 <1307134727.3800.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 09:23:54 +0300
Message-ID: <1307341434.23002.382.camel@cumari> (sfid-20110606_082410_171751_2980DB8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 22:58 +0200, Johannes Berg wrote: 
> On Fri, 2011-06-03 at 17:00 +0100, duaneg@dghda.com wrote:
> > Hi there,
> > 
> > I'm getting a deadlock with 3.0.0-rc1:
> > 
> > Jun  3 12:06:20 kereru kernel: =======================================================
> > Jun  3 12:06:20 kereru kernel: [ INFO: possible circular locking dependency detected ]
> > Jun  3 12:06:20 kereru kernel: 3.0.0-rc1-00049-g1fa7b6a #57
> > Jun  3 12:06:20 kereru kernel: -------------------------------------------------------
> > Jun  3 12:06:20 kereru kernel: kworker/0:1/4525 is trying to acquire lock:
> > Jun  3 12:06:20 kereru kernel: (&rdev->mtx){+.+.+.}, at: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
> > Jun  3 12:06:20 kereru kernel: 
> > Jun  3 12:06:20 kereru kernel: but task is already holding lock:
> > Jun  3 12:06:20 kereru kernel: (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff8164dcef>] cfg80211_rfkill_set_block+0x4f/0xa0
> > Jun  3 12:06:20 kereru kernel: 
> > Jun  3 12:06:20 kereru kernel: which lock already depends on the new lock.
> 
> This is caused by Luca's scheduled scan changes. The reason is that
> cfg80211_rfkill_set_block holds devlist_mtx, but then he added
> cfg80211_lock_rdev(rdev); to NETDEV_GOING_DOWN, which is of course
> invoked by dev_close() in cfg80211_rfkill_set_block(). Thus, the
> problem. Not sure what to do to solve it, I'll let him sort it out :)

Argh! Well, I guess I have to look into how to solve this. :\


-- 
Cheers,
Luca.

