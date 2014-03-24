Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46975 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaCXOCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 10:02:22 -0400
Received: by mail-oa0-f52.google.com with SMTP id l6so5859073oag.11
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 07:02:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395669396.4515.62.camel@dubbel>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-4-git-send-email-michal.kazior@tieto.com>
	<1395669396.4515.62.camel@dubbel>
Date: Mon, 24 Mar 2014 15:02:21 +0100
Message-ID: <CA+BoTQ=G=fXBiQ7cGi2KT2B3RP9_9_AW-mL0-ucUYCK0OYUOHQ@mail.gmail.com> (sfid-20140324_150234_129636_0E81E8B4)
Subject: Re: [PATCH v2 3/4] cfg80211: export interface stopping function
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 14:56, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
>> This exports a new cfg80211_stop_iface() function.
>>
>> This is intended for driver internal interface
>> combination management and channel switching.
>>
>> Due to locking issues (it re-enters driver) the
>> call is asynchronous and uses cfg80211 event
>> list/worker.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> Looks good to me, with a couple of nitpicks.
>
> [...]
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 2f28ac4..7f0cbfb 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -4705,6 +4705,21 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
>>                               const u8 radar_detect,
>>                               const int iftype_num[NUM_NL80211_IFTYPES]);
>>
>> +/*
>> + * cfg80211_stop_iface - stop given interface
>> + *
>> + * @wiphy: the wiphy
>> + * @wdev: wireless device
>> + *
>> + * Stop interface as if AP was stopped, IBSS/mesh left, STA disconnected.
>
> This is not very clear.  Maybe you should say that this allows the
> driver to _trigger_ an interface to be stopped, so that it's clear that
> all the stopping flow will take place.

Yeah, it's async so "trigger" makes more sense.


>> + *
>> + * This is intended for channel switching and internal driver interface
>> + * combination management.
>
> Not sure you need to say when this is needed.  The driver could call it
> for any internal reason.

I'll remove this sentence then unless someone has an objection? :-)


> [...]
>> @@ -789,6 +788,37 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
>>       wdev->beacon_interval = 0;
>>  }
>>
>> +void cfg80211_leave(struct cfg80211_registered_device *rdev,
>> +                 struct wireless_dev *wdev)
>> +{
>> +     ASSERT_RTNL();
>> +
>> +     wdev_lock(wdev);
>> +     __cfg80211_leave(rdev, wdev);
>> +     wdev_unlock(wdev);
>> +}
>> +
>> +void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
>> +{
>> +     struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
>> +     struct cfg80211_event *ev;
>> +     unsigned long flags;
>> +
>> +     trace_cfg80211_stop_iface(wiphy, wdev);
>> +
>> +     ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
>
> Is there any reason why you don't pass the GFP type to this function, as
> in all other functions that allow the driver to queue events?

Not really. I'll add the argument.


Michał
