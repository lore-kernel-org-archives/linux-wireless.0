Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33525 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946065AbXEAXfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 19:35:41 -0400
Date: Wed, 2 May 2007 01:35:34 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: limit URB buffering in tx path
Message-ID: <20070502013534.0de2fa33@logostar.upir.cz>
In-Reply-To: <20070501224045.GA26845@p15091797.pureserver.info>
References: <20070501030100.BDE3D7B409F@zog.reactivated.net>
	<20070501123411.081c43c6@logostar.upir.cz>
	<20070501195008.GA14294@p15091797.pureserver.info>
	<20070501231028.4cfa4053@logostar.upir.cz>
	<20070501224045.GA26845@p15091797.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2 May 2007 00:40:45 +0200, Ulrich Kunitz wrote:
> Jiri, even if ZD1211B supports multiple queues, there is only one
> USB endpoint receiving packets for transmission. I suppose that
> the queue for the packet can be set in the control data for the
> packet. However if the device doesn't read USB blocks anymore, all
> queues will be affected.

Ah, that's stupid. I hope nobody is advertising these devices have a decent
QoS support.

> At this point in time I have to stop all
> queues. Sure I could care for the different priorities of the
> queues by stopping low-priority queues earlier, but if the user is
> overloading the device, I have to stop all queues.

Or you can split the available buffer space in the device, i.e. reserve
some fixed part for the first queue, some part for the second queue, etc.
Otherwise, the QoS is not so useful (you will still profit from the shorter
backoff, of course, so it's not completely useless).

But I don't know how many urbs the device can accept, it may not be
feasible to do that. (But if it can accept reasonable amount of urbs, I'd
suggest to implement that. It will need some testing to see whether it
really improves something or not, though.)

> > If you support one queue only, call ieee80211_stop_queue(hw, 0). Calling
> > ieee80211_stop_queues if you have just a full queue is wrong.
> 
> Again I don't just have a full queue, I cannot send any packets to
> the device anymore. Under this condition I simply stop all queues,
> not caring whether there are 1 or 1024.

Okay, ACK then.

Thanks for the clarification,

 Jiri

-- 
Jiri Benc
SUSE Labs
