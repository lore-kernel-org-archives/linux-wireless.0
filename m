Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:26758 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761000AbYGQQCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 12:02:01 -0400
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/31]: net: Implement simple sw TX hashing.
From: Andi Kleen <andi@firstfloor.org>
References: <20080717.051635.124264554.davem@davemloft.net>
Date: Thu, 17 Jul 2008 17:59:33 +0200
In-Reply-To: <20080717.051635.124264554.davem@davemloft.net> (David Miller's message of "Thu, 17 Jul 2008 05:16:35 -0700 (PDT)")
Message-ID: <87vdz4sdqy.fsf@basil.nowhere.org> (sfid-20080717_180238_573576_9902F742)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> +static u16 simple_tx_hash(struct net_device *dev, struct sk_buff *skb)
> +{
> +	u32 *addr, *ports, hash, ihl;
> +	u8 ip_proto;
> +	int alen;
> +
> +	switch (skb->protocol) {
> +	case __constant_htons(ETH_P_IP):
> +		ip_proto = ip_hdr(skb)->protocol;
> +		addr = &ip_hdr(skb)->saddr;
> +		ihl = ip_hdr(skb)->ihl;
> +		alen = 2;
> +		break;
> +	case __constant_htons(ETH_P_IPV6):
> +		ip_proto = ipv6_hdr(skb)->nexthdr;
> +		addr = &ipv6_hdr(skb)->saddr.s6_addr32[0];
> +		ihl = (40 >> 2);
> +		alen = 8;
> +		break;
> +	default:
> +		return 0;

Could you add a linuxmib counter for this default event? Just so that 
people can diagnose this more easily.

> +
> +	ports = (u32 *) (skb_network_header(skb) + (ihl * 4));
> +
> +	hash = 0;
> +	while (alen--)
> +		hash ^= *addr++;

Are you sure the hash behaves the same between big endian and little
endian? Perhaps it would be safer to always convert endian even if
that complicates the code a bit.

> +		hash ^= *ports;
> +		break;
> +
> +	default:
> +		break;

And also a linuxmib counter here.

> +	}
> +
> +	return hash % dev->real_num_tx_queues;

I haven't rechecked it in detail, but I suspect some more
folding of higher bits would be better again for endian safety.

-Andi

