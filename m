Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.144.80]:32084 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751405AbeCUOUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 10:20:06 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 69BD441FCA
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 08:57:19 -0500 (CDT)
Subject: Re: [PATCH] mac80211: aes-cmac: remove VLA usage
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180321134247.GA1275@embeddedgus>
 <1521640094.2645.29.camel@sipsolutions.net>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b367cf76-e6c5-3d6d-5d81-a68ae245e6b9@embeddedor.com> (sfid-20180321_152009_663041_7E57F944)
Date: Wed, 21 Mar 2018 08:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <1521640094.2645.29.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/21/2018 08:48 AM, Johannes Berg wrote:
> On Wed, 2018-03-21 at 08:42 -0500, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wvla, remove VLAs and replace them
>> with dynamic memory allocation instead.
>>
>> The use of stack Variable Length Arrays needs to be avoided, as they
>> can be a vector for stack exhaustion, which can be both a runtime bug
>> or a security flaw. Also, in general, as code evolves it is easy to
>> lose track of how big a VLA can get. Thus, we can end up having runtime
>> failures that are hard to debug.
>>
>> Also, fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   net/mac80211/aes_cmac.c | 36 ++++++++++++++++++++++++------------
>>   1 file changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
>> index 2fb6558..c9444bf 100644
>> --- a/net/mac80211/aes_cmac.c
>> +++ b/net/mac80211/aes_cmac.c
>> @@ -27,30 +27,42 @@ static const u8 zero[CMAC_TLEN_256];
>>   void ieee80211_aes_cmac(struct crypto_shash *tfm, const u8 *aad,
>>   			const u8 *data, size_t data_len, u8 *mic)
>>   {
>> -	SHASH_DESC_ON_STACK(desc, tfm);
>> +	struct shash_desc *shash;
>>   	u8 out[AES_BLOCK_SIZE];
>>   
>> -	desc->tfm = tfm;
>> +	shash = kmalloc(sizeof(*shash) + crypto_shash_descsize(tfm),
>> +			GFP_KERNEL);
>> +	if (!shash)
>> +		return;
> 
> Honestly, this seems like a really bad idea - you're now hitting
> kmalloc for every TX/RX frame here.
> 
> SHA_DESC_ON_STACK() should just be fixed to not need a VLA, but take
> some sort of maximum, I guess?
> 

SHA_DESC_ON_STACK is currently being used in multiple places. But, yeah, 
I think we can define multiple macros of the same kind and adjust to the 
characteristics of each the component.

How big do you think tfm can get?

Thanks
--
Gustavo
