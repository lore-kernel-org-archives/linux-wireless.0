Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41354 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab2FTKjB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:39:01 -0400
Received: by lbok6 with SMTP id k6so556441lbo.32
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 03:38:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340180991.4655.30.camel@jlt3.sipsolutions.net>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
	<1340178370.4655.22.camel@jlt3.sipsolutions.net>
	<CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com>
	<1340180991.4655.30.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 13:38:57 +0300
Message-ID: <CAK80WHbMVr0GVrKRGL9OD8CUHi8FBVRL0tDGewf9doLm2etb0g@mail.gmail.com> (sfid-20120620_123914_485154_E083E06E)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Yes, but if we let the attributes through then the driver author can
> test his code and see different timings, even though the flag isn't set,
> and then get confused. It'd be easier for the driver authors and more
> reliable if we require the flag to be set for even reading timings from
> userspace. Otherwise the driver might honour them even if the flag isn't
> set which is very odd.
>

Will add this check, so we will read scan attributes only if the
NL80211_FEATURE_SCAN_TIMES is set by the  driver.

>
>> > I pointed this out before -- this is problematic. Userspace could
>> > request a max time of 10, and then this would set the min time to 30,
>> > which means min > max which is completely stupid. We should prevent such
>> > settings.
>> >
>>
>> This check is done in nl80211_trigger_scan(), please see:
>>
>> +» » if·(request->min_ch_time·>·request->max_ch_time)
>> +» » » return·-EINVAL;
>>
>> and
>>
>> +» » if·(request->min_passive_ch_time·>·request->max_passive_ch_time)
>> +» » » return·-EINVAL;
>>
>> in this case we return EINVAL, btw this also documented:
>> + *    If one of the min times will be greater than max or set to zero,
>> + *    -EINVAL will be returned. For the software scan only the min times
>
> You're not getting it.
>
> If I set *ONLY* max_passive_ch_time = 10 via nl80211, what will happen?
>

There is no MAX times for the software scan, so the default values
will be used ,no problem here.
The hw_scan has it's own specific default values, and it should
validate that his default min_passive_channel_time is <=
max_passive_ch_time from the user request.

The other option is to enforce usermode to define always min *and*
max, something like:
if ((info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) &&
    (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME])) {
             request->min_ch_time =
nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
             request->max_ch_time =
nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]);
    }

Although, not sure that enforcing is the correct way ?

-- 
Thanks,
Victor.
