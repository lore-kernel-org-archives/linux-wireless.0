Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56980 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2LGR5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 12:57:15 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so601586lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 09:57:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C217EB.3070808@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
 <1354817847-23440-11-git-send-email-juhosg@openwrt.org> <CAB=NE6WwuwKzLkLxsggvAGhF5TKcDjWbaw3vkst4gnLFEYjP7Q@mail.gmail.com>
 <50C217EB.3070808@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 7 Dec 2012 09:56:53 -0800
Message-ID: <CAB=NE6XM2PpgN3mqwPbKDneoB76jAfUaLvhm7-CDMVTEeSkuVQ@mail.gmail.com> (sfid-20121207_185720_141276_29E1765A)
Subject: Re: [PATCH v2 10/13] qca-swiss-army-knife: allow to print initvals
 with more than 5 columns
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 8:23 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> 2012.12.07. 0:02 keltezéssel, Luis R. Rodriguez írta:
>> On Thu, Dec 6, 2012 at 10:17 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
>>> @@ -416,19 +423,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
>>>         return val;
>>>  }
>>>
>>> -static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
>>> +static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
>>> +                                  u32 columns, bool onedim, bool wide)
>>>  {
>>> -       u32 p_columns = columns > 5 ? 5 : columns;
>>> +       u32 p_columns;
>>>         u32 col, row;
>>>
>>> -       /*
>>> -        * This checksum stuff is designed for columns <= 8),
>>> -        * and spreads the checksum over 64 bits but since currently
>>> -        * the initval max column size is 6 we only use the first 48
>>> -        * bits.
>>> -        */
>>> -       if (columns > 6)
>>> -               return;
>>> +       if (wide) {
>>> +               p_columns = columns;
>>> +       } else {
>>> +               p_columns = columns > 5 ? 5 : columns;
>>> +
>>> +               /*
>>> +               * This checksum stuff is designed for columns <= 8),
>>> +               * and spreads the checksum over 64 bits but since currently
>>> +               * the initval max column size is 6 we only use the first 48
>>> +               * bits.
>>> +               */
>>> +               if (columns > 6)
>>> +                       return;
>>> +       }
>>
>> The comment here was for the case that we were using the old nasty
>> checksum thingy I invented, prior to you adding SHA1 checksum support.
>> The column limitation therefore seems artificial here ?
>
> Well, the comment and the 'if (columns > 6)' block can be removed.
> However, the
>         p_columns = columns > 5 ? 5 : columns;
> line ensures that we don't print the values for 'Turbo' modes. Although it can
> be removed (along with the 'wide' argument) but that needs more changes.

Sure.

>> Also, as per Adrian's advice on the eeprom dump tool, perhaps we can
>> remove clutter from the initvals tool by allowing us to copy to the
>> local directory the initval files from a linux-next tag.
>>
>> git show next-20121204:drivers/net/wireless/ath/ath9k/ar9002_initvals.h
>>> path/ar9002_initvals.h
>>
>> For example. But this would mean requiring us to get diffs by using a
>> kernel git tree, separate from where we are. Not sure if there are
>> gains with this strategy. Its unclear.
>
> Copying the initval headers from a git tree would add unnecessary complexity
> IMHO. If we want to check the validity of the initval headers in a given kernel
> tree, that can be achieved in a simpler way. The path which contains the ath9k
> specific initval headers can be defined as an include dir while compiling the
> initval tool.

Makes sense.

  Luis
