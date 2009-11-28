Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:57854 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbZK1VoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:44:04 -0500
Message-ID: <4B1199A7.7090903@gmail.com>
Date: Sat, 28 Nov 2009 22:44:07 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH] rt2x00: Further L2 padding fixes.
References: <1259433154-2587-1-git-send-email-gwingerde@gmail.com> <200911282226.58091.IvDoorn@gmail.com>
In-Reply-To: <200911282226.58091.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/09 22:26, Ivo van Doorn wrote:
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
>> index b8f0954..562a344 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>  	unsigned int frame_length = skb->len;
>>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
>> -	unsigned int l2pad = 4 - (payload_align - header_align);
>> +	unsigned int l2pad = 4 - (header_length & 3);
> 
> Not sure about this, the l2pad should be the total bytes between the header and payload.
> What if we have a frame for which both the header and the payload should be moved?

That is taken into consideration here. The beauty of this is that in order to calculate the
number of bytes between the header and the payload you don't even have to consider the current
locations of both in the buffer, because it is only a function of the header length. I.e. if a
header is 24 bytes long, then no L2 padding is needed, as a properly aligned header will result
in a properly aligned payload. If a header is 26 bytes long, then 2 bytes of L2 padding is needed
as there are 2 bytes between the end of the header and the next 4-bytes boundary. This is all
independent of whether the current header and the current payload are properly aligned.
So, the value of l2pad shouldn't be used to determine if any alignment needs to be done, it only
will tell you how many padding bytes will be required between the header and the payload.

Also, note that the same formula is used in the rt2x00queue_remove_l2pad function, and this is basically
copied from there.

> 
> The code in this function handles multiple scenarios, one where both the payload and
> header must be moved or when only one of both should be moved. In each case the l2pad
> depends on both the payload and header alignment sizes.
> 
>>  	if (header_align == payload_align) {
>>  		/*
>> @@ -216,6 +216,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>  		memmove(skb->data + header_length + l2pad,
>>  			skb->data + header_length + l2pad + payload_align,
>>  			frame_length - header_length);
>> +		skb_trim(skb, frame_length + l2pad);
>>  		skbdesc->flags |= SKBDESC_L2_PADDED;
>>  	}
>>  }
>> @@ -346,7 +347,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
>>  	 * Header and alignment information.
>>  	 */
>>  	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
>> -	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
>> +	txdesc->l2pad = 4 - (txdesc->header_length & 3);
> 
> ALIGN_SIZE() depends on the actual address of the payload, and thus should be better
> and indicating the amount of padding which is required. However the bug might be that we need
> to do the same calculation as in rt2x00queue_insert_l2pad() and make it depend on the ALIGN_SIZE
> values from header and payload.
> 

Yep, ALIGN_SIZE does. But the number of l2pad bytes doesn't depend on the actual address of the
payload, it only depends on the length of the header. See above for the explanation.

---
Gertjan.

