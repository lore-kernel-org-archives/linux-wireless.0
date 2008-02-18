Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYBRVRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 16:17:39 -0500
Message-ID: <47B9F5E7.3020905@trash.net> (sfid-20080218_211744_334121_DCC75BC9)
Date: Mon, 18 Feb 2008 22:17:27 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
References: <20080215.025855.202184003.davem@davemloft.net>	<1203097370.21308.18.camel@localhost>	<47B9A20C.10304@trash.net> <20080218.125525.192686382.davem@davemloft.net>
In-Reply-To: <20080218.125525.192686382.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 18 Feb 2008 16:19:40 +0100
>
>   
>> Joe Perches wrote:
>>     
>>>
>>>> We specifically removed this sort of thing, please don't
>>>> add it back.
>>>>         
>> Why?
>>     
>
> We converted the entire tree over the print_mac(), and since
> the MAC_FMT stuff was therefore no longer used we could
> remove it.
>
> Some references slipped back in somehow, and thus MAC_FMT
> did too.
>
> There is no reason to keep around a global interface for
> _one_ user when that user can use the recommended interface
> just as equally as the rest of the tree which we converted.
>
> This is a pr_debug() statement we're talking about here.
> :-)
>   

The way pr_debug is implemented it still results in two function
calls per packet since the compiler doesn't know that it doesn't
have visible side-effects besides modifying the (unused) buffer.
I confirmed this using codiff.


