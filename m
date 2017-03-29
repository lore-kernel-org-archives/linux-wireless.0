Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50450 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdC2PfQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 11:35:16 -0400
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
 <1490776922.7948.9.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com> (sfid-20170329_173559_217632_52F85C57)
Date: Wed, 29 Mar 2017 08:35:14 -0700
MIME-Version: 1.0
In-Reply-To: <1490776922.7948.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2017 01:42 AM, Johannes Berg wrote:
>
>> +	if (data->center_freq2)
>> +		if (nla_put_u32(skb, HWSIM_ATTR_CENTER_FREQ2, data-
>>> center_freq2))
>> +			goto nla_put_failure;
>>
>
> That could be simplified (but isn't really interesting)
>
>> + * @HWSIM_ATTR_CENTER_FREQ2: Configured center-freq-2.  Not reported
>> if value is zero.
>
> The value 0 really just means "unused" - so this should say "if used"
> or so.
>
>> + * @HWSIM_ATTR_CH_WIDTH: Configured channel width.
>
> That should point to &enum nl80211_chan_width I guess.
>
> Anyway, all of that is minor. The biggest problem I have with this
> patch upon close review is that it only handles one case, and actually
> ties that case to the nl80211 API.
>
> hwsim also can deal with channel contexts already, is there much point
> in making the userspace API ignorant of that?

The patch appeared to solve my problem, and it seems an improvement
over what is there currently.  Whoever wants it to support even more things
can add that in the future?

If you remember, the first iteration of my patch had the NL API defines
more general, so that someone could just add more data members
as the needs grew.  It can still grow, however.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
