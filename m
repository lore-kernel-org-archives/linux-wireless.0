Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62114 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaBDL3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:29:50 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so3222449bkz.38
        for <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 03:29:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391504990.26522.34.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	<1391421529-6067-2-git-send-email-michal.kazior@tieto.com>
	<1391504990.26522.34.camel@porter.coelho.fi>
Date: Tue, 4 Feb 2014 12:29:45 +0100
Message-ID: <CA+BoTQkdorOFytjLYHC9OhxH1w=sNTTPRF7b2cSAWy8OCeBQ0A@mail.gmail.com> (sfid-20140204_122953_806480_A4525F24)
Subject: Re: [RFC 1/2] mac80211: merge STA CSA code
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2014 10:09, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
>> Managed interface channel switching code was
>> mostly redundant.
>>
>> This makes it easier to do more channel switching
>> code refactoring.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> Looks good! Just some nitpicks below (and I left the timstamp discussion
> between you and Johannes ;)
>
> [...]
>
>> @@ -3011,51 +3012,89 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>>       sdata->radar_required = sdata->csa_radar_required;
>>       err = ieee80211_vif_change_channel(sdata, &changed);
>>       mutex_unlock(&local->mtx);
>> -     if (WARN_ON(err < 0))
>> -             return;
>> +
>> +     sdata->vif.csa_active = false;
>> +
>> +     if (WARN_ON(err < 0)) {
>> +             sdata_info(sdata, "vif channel switch failed\n");
>> +             return err;
>> +     }
>
> Maybe WARN(err < 0, "vif channel switch failed\n") instead?

I don't mind :)


>> +void ieee80211_csa_disconnect(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>> +
>> +     switch (sdata->vif.type) {
>> +     case NL80211_IFTYPE_STATION:
>> +     case NL80211_IFTYPE_P2P_CLIENT:
>> +             ieee80211_queue_work(&local->hw,
>> +                                  &ifmgd->csa_connection_drop_work);
>> +             break;
>> +     default:
>> +             /* XXX: other iftypes should be halted too */
>
> Good point.  This case would suck, but we need to do something because
> the stations will think that we're on the different channel at this
> point.  But maybe instead the userspace should be notified instead of
> halting here? It could retry with a count 0, for example.

Ideally cfg80211 should be the one stopping interfaces. This way you'd
get AP stopped event (recently done by Johannes) and userspace can do
something about (e.g. re-start APs from scratch).


>> -int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>> -                          struct cfg80211_csa_settings *params)
>> +int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
>> +                            struct cfg80211_csa_settings *params)
>
> Why did you have to split this function? All cases where you call
> __ieee80211_channel_switch() you lock->call->unlock anyway.

It was shorter. The function does a bunch of return's so I'd have to
do err+goto. Since it asserts sdata lock is held I decided to assert
chanctx_mtx is held as well and lock the thing from call sites.


>> @@ -998,6 +944,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>>       if (res)
>>               return;
>>
>> +     /* FIXME: This check should be moved to cfg80211 */
>
> This is not really related to this patch.
>
>
>>       if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
>>                                    IEEE80211_CHAN_DISABLED)) {
>>               sdata_info(sdata,

Ideally mac80211 shouldn't be the one checking that - it should be
cfg80211, shouldn't it?


>>  static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
>> @@ -1758,6 +1690,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>>       del_timer_sync(&sdata->u.mgd.timer);
>>       del_timer_sync(&sdata->u.mgd.chswitch_timer);
>>
>> +     sdata->vif.csa_active = false;
>>       sdata->vif.bss_conf.dtim_period = 0;
>>       sdata->vif.bss_conf.beacon_rate = NULL;
>
> This is also not directly related.  It's actually a bug fix for the
> existing code, isn't it?

Good point.


>
>
> [...]
>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 8b32a1f..28ab3a9 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -11240,7 +11240,9 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
>>       if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
>>                   wdev->iftype != NL80211_IFTYPE_P2P_GO &&
>>                   wdev->iftype != NL80211_IFTYPE_ADHOC &&
>> -                 wdev->iftype != NL80211_IFTYPE_MESH_POINT))
>> +                 wdev->iftype != NL80211_IFTYPE_MESH_POINT &&
>> +                 wdev->iftype != NL80211_IFTYPE_STATION &&
>> +                 wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
>>               return;
>
> You should update the NL80211_CMD_CH_SWITCH_NOTIFY documentation in
> nl80211.h.

Good point. Thanks!


Michał
