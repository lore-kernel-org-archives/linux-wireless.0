Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64151 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LVOaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:30:19 -0500
Received: by iyi12 with SMTP id 12so4099534iyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:30:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293026525.3531.21.camel@jlt3.sipsolutions.net>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <1292864555-28661-3-git-send-email-lrodriguez@atheros.com> <1293026525.3531.21.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Dec 2010 09:29:58 -0500
Message-ID: <AANLkTin+GOH_EKhoXFZwo0VsS3=2RHCo68WceaJ3XC_a@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: process new country regulatory flags (DFS)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 9:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:
>
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -858,6 +858,9 @@ enum nl80211_commands {
>>   *   attributes, specifying what a key should be set as default as.
>>   *   See &enum nl80211_key_default_types.
>>   *
>> + * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
>> + *   These are @NL80211_CFLAG_DFS_*
>> + *
>
> Please also add a note "(u16)" here or so.

Sure.

>> +#define flag_check_print(_str) \
>> +     do { \
>> +             if (has_flag) \
>> +                     pr_info(", "); \
>> +             pr_info(_str); \
>> +             has_flag = true; \
>> +     } while (0)
>> +
>> +static void print_country_flags(u16 flags)
>> +{
>
> Can you move the define into the function, and also #undef it please?

OK

> Also -- it seems that this is never reported back to be printed by iw
> reg get?

Actually it is. See the changes on nl80211_get_reg(), and I tested
this and I get it.

> I think that might be needed?

Yeap.

> If you do, it should only report
> the ones that the kernel knows about (i.e. mask them with the _ALL
> thing)

Sure.

> Does it make sense to actually have this a bitmask rather than an enum?

Good question.

> Do we think there's some place that needs _multiple_ rules?

Good question, I have my call with Michael scheduled for 11am PST
time, hope to get some insight into his regulatory crystal ball then.

  Luis
