Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57905 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYL3NFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 08:05:00 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 05:05:00 -0800
Date: Tue, 30 Dec 2008 18:23:10 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Handle power constraint level advertised in
	11d+h beacon
Message-ID: <20081230125309.GA9080@localhost.localdomain> (sfid-20081230_140504_717286_FAA9522D)
References: <1230641555-13425-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1230641555-13425-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 06:22:35PM +0530, Vasanth Thiagarajan wrote:
> This patch uses power constraint level while determining the maximum
> transmit power, there by it makes sure that any power mitigation
> requirement for the channel in the current regulatory domain is met.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  include/net/mac80211.h     |    2 ++
>  net/mac80211/ieee80211_i.h |    3 +++
>  net/mac80211/main.c        |   10 ++++++++--
>  net/mac80211/mlme.c        |   20 +++++++++++++++++++-
>  net/mac80211/spectmgmt.c   |   22 ++++++++++++++++++++++
>  5 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 153a8d1..a1126d3 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -549,6 +549,7 @@ enum ieee80211_conf_changed {
>   * @flags: configuration flags defined above
>   * @power_level: requested transmit power (in dBm)
>   * @user_power_level: User configured transmit power (in dBm)
> + * @power_constr_level: Power constraint level advertised in 11h beacon (in dBm)
>   * @channel: the channel to tune to
>   * @ht: the HT configuration for the device
>   * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
> @@ -563,6 +564,7 @@ struct ieee80211_conf {
>         u32 flags;
>         int power_level;
>         int user_power_level;
> +       int power_constr_level;
> 
>         u16 listen_interval;
>         bool radio_enabled;
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 117718b..1abe96e 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -964,6 +964,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
>  void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
>                                        struct ieee80211_mgmt *mgmt,
>                                        size_t len);
> +void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> +                                u16 capab_info, u8 *pwr_constr_elem,
> +                                u8 pwr_constr_elem_len);
> 
>  /* utility functions/constants */
>  extern void *mac80211_wiphy_privid; /* for wiphy privid */
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 8831e87..66108f6 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -224,10 +224,16 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>                 changed |= IEEE80211_CONF_CHANGE_CHANNEL;
>         }
> 
> -       if (!local->hw.conf.user_power_level)
> +       if (local->sw_scanning)
>                 power = chan->max_power;
>         else
> -               power = min(chan->max_power, local->hw.conf.user_power_level);
> +               power = local->hw.conf.power_constr_level ?
> +                       (chan->max_power - local->hw.conf.power_constr_level) :
> +                       chan->max_power;
> +
> +       if (local->hw.conf.user_power_level)
> +               power = min(power, local->hw.conf.user_power_level);
> +
>         if (local->hw.conf.power_level != power) {
>                 changed |= IEEE80211_CONF_CHANGE_POWER;
>                 local->hw.conf.power_level = power;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index e317c6d..f193ba4 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -911,6 +911,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>         local->oper_channel_type = NL80211_CHAN_NO_HT;
>         config_changed |= IEEE80211_CONF_CHANGE_HT;
> 
> +       local->hw.conf.power_constr_level = 0;
> +
>         del_timer_sync(&local->dynamic_ps_timer);
>         cancel_work_sync(&local->dynamic_ps_enable_work);
> 
> @@ -1719,7 +1721,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>         ieee80211_rx_bss_put(local, bss);
>  }
> 
> -
>  static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
>                                          struct ieee80211_mgmt *mgmt,
>                                          size_t len,
> @@ -1748,6 +1749,16 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
>                        sdata->dev->name);
>                 ieee80211_authenticate(sdata, ifsta);
>         }
> +
> +       /* TODO: for IBSS */
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
>                         elems.country_elem, elems.country_elem_len);
>         }
> 
> +       /* TODO: IBSS also needs this */
> +       if (elems.pwr_constr_elem)
> +               ieee80211_handle_pwr_constr(sdata,
> +                               le16_to_cpu(mgmt->u.probe_resp.capab_info),
> +                               elems.pwr_constr_elem,
> +                               elems.pwr_constr_elem_len);
> +
>         ieee80211_bss_info_change_notify(sdata, changed);
>  }
> 
> diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
> index f72bad6..f7ffec1 100644
> --- a/net/mac80211/spectmgmt.c
> +++ b/net/mac80211/spectmgmt.c
> @@ -84,3 +84,25 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
>                         mgmt->sa, mgmt->bssid,
>                         mgmt->u.action.u.measurement.dialog_token);
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
> +
> +       /* Power constraint IE length should be 1 octet */
> +       if (pwr_constr_elem_len != 1)
> +               return;
> +
> +       if ((*pwr_constr_elem <= conf->channel->max_power) &&
> +           (*pwr_constr_elem != conf->power_constr_level)) {
> +               conf->power_constr_level = *pwr_constr_elem;
> +               ieee80211_hw_config(sdata->local, 0);
> +       }
> +}
> +

This patch will apply on top of my previous tx power fix.

vasanth
> --
> 1.5.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
