Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:51631 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZLAVIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:08:07 -0500
Message-ID: <4B1585BC.60700@gmail.com>
Date: Tue, 01 Dec 2009 22:08:12 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: Re: [PATCH v3 4/4] rt2x00: Only remove L2 padding in received frames
 if there is payload.
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-4-git-send-email-gwingerde@gmail.com> <1259615298-2305-5-git-send-email-gwingerde@gmail.com> <200912012016.03145.IvDoorn@gmail.com>
In-Reply-To: <200912012016.03145.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/09 20:16, Ivo van Doorn wrote:
> On Monday 30 November 2009, Gertjan van Wingerde wrote:
>> L2 padding will only be present when there is actual payload present.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
>> index ca2bcc0..b93731b 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
>> @@ -401,7 +401,9 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
>>  	    (rxdesc.flags & RX_FLAG_IV_STRIPPED))
>>  		rt2x00crypto_rx_insert_iv(entry->skb, header_length,
>>  					  &rxdesc);
>> -	else if (rxdesc.dev_flags & RXDONE_L2PAD)
>> +	else if (header_length &&
>> +		 (rxdesc.size > header_length) &&
>> +		 (rxdesc.dev_flags & RXDONE_L2PAD))
>>  		rt2x00queue_remove_l2pad(entry->skb, header_length);
>>  	else
>>  		rt2x00queue_align_payload(entry->skb, header_length);
> 
> Is there a scenario where header_lenght can be 0?
> And if there is, shouldn't we have bailed-out completely already?
> 

Actually, there is. ieee80211_get_hdrlen_from_skb returns 0 when it detects that
the skb is actually shorter than it should be (according to the frame type indicated
by the frame_control field).
I'm using that here to check whether actually any payload is present, as a value of 0
means that there isn't even a full header.
We should still pass on the frame in that case, for the monitor interfaces.

I agree it is a bit of a trick, but it works.

---
Gertjan.
