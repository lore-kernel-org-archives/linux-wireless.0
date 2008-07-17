Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49122
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760239AbYGQWgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 18:36:10 -0400
Date: Thu, 17 Jul 2008 15:36:09 -0700 (PDT)
Message-Id: <20080717.153609.142867331.davem@davemloft.net> (sfid-20080718_003618_530264_6DFB43EA)
To: kaber@trash.net
Cc: netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <487F4DA6.6010009@trash.net>
References: <487F4327.1000107@trash.net>
	<20080717.061239.51839567.davem@davemloft.net>
	<487F4DA6.6010009@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 17 Jul 2008 15:48:22 +0200

> One thought that occured to me - we could avoid all the visiblity
> issues wrt. dev->qdisc_list by simply getting rid of it :)
> 
> If we move the qdisc list from the device to the root Qdisc itself,
> it would become invisible automatically as soon as we assign a new
> root qdisc to the netdev_queue. Iteration would become slightly
> more complicated since we'd have to iterate over all netdev_queues,
> but I think it should avoid most of the problems I mentioned
> (besides the u32_list thing).

What might make sense is to have a special Qdisc_root structure which
is simply:

struct Qdisc_root {
	struct Qdisc		qd;
	struct list_head	qdisc_list;
};

Everything about tree level synchronization would be type explicit.

Yes, as you say, the qdisc iteration would get slightly ugly.  But
that doesn't seem to be a huge deal.

But it seems a clean solution to the child qdisc visibility problem.

About u32_list, that thing definitely needs some spinlock.  The
consultation of that list, and refcount mods, only occur during config
operations.  So it's not like we have to grab this lock in the data
paths.

If we really want to sweep this problem under the rug, there is another
way.  Have the qdisc_destroy() RCU handler kick off a workqueue, and
grab the RTNL semaphore there during the final destruction calls. :-)

