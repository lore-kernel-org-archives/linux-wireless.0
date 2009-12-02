Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51742 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZLBHww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 02:52:52 -0500
Received: by bwz27 with SMTP id 27so4129503bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 23:52:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B15940A.8070304@gmail.com>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
	 <200912012016.03145.IvDoorn@gmail.com> <4B1585BC.60700@gmail.com>
	 <200912012257.02397.IvDoorn@gmail.com> <4B15940A.8070304@gmail.com>
Date: Wed, 2 Dec 2009 08:52:57 +0100
Message-ID: <a32f33a40912012352v3f98eaao6c04b062f3427e5@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] rt2x00: Only remove L2 padding in received frames
	if there is payload.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 1, 2009 at 11:09 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 12/01/09 22:57, Ivo van Doorn wrote:
>> On Tuesday 01 December 2009, Gertjan van Wingerde wrote:
>>> On 12/01/09 20:16, Ivo van Doorn wrote:
>>>> On Monday 30 November 2009, Gertjan van Wingerde wrote:
>>>>> L2 padding will only be present when there is actual payload present.
>>>>>
>>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>>> ---
>>>>>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +++-
>>>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
>>>>> index ca2bcc0..b93731b 100644
>>>>> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
>>>>> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
>>>>> @@ -401,7 +401,9 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
>>>>>        (rxdesc.flags & RX_FLAG_IV_STRIPPED))
>>>>>            rt2x00crypto_rx_insert_iv(entry->skb, header_length,
>>>>>                                      &rxdesc);
>>>>> -  else if (rxdesc.dev_flags & RXDONE_L2PAD)
>>>>> +  else if (header_length &&
>>>>> +           (rxdesc.size > header_length) &&
>>>>> +           (rxdesc.dev_flags & RXDONE_L2PAD))
>>>>>            rt2x00queue_remove_l2pad(entry->skb, header_length);
>>>>>    else
>>>>>            rt2x00queue_align_payload(entry->skb, header_length);
>>>>
>>>> Is there a scenario where header_lenght can be 0?
>>>> And if there is, shouldn't we have bailed-out completely already?
>>>>
>>>
>>> Actually, there is. ieee80211_get_hdrlen_from_skb returns 0 when it detects that
>>> the skb is actually shorter than it should be (according to the frame type indicated
>>> by the frame_control field).
>>> I'm using that here to check whether actually any payload is present, as a value of 0
>>> means that there isn't even a full header.
>>> We should still pass on the frame in that case, for the monitor interfaces.
>>
>> Ok, then we should pass it to mac80211, but we better use a goto or something to
>> skip all frame manipulation (like the rt2x00crypto_rx_insert_iv and rt2x00queue_align_payload)
>> as well.
>>
>
> Good point. Can we do that as a follow-up patch?

Sure. :)

Ivo
