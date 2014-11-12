Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:41265 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaKLWxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 17:53:52 -0500
Received: by mail-la0-f51.google.com with SMTP id q1so12274018lam.38
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 14:53:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffu1tbsm=yqJnGXnJeg3GmfixcYRiY3SFcPKzB48C8p1A@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <1414046257-22184-3-git-send-email-arik@wizery.com> <CAB=NE6VaTS+d-NJDkezN5+4b9txVrXXynMHZGxVjG08aEC2EsQ@mail.gmail.com>
 <CA+XVXffu1tbsm=yqJnGXnJeg3GmfixcYRiY3SFcPKzB48C8p1A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 12 Nov 2014 14:53:30 -0800
Message-ID: <CAB=NE6VXSba1=bntediLrnh+T90fBPs_U75GmtaE2XvBQF-KSA@mail.gmail.com> (sfid-20141112_235355_280959_1B4A0AA0)
Subject: Re: [PATCH 2/5] cfg80211: leave invalid channels on regdomain change
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2014 at 1:18 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Nov 5, 2014 at 5:16 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> +static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
>>> +{
>>> +       struct ieee80211_channel *ch;
>>> +       struct cfg80211_chan_def chandef;
>>> +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>>> +       bool ret = true;
>>> +
>>> +       wdev_lock(wdev);
>>> +
>>> +       if (!wdev->netdev || !netif_running(wdev->netdev))
>>> +               goto out;
>>> +
>>> +       switch (wdev->iftype) {
>>> +       case NL80211_IFTYPE_AP:
>>> +       case NL80211_IFTYPE_P2P_GO:
>>> +               if (!wdev->beacon_interval)
>>> +                       goto out;
>>> +
>>> +               ret = cfg80211_reg_can_beacon(wiphy,
>>> +                                             &wdev->chandef, wdev->iftype);
>>> +               break;
>>> +       case NL80211_IFTYPE_STATION:
>>> +       case NL80211_IFTYPE_P2P_CLIENT:
>>> +               if (!wdev->current_bss ||
>>> +                   !wdev->current_bss->pub.channel)
>>> +                       goto out;
>>> +
>>> +               ch = wdev->current_bss->pub.channel;
>>> +               if (rdev->ops->get_channel &&
>>> +                   !rdev_get_channel(rdev, wdev, &chandef))
>>> +                       ret = cfg80211_chandef_usable(wiphy, &chandef,
>>> +                                                     IEEE80211_CHAN_DISABLED);
>>> +               else
>>> +                       ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
>>> +               break;
>>> +       default:
>>> +               /* others not implemented for now */
>>
>> Looks good to me except this of course, since its a flag that will
>> enable this per wiphy might as well WARN() if you really do not want
>> to think about this. That means that once someone does enable this on
>> a wiphy with the other type of interfaces they'll have to think about
>> this, likewise one could warn if a wiphy interface is registered with
>> the flag to follow this but supports a mode not handled here yet.
>
> But I do want to support a wiphy that has other modes
> (NL80211_IFTYPE_ADHOC), but I don't want people to get warnings every
> time they use IBSS.
> Maybe I'll rename the flag to REGULATORY_ENFORCE_AP_STA_CHANNELS?

Then it depends on how important this feature is for your regulatory
requirements. If its important then I'd wait until its properly
implemented, if its not required for the other modes then a simple
information message would suffice.

 Luis
