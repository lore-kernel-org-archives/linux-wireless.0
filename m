Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48223 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFWRMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 13:12:34 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so5831337pdj.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 10:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-3-git-send-email-arik@wizery.com> <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 23 Jun 2014 20:12:18 +0300
Message-ID: <CA+XVXfc=zDyie-3xO86k98zKQUZqDm0dEf9d5qMDAX83svfR_Q@mail.gmail.com> (sfid-20140623_191237_974473_6AFA95CD)
Subject: Re: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2014 at 1:08 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> If the regulatory request contains the special "99" unknown-country code,
>> allow a different alpha2 as response.
>>
>> This special alpha2 is used when the real alpha2 is unknown and should
>> be provided by the driver via its get_regd() wiphy callback, as part of
>> the regdomain info.
>>
>> Change-Id: I286e3aed828cabf22292b6fe320fdcfa61f0b951
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> Reviewed-on: https://gerrit.rds.intel.com/32266
>> Tested-by: IWL Jenkins
>> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/wireless/reg.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index e2f33d7..c429ec5 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -418,7 +418,8 @@ static bool is_user_regdom_saved(void)
>>                 return false;
>>
>>         /* This would indicate a mistake on the design */
>> -       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
>> +       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2) &&
>> +                !is_unknown_alpha2(user_alpha2),
>>                  "Unexpected user alpha2: %c%c\n",
>>                  user_alpha2[0], user_alpha2[1]))
>>                 return false;
>
> When would the user alpha2 be a custom value? This is *very* different
> than allowing an API to set the regulatory domain to a specific alpha2
> value, which is what I though this was all about.

Well there's a default country burned in the FW/NVRAM. In order to get
this country I send the "99" country code to FW, and it replies with
the correct country code. Since we need the regulatory settings
anyway, I didn't want to invent some new API to just get the current
country code and then request settings for it.
We could go down that route but IMHO that would complicate things
needlessly.. Perhaps you have a different suggestion?

>
>> @@ -595,7 +596,8 @@ bool reg_is_valid_request(const char *alpha2)
>>         if (!lr || lr->processed)
>>                 return false;
>>
>> -       return alpha2_equal(lr->alpha2, alpha2);
>> +       return alpha2_equal(lr->alpha2, alpha2) ||
>> +              is_unknown_alpha2(lr->alpha2);
>>  }
>
> This patch seems to be allowing custom user alpha2s to be passed,
> while the commit log is indicating we want to allow a change from a
> custom value that is set to a regular alpha2.

See above.

Regards,
Arik
