Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42528 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201Ab1DSNLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:11:12 -0400
Subject: Re: [PATCH 1/4] mwl8k: Do not stop tx queues
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: <nishants@marvell.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
In-Reply-To: <20110419102656.GL1897@wantstofly.org>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
	 <20110419074809.GJ1897@wantstofly.org>
	 <1303207697.20919.31.camel@localhost.localdomain>
	 <20110419102656.GL1897@wantstofly.org>
Content-Type: text/plain
Date: Tue, 19 Apr 2011 18:35:55 +0530
Message-ID: <1303218355.21371.6.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2011-04-19 at 03:26 -0700, Lennert Buytenhek wrote:
> On Tue, Apr 19, 2011 at 03:38:17PM +0530, Nishant Sarmukadam wrote:
> 
> > > > This is in preparation to support life time expiry of packets in the
> > > > hardware to avoid head-of-line blocking where a slow client can
> > > > hog a tx queue and affect the traffic to a faster client from the same
> > > > queue. Time stamp the packets in driver to allow dropping them in the
> > > > hardware if they are queued for more than 500ms.
> > > > 
> > > > Since queues are not being stopped now, we need to be prepared for
> > > > a situation where packets hit the driver after the queues are full.
> > > > Drop all such packets in the driver itself.
> > > 
> > > What this patch seems to do is: don't propagate queue start/stop
> > > indications to mac80211, and if a packet is handed to mwl8k for
> > > transmission while a TX queue is full, just drop it in the driver.
> > > (This doesn't seem to correspond with the commit message.)
> > 
> > We were invoking mac80211 routines to start/stop tx queues. Since we do
> > not call these routines now, the queues will not be stopped anymore.
> > Hence, packets that enter the driver after the corresponding queue is
> > full, need to be dropped. This is mentioned in the commit description.
> > Please let me know if I am missing something. 
> 
> Maybe it's me, but to me, the commit message seems to say that queue
> starting/stopping is already not being done anymore by mwl8k, and
> because of that, we need to drop packets that are being transmitted
> in the driver when the TX queue is full, which this patch does.

Ok, I will try to address this in patch set V2.

> 
> 
> > > But since the driver still has an accurate idea of TX queue fullness
> > > (i.e. it's not as if at transmit time, you go and transparently reclaim
> > > TX queue entries), why do you need to start/stop mac80211 TX queues at
> > > all?  Won't it still work fine without deleting that logic?
> > 
> > We need to timestamp all tx packets. If we stop the queues, packets will
> > be queued up outside the driver (in queue full conditions). Since we
> > will be able to timestamp the packets only after they hit the driver,
> > the timestamp will be less accurate since we cannot consider the time
> > the packets spent in the queues outside the driver.
> 
> This is a fair argument, and this really should be in the commit message.

I will incorporate this in patch set V2.



