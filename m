Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32805 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932367AbeGCP21 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 11:28:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id c6-v6so4633193oiy.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2018 08:28:27 -0700 (PDT)
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
To: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>
Cc: Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20180518093007.23594-1-pkshih@realtek.com>
 <20180518093007.23594-14-pkshih@realtek.com>
 <87po1fhwfd.fsf@purkki.adurom.net> <1527732798.8418.7.camel@realtek.com>
 <87sh56f3sv.fsf@codeaurora.org> <1530597815.6330.4.camel@realtek.com>
 <87y3esrgkr.fsf@kamboji.qca.qualcomm.com>
 <b69340e7-b7ae-2b54-9488-c9c7bcffecf2@nbd.name>
 <87po04r3hk.fsf@kamboji.qca.qualcomm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2eb770f9-2242-2234-b853-d53b0198fda4@lwfinger.net> (sfid-20180703_172832_253100_76BD98D7)
Date: Tue, 3 Jul 2018 10:28:25 -0500
MIME-Version: 1.0
In-Reply-To: <87po04r3hk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2018 05:57 AM, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2018-07-03 08:14, Kalle Valo wrote:
>>> Pkshih <pkshih@realtek.com> writes:
>>>
>>>> On Fri, 2018-06-29 at 10:30 +0300, Kalle Valo wrote:
>>>>> Pkshih <pkshih@realtek.com> writes:
>>>>>
>>>>>> On Tue, 2018-05-29 at 08:18 +0300, Kalle Valo wrote:
>>>>>>> <pkshih@realtek.com> writes:
>>>>>>>   
>>>>>>
>>>>>> Because C2H data is little endian order, the struct will look like
>>>>>> struct foo {
>>>>>> #ifdef __LITTLE_ENDIAN
>>>>>>   	u8 bar:4;
>>>>>>   	u8 koo:4;
>>>>>> #else
>>>>>>   	u8 koo:4;
>>>>>>   	u8 bar:4;
>>>>>> #endif
>>>>>> }
>>>>>
>>>>> With u8 you don't need endian check, right? I would assume that with
>>>>> both little and big endian bar and koo would be in the same place.
>>>>
>>>> I think u8 with bitfield would be different between little and big endian
>>>> machines.
>>>
>>> To me that does not make any sense, I have never heard about bit
>>> endianness any of the devices I have worked on.
>>
>> Unfortunately, the order in which these fields are laid out is different
>> between big and little endian, even when only dealing with u8.
> 
> Oh, didn't know that. Can you give some examples about endian problems
> with u8 bitfields? Still not getting it. Not that it matters, just
> curious.
> 
>> That alone is a strong reason to avoid bitfields entirely for anything
>> shared between the host and something else.
> 
> Very good to know, thanks.

Kalle,

By now, I think you understand that not only the byte order is different between 
BE and LE, but the bit order within a byte is different as well. In the normal 
situation where only byte-sized quantities are involved, then there need not be 
any concern. If you need to mask part of the byte, the mask itself will be in 
the correct endianess.

To me, the main advantage of using using bitfield notation is that the compiler 
does the work of generating the masks needed to extract a portion of the byte. I 
consider that to be slightly less likely to have errors that relying on the 
programmer to generate the mask. A secondary benefit is that the bitfield 
notation is self documenting.

Larry
