Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXKXUND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 15:13:03 -0500
Message-ID: <4748855C.5090103@linux-foundation.org> (sfid-20071124_201316_570733_C456DE58)
Date: Sat, 24 Nov 2007 12:11:08 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au>
In-Reply-To: <20071124141319.GA27819@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herbert Xu wrote:
> On Sat, Nov 24, 2007 at 02:49:36PM +0100, Johannes Berg wrote:
>   
>> Right. I just didn't think that would be a valid value for an
>> architecture to set.
>>     
>
> OK.  Let me clarify this a bit more.  We require at least one
> of the following rules to be met:
>
> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> * or the platform provides unaligned exception handlers.
>
> So if your platform violates both rules then it won't work with
> the IP stack, simple as that.  Fortunately I don't think such a
> platform exists currently on Linux.
>
> Cheers,
>   

Then what about hardware that can't dma ethernet to non-aligned address.
Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack should
handle any alignment, and do the appropriate memove if the CPU requires 
alignment.
