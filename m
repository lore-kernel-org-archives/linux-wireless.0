Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39859 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814Ab1KJOfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 09:35:18 -0500
Message-ID: <1320935713.2310.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> (sfid-20111110_153533_082549_9B566EB4)
Subject: Re: creating netdev queues on the fly?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 10 Nov 2011 15:35:13 +0100
In-Reply-To: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le jeudi 10 novembre 2011 à 14:58 +0100, Johannes Berg a écrit :
> Hi,
> 
> I've been thinking about how we manage TX queues in wifi and right now
> we just split things up by access category for QoS purposes.
> 
> However we have the issue that we might be pushing data to stations with
> completely different speeds. Onn wired, where our outgoing speed is
> essentially constant and some router/switch has to drop packets for the
> slow link:
> 
> machine A === 1000mbps link ==== [switch] === 1000mbps === machine B
>                                      |
>                                      +--- 100mbps link --- machine C
> 
> But on wireless we really transmit to slow stations only with a slow
> speed, so our outgoing speed differs. I think the scenario is quite
> different, also because the speed can vary obviously.
> 
> So to get to my question: What if we could create netdev queues on the
> fly?
> 
> The reason to do that is that we really don't want to reserve some 8000
> queues just because somebody could possibly try to create 2000
> connections (2007 is the theoretical max due to protocol restrictions)
> to the AP interface. We also don't really want to create a netdev for
> each peer (though you could implement it that way today).
> 
> I looked at this and it doesn't seem terrible. Creating & destroying the
> queues might be tricky though. I think ndo_select_queue might return the
> queue pointer instead of an index, and then that queue could be used.
> The normal queues would still be in an array, with maybe a linked list
> of extra queues that were dynamically created. Obviously the driver
> would have to be able to manage that.
> 
> Ultimately, all the frames will of course end up on the same four
> hardware queues again. But this would some better management, and piled
> up traffic to one station that suddenly dies wouldn't impact performance
> for all others as badly as it does today since we wouldn't let all those
> frames pile up on the hardware queues, they'd only get there with some
> mechanism that might take airtime into account.
> 
> I think this might also make implementing reservation (tspec) easier.
> Not sure if anyone wants/needs that though.
> 
> 
> Am I completely crazy?
> 

In term of qdisc management I believe its a bit complex if we start to
dynamically add netdev queues :)

My first idea would be to extend Qdisc management so that a device can
callback qdisc when a frame is finaly delivered / consumed / discarded.

We currently only have qdisc->enqueue() and qdisc->dequeue(), we could
add qdisc->deliver_callback(skb)

You keep devices as they are, with a netdevqueue per hardware queue.

Then, using a Qdisc like existing ones, but with a limit of
outstanding(given to device but not yet consumed) packets per class.

external tc classifier would deliver a hash/index depending on remote
station.

As a bonus you can get all the existing rate estimators / QOS /
shapers ...



