Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:47533 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaAVGgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:36:20 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so4309219eaj.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:36:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390319550.6199.59.camel@jlt4.sipsolutions.net>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	<1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	<1390319550.6199.59.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 07:36:18 +0100
Message-ID: <CA+BoTQ=sWMSN5NveRf0aw98mMYWks2eXKWzZvk4NZgGLOctuQQ@mail.gmail.com> (sfid-20140122_073624_359003_A16909B4)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2014 16:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-20 at 15:09 +0100, Michal Kazior wrote:
>
>> @@ -2583,6 +2588,7 @@ enum wiphy_flags {
>>       WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL        = BIT(21),
>>       WIPHY_FLAG_SUPPORTS_5_10_MHZ            = BIT(22),
>>       WIPHY_FLAG_HAS_CHANNEL_SWITCH           = BIT(23),
>> +     WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH        = BIT(24),
>>  };
>
> You could probably use an nl80211 feature flag directly, see e.g.
> NL80211_FEATURE_HT_IBSS (enum nl80211_feature_flags) and save the code
> to set the extra flag attribute.
>
>> + * @NL80211_ATTR_CH_SWITCH_IFACES: Nested attribute with channel switch
>> + *   settings in each entry (ifindex, frequency, beacon IEs). Also used as a
>> + *   device capability flag in nl80211_send_wiphy().
>
> Which would obviously change this.
>
>> +int ieee80211_channel_switch(struct wiphy *wiphy,
>> +                          struct cfg80211_csa_settings *params,
>> +                          int num_params)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     int err;
>> +
>> +     /* multi-vif CSA is not implemented */
>> +     if (num_params > 1)
>> +             return -EOPNOTSUPP;
>
> The capability flag should be checked in cfg80211, so this shouldn't be
> needed?

Okay.


>> +int ieee80211_channel_switch(struct wiphy *wiphy,
>> +                          struct cfg80211_csa_settings *params,
>> +                          int num_params);
>
> This function can be static now as the other places call the __ version
> now. Careful with locking though - you just moved it as well, won't the
> callers have to be updated?

Good point. I'll make it static.

ieee80211_channel_switch() was always called with the assumption
wdev->mtx is held. Only cfg80211_channel_switch() caller is changed
wrt to locking of wdev->mtx (since you can't take a bunch of wdev
locks just like that..). That's why other callers use __ version now.


>> +     /* static variables avoid waste of stack size - this
>>        * function is called under RTNL lock, so this should not be a problem.
>>        */
>>       static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
>
> Technically we could even just reuse family->attrs since we're also
> under genl_lock :)
>
>> -     u8 radar_detect_width = 0;
>> +     struct net_device *dev = NULL;
>> +     struct wireless_dev *wdev;
>>       int err;
>>       bool need_new_beacon = false;
>>
>> -     if (!rdev->ops->channel_switch ||
>> -         !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
>> -             return -EOPNOTSUPP;
>> +     ASSERT_RTNL();
>> +
>> +     if (!attrs[NL80211_ATTR_IFINDEX])
>> +             return -EINVAL;
>
> Hmm, shouldn't you use the ifindex from the csa_attrs? Or are you
> requiring one to be in the outer data to identify the wiphy? But that
> seems odd too, you can just get the wiphy in whatever way by asking the
> pre_doit for that?

I'm not sure I understand you.

There are two command variants now:

1: the old one, which has ifindex in the root
2: the new one, which has wiphy in the root, and an array of (1)
within CH_SWITCH_IFACES (and each entry has ifindex at its root)


>> +             nla_for_each_nested(attrs,
>> +                                 info->attrs[NL80211_ATTR_CH_SWITCH_IFACES],
>> +                                 tmp) {
>> +                     nla_parse(csa_attrs, NL80211_ATTR_MAX, nla_data(attrs),
>> +                               nla_len(attrs), nl80211_policy);
>
> I think nla_parse() can fail, you should check that, otherwise there's
> no full validity checking of the attributes contained in it I believe.

Good point. I'll fix that.


Michał
