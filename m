Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:34968 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYDAHjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 03:39:21 -0400
Message-ID: <47F1E6A4.4030008@work.ksp.sk> (sfid-20080401_083926_864855_A1725DFC)
Date: Tue, 01 Apr 2008 09:39:16 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 2/2] mac80211: use short_preamble mode from capability
 if ERP IE not present
References: <47F0FDA6.3000609@work.ksp.sk> <1ba2fa240803312249v233086dcp88c4edeb66540562@mail.gmail.com>
In-Reply-To: <1ba2fa240803312249v233086dcp88c4edeb66540562@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Mon, Mar 31, 2008 at 6:05 PM, Vladimir Koutny <vlado@work.ksp.sk> wrote:
>> When associating to a b-only AP where there is no ERP IE, short preamble
>>  mode is left at previous state (probably also protection mode). In this
>>  case, disable protection and use short preamble mode as specified in
>>  capability field. The same is done if capability field is changed on-the-fly.
>>
> 
> Not sure that capability information elements can change on the fly.

Not sure about short_preamble field either, but ie. short_slot_time does
change (btw. this is not handled by mac80211 at all, so the driver has to
decode it itself).


> I've posted patch that passes the whole capability upon association to
> driver and driver can choose whether short preabmle MIGHT by used or
> not.
> AP my force stations to move to long preamble by issuing ERP IE.
> 
> So I think this patch is redunant.

Still, the issue is that bss_conf->use_short_preamble contains wrong
value when associating to non-erp AP. So even with your patch, the driver
can't decide which preamble mode to use - ERP IE has higher priority than
capability field, but the driver can't tell from bss_conf if the ERP-based
values are valid or not.

Regards,
 Vlado

> 
> 
>>  Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
>>
>>  ---
>>  diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
>>  index 6fb179a..2b49852 100644
>>  --- a/net/mac80211/ieee80211_sta.c
>>  +++ b/net/mac80211/ieee80211_sta.c
>>  @@ -353,14 +353,12 @@ static void ieee80211_sta_wmm_params(struct net_device *dev,
>>         }
>>   }
>>
>>  -
>>  -static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>>  -                                  u8 erp_value)
>>  +static u32 ieee80211_handle_protect_preamb(struct ieee80211_sub_if_data *sdata,
>>  +                                          bool use_protection,
>>  +                                          bool use_short_preamble)
>>   {
>>         struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
>>         struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>>  -       bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
>>  -       bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
>>         DECLARE_MAC_BUF(mac);
>>         u32 changed = 0;
>>
>>  @@ -391,6 +389,32 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>>         return changed;
>>   }
>>
>>  +static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>>  +                                  u8 erp_value)
>>  +{
>>  +       bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
>>  +       bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
>>  +
>>  +       return ieee80211_handle_protect_preamb(sdata,
>>  +                       use_protection, use_short_preamble);
>>  +}
>>  +
>>  +static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
>>  +                                          struct ieee80211_sta_bss *bss)
>>  +{
>>  +       u32 changed = 0;
>>  +
>>  +       if (bss->has_erp_value)
>>  +               changed |= ieee80211_handle_erp_ie(sdata, bss->erp_value);
>>  +       else {
>>  +               u16 capab = bss->capability;
>>  +               changed |= ieee80211_handle_protect_preamb(sdata, false,
>>  +                               (capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
>>  +       }
>>  +
>>  +       return changed;
>>  +}
>>  +
>>   int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
>>                                    struct ieee80211_ht_info *ht_info)
>>   {
>>  @@ -509,9 +533,7 @@ static void ieee80211_set_associated(struct net_device *dev,
>>                                            local->hw.conf.channel->center_freq,
>>                                            ifsta->ssid, ifsta->ssid_len);
>>                 if (bss) {
>>  -                       if (bss->has_erp_value)
>>  -                               changed |= ieee80211_handle_erp_ie(
>>  -                                               sdata, bss->erp_value);
>>  +                       changed |= ieee80211_handle_bss_capability(sdata, bss);
>>                         ieee80211_rx_bss_put(dev, bss);
>>                 }
>>
>>  @@ -2756,6 +2778,11 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
>>
>>         if (elems.erp_info && elems.erp_info_len >= 1)
>>                 changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
>>  +       else {
>>  +               u16 capab = le16_to_cpu(mgmt->u.beacon.capab_info);
>>  +               changed |= ieee80211_handle_protect_preamb(sdata, false,
>>  +                               (capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
>>  +       }
>>
>>         if (elems.ht_cap_elem && elems.ht_info_elem &&
>>             elems.wmm_param && local->ops->conf_ht &&
>>  --
>>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>  the body of a message to majordomo@vger.kernel.org
>>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

