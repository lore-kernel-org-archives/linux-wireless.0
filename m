Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:22845 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933548AbZGPXbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:31:20 -0400
Received: by an-out-0708.google.com with SMTP id d40so603690and.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 16:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247786409.1055.7.camel@johannes.local>
References: <1247784904-805-1-git-send-email-lrodriguez@atheros.com>
	<1247786409.1055.7.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Jul 2009 16:31:00 -0700
Message-ID: <43e72e890907161631r5e3f5bf3qed04d361b1d8b843@mail.gmail.com>
Subject: Re: [RFC] cfg80211: add WoW support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 4:20 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-16 at 15:55 -0700, Luis R. Rodriguez wrote:
>
>> + * NL80211_WOW_TRIGGER_DISABLE_ALL: Disables all WoW triggers on
>> + *   the device.
>
> I don't understand the need for this. How is that different from
> userspace passing a 0 value for the attribute?

That's fine as well.

>> +     triggers_requested =
>> +             nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
>> +
>> +     if (triggers_requested & NL80211_WOW_TRIGGER_DISABLE_ALL) {
>> +             rdev->wow.triggers_enabled = 0;
>> +             goto out;
>> +     }
>
> I mean, what do these extra lines of code buy us?

Sure, OK, I'll just use 0.

>> +     /* We only support magic packet right now */
>> +     if (!triggers_requested ||
>> +         !(triggers_requested & NL80211_WOW_TRIGGER_MAGIC_PACKET)) {
>> +             err = -EOPNOTSUPP;
>> +             goto out;
>> +     }
>
> Oi that seems like a roundabout way of saying
>
>        if (triggers_requested & ~NL80211_WOW_TRIGGER_MAGIC_PACKET)
>                ...

:) true

>> +     mutex_lock(&rdev->devlist_mtx);
>> +     /*
>> +      * It only makes sense to enable WoW if we're associated as a STA,
>> +      * the AP should be buffering frames for us. We'll discard all frames
>> +      * and only process the frames which will trigger us on in hardware.
>> +      */
>> +     list_for_each_entry(wdev, &rdev->netdev_list, list) {
>
> I don't understand. You already have a netdev pointer from
>
>        get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
>
> why not just check the corresponding wdev for that netdev?

Well I was thinking of checking all netdevs, not just its own.

> I would store
> this netdev in the cfg80211_wow struct too, so you know on
> __cfg80211_disconnected() whether it was this netdev. And reject wow
> configuration if a wow configuration is already active for a different
> netdev?
>
> That way you can configure wow 'per netdev' but it's really only for one
> at a time.

Alright, this makes it a lot simpler, will do it this way, thanks.

  Luis
