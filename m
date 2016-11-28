Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34721 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933012AbcK1P3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 10:29:54 -0500
Received: by mail-io0-f195.google.com with SMTP id r94so23300823ioe.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 07:29:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480344479.8107.60.camel@sipsolutions.net>
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
 <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com> <1480344479.8107.60.camel@sipsolutions.net>
From: Andrew Zaborowski <balrogg@googlemail.com>
Date: Mon, 28 Nov 2016 16:29:52 +0100
Message-ID: <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com> (sfid-20161128_162958_103650_4E817CC7)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 28 November 2016 at 15:47, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> + * @set_cqm_rssi_range_config: Configure two RSSI thresholds in the
>> > + * connection quality monitor.  Even if the driver implements both the
>> > + * single threshold and low/high thresholds mechanisms, it should assume
>> + *   only one is active at any time.
>
> Why would a driver still (be allowed to!) implement both?

In order to keep the hardware offload feature when working with
hardware that can only offload the old single-thresholds method, but
where the kernel also wants to support the new method by looking at
all the beacons in software.  IIRC I identified just one driver that
would be in this situation: wl1271.

This is a specific case and the semantics implemented by the wl1271
may be a little different from those in the rest of the drivers so
this may be worth very little.  I can change the comment to imply only
one method should be implemented.

>
>> +     int     (*set_cqm_rssi_range_config)(struct wiphy *wiphy,
>> +                                          struct net_device *dev,
>> +                                          s32 rssi_low, s32 rssi_high);
>
> Seems there still should be a hysteresis? Or am I misunderstanding the
> intent here? I.e. isn't it meant to report low/medium/high later?

This isn't exposed directly to users, instead it's used by the code in
nl80211.c which will always reset the thresholds when either threshold
is crossed.  The hysteresis can then be either handled in nl80211.c
(factored into the threshold values) or in the firmware/driver, this
won't change the number of wakeups.

It's probably easier to do it in one place and keep it simple on the drivers?

>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 33026e1..7da1056 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>
> I'd prefer you split cfg80211 and mac80211 patches, i.e. provide the
> new API first and then implement it in mac80211 separately.

Yes, will do, only as this is purely an RFC I preferred to keep the
conext together.

>
>> +void cfg80211_cqm_config_free(struct wireless_dev *wdev)
>> +{
>> +     if (!wdev->cqm_config)
>> +             return;
>> +
>> +     kfree(wdev->cqm_config->rssi_thresholds);
>> +     kfree(wdev->cqm_config);
>> +     wdev->cqm_config = NULL;
>> +}
>
> You can save this complexity by just making the cqm_config struct have
> all the thresholds inside itself - pretty easy to allocate by just
> counting them first.

Ok, guess I can do that and let last_rssi_event_value get reset when
the thresholds are reconfigured.

Best regards
