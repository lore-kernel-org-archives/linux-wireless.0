Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYBRVbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 16:31:37 -0500
Message-ID: <47B9F92F.7060709@trash.net> (sfid-20080218_213141_887196_C7B16B59)
Date: Mon, 18 Feb 2008 22:31:27 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, bruno@thinktube.com,
	netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
References: <20080215104804.9870.15722.stgit@one>	 <20080215.025855.202184003.davem@davemloft.net>	 <1203097370.21308.18.camel@localhost>  <47B9A20C.10304@trash.net> <1203359462.7181.80.camel@localhost>
In-Reply-To: <1203359462.7181.80.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> On Mon, 2008-02-18 at 16:19 +0100, Patrick McHardy wrote:
>   
>>> @@ -404,11 +405,8 @@ static int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
>>>  
>>>  	pr_debug("%s: about to send skb: %p to dev: %s\n",
>>>  		__FUNCTION__, skb, skb->dev->name);
>>> -	pr_debug("  " MAC_FMT " " MAC_FMT " %4hx %4hx %4hx\n",
>>> -		 veth->h_dest[0], veth->h_dest[1], veth->h_dest[2],
>>> -		 veth->h_dest[3], veth->h_dest[4], veth->h_dest[5],
>>> -		 veth->h_source[0], veth->h_source[1], veth->h_source[2],
>>> -		 veth->h_source[3], veth->h_source[4], veth->h_source[5],
>>> +	pr_debug("  %s %s %4hx %4hx %4hx\n",
>>> +		 print_mac(mac, veth->h_dest), print_mac(mac2, veth->h_source),
>>>       
>> This results in print_mac getting called twice per packet even without
>> debugging. Whats the problem with MAC_FMT?
>>     
>
> It's just a consistency thing.
> It identifies code where MAC addresses are used.
>   
> an allyesconfig is a bit smaller (~.1%).
> pr_debug is a noop when not debugging, print_mac is optimized away.
>   

No its not, which I also stated in the commit message that restored
it.

0x0000000060244313 <vlan_dev_hard_start_xmit+433>:      callq  
0x60161dbd <print_mac>
0x0000000060244318 <vlan_dev_hard_start_xmit+438>:      lea    
-0x50(%rbp),%rdi
0x000000006024431c <vlan_dev_hard_start_xmit+442>:      mov    %r15,%rsi
0x000000006024431f <vlan_dev_hard_start_xmit+445>:      callq  
0x60161dbd <print_mac>


