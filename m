Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62494 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3LDIb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:31:58 -0500
Received: by mail-wi0-f175.google.com with SMTP id hi5so7841322wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 00:31:58 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Dec 2013 09:31:57 +0100
Message-ID: <CADnKcViSH_VEgJH1=twMtwH+sWV6NaDx=sq359KCdmCS2EuVNw@mail.gmail.com> (sfid-20131204_093203_309404_592550E1)
Subject: Re: [PATCH v3] cfg80211: fix dfs channel state after stopping AP
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2013 15:18, Johannes Berg <johannes@sipsolutions.net> wrote:

>> +             if (cfg80211_chandef_dfs_required(wdev->wiphy, &wdev->preset_chandef))
>> +                     cfg80211_leave_dfs_chandef(wdev->wiphy, &wdev->preset_chandef);
>
> *far* too long lines. Read CodingStyle documentation please.
>
> Also, any reason to not always call cfg80211_leave_dfs_chandef()?

I had only cfg80211_leave_dfs_chandef() but then I added if() and
exceeded  80 lines.
So I will call always cfg80211_leave_dfs_chandef().

>> +static void cfg80211_leave_dfs_chans(struct wiphy *wiphy,
>> +                                  u32 center_freq,
>> +                                  u32 bandwidth)
>> +{
>> +     struct ieee80211_channel *c;
>> +     u32 freq, start_freq, end_freq;
>> +
>> +     start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
>> +     end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
>> +
>> +     for (freq = start_freq; freq <= end_freq; freq += 20) {
>> +             c = ieee80211_get_channel(wiphy, freq);
>> +             if (!c)
>> +                     continue;
>> +             if (!(c->flags & IEEE80211_CHAN_RADAR))
>> +                     continue;
>> +             if (c->dfs_state != NL80211_DFS_AVAILABLE)
>> +                     continue;
>> +
>> +             cfg80211_set_chans_dfs_state(wiphy, freq, 20, NL80211_DFS_USABLE);
>
> This seems to catch it anyway.
>
> This also seems a bit wrong, if regulatory happens to change and say the
> RADAR flag goes away, then this won't set it to USABLE, and then if the
> RADAR flag later re-appears? I guess Luis should handle that in reg.c
> though or so?

Yes, you are right. It does not matter if RADAR flag is set. When we
are leaving AP mode then none of channels should have dfs_state =
NL80211_DFS_AVAILABLE. So all DFS_AVAILABLE channel will be set to
DFS_USABLE.

I will send new version of this patch.

Concerning your question whether this patch is needed in 3.13. I think
this is rather important issue. Look at such situation:
*start AP on DFS channel,
*CAC pass - channel dfs_state changes to AVAILABLE, AP starts beaconing,
*stop AP by killing hostapd, channel dfs_state stays AVAILABLE,
*start AP again, it starts beaconig immediately, there is no CAC
beacuse channel dfs_state is AVAILABLE.

Purpose of this patch is to change channel dfs_state to USABLE when
leaving/stoping AP, so starting AP again will trigger first CAC and
after successful CAC starts beaconig.


> johannes
Marek
