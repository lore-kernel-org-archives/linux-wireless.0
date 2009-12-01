Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:57501 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbZLAVEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:04:55 -0500
Message-ID: <4B1584FC.5020804@gmail.com>
Date: Tue, 01 Dec 2009 22:05:00 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: Re: [PATCH v3 3/4] rt2x00: Reorganize L2 padding inserting function.
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-3-git-send-email-gwingerde@gmail.com> <1259615298-2305-4-git-send-email-gwingerde@gmail.com> <200912012013.47692.IvDoorn@gmail.com>
In-Reply-To: <200912012013.47692.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/09 20:13, Ivo van Doorn wrote:
> On Monday 30 November 2009, Gertjan van Wingerde wrote:
>> Simplify the rt2x00queue_insert_l2pad function by handling the alignment
>> operations one by one. Do not special case special circumstances.
>> Basically first perform header alignment, and then perform payload alignment
>> (if any payload does exist). This results in a properly aligned skb.
>>
>> The end result is better readable code, with better results, as now L2 padding
>> is inserted only when a payload is actually present in the frame.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2x00queue.c |   60 +++++++++++++----------------
>>  1 files changed, 27 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
>> index 719f4ae..7452fa8 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>> @@ -177,45 +177,38 @@ void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length)
>>  
>>  void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>  {
>> -	unsigned int frame_length = skb->len;
>> +	unsigned int payload_length = skb->len - header_length;
>>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
>>  	unsigned int l2pad = L2PAD_SIZE(header_length);
>>  
>> -	if (header_align == payload_align) {
>> -		/*
>> -		 * Both header and payload must be moved the same
>> -		 * amount of bytes to align them properly. This means
>> -		 * we don't use the L2 padding but just move the entire
>> -		 * frame.
>> -		 */
>> -		rt2x00queue_align_frame(skb);
>> -	} else if (!payload_align) {
>> -		/*
>> -		 * Simple L2 padding, only the header needs to be moved,
>> -		 * the payload is already properly aligned.
>> -		 */
>> -		skb_push(skb, header_align);
>> -		memmove(skb->data, skb->data + header_align, header_length);
>> -	} else {
>> -		/*
>> -		 *
>> -		 * Complicated L2 padding, both header and payload need
>> -		 * to be moved. By default we only move to the start
>> -		 * of the buffer, so our header alignment needs to be
>> -		 * increased if there is not enough room for the header
>> -		 * to be moved.
>> -		 */
>> -		if (payload_align > header_align)
>> -			header_align += 4;
>> +	/*
>> +	 * Adjust the header alignment if the payload needs to be moved more
>> +	 * than the header.
>> +	 */
>> +	if (payload_align > header_align)
>> +		header_align += 4;
>> +
>> +	/* There is nothing to do if no alignment is needed */
>> +	if (!header_align)
>> +		return;
>>  
>> -		skb_push(skb, header_align);
>> -		memmove(skb->data, skb->data + header_align, header_length);
>> +	/* Reserve the amount of space needed in front of the frame */
>> +	skb_push(skb, header_align);
>> +
>> +	/*
>> +	 * Move the header.
>> +	 */
>> +	memmove(skb->data, skb->data + header_align, header_length);
>> +
>> +	/* Move the payload, if present and if required */
>> +	if (payload_length && payload_align)
>>  		memmove(skb->data + header_length + l2pad,
>>  			skb->data + header_length + l2pad + payload_align,
>> -			frame_length - header_length);
>> -		skb_trim(skb, frame_length + l2pad);
>> -	}
>> +			payload_length);
>> +
>> +	/* Trim the skb to the correct size */
>> +	skb_trim(skb, header_length + l2pad + payload_length);
>>  }
>>  
>>  void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
>> @@ -343,7 +336,8 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
>>  	 * Header and alignment information.
>>  	 */
>>  	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
>> -	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
>> +	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags) &&
>> +	    (entry->skb->len > txdesc->header_length))
>>  		txdesc->l2pad = L2PAD_SIZE(txdesc->header_length);
> 
> This check is a bit unclear, are you not simply checking for ieee80211_is_data() or
> ieee80211_is_data_present()?
> 

Well, this check is more based on the actual contents of the skb, where ieee802111_is_data
and ieee80211_is_data_present only indicate, based on the frame_control field, whether any
data should be present.

Personally, I think this is safer, as it matches the actual data at hand. But I guess if
absolutely necessary ieee80211_is_data_present can be used as well.

---
Gertjan.
