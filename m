Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:34327 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0CTCo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 22:44:29 -0400
Received: by yxe12 with SMTP id 12so880648yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 19:44:28 -0700 (PDT)
From: Bruno Randolf <randolf.bruno@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local data structure
Date: Sat, 20 Mar 2010 11:44:24 +0900
Cc: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Tony Huang <ht6100@gmail.com>
References: <4BA24A12.4030208@gmail.com> <4BA344FB.1090500@gmail.com> <a0b9368788449213d36b75dccd97c6a6@localhost>
In-Reply-To: <a0b9368788449213d36b75dccd97c6a6@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003201144.24471.randolf.bruno@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 March 2010 03:49:27 Johannes Berg wrote:
> On Fri, 19 Mar 2010 10:33:47 +0100, "lorenzo.bianconi83@gmail.com"
> 
> >>  	if (!skb_queue_empty(&local->pending[queue]))
> >>  	
> >>  		tasklet_schedule(&local->tx_pending_tasklet);
> >> 
> >> -
> >> -	rcu_read_lock();
> >> -	list_for_each_entry_rcu(sdata, &local->interfaces, list)
> >> -		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
> >> -	rcu_read_unlock();
> 
> That's obviously wrong, need to move the code to the else branch of the
> above if instead.
> 
> > I tested the patch on kernel 2.6.32.7 with compat-wireless-2010-03-03
> 
> but
> 
> > it seems that the problem is not solved. If I set the lowest priority
> 
> queue
> 
> > (Backgreound), the system will crash for an out of memory panic. During
> 
> the
> 
> > tests I carried out, I transmit 50Mbps UDP traffic.
> 
> How are you generating traffic? I just dumped like 2Gbps traffic at it
> and everything works just fine. I verified queues are stopped and started
> properly.

i think i'm hitting the same bug, but not sure (i will try to check next 
week). this is easy to reproduce, but you need 4 (at least 3) machines:

setup 2 wireless cards, talking to each other (i use IBSS) on different 
machines. then setup routing like this:

[1] - [WL1] - [WL2] - [2]

now send more UDP traffic than the wireless link can handle (iperf -u -b 50M 
for example) between [1] and [2]. watch the free memory get less and less at 
[WL1] until it chrashes.

bruno
