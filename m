Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33671 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3J2Kcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 06:32:50 -0400
Received: by mail-la0-f46.google.com with SMTP id hp15so6222339lab.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 03:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W53b=uOkaVUFfKcszXPikS=ax6k_G+7Wmb7g_acpSTsA@mail.gmail.com>
References: <1383027326-2635-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6W53b=uOkaVUFfKcszXPikS=ax6k_G+7Wmb7g_acpSTsA@mail.gmail.com>
Date: Tue, 29 Oct 2013 11:32:49 +0100
Message-ID: <CALhHN=oThh7HMW5cHQmW_U0yrzN5x3+ZW6a+yd9fc8fyjcuL+w@mail.gmail.com> (sfid-20131029_113254_117101_31FA67A7)
Subject: Re: [PATCH] cfg80211: allow beaconing after CAC
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 October 2013 11:25, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Tue, Oct 29, 2013 at 7:15 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> After going throught the Channel Availability Check (CAC)
>> required by DFS enable beaconing. Channels that have gone
>> through a CAC will be in the NL80211_DFS_AVAILABLE.
>> Without this change APs don't start beaconing after
>> successful CAC.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>> One flag could be used in the future IEEE80211_CHAN_NO_IR.
>>
>>  net/wireless/chan.c |   20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index a6f5c4c..205acf2 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -432,6 +432,7 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
>>  {
>>         struct ieee80211_channel *c;
>>         u32 freq, start_freq, end_freq;
>> +       u32 ignore_flags;
>>
>>         start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
>>         end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
>> @@ -441,13 +442,24 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
>>                 if (!c)
>>                         return false;
>>
>> +               ignore_flags = IEEE80211_CHAN_RADAR;
>> +
>>                 /* check for radar flags */
>> -               if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
>> -                   (c->dfs_state != NL80211_DFS_AVAILABLE))
>> -                       return false;
>> +               if (prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) {
>> +                       if (c->dfs_state != NL80211_DFS_AVAILABLE)
>> +                               return false;
>> +                       /*
>> +                        * If DFS is required we should check only
>> +                        * c->dfs_state == NL80211_DFS_AVAILABLE and
>> +                        * ignore IEEE80211_CHAN_NO_IBSS and
>> +                        * IEEE80211_CHAN_PASSIVE_SCAN flags
>> +                        */
>> +                       ignore_flags |= IEEE80211_CHAN_NO_IBSS |
>> +                                       IEEE80211_CHAN_PASSIVE_SCAN;
>> +               }
>>
>>                 /* check for the other flags */
>> -               if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
>> +               if (c->flags & prohibited_flags & ~ignore_flags)
>>                         return false;
>>         }
>
> How do we know that prohibited_flags won't have IEEE80211_CHAN_RADAR
> or IEEE80211_CHAN_NO_IBSS set?
>
> Also why is IEEE80211_CHAN_NO_IBSS used and not IEEE80211_CHAN_NO_IR
> instead? I sent patches to help clarify this situation around usage of
> both no-ibss and active scan flags, by merging them to no-ir. I'm not
> sure of the status of those patches going in.
>

I am not sure. Even without my patch seems  IEEE80211_CHAN_RADAR is
added to prohibited_flags and have different meaning (I think).
In orginal code we have:

if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)

So, we skiping CHAN_RADAR anyway? I am not sure we should change
prohibited_flags to different name or stop skiping CHAN_RADAR and
modify upper layer - cfg80211_reg_can_beacon() in such case.

BR
Janusz
