Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46667 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422727Ab2LGQXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 11:23:08 -0500
Message-ID: <50C217EB.3070808@openwrt.org> (sfid-20121207_172314_234517_96708B23)
Date: Fri, 07 Dec 2012 17:23:07 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 10/13] qca-swiss-army-knife: allow to print initvals
 with more than 5 columns
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org> <1354817847-23440-11-git-send-email-juhosg@openwrt.org> <CAB=NE6WwuwKzLkLxsggvAGhF5TKcDjWbaw3vkst4gnLFEYjP7Q@mail.gmail.com>
In-Reply-To: <CAB=NE6WwuwKzLkLxsggvAGhF5TKcDjWbaw3vkst4gnLFEYjP7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.07. 0:02 keltezéssel, Luis R. Rodriguez írta:
> On Thu, Dec 6, 2012 at 10:17 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> @@ -416,19 +423,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
>>         return val;
>>  }
>>
>> -static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
>> +static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
>> +                                  u32 columns, bool onedim, bool wide)
>>  {
>> -       u32 p_columns = columns > 5 ? 5 : columns;
>> +       u32 p_columns;
>>         u32 col, row;
>>
>> -       /*
>> -        * This checksum stuff is designed for columns <= 8),
>> -        * and spreads the checksum over 64 bits but since currently
>> -        * the initval max column size is 6 we only use the first 48
>> -        * bits.
>> -        */
>> -       if (columns > 6)
>> -               return;
>> +       if (wide) {
>> +               p_columns = columns;
>> +       } else {
>> +               p_columns = columns > 5 ? 5 : columns;
>> +
>> +               /*
>> +               * This checksum stuff is designed for columns <= 8),
>> +               * and spreads the checksum over 64 bits but since currently
>> +               * the initval max column size is 6 we only use the first 48
>> +               * bits.
>> +               */
>> +               if (columns > 6)
>> +                       return;
>> +       }
> 
> The comment here was for the case that we were using the old nasty
> checksum thingy I invented, prior to you adding SHA1 checksum support.
> The column limitation therefore seems artificial here ?

Well, the comment and the 'if (columns > 6)' block can be removed.
However, the
	p_columns = columns > 5 ? 5 : columns;
line ensures that we don't print the values for 'Turbo' modes. Although it can
be removed (along with the 'wide' argument) but that needs more changes.

> Also, as per Adrian's advice on the eeprom dump tool, perhaps we can
> remove clutter from the initvals tool by allowing us to copy to the
> local directory the initval files from a linux-next tag.
> 
> git show next-20121204:drivers/net/wireless/ath/ath9k/ar9002_initvals.h
>> path/ar9002_initvals.h
> 
> For example. But this would mean requiring us to get diffs by using a
> kernel git tree, separate from where we are. Not sure if there are
> gains with this strategy. Its unclear.

Copying the initval headers from a git tree would add unnecessary complexity
IMHO. If we want to check the validity of the initval headers in a given kernel
tree, that can be achieved in a simpler way. The path which contains the ath9k
specific initval headers can be defined as an include dir while compiling the
initval tool.

-Gabor

