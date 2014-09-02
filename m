Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54482 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaIBJdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 05:33:31 -0400
Message-ID: <1409650402.1808.8.camel@jlt4.sipsolutions.net> (sfid-20140902_113340_444504_46F18680)
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Anastasov <ja@ssi.bg>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Tue, 02 Sep 2014 11:33:22 +0200
In-Reply-To: <alpine.LFD.2.11.1408271625500.2348@ja.home.ssi.bg>
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
	   <alpine.LFD.2.11.1408212119510.1896@ja.home.ssi.bg>
	   <20140822.105405.1982870131653082781.davem@davemloft.net>
	  <1409130792.2505.5.camel@jlt4.sipsolutions.net>
	  <alpine.LFD.2.11.1408271255230.2348@ja.home.ssi.bg>
	 <1409138967.2505.11.camel@jlt4.sipsolutions.net>
	 <alpine.LFD.2.11.1408271625500.2348@ja.home.ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-27 at 17:31 +0300, Julian Anastasov wrote:

> > All IP protocols, this comes either from the IPv4 RFC (1122) or from the
> > wireless issue which affects all protocols.
> 
> 	I did a grep for inet_add_protocol, in case if
> we prefer to use per-protocol checks:
> 
> Protocols that look ok to me: TCP, SCTP, DCCP
> 
> ICMP: missing check in icmp_rcv
> UDP, UDPLITE: need check in __udp4_lib_rcv
> IGMP: uses only multicast address?
> PIM: not sure if __pim_rcv() needs check, before skb_tunnel_rx()
> 	changes pkt_type?
> 
> More protocols are also registered with inet_add_protocol(), I don't
> see pkt_type checks there, mostly tunnels:
> - IPPROTO_GRE
> - IPPROTO_L2TP
> - IPPROTO_IPIP
> - IPPROTO_IPV6 (tunnel64_rcv)
> 
> 	If going to use a global check I hope there are
> no protocols that require exception to this rule.

Yeah that's the big question. Are you saying that TCP already implements
this? But I guess for TCP it's least interesting in a sense? Not really
sure.

I'd feel better implementing it at the IP level though, since it's a
fairly low-level requirement and also RFC 1122 is on the IP level
(obviously)

johannes


