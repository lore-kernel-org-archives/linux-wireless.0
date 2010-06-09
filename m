Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab0FILja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 07:39:30 -0400
Subject: Re: Possible leak in the ampdu aggregation code?
From: Johannes Berg <johannes@sipsolutions.net>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <EC64E4604C8024438259B683BB2514E1079C16BCC6@SC-VEXCH1.marvell.com>
References: <EC64E4604C8024438259B683BB2514E1079C16BCC6@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 13:39:28 +0200
Message-ID: <1276083568.14580.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 01:35 -0700, Nishant Sarmukadam wrote:

> I wanted to get some views on a possible issue while using mac80211
> ampdu support. 
> skb's from pending queue for a TID are spliced onto the local pending
> queue when tearing down a block ack session.

Right.

> If aggregation is stopped before the ampdu state becomes
> HT_AGG_STATE_OPERATIONAL say on addba timer expiry or if the addba
> request is declined, the state is changed to
> HT_AGG_STATE_REQ_STOP_BA_MSK |(initiator <<
> HT_AGG_STATE_INITIATOR_SHIFT) in ___ieee80211_stop_tx_ba_session. 

Right.

> After commit 416fbdff2137e8d8cc8f23f517bee3a26b11526f, the ampdu state
> needs to have HT_ADDBA_REQUESTED_MSK set, else the skb's are not
> spliced.

Bleh. That commit is bogus. I didn't even know it existed. It looks like
that commit was trying to fix the issue fixed by
827d42c9ac91ddd728e4f4a31fefb906ef2ceff7 but ended up just hiding it
enough that we didn't really find the cause of issue for a long time
still... we shouldn't even have been stopping the aggregation session
when it was never started!!

I think that commit should just be reverted.

johannes

