Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57046 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947110Ab3BHVpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 16:45:15 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2199192eek.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 13:45:14 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: protect rx-path with spinlock
Date: Fri, 8 Feb 2013 22:45:10 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Amit SHAKYA <amit.shakya@stericsson.com>,
	"John W.Linville" <linville@tuxdriver.com>
References: <1360313413.8166.1.camel@jlt4.sipsolutions.net> <E1U3pik-0005vi-Jv@debian64.localnet> <1360359377.29851.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360359377.29851.35.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302082245.10927.chunkeey@googlemail.com> (sfid-20130208_224524_957118_D6D63FA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 February 2013 22:36:17 Johannes Berg wrote:
> On Mon, 2013-02-04 at 17:44 +0000, Christian Lamparter wrote:
> > This patch fixes the problem which was discussed in
> > "mac80211: Fix PN corruption in case of multiple
> > virtual interface" [1].
> > 
> > Amit Shakya reported a serious issue with my patch:
> > mac80211: serialize rx path workers" [2]:
> > 
> > In case, ieee80211_rx_handlers processing is going on
> > for skbs received on one vif and at the same time, rx
> > aggregation reorder timer expires on another vif then
> > sta_rx_agg_reorder_timer_expired is invoked and it will
> > push skbs into the single queue (local->rx_skb_queue).
> > 
> > ieee80211_rx_handlers in the while loop assumes that
> > the skbs are for the same sdata and sta. This assumption
> > doesn't hold good in this scenario and the PN gets
> > corrupted by PN received in other vif's skb, causing
> > traffic to stop due to PN mismatch."
> 
> Applied. It's kinda late in the merge window, so I'm not
> pushing it for 3.8 any more, since very few people seem
> to have noticed this issue.
> 
> If needed, somebody else can champion it for stable :-)
That's most likely because BARs should actually take care
of releasing stuck frames anyway. The release timer is there
just in case the BAR which would release the ampdu reorder
buffer is also lost.

Regards,
	Christian
