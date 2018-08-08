Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeHHMFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 08:05:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
References: <20180807225040.GA2164@beast> <20180808092450.GA25772@redhat.com>
Date: Wed, 08 Aug 2018 12:46:54 +0300
In-Reply-To: <20180808092450.GA25772@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 8 Aug 2018 11:24:52 +0200")
Message-ID: <871sb942cx.fsf@kamboji.qca.qualcomm.com> (sfid-20180808_114708_043657_573C3E69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, Aug 07, 2018 at 03:50:40PM -0700, Kees Cook wrote:
>> Even with "const" variables, the compiler will generate warnings about
>> VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
>> a #define instead of a const to do the array sizing.
>> 
>> [1]
>> https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>> 
>> Fixes: e87b5039511a ("mt76x0: eeprom files")
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> Please include this for the v4.19 merge window. The VLA was introduced
>> with the new source file (which I also note is missing a SPDX line), so
>
> I thought SPDX line is needed only if file has no license and eeprom.c
> file and other mt76x0 files have specified the license. Is SPDX still
> needed in that case ?
>  
>> +#define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
>>  static int
>>  mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
>>  {
>> -	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
>> -	u8 data[map_reads * 16];
>
> Why this is variable length array? DIV_ROUND_UP can not be calculated
> at compile time? But if so, macro do not change the situation either.

The commit log mentioned:

  "Even with "const" variables, the compiler will generate warnings about
   VLA usage."

So I guess the compiler (gcc?) is just not smart enough in this case?

-- 
Kalle Valo
