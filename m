Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43369 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeHHSBp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 14:01:45 -0400
Received: by mail-yw1-f65.google.com with SMTP id l189-v6so1851433ywb.10
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 08:41:31 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id g203-v6sm2096004ywb.69.2018.08.08.08.41.29
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Aug 2018 08:41:29 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id j68-v6so1872628ywg.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 08:41:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871sb942cx.fsf@kamboji.qca.qualcomm.com>
References: <20180807225040.GA2164@beast> <20180808092450.GA25772@redhat.com> <871sb942cx.fsf@kamboji.qca.qualcomm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Aug 2018 08:41:28 -0700
Message-ID: <CAGXu5jKqeAHDWdNg++QJko5AM4g160kEQ54jLAojpRq6FszqgA@mail.gmail.com> (sfid-20180808_174201_898428_0BD027B9)
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 8, 2018 at 2:46 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>
>> On Tue, Aug 07, 2018 at 03:50:40PM -0700, Kees Cook wrote:
>>> Even with "const" variables, the compiler will generate warnings about
>>> VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
>>> a #define instead of a const to do the array sizing.
>>>
>>> [1]
>>> https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>>
>>> Fixes: e87b5039511a ("mt76x0: eeprom files")
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> Please include this for the v4.19 merge window. The VLA was introduced
>>> with the new source file (which I also note is missing a SPDX line), so
>>
>> I thought SPDX line is needed only if file has no license and eeprom.c
>> file and other mt76x0 files have specified the license. Is SPDX still
>> needed in that case ?

I thought all source files needed SPDX: https://lwn.net/Articles/739183/

>>
>>> +#define MT_MAP_READS        DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
>>>  static int
>>>  mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
>>>  {
>>> -    const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
>>> -    u8 data[map_reads * 16];
>>
>> Why this is variable length array? DIV_ROUND_UP can not be calculated
>> at compile time? But if so, macro do not change the situation either.
>
> The commit log mentioned:
>
>   "Even with "const" variables, the compiler will generate warnings about
>    VLA usage."
>
> So I guess the compiler (gcc?) is just not smart enough in this case?

Correct. This is technically a false positive, but with the goal of
adding -Wvla to the build globally, we have to get rid of these as
well. It's a little frustrating, I agree, but with all others fixed
now, these stand out. :)

-Kees

-- 
Kees Cook
Pixel Security
