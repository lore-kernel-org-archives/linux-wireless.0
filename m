Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48659 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0KEAHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 20:07:23 -0400
Received: by eye27 with SMTP id 27so1470048eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 17:07:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinrhE9oOwYP8-ujeJ_YS97AP8=mwgmQ09gd1B6u@mail.gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011042040.12419.IvDoorn@gmail.com>
	<201011042040.47235.IvDoorn@gmail.com>
	<201011042041.06812.IvDoorn@gmail.com>
	<AANLkTinrhE9oOwYP8-ujeJ_YS97AP8=mwgmQ09gd1B6u@mail.gmail.com>
Date: Thu, 4 Nov 2010 17:07:21 -0700
Message-ID: <AANLkTi=CM9EQxQ7kFmRhiPRzC+dxyb67Xk=m8=U8-CDX@mail.gmail.com>
Subject: Re: [PATCH 11/13] rt2x00: Fix crash on USB unplug
From: Blaise Gassend <blaise@willowgarage.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
>> index a5c7a4f..b6822cd 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
>> @@ -483,6 +483,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>>        unsigned int header_length;
>>        int rate_idx;
>>
>> +       if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
>> +           !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>> +               goto submit_entry;
>> +
>>        if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
>>                goto submit_entry;
>>
>
> Could these two if statements be combined?

I'm also worried that the crash may still happen when the second if
causes a jump. So far I am still getting crashes with this patch in.
