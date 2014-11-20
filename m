Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49790 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbaKTVbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:31:25 -0500
Message-ID: <1416519074.8557.15.camel@sipsolutions.net> (sfid-20141120_223129_412885_17C22543)
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: ja@ssi.bg, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 20 Nov 2014 22:31:14 +0100
In-Reply-To: <20140822.105405.1982870131653082781.davem@davemloft.net>
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
	 <alpine.LFD.2.11.1408212119510.1896@ja.home.ssi.bg>
	 <20140822.105405.1982870131653082781.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-08-22 at 10:54 -0700, David Miller wrote:

> >>  	if (res.type == RTN_BROADCAST)
> >>  		goto brd_input;
> > 
> > 	Is this place better, after checking for RTN_BROADCAST?
> > 
> > 	/* ARP link-layer broadcasts are acceptable here */
> > 	if ((skb->pkt_type == PACKET_BROADCAST ||
> > 	     skb->pkt_type == PACKET_MULTICAST) &&
> > 	    skb->protocol == htons(ETH_P_IP))
> > 		goto e_inval;
> 
> Indeed, this would make ARP happier, but that still leaves open the
> issue of CLUSTERIP.

I'm back looking at this, but must admit I'm completely confused now :-)

I could add an IPv4 sysctl to control this behaviour:
  0 - off
  1 - RFC 1122 "SHOULD"
  2 - also drop unicast-in-multicast (for wireless)

But I guess due to cluster-IP it would have to default to 0.


However, talk about ip_local_deliver_finish() in this thread has me
wondering if we could just implement it using iptables? I guess
ipt_addrtype and ip6t_addrtype would let me do that?

johannes


