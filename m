Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57473 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159AbYJCD3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 23:29:39 -0400
Date: Thu, 2 Oct 2008 22:29:38 -0500
From: Robin Holt <holt@sgi.com>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>
Subject: Re: System pauses with iwl3945 AP associate. RFKill unpauses.
Message-ID: <20081003032938.GX28581@sgi.com> (sfid-20081003_052944_074194_0C3936D1)
References: <20081001115830.GD8534@sgi.com> <BAY133-W6C33FBF8B67482CE4D8F8B2420@phx.gbl> <20081002233422.GF8534@sgi.com> <20081003014750.GT28581@sgi.com> <20081003022554.GU28581@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081003022554.GU28581@sgi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 09:25:54PM -0500, Robin Holt wrote:
> OK.  I think I have convinced myself this is an issue with
> sta_info_debugfs_add_work().  I am going to turn off
> CONFIG_MAC80211_DEBUGFS and see if that makes things better.

Appear to be on the right track here.  With CONFIG_MAC80211_DEBUGFS=y, I
could only suspend/resume approx 4 times without iwl3945 hanging.  I had
worked around that by modprobe -r iwl3945 and waiting a while before
suspending.  Now with CONFIG_MAC80211_DEBUGFS=n, I have done 6 suspends
with the machine suspended for 5 minutes before resuming and it has not
hung.  That has not occurred before.  I will continue to test this for
the next few days.


Thanks,
Robin

> 
> Thanks,
> Robin
> 
> On Thu, Oct 02, 2008 at 08:47:50PM -0500, Robin Holt wrote:
> > On Thu, Oct 02, 2008 at 06:34:22PM -0500, Robin Holt wrote:
> > > I do have KDB installed as well and one other thing I noticed is we are
> > > adding work to a workqueue at the time of the hang.  Not sure if this
> > > is accurate and I forgot that I only have a VGA console so there is
> > > no record of the KDB output.
> > 
> > OK.  In KDB.  Here goes...
> > 
> > events/0 process is on cpu0 with the following stack.
> > 
> > _spin_unlock_irqrestore+0x10
> > [mac80211]sta_info_debugfs_add_work+0x82
> > run_workqueue+0xd4
> > worker_thread+0x88
> > kthread+0x42
> > 
> > 
> > I few times later, I got:
> > _cond_resched+0x10
> > [mac80211]sta_info_destroy+0x10
> > [mac80211]sta_info_debugfs_add_work+0xee
> > run_workqueue+0xd4
> > worker_thread+0x88
> > kthread+0x42
> > 
> > I am transposing these from screen to this email so I reserve the right
> > to be slightly off, but these appear to be the call traces.
> > 
> > It looks to me like this add_work loop is truly an infinite loop and
> > preventing interrupts from being processed on cpu0.
> > 
> > Thanks,
> > Robin
