Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZDVU7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 16:59:05 -0400
Subject: Re: [RFC 2/2] mac80211: unify config_interface and bss_info_changed
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090422154644.464399343@sipsolutions.net>
References: <20090422154559.528196740@sipsolutions.net>
	 <20090422154644.464399343@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 14:05:09 -0700
Message-Id: <1240434309.29805.73.camel@rc-desk> (sfid-20090422_225910_679296_6B907C68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


On Wed, 2009-04-22 at 08:46 -0700, Johannes Berg wrote:
> The config_interface method is a little strange, it contains the
> BSSID and beacon updates, while bss_info_changed contains most
> other BSS information for each interface. This patch removes
> config_interface and rolls all the information it previously
> passed to drivers into bss_info_changed.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Tested with ar9170, zd1211, p54 and iwlagn.

Thank you very much for testing it.


[...]

> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c        2009-04-22 15:56:25.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c     2009-04-22 15:56:29.000000000 +0200
> @@ -2543,7 +2543,6 @@ static struct ieee80211_ops iwl_hw_ops =
>         .add_interface = iwl_mac_add_interface,
>         .remove_interface = iwl_mac_remove_interface,
>         .config = iwl_mac_config,
> -       .config_interface = iwl_mac_config_interface,
>         .configure_filter = iwl_configure_filter,
>         .set_key = iwl_mac_set_key,
>         .update_tkip_key = iwl_mac_update_tkip_key,
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c       2009-04-22 15:56:48.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c    2009-04-22 17:38:00.000000000 +0200
> @@ -2231,15 +2231,63 @@ static void iwl_ht_conf(struct iwl_priv
> 
>  #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
>  void iwl_bss_info_changed(struct ieee80211_hw *hw,
> -                                    struct ieee80211_vif *vif,
> -                                    struct ieee80211_bss_conf *bss_conf,
> -                                    u32 changes)
> +                         struct ieee80211_vif *vif,
> +                         struct ieee80211_bss_conf *bss_conf,
> +                         u32 changes)
>  {
>         struct iwl_priv *priv = hw->priv;
>         int ret;
> 
>         IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
> 
> +       if (!iwl_is_alive(priv))
> +               return;
> +
> +       mutex_lock(&priv->mutex);
> +
> +       if ((changes & BSS_CHANGED_BSSID) && !iwl_is_rfkill(priv)) {
> +               /* If there is currently a HW scan going on in the background
> +                * then we need to cancel it else the RXON below will fail. */
> +               if (iwl_scan_cancel_timeout(priv, 100)) {
> +                       IWL_WARN(priv, "Aborted scan still in progress "
> +                                   "after 100ms\n");
> +                       IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
> +                       mutex_unlock(&priv->mutex);
> +                       return;
> +               }
> +               memcpy(priv->staging_rxon.bssid_addr,
> +                      bss_conf->bssid, ETH_ALEN);
> +
> +               /* TODO: Audit driver for usage of these members and see
> +                * if mac80211 deprecates them (priv->bssid looks like it
> +                * shouldn't be there, but I haven't scanned the IBSS code
> +                * to verify) - jpk */
> +               memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
> +
> +               if (priv->iw_mode == NL80211_IFTYPE_AP)
> +                       iwlcore_config_ap(priv);
> +               else {
> +                       int rc = iwlcore_commit_rxon(priv);
> +                       if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
> +                               iwl_rxon_add_station(
> +                                       priv, priv->active_rxon.bssid_addr, 1);
> +               }
> +       } else {
> +               iwl_scan_cancel_timeout(priv, 100);
> +               priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
> +               iwlcore_commit_rxon(priv);
> +       }

I do not think the above if clause fully captures what was done in
iwl_mac_config_interface(). If rfkill is enabled we do not want to send
a command to the device. This is possible in this else clause. Perhaps
the else can have an extra check like ...

...
} else if (!iwl_is_rfkill(priv)) {
...

> +
> +       if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
> +           changes & BSS_CHANGED_BEACON) {
> +               struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
> +
> +               if (beacon)
> +                       iwl_mac_beacon_update(hw, beacon);
> +       }
> +
> +       mutex_unlock(&priv->mutex);
> +
>         if (changes & BSS_CHANGED_ERP_PREAMBLE) {
>                 IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
>                                    bss_conf->use_short_preamble);
> @@ -2297,7 +2345,7 @@ void iwl_bss_info_changed(struct ieee802
>                                         &priv->staging_rxon,
>                                         sizeof(struct iwl_rxon_cmd));
>         }
> -
> +       IWL_DEBUG_MAC80211(priv, "leave\n");

Why did you choose not to copy the code dealing with AP mode from
iwl_mac_config_interface()? I know that the driver does not currently
support it, but removing this code makes it harder for the case if this
support is added back. Considering the code is not currently used, would
you be ok with adding it as commented code?

>  }
>  EXPORT_SYMBOL(iwl_bss_info_changed);
> 
> @@ -2578,106 +2626,6 @@ out:
>  }
>  EXPORT_SYMBOL(iwl_mac_config);
> 
> -int iwl_mac_config_interface(struct ieee80211_hw *hw,
> -                                       struct ieee80211_vif *vif,
> -                                   struct ieee80211_if_conf *conf)
> -{
> -       struct iwl_priv *priv = hw->priv;
> -       int rc;
> -
> -       if (conf == NULL)
> -               return -EIO;
> -
> -       if (priv->vif != vif) {
> -               IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
> -               return 0;
> -       }
> -
> -       if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
> -           conf->changed & IEEE80211_IFCC_BEACON) {
> -               struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
> -               if (!beacon)
> -                       return -ENOMEM;
> -               mutex_lock(&priv->mutex);
> -               rc = iwl_mac_beacon_update(hw, beacon);
> -               mutex_unlock(&priv->mutex);
> -               if (rc)
> -                       return rc;
> -       }
> -
> -       if (!iwl_is_alive(priv))
> -               return -EAGAIN;
> -
> -       mutex_lock(&priv->mutex);
> -
> -       if (conf->bssid)
> -               IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
> -
> -/*
> - * very dubious code was here; the probe filtering flag is never set:
> - *
> -       if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
> -           !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
> - */
> -
> -       if (priv->iw_mode == NL80211_IFTYPE_AP) {
> -               if (!conf->bssid) {
> -                       conf->bssid = priv->mac_addr;
> -                       memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
> -                       IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
> -                                          conf->bssid);
> -               }
> -               if (priv->ibss_beacon)
> -                       dev_kfree_skb(priv->ibss_beacon);
> -
> -               priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
> -       }

This is the AP code I refer to above ...

> -
> -       if (iwl_is_rfkill(priv))
> -               goto done;
> -
> -       if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
> -           !is_multicast_ether_addr(conf->bssid)) {
> -               /* If there is currently a HW scan going on in the background
> -                * then we need to cancel it else the RXON below will fail. */
> -               if (iwl_scan_cancel_timeout(priv, 100)) {
> -                       IWL_WARN(priv, "Aborted scan still in progress "
> -                                   "after 100ms\n");
> -                       IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
> -                       mutex_unlock(&priv->mutex);
> -                       return -EAGAIN;
> -               }
> -               memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
> -
> -               /* TODO: Audit driver for usage of these members and see
> -                * if mac80211 deprecates them (priv->bssid looks like it
> -                * shouldn't be there, but I haven't scanned the IBSS code
> -                * to verify) - jpk */
> -               memcpy(priv->bssid, conf->bssid, ETH_ALEN);
> -
> -               if (priv->iw_mode == NL80211_IFTYPE_AP)
> -                       iwlcore_config_ap(priv);
> -               else {
> -                       rc = iwlcore_commit_rxon(priv);
> -                       if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
> -                               iwl_rxon_add_station(
> -                                       priv, priv->active_rxon.bssid_addr, 1);
> -               }
> -
> -       } else {
> -               iwl_scan_cancel_timeout(priv, 100);
> -               priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
> -               iwlcore_commit_rxon(priv);
> -       }
> -
> - done:
> -       IWL_DEBUG_MAC80211(priv, "leave\n");
> -       mutex_unlock(&priv->mutex);
> -
> -       return 0;
> -}
> -EXPORT_SYMBOL(iwl_mac_config_interface);
> -
>  int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
>                          struct ieee80211_tx_queue_stats *stats)
>  {
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h       2009-04-22 15:55:47.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h    2009-04-22 15:55:53.000000000 +0200
> @@ -281,9 +281,6 @@ void iwl_mac_remove_interface(struct iee
>                                  struct ieee80211_if_init_conf *conf);
>  int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
>  void iwl_config_ap(struct iwl_priv *priv);
> -int iwl_mac_config_interface(struct ieee80211_hw *hw,
> -                               struct ieee80211_vif *vif,
> -                               struct ieee80211_if_conf *conf);
>  int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
>                          struct ieee80211_tx_queue_stats *stats);
>  void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c   2009-04-22 15:56:02.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c        2009-04-22 15:56:07.000000000 +0200
> @@ -4016,7 +4016,6 @@ static struct ieee80211_ops iwl3945_hw_o
>         .add_interface = iwl_mac_add_interface,
>         .remove_interface = iwl_mac_remove_interface,
>         .config = iwl_mac_config,
> -       .config_interface = iwl_mac_config_interface,
>         .configure_filter = iwl_configure_filter,
>         .set_key = iwl3945_mac_set_key,
>         .get_tx_stats = iwl_mac_get_tx_stats,

Reinette



