Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57718
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbYGQWYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 18:24:47 -0400
Date: Thu, 17 Jul 2008 15:24:47 -0700 (PDT)
Message-Id: <20080717.152447.89672084.davem@davemloft.net> (sfid-20080718_002452_232868_C1776FFC)
To: kaber@trash.net
Cc: hadi@cyberus.ca, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <487F50EC.80008@trash.net>
References: <487F4327.1000107@trash.net>
	<1216301732.4726.26.camel@localhost>
	<487F50EC.80008@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 17 Jul 2008 16:02:20 +0200

> jamal wrote:
> > On Thu, 2008-17-07 at 15:03 +0200, Patrick McHardy wrote:
> > 
> > Like you i need to digest the patches to understand the impact on the
> > rest but one thing i did notice was the last patch (replacement of
> > pfifo_fast):
> > prioritization based on TOS/DSCP (setsockopt) would no longer work, some
> > user space code may suffer (routing daemons likely). One suggestion to
> > fix it is to load pfifo qdisc (which does what fifo_fast is attempting)
> > for drivers that are h/ware multiq capable.
> 
> That would perform priorization within each qdisc, the individual
> qdiscs would still be transmitted using seperate HW queues though.

I think from certain perspectives it frankly doesn't matter.

It's not like the skb->priority field lets the SKB bypass the packets
already in the TX ring of the chip with a lower priority.

It is true that, once the TX ring is full, the skb->priority thus
begins to have an influence on which packets are moved from the
qdisc to the TX ring of the device.

However, I wonder if we're so sure that we want to give normal users
that kind of powers.  Let's say for example that you set the highest
priority possible in the TOS socket option, and you do this for a ton
of UDP sockets, and you just blast packets out as fast as possible.
This backlogs the device TX ring, and if done effectively enough could
keep other sockets blocked out of the device completely.

Are we really really sure it's OK to let users do this?  :)

To me, as a default, I think TOS and DSCP really means just on-wire
priority.

If we absolutely want to, we can keep the old pfifo_fast around and use
it (shared on multiq) if a certain sysctl knob is set.
