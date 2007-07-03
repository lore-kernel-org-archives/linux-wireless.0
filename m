Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXGCM5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 08:57:21 -0400
Message-ID: <468A4788.7040201@trash.net>
Date: Tue, 03 Jul 2007 14:56:40 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
References: <200707022235.38791.mb@bu3sch.de> <200707031039.56710.mb@bu3sch.de> <468A41A3.1020903@trash.net> <200707031439.40828.mb@bu3sch.de>
In-Reply-To: <200707031439.40828.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 03 July 2007 14:31:31 Patrick McHardy wrote:
> 
>>The wireless multiqueue handling should be replaced by the generic
>>implementation in net-2.6.23 (using prio, seperating out the wme
>>classifier and killing the broken scheduler). You don't need to
>>stop individual subqueues for a full shutdown with that implementation,
>>you can just stop the global queue. Not sure if that really helps for
>>this case though since I didn't look to deep into this code.
> 
> 
> That's exactly what I want. Stop the "global queue".
> As there is no "global queue" in mac80211, I need to stop every queue.


I could help you take care of the scheduler part if someone
else takes care of the drivers and mac80211.

Roughly what they need to do is:

- use alloc_netdev_mq instead of alloc_netdev
- use netif_{start,stop,wake}_subqueue instead of the wireless
  equivalents
- when all subqueues are stopped the global queue should be stopped
  in the usual way (netif_stop_queue), when at least one is active
  the global queue should be woken
- use skb->queue_mapping instead of skb->priority to get the HW
  queue

The scheduler part mainly consists of offering a clean way to install
a different default qdisc than pfifo_fast and adding a default
classifier. I'm presuming the wme classifier would also be useful
for other (non-mac80211) wireless drivers that offer multiple queues,
so it should probably be completely seperated from mac80211 and moved
to net/sched.


