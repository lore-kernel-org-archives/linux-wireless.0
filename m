Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47014 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYL3PIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 10:08:18 -0500
Received: by bwz14 with SMTP id 14so17414033bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 07:08:15 -0800 (PST)
Message-ID: <1ba2fa240812300708o40717c87x13697c180be19913@mail.gmail.com> (sfid-20081230_160822_905721_F926673C)
Date: Tue, 30 Dec 2008 17:08:15 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>
Subject: Re: [RFC] mac80211: Handle power constraint level advertised in 11d+h beacon
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1230641555-13425-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1230641555-13425-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 2:52 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> This patch uses power constraint level while determining the maximum
> transmit power, there by it makes sure that any power mitigation
> requirement for the channel in the current regulatory domain is met.

> +
> +       /* TODO: for IBSS */

IIRC this particular feature of 11h is not supported in IBSS

> +       if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
> +           (ifsta->flags & IEEE80211_STA_ASSOCIATED) &&
> +           (memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) == 0) &&
> +           elems.pwr_constr_elem)
> +               ieee80211_handle_pwr_constr(sdata,
> +                               le16_to_cpu(mgmt->u.probe_resp.capab_info),
> +                               elems.pwr_constr_elem,
> +                               elems.pwr_constr_elem_len);
>  }
>
>
> @@ -1841,6 +1852,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>                        elems.country_elem, elems.country_elem_len);
>        }
>
> +       /* TODO: IBSS also needs this */
> +       if (elems.pwr_constr_elem)
> +               ieee80211_handle_pwr_constr(sdata,
> +                               le16_to_cpu(mgmt->u.probe_resp.capab_info),
> +                               elems.pwr_constr_elem,
> +                               elems.pwr_constr_elem_len);
> +
>        ieee80211_bss_info_change_notify(sdata, changed);
>  }
>
> diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
> index f72bad6..f7ffec1 100644
> --- a/net/mac80211/spectmgmt.c
> +++ b/net/mac80211/spectmgmt.c
> @@ -84,3 +84,25 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
>                        mgmt->sa, mgmt->bssid,
>                        mgmt->u.action.u.measurement.dialog_token);
>  }
> +
> +void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> +                                u16 capab_info, u8 *pwr_constr_elem,
> +                                u8 pwr_constr_elem_len)
> +{
> +       struct ieee80211_conf *conf = &sdata->local->hw.conf;
> +
> +       if ((conf->channel->band != IEEE80211_BAND_5GHZ) ||
> +           !(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
> +               return;

I think our original patch removed need of IEEE80211_BAND_5GHZ as
WLAN_CAPABILITY_SPECTRUM_MGMT
is sufficient condition.

> +       /* Power constraint IE length should be 1 octet */
> +       if (pwr_constr_elem_len != 1)
> +               return;
> +
> +       if ((*pwr_constr_elem <= conf->channel->max_power) &&
> +           (*pwr_constr_elem != conf->power_constr_level)) {

This is defined only when you receive country IE, how do you check for it?

Thanks
Tomas
