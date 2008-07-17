Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37018 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbYGQXtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 19:49:00 -0400
Message-ID: <487FDA67.30902@trash.net> (sfid-20080718_014905_307741_8F24DD8A)
Date: Fri, 18 Jul 2008 01:48:55 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hadi@cyberus.ca, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
References: <487F4327.1000107@trash.net>	<1216301732.4726.26.camel@localhost>	<487F50EC.80008@trash.net> <20080717.152447.89672084.davem@davemloft.net>
In-Reply-To: <20080717.152447.89672084.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 17 Jul 2008 16:02:20 +0200
> 
>> jamal wrote:
>>> prioritization based on TOS/DSCP (setsockopt) would no longer work, some
>>> user space code may suffer (routing daemons likely). One suggestion to
>>> fix it is to load pfifo qdisc (which does what fifo_fast is attempting)
>>> for drivers that are h/ware multiq capable.
>> That would perform priorization within each qdisc, the individual
>> qdiscs would still be transmitted using seperate HW queues though.
> 
> I think from certain perspectives it frankly doesn't matter.
> 
> It's not like the skb->priority field lets the SKB bypass the packets
> already in the TX ring of the chip with a lower priority.
> 
> It is true that, once the TX ring is full, the skb->priority thus
> begins to have an influence on which packets are moved from the
> qdisc to the TX ring of the device.
> 
> However, I wonder if we're so sure that we want to give normal users
> that kind of powers.  Let's say for example that you set the highest
> priority possible in the TOS socket option, and you do this for a ton
> of UDP sockets, and you just blast packets out as fast as possible.
> This backlogs the device TX ring, and if done effectively enough could
> keep other sockets blocked out of the device completely.
> 
> Are we really really sure it's OK to let users do this?  :)
> 
> To me, as a default, I think TOS and DSCP really means just on-wire
> priority.
> 
> If we absolutely want to, we can keep the old pfifo_fast around and use
> it (shared on multiq) if a certain sysctl knob is set.

No, I fully agree that this is too much detail :) Its highly
unlikely that this default behaviour is important on a per
packet level :) I just meant to point out that using a pfifo
is not going to be the same behaviour as previously.

