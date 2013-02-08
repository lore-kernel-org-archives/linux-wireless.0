Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3BHVgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 16:36:23 -0500
Message-ID: <1360359377.29851.35.camel@jlt4.sipsolutions.net> (sfid-20130208_223627_237679_741584B5)
Subject: Re: [PATCH] mac80211: protect rx-path with spinlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amit SHAKYA <amit.shakya@stericsson.com>,
	"John W.Linville" <linville@tuxdriver.com>
Date: Fri, 08 Feb 2013 22:36:17 +0100
In-Reply-To: <E1U3pik-0005vi-Jv@debian64.localnet> (sfid-20130208_161841_772770_A952DF8D)
References: <1360313413.8166.1.camel@jlt4.sipsolutions.net>
	 <E1U3pik-0005vi-Jv@debian64.localnet>
	 (sfid-20130208_161841_772770_A952DF8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 17:44 +0000, Christian Lamparter wrote:
> This patch fixes the problem which was discussed in
> "mac80211: Fix PN corruption in case of multiple
> virtual interface" [1].
> 
> Amit Shakya reported a serious issue with my patch:
> mac80211: serialize rx path workers" [2]:
> 
> In case, ieee80211_rx_handlers processing is going on
> for skbs received on one vif and at the same time, rx
> aggregation reorder timer expires on another vif then
> sta_rx_agg_reorder_timer_expired is invoked and it will
> push skbs into the single queue (local->rx_skb_queue).
> 
> ieee80211_rx_handlers in the while loop assumes that
> the skbs are for the same sdata and sta. This assumption
> doesn't hold good in this scenario and the PN gets
> corrupted by PN received in other vif's skb, causing
> traffic to stop due to PN mismatch."

Applied. It's kinda late in the merge window, so I'm not pushing it for
3.8 any more, since very few people seem to have noticed this issue.

If needed, somebody else can champion it for stable :-)

johannes

