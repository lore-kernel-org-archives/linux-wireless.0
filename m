Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48809 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2DWWfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 18:35:14 -0400
Message-ID: <4F95D921.6060104@candelatech.com> (sfid-20120424_003519_391701_3F5C15EF)
Date: Mon, 23 Apr 2012 15:35:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 3/4] mac80211: Framework to get wifi-driver stats via
 ethtool.
References: <1335210632-19958-1-git-send-email-greearb@candelatech.com> <1335210632-19958-4-git-send-email-greearb@candelatech.com> <CAB3XZEd8+YORDzCS0ZTVati9E2e05gTP5=7QLirQ=-Kus5DF+A@mail.gmail.com>
In-Reply-To: <CAB3XZEd8+YORDzCS0ZTVati9E2e05gTP5=7QLirQ=-Kus5DF+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2012 03:17 PM, Eliad Peller wrote:
> On Mon, Apr 23, 2012 at 10:50 PM,<greearb@candelatech.com>  wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This adds hooks to call into the driver to get additional
>> stats for the ethtool API.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
> [...]
>
>> @@ -463,10 +463,17 @@ static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
>>                                        struct net_device *dev,
>>                                        int sset)
>>   {
>> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +       int rv = 0;
>> +
>>         if (sset == ETH_SS_STATS)
>> -               return STA_STATS_LEN;
>> +               rv += STA_STATS_LEN;
>>
>> -       return -EOPNOTSUPP;
>> +       rv += drv_get_et_sset_count(sdata, sset);
>> +
> this is pretty confusing, because usually negative return value (e.g.
> -EINVAL) is valid, and in this case it will corrupt the total sum
> instead.

Well, in this case, you just should not return a negative value.

I can think of no reason this method should have a failure mode
if it is implemented at all, and if it does for some reason,
it can return 0.

These API are not meant to be dynamic in nature.  Effectively
the get-count method just lets you know how many strings
and stats to expect, and the numbers (and positions)
of all three should not change once the driver is loaded.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

