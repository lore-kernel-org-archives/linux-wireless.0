Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:50390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbXK0RRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:17:17 -0500
Message-ID: <474C50D7.5010901@zytor.com> (sfid-20071127_171720_947445_2BC3AF76)
Date: Tue, 27 Nov 2007 09:16:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org>
In-Reply-To: <4748855C.5090103@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> Herbert Xu wrote:
>> On Sat, Nov 24, 2007 at 02:49:36PM +0100, Johannes Berg wrote:
>>  
>>> Right. I just didn't think that would be a valid value for an
>>> architecture to set.
>>>     
>>
>> OK.  Let me clarify this a bit more.  We require at least one
>> of the following rules to be met:
>>
>> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
>> * or the platform provides unaligned exception handlers.
>>
>> So if your platform violates both rules then it won't work with
>> the IP stack, simple as that.  Fortunately I don't think such a
>> platform exists currently on Linux.
>>
>> Cheers,
>>   
> 
> Then what about hardware that can't dma ethernet to non-aligned address.
> Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack 
> should handle any alignment, and do the appropriate memove if the CPU requires 
> alignment.

I wrote a patch for the IP stack to realign packets if necessary at one 
point.  I should dredge it up again and submit it for collective flamage.

	-hpa

