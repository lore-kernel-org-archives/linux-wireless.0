Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58370 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0KFMvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 08:51:33 -0400
Received: by qwb8 with SMTP id 8so1289623qwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 05:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=CM9EQxQ7kFmRhiPRzC+dxyb67Xk=m8=U8-CDX@mail.gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011042040.12419.IvDoorn@gmail.com>
	<201011042040.47235.IvDoorn@gmail.com>
	<201011042041.06812.IvDoorn@gmail.com>
	<AANLkTinrhE9oOwYP8-ujeJ_YS97AP8=mwgmQ09gd1B6u@mail.gmail.com>
	<AANLkTi=CM9EQxQ7kFmRhiPRzC+dxyb67Xk=m8=U8-CDX@mail.gmail.com>
Date: Sat, 6 Nov 2010 13:51:32 +0100
Message-ID: <AANLkTin=XHzPBrxZyb2=5L1vLpz6VeOLZoPnQ1HwwJzQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] rt2x00: Fix crash on USB unplug
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Blaise Gassend <blaise@willowgarage.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Nov 5, 2010 at 1:07 AM, Blaise Gassend <blaise@willowgarage.com> wrote:
>>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>>> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>> ---
>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
>>> index a5c7a4f..b6822cd 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
>>> @@ -483,6 +483,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>>>        unsigned int header_length;
>>>        int rate_idx;
>>>
>>> +       if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
>>> +           !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>>> +               goto submit_entry;
>>> +
>>>        if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
>>>                goto submit_entry;
>>>
>>
>> Could these two if statements be combined?

They can, but I wanted the separation for clarity, the first
if-statement checks the
device state, while the second if-statement is for the frame itself.

> I'm also worried that the crash may still happen when the second if
> causes a jump. So far I am still getting crashes with this patch in.

I don't see how this could cause a crash, I know there are still issues
around this function, but how can the usage of 2 if-statement cause a crash?

Ivo
