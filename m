Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3DWGsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 02:48:36 -0400
Message-ID: <1366699708.8385.1.camel@jlt4.sipsolutions.net> (sfid-20130423_084841_283379_2E90A761)
Subject: Re: [PATCH] mac80211: fix spurious use of rcu_dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	karl.beldan@gmail.com
Date: Tue, 23 Apr 2013 08:48:28 +0200
In-Reply-To: <201304230258.08359.chunkeey@googlemail.com> (sfid-20130423_025828_450785_53ED9197)
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
	 <201304230258.08359.chunkeey@googlemail.com>
	 (sfid-20130423_025828_450785_53ED9197)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 02:58 +0200, Christian Lamparter wrote:
> This patch fixes the following RCU debug splat:
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.9.0-rc8-wl+ #31 Tainted: G           O
> -------------------------------
> net/mac80211/rate.c:691 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
>  
> rcu_scheduler_active = 1, debug_locks = 1
>  3 locks held by hostapd/9451:
>  #0:  (genl_mutex){+.+.+.}, at: [<c1326365>] genl_lock+0xf/0x11
>  #1:  (rtnl_mutex){+.+.+.}, at: [<c13133c4>] rtnl_lock+0xf/0x11
>  #2:  (&rdev->mtx){+.+.+.}, at: [<f853395e>] nl80211_pre_doit+0x166/0x180 [cfg80211]
> 
> stack backtrace:
> Pid: 9451, comm: hostapd Tainted: G           O 3.9.0-rc8-wl+ #31
> Call Trace:
>  [<c107da0b>] lockdep_rcu_suspicious+0xe6/0xee
>  [<f8bf82ad>] rate_control_set_rates+0x43/0x5a [mac80211]
>  [<f8c2cacb>] minstrel_update_rates+0xdc/0xe2 [mac80211]
>  [<f8c2cfb0>] minstrel_rate_init+0x24c/0x33d [mac80211]
>  [<f8c2d9d3>] minstrel_ht_update_caps+0x206/0x234 [mac80211]
>  [<c1080a8d>] ? lock_release+0x1c9/0x226
>  [<f8c2da25>] minstrel_ht_rate_init+0x10/0x14 [mac80211]
>  [...]
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Actually, rcu_read_lock() might not be necessary in this special
> case [the RC is not yet initialized, so nothing bad can happen].
> 
> But, since the rcu_read_lock() has a low overhead and
> rate_control_set_rates mac80211.h doc does not mention
> anything about locking, I think this is a viable way. 

I think that, on the contrary, it's completely strange/wrong. ;-)

> +       rcu_read_lock();
> +       old = rcu_dereference(pubsta->rates);

Here's have a dereference.
 
>         rcu_assign_pointer(pubsta->rates, rates);

and here's an assignment. The assignment ought to be protected already
by some locking, presumably, so similarly is the rcu_dereference() which
then should just be rcu_dereference_protected()?

johannes


