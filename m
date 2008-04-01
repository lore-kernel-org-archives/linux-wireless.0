Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:49165 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYDAFtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 01:49:24 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2065916wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 22:49:22 -0700 (PDT)
Message-ID: <1ba2fa240803312249v233086dcp88c4edeb66540562@mail.gmail.com> (sfid-20080401_064928_388241_7B3D1705)
Date: Tue, 1 Apr 2008 08:49:20 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vladimir Koutny" <vlado@work.ksp.sk>
Subject: Re: [PATCH 2/2] mac80211: use short_preamble mode from capability if ERP IE not present
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <47F0FDA6.3000609@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47F0FDA6.3000609@work.ksp.sk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 31, 2008 at 6:05 PM, Vladimir Koutny <vlado@work.ksp.sk> wrote:
> When associating to a b-only AP where there is no ERP IE, short preamble
>  mode is left at previous state (probably also protection mode). In this
>  case, disable protection and use short preamble mode as specified in
>  capability field. The same is done if capability field is changed on-the-fly.
>

Not sure that capability information elements can change on the fly.
I've posted patch that passes the whole capability upon association to
driver and driver can choose whether short preabmle MIGHT by used or
not.
AP my force stations to move to long preamble by issuing ERP IE.

So I think this patch is redunant.


>  Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
>
>  ---
>  diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
>  index 6fb179a..2b49852 100644
>  --- a/net/mac80211/ieee80211_sta.c
>  +++ b/net/mac80211/ieee80211_sta.c
>  @@ -353,14 +353,12 @@ static void ieee80211_sta_wmm_params(struct net_device *dev,
>         }
>   }
>
>  -
>  -static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>  -                                  u8 erp_value)
>  +static u32 ieee80211_handle_protect_preamb(struct ieee80211_sub_if_data *sdata,
>  +                                          bool use_protection,
>  +                                          bool use_short_preamble)
>   {
>         struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
>         struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>  -       bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
>  -       bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
>         DECLARE_MAC_BUF(mac);
>         u32 changed = 0;
>
>  @@ -391,6 +389,32 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>         return changed;
>   }
>
>  +static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>  +                                  u8 erp_value)
>  +{
>  +       bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
>  +       bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
>  +
>  +       return ieee80211_handle_protect_preamb(sdata,
>  +                       use_protection, use_short_preamble);
>  +}
>  +
>  +static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
>  +                                          struct ieee80211_sta_bss *bss)
>  +{
>  +       u32 changed = 0;
>  +
>  +       if (bss->has_erp_value)
>  +               changed |= ieee80211_handle_erp_ie(sdata, bss->erp_value);
>  +       else {
>  +               u16 capab = bss->capability;
>  +               changed |= ieee80211_handle_protect_preamb(sdata, false,
>  +                               (capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
>  +       }
>  +
>  +       return changed;
>  +}
>  +
>   int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
>                                    struct ieee80211_ht_info *ht_info)
>   {
>  @@ -509,9 +533,7 @@ static void ieee80211_set_associated(struct net_device *dev,
>                                            local->hw.conf.channel->center_freq,
>                                            ifsta->ssid, ifsta->ssid_len);
>                 if (bss) {
>  -                       if (bss->has_erp_value)
>  -                               changed |= ieee80211_handle_erp_ie(
>  -                                               sdata, bss->erp_value);
>  +                       changed |= ieee80211_handle_bss_capability(sdata, bss);
>                         ieee80211_rx_bss_put(dev, bss);
>                 }
>
>  @@ -2756,6 +2778,11 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
>
>         if (elems.erp_info && elems.erp_info_len >= 1)
>                 changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
>  +       else {
>  +               u16 capab = le16_to_cpu(mgmt->u.beacon.capab_info);
>  +               changed |= ieee80211_handle_protect_preamb(sdata, false,
>  +                               (capab & WLAN_CAPABILITY_SHORT_PREAMBLE) != 0);
>  +       }
>
>         if (elems.ht_cap_elem && elems.ht_info_elem &&
>             elems.wmm_param && local->ops->conf_ht &&
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
