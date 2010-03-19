Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0CSSta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 14:49:30 -0400
To: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
 =?UTF-8?Q?ieee=38=30=32=31=31=5Flocal=20data=20structure?=
MIME-Version: 1.0
Date: Fri, 19 Mar 2010 19:49:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bruno Randolf <br1@einfach.org>, Tony Huang <ht6100@gmail.com>
In-Reply-To: <4BA344FB.1090500@gmail.com>
References: <4BA24A12.4030208@gmail.com> <1268936446.4005.13.camel@jlt3.sipsolutions.net> <4BA344FB.1090500@gmail.com>
Message-ID: <a0b9368788449213d36b75dccd97c6a6@localhost>
Content-Type: text/plain;
 charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 19 Mar 2010 10:33:47 +0100, "lorenzo.bianconi83@gmail.com"
>>  	if (!skb_queue_empty(&local->pending[queue]))
>>  		tasklet_schedule(&local->tx_pending_tasklet);
>> -
>> -	rcu_read_lock();
>> -	list_for_each_entry_rcu(sdata, &local->interfaces, list)
>> -		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
>> -	rcu_read_unlock();

That's obviously wrong, need to move the code to the else branch of the
above if instead.

> I tested the patch on kernel 2.6.32.7 with compat-wireless-2010-03-03
but
> it seems that the problem is not solved. If I set the lowest priority
queue
> (Backgreound), the system will crash for an out of memory panic. During
the
> tests I carried out, I transmit 50Mbps UDP traffic.

How are you generating traffic? I just dumped like 2Gbps traffic at it
and everything works just fine. I verified queues are stopped and started
properly.

johannes

