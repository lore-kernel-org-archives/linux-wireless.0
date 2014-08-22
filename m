Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:52619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaHVRyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 13:54:06 -0400
Date: Fri, 22 Aug 2014 10:54:05 -0700 (PDT)
Message-Id: <20140822.105405.1982870131653082781.davem@davemloft.net> (sfid-20140822_195412_255507_7935DB4F)
To: ja@ssi.bg
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.11.1408212119510.1896@ja.home.ssi.bg>
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
	<alpine.LFD.2.11.1408212119510.1896@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>
Date: Thu, 21 Aug 2014 22:51:02 +0300 (EEST)

>>  	if (res.type == RTN_BROADCAST)
>>  		goto brd_input;
> 
> 	Is this place better, after checking for RTN_BROADCAST?
> 
> 	/* ARP link-layer broadcasts are acceptable here */
> 	if ((skb->pkt_type == PACKET_BROADCAST ||
> 	     skb->pkt_type == PACKET_MULTICAST) &&
> 	    skb->protocol == htons(ETH_P_IP))
> 		goto e_inval;

Indeed, this would make ARP happier, but that still leaves open the
issue of CLUSTERIP.
