Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47123 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYIZBkS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 21:40:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 18:40:18 -0700
Date: Thu, 25 Sep 2008 18:40:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomas.winkler@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20080926014010.GQ6204@tesla> (sfid-20080926_034024_136935_205F3208)
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 12:34:57PM -0700, Tomas Winkler wrote:
> Re-enable aggregation by addressing skb->cb overwrites
> after insertion into the qdisc. Aggregation was disabled
> after the new TX multiqueue changes were introduced. Instead
> of relying on the skb->cb we use two flags on the skb.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V1:
> Users have been reporting low rates on 2.6.27 with 11n drivers, the
> problem is been 11n aggregation was disabled due to the new TX multique
> changes. We should have addressed this sooner but we just got to it now.
> 
> Without addressing this we won't get 11n aggregation on 2.6.27. I tried
> to minimize the changes required. I'm about to test this, it compiles.
> 
> If this doesn't get upstream for 27 perhaps distributions are willing to
> carry it around then and if so oh well (grr...).
> V2:
>  1. removed skbuff ->is_part_ampdu
>  2. fixed compilation warnings
> 
> 
> V3
> This version address rtnl_lock requirement in requiring
> currently only starting ba session is supported it works on
> remove it crashes.
> It's starting get ugly....
> 
> Please review

I did a review today and it look sane so far, I will test this
tomorrow and try to help zero in the cause of the lock you are
seeing.

Here is also a more detailed commit log entry which should
also help in trying to understand the issue at hand:

---

Re-enable aggregation by addressing skb->cb overwrites
after insertion into the qdisc. Aggregation was disabled
after the new TX multiqueue changes were introduced
as it made a bug apparent in mac80211.

Two flags (IEEE80211_TX_CTL_REQUEUE and IEEE80211_TX_CTL_AMPDU)
required for proper aggregation control cannot be relied on
after the new TX multiqueue changes went in due to the fact
that after an skb is insterted into the qdisc the skb->cb is
cleared.

We deal with IEEE80211_TX_CTL_REQUEUE by moving this flag
directly into the skb. We deal with IEEE80211_TX_CTL_AMPDU
by setting this flag again later during the the TX sequence
handler, ieee80211_tx_h_sequence(), by checking if the tid
for the skb for the destination sta is in an active
High Throughput (HT) state.

To properly correct aggregation under the new TX MQ work
we also have to use rtnl_lock() when starting starting
an aggregation session to prevent a possible race against
the skb's queue's removal.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
