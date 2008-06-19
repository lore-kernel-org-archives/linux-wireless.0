Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:45599 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYFSUQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 16:16:38 -0400
Received: by py-out-1112.google.com with SMTP id p76so411582pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 13:16:38 -0700 (PDT)
Message-ID: <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com> (sfid-20080619_221642_483217_B52CC7F4)
Date: Thu, 19 Jun 2008 23:16:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information Element
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Assaf Krauss" <assaf.krauss@intel.com>
In-Reply-To: <1213902216.8967.78.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
	 <1213902216.8967.78.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 10:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +static void ieee80211_calculate_power_level(struct ieee80211_local *local)
>> +{
>> +     struct ieee80211_channel *chan = local->hw.conf.channel;
>> +
>> +     local->hw.conf.power_level = chan->max_power;
>> +     if (local->hw.conf.user_pwr_limit)
>> +             local->hw.conf.power_level = min(local->hw.conf.user_pwr_limit,
>> +                     local->hw.conf.power_level);
>> +     if (local->hw.conf.tpc_pwr_limit)
>> +             local->hw.conf.power_level = min(local->hw.conf.tpc_pwr_limit,
>> +                     local->hw.conf.power_level);
>> +}
>> +
>>  int ieee80211_hw_config(struct ieee80211_local *local)
>>  {
>>       struct ieee80211_channel *chan;
>> @@ -1040,13 +1053,7 @@ int ieee80211_hw_config(struct ieee80211_local *local)
>>
>>       local->hw.conf.channel = chan;
>>
>> -     if (!local->hw.conf.power_level)
>> -             local->hw.conf.power_level = chan->max_power;
>> -     else
>> -             local->hw.conf.power_level = min(chan->max_power,
>> -                                            local->hw.conf.power_level);
>> -
>> -     local->hw.conf.max_antenna_gain = chan->max_antenna_gain;
>> +     ieee80211_calculate_power_level(local);
>
> Lost antenna gain setting?

Oops

>
>
>> +     if (country_ie_len < 6) {
>> +             printk(KERN_ERR "%s: country information element shorter (%d)"
>> +                     " than expected.\n", __func__, country_ie_len);
>
> Remotely exploitable security bug.
Please explain,
>
>> -     if (local->hw.conf.power_level != new_power_level) {
>> -             local->hw.conf.power_level = new_power_level;
>> +              local->hw.conf.user_pwr_limit = 0;
>
> whitespace damage.
Will fix, strange though it passed checkpatch

Thanks for review
Adding Luis with hope for some more review with connection to reg domain stuff.

Tomas
