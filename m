Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62037 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbAPLYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:24:22 -0500
Received: by mail-ie0-f177.google.com with SMTP id rd18so20093795iec.8
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:24:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421405364.9214.1.camel@sipsolutions.net>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	<1421405364.9214.1.camel@sipsolutions.net>
Date: Fri, 16 Jan 2015 12:24:22 +0100
Message-ID: <CALhHN=payu27bPU+G5txsFkm6N=w_FL+LA8dVZAO96bwXXqiAg@mail.gmail.com> (sfid-20150116_122426_042335_FD882BB7)
Subject: Re: [RFCv2 1/6] mac80211: ibss, fix chandef setup for HT40
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 January 2015 at 11:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
>> In some cases when used HT40+/HT40-, center_freq1
>> was configured incorrectly. Next this couse
>
> couse?
>
>> @@ -407,10 +407,15 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>       switch (sdata->u.ibss.chandef.width) {
>>       case NL80211_CHAN_WIDTH_20_NOHT:
>>       case NL80211_CHAN_WIDTH_20:
>> -     case NL80211_CHAN_WIDTH_40:
>>               chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
>>               cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
>>               break;
>
> Sorry, I don't see the bug. "Sometimes"?
>
> cfg80211_get_chandef_type() will return HT40+/- correctly according to
> the chandef, and then you'll use it again to create the chandef - should be OK.
>
>> +       case NL80211_CHAN_WIDTH_40:
>> +               cfg80211_chandef_create(&chandef, cbss->channel,
>> +                                       NL80211_CHAN_WIDTH_20_NOHT);
>> +               chandef.width = sdata->u.ibss.chandef.width;
>> +               chandef.center_freq1 =
>> sdata->u.ibss.chandef.center_freq1;
>> +               break;
>
> Please don't mix chantype stuff and chandef stuff ... just create the
> chandef manually if you must. I really think the code above should have
> worked though, unless it's using the wrong inputs somehow.
>
This is scenario:

1) first ibss HT20 run on 5180
2) second ibss configured HT40+ using 36 channel
3) supplicant detect OBSS and decide to switch 40 and HT40-
4) this code confgure chandef->center_freq1 = 5170
5) reg_can_beacon() then fail and we fall back to NOHT_20

So, with patch we will configure center_freq1 connectly and could work
using HT40, no matter we will configure primary/secondary channel as a
control one.
So, we could have same problems when VHT80 will be used - different
control channels configured. With patch even we have different control
channel configured, will fix this and could connect correctly. I am
not sure this is best option here but allow to work.

BR
Janusz
