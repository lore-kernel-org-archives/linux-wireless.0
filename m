Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:37224 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933512AbaH0KZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 06:25:26 -0400
Date: Wed, 27 Aug 2014 13:23:17 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Johannes Berg <johannes@sipsolutions.net>
cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
In-Reply-To: <1409130792.2505.5.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.LFD.2.11.1408271255230.2348@ja.home.ssi.bg> (sfid-20140827_122537_027369_078B676F)
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>  <alpine.LFD.2.11.1408212119510.1896@ja.home.ssi.bg>  <20140822.105405.1982870131653082781.davem@davemloft.net> <1409130792.2505.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


	Hello,

On Wed, 27 Aug 2014, Johannes Berg wrote:

> On Fri, 2014-08-22 at 10:54 -0700, David Miller wrote:
> 
> > > 	Is this place better, after checking for RTN_BROADCAST?
> > > 
> > > 	/* ARP link-layer broadcasts are acceptable here */
> > > 	if ((skb->pkt_type == PACKET_BROADCAST ||
> > > 	     skb->pkt_type == PACKET_MULTICAST) &&
> > > 	    skb->protocol == htons(ETH_P_IP))
> > > 		goto e_inval;
> > 
> > Indeed, this would make ARP happier, but that still leaves open the
> > issue of CLUSTERIP.
> 
> Unfortunately, I have no idea how to determine that CLUSTERIP is active
> here? Do we need to tag frames, or would a sysctl work?
> 
> Or should we go back to the drawing board and not make this change in
> the IP stack at all? But parsing all the IP layer in the wireless stack
> is really quite ugly as well.

	CLUSTERIP works in LOCAL_IN. My preference is to
add checks in every protocol where it is missing but if
you prefer a global check, ip_local_deliver_finish() is
a good place: CLUSTERIP already changed pkt_type to
PACKET_HOST. For example:

	if (!(skb_rtable(skb)->rt_flags &
	      (RTCF_BROADCAST | RTCF_MULTICAST)) &&
	    (skb->pkt_type == PACKET_BROADCAST ||
	     skb->pkt_type == PACKET_MULTICAST)) {
		kfree_skb(skb);
		return;
	}

	By this way we protect the local stack globally.
BTW, what kind of packets (protocol) we want to drop? UDP?

	As for ip_forward(), there is already check for
PACKET_HOST.

	Not sure, may be a MIB counter for such drops
would be useful.

Regards

--
Julian Anastasov <ja@ssi.bg>
