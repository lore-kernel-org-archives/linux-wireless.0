Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3BDU4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 15:56:17 -0500
Message-ID: <1360011393.17993.37.camel@jlt4.sipsolutions.net> (sfid-20130204_215621_559274_2140A3BE)
Subject: Re: Memory leak in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: mcgrof@do-not-panic.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Feb 2013 21:56:33 +0100
In-Reply-To: <51100C8E.6040502@lwfinger.net> (sfid-20130204_203132_375841_8B344B1E)
References: <510D9E71.2080300@lwfinger.net>
	  (sfid-20130203_001709_849515_E1CDB041) <1359998652.17993.9.camel@jlt4.sipsolutions.net>
	 <51100C8E.6040502@lwfinger.net> (sfid-20130204_203132_375841_8B344B1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

> You got it right. I got two tracebacks as follows:
> 
> [   22.147978] cfg80211: wiphy->regd changed at line 1459: old           (null), new: ffff8800b1e25a80
> [   22.147982] Pid: 292, comm: kworker/1:1 Not tainted 3.8.0-rc6-wl+ #96
> [   22.147985] Call Trace:
> [   22.148032]  [<ffffffffa03c6623>] reg_todo+0x403/0x5e0 [cfg80211]
> [   22.148088]  [<ffffffff81063cdd>] process_one_work+0x19d/0x6f0

> [   22.161223] cfg80211: request_wiphy->regd changed at line 2199: old ffff8800b1e25a80, new: ffff8800b61c66c0
> [   22.161230] Pid: 2377, comm: crda Not tainted 3.8.0-rc6-wl+ #96
> [   22.161233] Call Trace:
> [   22.161275]  [<ffffffffa03c76fc>] set_regdom+0x6dc/0x750 [cfg80211]
> [   22.161293]  [<ffffffffa03d1f56>] nl80211_set_reg+0x236/0x2a0 [cfg80211]

> The second one replaced a non-NULL pointer, and kmemleak confirms that it is the 
> leaked block.

Ok, good. I'm not sure how a recent change would have caused this
though, but I'm sure we can fix it :)

> This leak seems to occur because I am loading cfg80211 with the regdom set to 
> "US"; however, the driver is forcing "CN". That is my penalty for buying the 
> adapter on Ebay; however, I think my setting should override that of the driver, 
> which might be a separate bug. I'm OK as long as there are no FCC inspectors in 
> my neighborhood to see that I am sending out probes on channels 12 and 13.

:)
That might indeed be a different bug.

> I am only vaguely familiar with the rcu routines. Is it sufficient to do the 
> simple kfree() before the rcu_assign_pointer() call, or is it necessary to make 
> an rcu_lock() call as well? If a simple kfree() is all that is needed, then the 
> following patch should be OK. If is is, I'll do some testing and do a proper 
> submission later:

No, neither is quite right, another thread might be accessing it at the
same time.

> Index: wireless-testing-new/net/wireless/reg.c
> ===================================================================
> --- wireless-testing-new.orig/net/wireless/reg.c
> +++ wireless-testing-new/net/wireless/reg.c
> @@ -2189,10 +2189,12 @@ static int __set_regdom(const struct iee
>                   * However if a driver requested this specific regulatory
>                   * domain we keep it for its private use
>                   */
> -               if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER)
> +               if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
> +                       kfree(request_wiphy->regd);

This one should be rcu_free_regdom(), except you also need a temporary
variable:

	tmp = get_wiphy_regdom(request_wiphy);
	rcu_assign_pointer(request_wiphy->regd, rd);
	rcu_free_regdom(tmp);

Note this also works if "tmp" ends up NULL.

johannes

