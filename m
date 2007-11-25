Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910AbXKYVXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 16:23:12 -0500
Message-ID: <4749E768.9040002@linux-foundation.org> (sfid-20071125_212317_850844_5887CC50)
Date: Sun, 25 Nov 2007 13:21:44 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org> <20071125010814.GD31668@gondor.apana.org.au>
In-Reply-To: <20071125010814.GD31668@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herbert Xu wrote:
> On Sat, Nov 24, 2007 at 12:11:08PM -0800, Stephen Hemminger wrote:
>   
>> Then what about hardware that can't dma ethernet to non-aligned address.
>> Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack should
>> handle any alignment, and do the appropriate memove if the CPU requires 
>> alignment.
>>     
>
> Luckily all sky2 users have been on x86 so far :)
>
> Here's an idea.  Put the data of the packet into the page frags
> where alignment is not an issue but copy the header so that it
> is aligned.
>
> Would that work?
>
> Cheers,
>   
No too wasteful. I'm working a patch to eth_type_trans to realign if 
needed for any device.
