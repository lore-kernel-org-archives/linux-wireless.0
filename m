Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63921 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZLCJcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 04:32:42 -0500
Received: by ywh12 with SMTP id 12so1244490ywh.21
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 01:32:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B163956.1060709@free.fr>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com>
	 <4B14594E.2090307@free.fr> <4B158ADF.7060700@gmail.com>
	 <4B163956.1060709@free.fr>
Date: Thu, 3 Dec 2009 10:32:48 +0100
Message-ID: <14add3d10912030132r251779efq10dc08768aefd8c1@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 2, 2009 at 10:54 AM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Gertjan van Wingerde a écrit :
>>
>> On 12/01/09 00:46, Benoit PAPILLAULT wrote:
>>
>>>
>>> Gertjan van Wingerde a écrit :
>>>
>>>>
>>>> The L2 padding fixes patch has grown a bit and now consists of 4
>>>> separate
>>>> patches to clean the L2 padding code up and to fix a number of bugs at
>>>> the
>>>> same time.
>>>>
>>>>        1. rt2x00: Further L2 padding fixes.
>>>>        2. rt2x00: Remove SKBDESC_L2_PADDED flag.
>>>>        3. rt2x00: Reorganize L2 padding inserting function.
>>>>        4. rt2x00: Only remove L2 padding in received frames if there is
>>>> payload.
>>>>
>>>> ---
>>>> Gertjan.
>>>>
>>>
>>> Thanks Gertjan for the patches, I know that padding is a bit of
>>> nightware. I've testing your tree and here are the results:
>>>
>>> 1. On TX : It fails for control frames with hdrlen=10 since it will
>>> produce l2pad = 2 in your case, where it should be 0. In all other
>>> cases, it works!
>>>
>>>
>>
>> Hmm. That's strange, as patch 3 of the series should have handled this.
>> Basically this patch
>> checks if a frame actually has payload, and refrains from inserting l2pad
>> and payload alignment
>> in that case.
>>
>> How did you detect this failure?
>>
>
> I sent every possible frame type in monitor and compared with what ath9k in
> monitor mode received.
>>
>> What did you observe on the "wire", i.e. how was the frame malformed
>> because of this?
>>
>
> For instance, i sent :
> c400c400c40000000000 (10 bytes)
>
> and I received :
> c400ca00c400000000000000 (12 bytes)
>
> You can see the 2 bytes added at the end (bytes 2-3 are modified by the HW
> since it contains the duration_id)

OK. Thanks for the example. I think I already know where the problem is. The
rt2x00queue_insert_l2pad function doesn't trim down the skb properly in case the
frame has no payload. I'll provide a patch, but that may take until
Friday (when I get back
home).

>>
>> Also, would it be possible to get some of the skb details of a frame that
>> fails?
>>
>
> I'll redo the test. What details do you want?

Never mind. I think I already know where the problem is.

>>
>>
>>>
>>> Solution : padding is only needed for data frames for rt28x devices, so
>>> I think it's better to something like rt2xqueue_padpos
>>>
>>> [http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=95ddf076c13062d1026025d97ba511f880a1792d]
>>>
>>>
>>
>> I'm still not fond of using detailed ieee 802.11 frame format knowledge to
>> do this. I prefer
>> to use standard mac80211 functions with a bit of detection on the actual
>> skb.
>>
>
> If you want to use mac80211 functions, we can do something like that : /*
> * Determine the L2 padding size based on the 802.11 header length
> *
> * Exact formula is (4 - (header_length%4))%4 but since header_length is
> * always a multiple of 2, we could simplify to (header_length&3).

Current formula is (-header_length) & 3, which works even for
header_lengths that are not
a multiple of 2.

> *
> * L2PAD is only present for data frame and an easy way to check for that is
> * to compare header_length with 24 bytes.
> */
> #define L2PAD_SIZE(__header) \
>      ((__header)<24 ? 0 : ((4 - ((__header)%4))%4))
>

That depends on what the purpose of the L2PAD_SIZE macro is going to
be. At the moment
the intention is to have L2PAD_SIZE compute the number of l2pad bytes
necessary, if a
payload is present. Detection on whether actually a payload is present
and whether the
outcome of this macro should be used should be at the call-sites of this macro.

---
Gertjan.
