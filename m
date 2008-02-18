Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2592 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYBRSbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 13:31:31 -0500
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, bruno@thinktube.com,
	netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <47B9A20C.10304@trash.net>
References: <20080215104804.9870.15722.stgit@one>
	 <20080215.025855.202184003.davem@davemloft.net>
	 <1203097370.21308.18.camel@localhost>  <47B9A20C.10304@trash.net>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 10:31:02 -0800
Message-Id: <1203359462.7181.80.camel@localhost> (sfid-20080218_183150_933480_CE8C32E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-18 at 16:19 +0100, Patrick McHardy wrote:
> > @@ -404,11 +405,8 @@ static int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  	pr_debug("%s: about to send skb: %p to dev: %s\n",
> >  		__FUNCTION__, skb, skb->dev->name);
> > -	pr_debug("  " MAC_FMT " " MAC_FMT " %4hx %4hx %4hx\n",
> > -		 veth->h_dest[0], veth->h_dest[1], veth->h_dest[2],
> > -		 veth->h_dest[3], veth->h_dest[4], veth->h_dest[5],
> > -		 veth->h_source[0], veth->h_source[1], veth->h_source[2],
> > -		 veth->h_source[3], veth->h_source[4], veth->h_source[5],
> > +	pr_debug("  %s %s %4hx %4hx %4hx\n",
> > +		 print_mac(mac, veth->h_dest), print_mac(mac2, veth->h_source),
> This results in print_mac getting called twice per packet even without
> debugging. Whats the problem with MAC_FMT?

It's just a consistency thing.
It identifies code where MAC addresses are used.
an allyesconfig is a bit smaller (~.1%).
pr_debug is a noop when not debugging, print_mac is optimized away.

