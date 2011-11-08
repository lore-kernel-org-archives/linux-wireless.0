Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56893 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1KHPmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:42:16 -0500
Received: by iage36 with SMTP id e36so654138iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 07:42:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320766054.24797.2.camel@jlt3.sipsolutions.net>
References: <1320759419-20743-1-git-send-email-eliad@wizery.com>
	<1320766054.24797.2.camel@jlt3.sipsolutions.net>
Date: Tue, 8 Nov 2011 17:42:15 +0200
Message-ID: <CAB3XZEcGPTzvnTg7DtG8q0E3pGT8KH+tozaO4ZtMGHyQNks_8A@mail.gmail.com> (sfid-20111108_164221_895098_B514E92C)
Subject: Re: [PATCH] mac80211: set carrier_on for ibss vifs only while joined
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 5:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-08 at 15:36 +0200, Eliad Peller wrote:
>> mac80211 should set carrier_on for ibss vifs
>> only while they are joined (similar to sta vifs)
>
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -97,6 +97,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>       /* if merging, indicate to driver that we leave the old IBSS */
>>       if (sdata->vif.bss_conf.ibss_joined) {
>>               sdata->vif.bss_conf.ibss_joined = false;
>> +             netif_carrier_off(sdata->dev);
>>               ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
>>       }
>>
>> @@ -207,6 +208,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>       bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
>>                                       mgmt, skb->len, 0, GFP_KERNEL);
>>       cfg80211_put_bss(bss);
>> +     netif_carrier_on(sdata->dev);
>>       cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
>
> Do we really need to toggle the carrier here? While we merge, shouldn't
> we just keep it up, just maybe stop the queues?
>
technically, we leave the ibss and then rejoin (unlike roaming). so i
guess setting the carrier on/off makes sense as well.
do you prefer stopping the queues instead?

Eliad.
