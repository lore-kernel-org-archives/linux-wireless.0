Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46315 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2KTJOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:14:23 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5719428obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 01:14:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353399218.10872.152.camel@cumari.coelho.fi>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-14-git-send-email-eliad@wizery.com>
	<1353399218.10872.152.camel@cumari.coelho.fi>
Date: Tue, 20 Nov 2012 11:14:23 +0200
Message-ID: <CAB3XZEd_2LfKC=nUt3DQEtSMQLov9k0mM=_UDCvGBWT4bvJ-CA@mail.gmail.com> (sfid-20121120_101429_719711_DBCF4323)
Subject: Re: [PATCH 13/15] wlcore: reconfigure rate policy on association
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 10:13 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> When first configuring the rate policy, before auth,
>> we still don't have the correct rates that were
>> agreed during association.
>>
>> Reconfigure the rate policy on association in order
>> to update them.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/main.c |   14 +++++++++++++-
>>  1 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>> index 0dd0ec1..a1ad326 100644
>> --- a/drivers/net/wireless/ti/wlcore/main.c
>> +++ b/drivers/net/wireless/ti/wlcore/main.c
>> @@ -3771,7 +3771,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>>               wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
>>       }
>>
>> -     if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT)) {
>> +     if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT |
>> +                    BSS_CHANGED_ASSOC)) {
>>               rcu_read_lock();
>>               sta = ieee80211_find_sta(vif, bss_conf->bssid);
>>               if (!sta)
>> @@ -3958,6 +3959,17 @@ sta_not_found:
>>               if (ret < 0)
>>                       goto out;
>>
>> +             if (sta_rate_set) {
>> +                     wlvif->rate_set =
>> +                             wl1271_tx_enabled_rates_get(wl,
>> +                                                         sta_rate_set,
>> +                                                         wlvif->band);
>> +
>> +                     ret = wl1271_acx_sta_rate_policies(wl, wlvif);
>> +                     if (ret < 0)
>> +                             goto out;
>> +             }
>> +
>>               if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
>>                       wl12xx_set_authorized(wl, wlvif);
>>       }
>
> Yes, it's messy that we use the same value for vif-supported rates and
> current association negotiated rates... :(
>
yeah, we have a total mess with all the configured/supported rates.
we'll have to reorganize it at some point.

Eliad.
