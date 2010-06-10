Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58157 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0FJF6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:58:35 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Jun 2010 22:58:32 -0700
Subject: RE: Possible leak in the ampdu aggregation code?
Message-ID: <EC64E4604C8024438259B683BB2514E1079C16C01D@SC-VEXCH1.marvell.com>
In-Reply-To: <1276083568.14580.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think that commit should just be reverted.

Ok, I will send a patch to revert commit 416fbdff2137e8d8cc8f23f517bee3a26b11526f.

Nishant

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Wednesday, June 09, 2010 5:09 PM
To: Nishant Sarmukadam
Cc: linux-wireless@vger.kernel.org; Luis R. Rodriguez
Subject: Re: Possible leak in the ampdu aggregation code?

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

