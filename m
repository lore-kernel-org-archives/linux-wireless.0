Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41603 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1I0VYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 17:24:52 -0400
Received: by eya28 with SMTP id 28so5123377eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 14:24:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317124553.4082.26.camel@jlt3.sipsolutions.net>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
 <1317034493-5300-5-git-send-email-arik@wizery.com> <1317124553.4082.26.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 28 Sep 2011 00:24:36 +0300
Message-ID: <CA+XVXfe99SqqSzmnuVj5FworRZD5y99kuNqynBXP+Uy678NWKQ@mail.gmail.com> (sfid-20110927_232455_805023_545E9EA0)
Subject: Re: [PATCH 4/5] nl80211/mac80211: allow adding TDLS peers as stations
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 14:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:
>
>> @@ -811,6 +817,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
>>
>>       sta_apply_parameters(local, sta, params);
>>
>> +     if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
>> +         (sta->flags & WLAN_STA_TDLS_PEER)) {
>> +             return -ENOTSUPP;
>> +     }
>
> I think this should maybe also make sure that the interface is in
> station mode? Otherwise it could get somewhat confusing. Also changes to
> the TDLS flag probably shouldn't be allowed.

Sure. I'll add some more guards.

>
> And this code might also be better in cfg80211, although this is only
> with external management, right?

There's a similar check in cfg80211 code, in nl80211_new_station().

>
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -2521,18 +2521,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
>> -             if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
>> +             if (params.sta_flags_mask &
>> +                             ~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
>> +                               BIT(NL80211_STA_FLAG_TDLS_PEER)))
>
> Why is the TDLS flag allowed to change?

I'll add some more TDLS specific guards in set_station as well.

>
>
>> +     /*
>> +      * Managed stations can only add TDLS peers, and only when the
>> +      * wiphy supports it.
>> +      */
>> +     if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_STATION &&
>> +         (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) ||
>> +          !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS)))
>>               return -EINVAL;
>
> If the device does full TDLS by itself I don't think we should be
> allowed to add/remove stations?

Fair point. I'll add a EXTERNAL_SETUP check here.

>
> Maybe you need to describe the command sequences a little bit somewhere.
> I'm getting a bad feeling about adding stations without supported rates,
> and this is only when we have external management etc.
>
> Part of your argument for having the frame sending etc. in the kernel
> was that then it's more like managed mode, but all the manual station
> handling is very much unlike that.
>
> I'm beginning to think that maybe it should be handled through the TDLS
> operations instead, more implicitly?
>

As discussed on IRC, the added station is convenient for implementing
the TDLS Tx-lock during link setup. Stations are (almost)
automatically purged when disassociating, thereby clearing TDLS state.
It's also already part of the mac80211 Tx path, so no need to add
other elements.

Adding a station with no supported rates is a bit strange, but it is
clearly flagged as a TDLS peer sta and checks are in place in the Tx
path to prevent abuse.

Arik
