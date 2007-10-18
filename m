Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:2438 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXJRAGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 20:06:20 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2969812wah
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 17:06:20 -0700 (PDT)
Message-ID: <1ba2fa240710171706l4ef00b27m27fd657bca3cddc0@mail.gmail.com> (sfid-20071018_010623_448794_68A51095)
Date: Thu, 18 Oct 2007 02:06:19 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
Cc: linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <11926651061687-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note:  this is a RFC patch not completed. Somehow I messed up the header
Thanks for feedback.


On 10/18/07, Tomas Winkler <tomas.winkler@intel.com> wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
> This patch gives a framework that will enable the mac80211 to inform
> to low level driver about association status changes + changes in bss
> status due to changes in BSS capabilities advertised by AP or in AP mode
> changes to be advertised and configured to.
> This will also obsolete current ops for each BSS change such as erp or wmm.
> In legacy networks the B G coexistence is handled by ERP While in HT there
> are many more issues such as 20/40Mhz, GF etc. It will be counterproductive
> to implement handlers for each parameter it is simpler to consolidate all in one
> handler under common structure
>
>
> 1 - struct ieee80211_erp_info will be used to inform about erp changes.
> 2 - struct ieee80211_wmm_info will be used to inform about wmm changes
> 3 - struct ieee80211_bss_data will be used to transfer this data to
> low-level driver
> 4 - bss_info_changed will triger the change in low-level driver
>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  include/net/mac80211.h       |   29 ++++++++++++++++
>  net/mac80211/ieee80211_sta.c |   77 +++++++++++++++++++++++++-----------------
>  2 files changed, 75 insertions(+), 31 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2b1bffb..fbd7e31 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -237,6 +237,33 @@ struct ieee80211_low_level_stats {
>         unsigned int dot11RTSSuccessCount;
>  };
>
> +/* next structs enable the mac80211 to send association notification
> + * to low-level driver, as well as data that may be changed through
> + * the lifetime of the BSS, after it was parsed to meaningful structs */
> +struct ieee80211_erp_info {
> +       u8 changes;
> +       int cts_protection;
> +       int preamble;
> +};
> +
> +struct ieee80211_wmm_info {
> +       int queue;
> +       struct ieee80211_tx_queue_params *params;
> +};
> +
> +#define ASSOC_CHNAGED_STATE     (1<<0)
> +#define ASSOC_CHNAGED_AID       (1<<1)
> +#define ASSOC_CHNAGED_ERP       (1<<2)
> +#define ASSOC_CHNAGED_WMM       (1<<3)
> +
> +struct ieee80211_bss_data {
> +       u8 changed_map; /* use ASSOC_CHNAGED_.. to indicate changed element */
> +       u8 assoc; /* 0 not assoc, 1 assoc */
> +       u16 aid;
> +       struct ieee80211_erp_info erp_info;
> +       struct ieee80211_wmm_info wmm_info;
> +};
> +
>  /* Transmit control fields. This data structure is passed to low-level driver
>   * with each TX frame. The low-level driver is responsible for configuring
>   * the hardware to use given values (depending on what is supported). */
> @@ -1021,6 +1048,8 @@ struct ieee80211_ops {
>         int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
>         int (*config_interface)(struct ieee80211_hw *hw,
>                                 int if_id, struct ieee80211_if_conf *conf);
> +       void (*bss_info_changed)(struct ieee80211_hw *hw,
> +                                struct ieee80211_bss_data *bss_data);
>         void (*configure_filter)(struct ieee80211_hw *hw,
>                                  unsigned int changed_flags,
>                                  unsigned int *total_flags,
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 7c93f29..f38eb5a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -408,56 +408,66 @@ static void ieee80211_sta_send_associnfo(struct net_device *dev,
>
>  static void ieee80211_set_associated(struct net_device *dev,
>                                      struct ieee80211_if_sta *ifsta,
> -                                    bool assoc)
> +                                    struct ieee80211_bss_data *bss_data)
>  {
>         struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>         union iwreq_data wrqu;
>
> -       if (!!(ifsta->flags & IEEE80211_STA_ASSOCIATED) == assoc)
> +       if (!bss_data->changed_map)
>                 return;
>
> -       if (assoc) {
> -               struct ieee80211_sub_if_data *sdata;
> -               struct ieee80211_sta_bss *bss;
> +       if (bss_data->changed_map & ASSOC_CHNAGED_STATE) {
> +               if (bss_data->assoc) {
> +                       struct ieee80211_sub_if_data *sdata;
> +                       struct ieee80211_sta_bss *bss;
>
> -               ifsta->flags |= IEEE80211_STA_ASSOCIATED;
> +                       ifsta->flags |= IEEE80211_STA_ASSOCIATED;
>
> -               sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> -               if (sdata->type != IEEE80211_IF_TYPE_STA)
> -                       return;
> +                       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +                       if (sdata->type != IEEE80211_IF_TYPE_STA)
> +                               return;
>
> -               bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
> -               if (bss) {
> -                       if (bss->has_erp_value)
> -                               ieee80211_handle_erp_ie(dev, bss->erp_value);
> -                       ieee80211_rx_bss_put(dev, bss);
> -               }
> +                       bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
> +                       if (bss) {
> +                               if (bss->has_erp_value)
> +                                 ieee80211_handle_erp_ie(dev, bss->erp_value);
> +                               ieee80211_rx_bss_put(dev, bss);
> +                       }
>
> -               netif_carrier_on(dev);
> -               ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
> -               memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
> -               memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
> -               ieee80211_sta_send_associnfo(dev, ifsta);
> -       } else {
> -               ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
> +                       netif_carrier_on(dev);
> +                       ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
> +                       memcpy(ifsta->prev_bssid,
> +                               sdata->u.sta.bssid, ETH_ALEN);
> +                       memcpy(wrqu.ap_addr.sa_data,
> +                               sdata->u.sta.bssid, ETH_ALEN);
> +                       ieee80211_sta_send_associnfo(dev, ifsta);
> +               } else {
> +                       ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
>
> -               netif_carrier_off(dev);
> -               ieee80211_reset_erp_info(dev);
> -               memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> +                       netif_carrier_off(dev);
> +                       ieee80211_reset_erp_info(dev);
> +                       memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> +               }
> +               wrqu.ap_addr.sa_family = ARPHRD_ETHER;
> +               wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
> +               ifsta->last_probe = jiffies;
> +               ieee80211_led_assoc(local, bss_data->assoc);
>         }
> -       wrqu.ap_addr.sa_family = ARPHRD_ETHER;
> -       wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
> -       ifsta->last_probe = jiffies;
> -       ieee80211_led_assoc(local, assoc);
> +       if (local->ops->bss_info_changed)
> +               local->ops->bss_info_changed(local_to_hw(local), bss_data);
>  }
>
>  static void ieee80211_set_disassoc(struct net_device *dev,
>                                    struct ieee80211_if_sta *ifsta, int deauth)
>  {
> +       struct ieee80211_bss_data bss_data;
> +
>         if (deauth)
>                 ifsta->auth_tries = 0;
>         ifsta->assoc_tries = 0;
> -       ieee80211_set_associated(dev, ifsta, 0);
> +       bss_data.assoc = 0;
> +       bss_data.changed_map = ASSOC_CHNAGED_STATE;
> +       ieee80211_set_associated(dev, ifsta, &bss_data);
>  }
>
>  static void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
> @@ -1162,6 +1172,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
>         u32 rates;
>         u16 capab_info, status_code, aid;
>         struct ieee802_11_elems elems;
> +       struct ieee80211_bss_data bss_data;
>         u8 *pos;
>         int i, j;
>
> @@ -1249,7 +1260,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
>         if (ifsta->assocresp_ies)
>                 memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
>
> -       ieee80211_set_associated(dev, ifsta, 1);
> +       bss_data.assoc = 1;
> +       bss_data.changed_map = ASSOC_CHNAGED_STATE;
> +       bss_data.aid = aid;
> +       bss_data.changed_map |= ASSOC_CHNAGED_AID;
> +       ieee80211_set_associated(dev, ifsta, &bss_data);
>
>         /* Add STA entry for the AP */
>         sta = sta_info_get(local, ifsta->bssid);
> --
> 1.5.2.4
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
