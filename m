Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62979 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3IKIKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 04:10:37 -0400
Received: by mail-ie0-f181.google.com with SMTP id y16so12464627ieg.26
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 01:10:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378799252.4799.61.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-11-git-send-email-eliad@wizery.com>
	<1378799252.4799.61.camel@porter.coelho.fi>
Date: Wed, 11 Sep 2013 10:10:37 +0200
Message-ID: <CAB3XZEdrEsAwDxPzY4ER+SHFLQN5-x6CXSpLFcW_KpGZ2ZCWkQ@mail.gmail.com> (sfid-20130911_101043_948228_D011568A)
Subject: Re: [PATCH 11/12] wl18xx: print new RDL versions during boot
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 10:47 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Victor Goldenshtein <victorg@ti.com>
>>
>> Extract and print info for the new RDL 5, 6, 7 and 8.
>> Replace const struct with function which translates
>> the RDL number to string.
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Signed-off-by: Barak Bercovitz <barak@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Why convert the array with a function? The array looks much cleaner to
> me.
>
the version numbers are not successive (4 -> 0x11), so i think it
makes sense, but i guess we can revert back to array if you prefer it
that way.

> [...[
>> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
>> index b47eb62..aef0c91 100644
>> --- a/drivers/net/wireless/ti/wl18xx/main.c
>> +++ b/drivers/net/wireless/ti/wl18xx/main.c
>> @@ -1228,16 +1228,46 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
>>       }
>>  }
>>
>> +static const char *wl18xx_rdl_name(enum wl18xx_rdl_num rdl_num)
>> +{
>> +     switch (rdl_num) {
>> +     case RDL_1_HP:
>> +         return "183xH";
>> +     case RDL_2_SP:
>> +         return "183x or 180x";
>> +     case RDL_3_HP:
>> +         return "187xH";
>> +     case RDL_4_SP:
>> +         return "187x";
>> +     case RDL_5_SP:
>> +         return "RDL11 - Not Supported";
>> +     case RDL_6_SP:
>> +         return "180xD";
>> +     case RDL_7_SP:
>> +         return "RDL13 - Not Supported (1893Q)";
>> +     case RDL_8_SP:
>> +         return "18xxQ";
>> +     default:
>> +         return "UNTRIMMED";
>
> This may become misleading if we get more RDLs versions in the future.
> And the untrimmed case is probably reporting 0? Or something predefined,
> hopefully, otherwise how can we know that we wouldn't randomly get a
> valid value?
>
you're right here.
untrimmed devices always use the 0 value.
i'll split it to "untrimmed" and "unknown".

> Also, in the unsupported cases, it would probably be better to bail out?
i'm not sure what "not supported" actually mean here (it might still work...).
i'd prefer continue using these values only for debugging (there
shouldn't really be such unsupported devices out there, afaik)

Eliad.
