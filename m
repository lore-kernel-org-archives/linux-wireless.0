Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58063 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaKEJSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:18:55 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so387268wgh.29
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 01:18:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VaTS+d-NJDkezN5+4b9txVrXXynMHZGxVjG08aEC2EsQ@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <1414046257-22184-3-git-send-email-arik@wizery.com> <CAB=NE6VaTS+d-NJDkezN5+4b9txVrXXynMHZGxVjG08aEC2EsQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 5 Nov 2014 11:18:39 +0200
Message-ID: <CA+XVXffu1tbsm=yqJnGXnJeg3GmfixcYRiY3SFcPKzB48C8p1A@mail.gmail.com> (sfid-20141105_101859_859469_E65E4BE8)
Subject: Re: [PATCH 2/5] cfg80211: leave invalid channels on regdomain change
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2014 at 5:16 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> +static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
>> +{
>> +       struct ieee80211_channel *ch;
>> +       struct cfg80211_chan_def chandef;
>> +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>> +       bool ret = true;
>> +
>> +       wdev_lock(wdev);
>> +
>> +       if (!wdev->netdev || !netif_running(wdev->netdev))
>> +               goto out;
>> +
>> +       switch (wdev->iftype) {
>> +       case NL80211_IFTYPE_AP:
>> +       case NL80211_IFTYPE_P2P_GO:
>> +               if (!wdev->beacon_interval)
>> +                       goto out;
>> +
>> +               ret = cfg80211_reg_can_beacon(wiphy,
>> +                                             &wdev->chandef, wdev->iftype);
>> +               break;
>> +       case NL80211_IFTYPE_STATION:
>> +       case NL80211_IFTYPE_P2P_CLIENT:
>> +               if (!wdev->current_bss ||
>> +                   !wdev->current_bss->pub.channel)
>> +                       goto out;
>> +
>> +               ch = wdev->current_bss->pub.channel;
>> +               if (rdev->ops->get_channel &&
>> +                   !rdev_get_channel(rdev, wdev, &chandef))
>> +                       ret = cfg80211_chandef_usable(wiphy, &chandef,
>> +                                                     IEEE80211_CHAN_DISABLED);
>> +               else
>> +                       ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
>> +               break;
>> +       default:
>> +               /* others not implemented for now */
>
> Looks good to me except this of course, since its a flag that will
> enable this per wiphy might as well WARN() if you really do not want
> to think about this. That means that once someone does enable this on
> a wiphy with the other type of interfaces they'll have to think about
> this, likewise one could warn if a wiphy interface is registered with
> the flag to follow this but supports a mode not handled here yet.

But I do want to support a wiphy that has other modes
(NL80211_IFTYPE_ADHOC), but I don't want people to get warnings every
time they use IBSS.
Maybe I'll rename the flag to REGULATORY_ENFORCE_AP_STA_CHANNELS?

Arik
