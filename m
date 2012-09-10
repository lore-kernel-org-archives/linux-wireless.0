Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2IJKpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 06:45:10 -0400
Message-ID: <1347273946.4272.2.camel@jlt4.sipsolutions.net> (sfid-20120910_124515_915311_95F06FA3)
Subject: Re: [PATCH v2] mac80211: use call_rcu() on sta deletion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Sep 2012 12:45:46 +0200
In-Reply-To: <1347191032-16203-1-git-send-email-eliad@wizery.com> (sfid-20120909_134334_008936_A651842D)
References: <1347191032-16203-1-git-send-email-eliad@wizery.com>
	 (sfid-20120909_134334_008936_A651842D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-09 at 14:43 +0300, Eliad Peller wrote:
> mac80211 calls synchronize_rcu() on sta deletion,
> which increase the roaming time significantly.
> 
> Convert it into a call_rcu() mechanism, in order
> to avoid blocking. Since some of the cleanup
> functions might sleep, schedule from the call_rcu
> callback a new work that will do the actual cleanup.
> 
> In order to make sure the cleanup occurs before
> the interface went down, flush local->workqueue
> on ieee80211_do_stop().

Applied.

johannes

