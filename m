Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51039 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KHTNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 14:13:25 -0500
Received: by pxi15 with SMTP id 15so1058874pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 11:13:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=vW6-WYfBZ39-s48-GVdmdy1ccLn2VZ85t-hAT@mail.gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011042040.12419.IvDoorn@gmail.com>
	<201011042040.47235.IvDoorn@gmail.com>
	<201011042041.06812.IvDoorn@gmail.com>
	<AANLkTinrhE9oOwYP8-ujeJ_YS97AP8=mwgmQ09gd1B6u@mail.gmail.com>
	<AANLkTi=CM9EQxQ7kFmRhiPRzC+dxyb67Xk=m8=U8-CDX@mail.gmail.com>
	<AANLkTin=XHzPBrxZyb2=5L1vLpz6VeOLZoPnQ1HwwJzQ@mail.gmail.com>
	<AANLkTi=vW6-WYfBZ39-s48-GVdmdy1ccLn2VZ85t-hAT@mail.gmail.com>
Date: Mon, 8 Nov 2010 20:13:24 +0100
Message-ID: <AANLkTik=rLRUmyg+0Ah4fKDb5yS4fEVdmFY-7RdejTDN@mail.gmail.com>
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

On Mon, Nov 8, 2010 at 8:08 PM, Blaise Gassend <blaise@willowgarage.com> wrote:
>>>>> +       if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
>>>>> +           !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>>>>> +               goto submit_entry;
>>>>> +
>>>>>        if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
>>>>>                goto submit_entry;
>> I don't see how this could cause a crash, I know there are still issues
>> around this function, but how can the usage of 2 if-statement cause a crash?
>
> What I meant here is that submit_entry does not kill the queue entry
> if data IO failed, which could result in an infinite loop if a
> disconnected device is causing the data IO case to be hit rather than
> one of the two previous ones.

The case that IO failure continuously occurs, while the device is still plugged,
isn't covered by this patch. However if the device was unplugged then
DEVICE_STATE_PRESENT would be cleared either on the first return of
the URB, or on the second in case of a race condition. In either case,
it will not pass the first if-statement when the device was unplugged,
so it doesn't
matter anymore what the entry->flags indicate.

Ivo
