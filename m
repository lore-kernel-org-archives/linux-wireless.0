Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33506 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1JMKmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 06:42:05 -0400
Received: by qadb15 with SMTP id b15so1307288qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 03:42:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318407677.3933.18.camel@jlt3.sipsolutions.net>
References: <op.v27rulkhya27un@edmitar>
	<1318407677.3933.18.camel@jlt3.sipsolutions.net>
Date: Thu, 13 Oct 2011 12:42:04 +0200
Message-ID: <CAFED-jk8xp62A8cyR1qbbFzfM1AJRMUzGQ1Z3b4pDGdBPWYOrw@mail.gmail.com> (sfid-20111013_124217_324427_C03D68A6)
Subject: Re: [RFC 02/07] compat-wireless: Connection quality monitor extensions
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

Generally we deliver this patch because is usefull in roaming cases.
Speed up roaming when beacon miss will be detected (without
disconnection in upper layer).
Some questions below.

2011/10/12 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2011-10-12 at 03:02 +0200, Dmitry Tarnyagin wrote:
>
>> added:
>> * beacon miss threshold - This value specifies the threshold
>>    for the BEACON loss level
>> * tx fail - This value specifies the threshold for the TX loss level
>
> That's a bit short for a changelog for such a big patch. The patch might
> stand to be split up into two and be explained better.
>
> Also, as Julian pointed out -- get your compat vs. wireless tree in
> order. You don't want to be modifying the compat repository, it's even
> impossible, you need to be submitting patches against wireless-next or
> -testing. You also need to make sure they apply against those trees,
> which this patch obviously can't:
>
>
>>   include/linux/compat-3.0.h |    2 +
>
> as you can see easily :)
>
>> +++ b/include/linux/nl80211.h
>> @@ -2311,6 +2311,14 @@ enum nl80211_ps_state {
>>    * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
>>    * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
>>    *  consecutive packets were not acknowledged by the peer
>> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD: BEACON threshold. This value
>> specifies
>> + *   the threshold for the BEACON loss level at which an event will be
>> + *   sent. Zero to disable.
>
> Should it really be zero to disable rather than leaving it out to
> disable?

Similar like in case of NL80211_ATTR_CQM_RSSI_
Usefull to disable in run-time also - when associated.

>
>> + * @NL80211_ATTR_CQM_BEACON_MISS_THOLD_EVENT: BEACON miss event
>> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD: TX threshold. This value specifies the
>> + *   the threshold for the TX loss level at which an event will be
>> + *   sent. Zero to disable.
>> + * @NL80211_ATTR_CQM_TX_FAIL_THOLD_EVENT: TX threshold event
>
> How's this not the same as PKT_LOSS_EVENT?

Based on supplicant code - this is mapped to EVENT_STATION_LOW_ACK.
Seems used only in case we are GO/AP and not configurable from user space.
I think possible to reuse PKT_LOSS_EVENT.
But still new HW_FLAGS is required for that and counter configuration
from user space could be usefull.


>
> Some advertising for whether this is supported or not is necessary.
>
>> +++ b/include/net/mac80211.h
>
> Again a fairly complex patch modifying both cfg80211 and mac80211 -- not
> good. Keep in mind that there are in fact drivers not using mac80211.
>
>> @@ -244,6 +244,10 @@ enum ieee80211_rssi_event {
>>    * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero
>> value
>>    *  implies disabled
>>    * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
>> + * @cqm_beacon_miss_thold: Connection quality monitor beacon threshold, a
>> zero
>> + *   value implies disabled
>> + * @cqm_tx_fail_thold: Connection quality monitor tx threshold, a zero
>> value
>> + *   implies disabled
>
> Your line-wrapping makes this hard to read :(
>
>> +++ b/net/mac80211/cfg.c
>> @@ -1751,6 +1751,58 @@ static int ieee80211_set_cqm_rssi_config(struct
>> wiphy *wiphy,
>>       return 0;
>>   }
>>
>> +static int ieee80211_set_cqm_beacon_miss_config(struct wiphy *wiphy,
>> +                                             struct net_device *dev,
>> +                                             u32 beacon_thold)
>> +{
>> +     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +     struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +     struct ieee80211_vif *vif = &sdata->vif;
>> +     struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
>> +
>> +     if (beacon_thold == bss_conf->cqm_beacon_miss_thold)
>> +             return 0;
>> +
>> +     bss_conf->cqm_beacon_miss_thold = beacon_thold;
>> +
>> +     if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS)) {
>> +             if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> +                     return -EOPNOTSUPP;
>> +             return 0;
>
> This looks/is wrong in multiple ways.


Could you add more description here - this is almost the same like
ieee80211_set_cqm_rssi_config() fuction.

>
>> +++ b/net/mac80211/mlme.c
>> @@ -2174,7 +2174,10 @@ void ieee80211_sta_work(struct
>> ieee80211_sub_if_data *sdata)
>>                                   ifmgd->probe_send_count, max_tries);
>>   #endif
>>                       ieee80211_mgd_probe_ap_send(sdata);
>> -             } else {
>> +             } else if (!(local->hw.flags &
>> +                             IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS) &&
>> +                        !(local->hw.flags &
>> +                             IEEE80211_HW_SUPPORTS_CQM_TX_FAIL)) {
>>                       /*
>>                        * We actually lost the connection ... or did we?
>>                        * Let's make sure!
>
> explain.

In case of BEACON_MISS we should not report connection_loss to upper
layer, we should only notify about beacon_miss and give a chance to
roam without disconnection. Without that first we will see
disconnection in wpa_supplicant. Next if roam will fail and driver
support IEEE80211_HW_SUPPORTS_CQM_BEACON_MISS should report this
connection_lost by itself via ieee80211_connection_loss().



>
>> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
>> index 21fc970..4194b3e 100644
>> --- a/net/wireless/mlme.c
>> +++ b/net/wireless/mlme.c
>> @@ -1097,6 +1097,7 @@ void cfg80211_gtk_rekey_notify(struct net_device
>> *dev, const u8 *bssid,
>>   }
>>   EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
>>
>> +
>>   void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
>
> spurious whitespace change
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


BR
Janusz
