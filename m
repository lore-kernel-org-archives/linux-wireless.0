Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:10120 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbYGTO6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 10:58:18 -0400
Received: by py-out-1112.google.com with SMTP id p76so813536pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 07:58:17 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Roland Dreier <rdreier@cisco.com>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <adaljzz6ruq.fsf@cisco.com>
References: <487F4327.1000107@trash.net>
	 <1216301732.4726.26.camel@localhost> <487F50EC.80008@trash.net>
	 <20080717.152447.89672084.davem@davemloft.net> <487FDA67.30902@trash.net>
	 <1216386624.4833.94.camel@localhost>  <adaljzz6ruq.fsf@cisco.com>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 10:58:14 -0400
Message-Id: <1216565894.4847.61.camel@localhost> (sfid-20080720_165822_766279_3B48712A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-18-07 at 10:10 -0700, Roland Dreier wrote:

> This is definitely true, but it is good to keep in mind that in the near
> future we will start to see things look a little like multiple "virtual
> wires."  This is because of new ethernet standards like per-priority
> pause, which makes it possible that one hardware ring on a NIC can
> transmit while another ring is paused (possibly because of congestion
> far off in the network).

Thats essentially what i am arguing for.
[I think some, not all, of the wireless qos schemes also have similar
scheduling].

My understanding of these wired "datacentre/virtualization" schemes you
describe is they are strict prio based. When the low prio "virtual wire"
is contending for the "physical wire" with a higher prio "virtual wire",
the high prio always wins. 
We just need to make sure this behavior is also maintained whatever
buffering scheme is used within or above the driver(qdisc level).

cheers,
jamal

