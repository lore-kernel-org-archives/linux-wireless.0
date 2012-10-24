Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53640 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161255Ab2JXWR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 18:17:27 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so810781wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 15:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351108774-7450-2-git-send-email-javier@cozybit.com>
References: <1351108774-7450-1-git-send-email-javier@cozybit.com> <1351108774-7450-2-git-send-email-javier@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 24 Oct 2012 15:17:05 -0700
Message-ID: <CAG6hwVNfvcy90tWqFqMDbQqHQmr1X5j6XSyvehspZ0PftzLE-A@mail.gmail.com> (sfid-20121025_001731_766510_AD50F259)
Subject: Re: [PATCH 1/2] ath9k_htc: Add support for NL80211_IFTYPE_MESH_POINT interfaces
To: devel@lists.open80211s.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ ath9k-devel

On Wed, Oct 24, 2012 at 12:59 PM, Javier Cardona <javier@cozybit.com> wrote:
> More specifically, enable AP-style beaconing on mesh ifaces, honor
> FIF_OTHER_BSS filter and change the hw capabilities to reflect mesh
> support.
>
> Also enable IEEE80211_HW_SUPPORTS_PER_STA_GTK, IEEE80211_HW_MFP_CAPABLE
> and WIPHY_FLAG_IBSS_RSN.  Probably these should depend on the
> capabilities of the hardware but I don't know which hardware supports
> what.  But these are required for secured mesh and work fine on our
> TL-WN821N
>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h            |    7 +++++++
>  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   17 ++++++++++++++++-
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    6 +++++-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   14 ++++++++++++++
>  4 files changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index b30596f..c64dd0f 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -207,6 +207,9 @@ struct ath9k_htc_target_rx_stats {
>                 case NL80211_IFTYPE_AP:         \
>                         _priv->num_ap_vif++;    \
>                         break;                  \
> +               case NL80211_IFTYPE_MESH_POINT: \
> +                       _priv->num_mbss_vif++;  \
> +                       break;                  \
>                 default:                        \
>                         break;                  \
>                 }                               \
> @@ -223,6 +226,9 @@ struct ath9k_htc_target_rx_stats {
>                 case NL80211_IFTYPE_AP:         \
>                         _priv->num_ap_vif--;    \
>                         break;                  \
> +               case NL80211_IFTYPE_MESH_POINT: \
> +                       _priv->num_mbss_vif--;  \
> +                       break;                  \
>                 default:                        \
>                         break;                  \
>                 }                               \
> @@ -449,6 +455,7 @@ struct ath9k_htc_priv {
>         u8 sta_slot;
>         u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
>         u8 num_ibss_vif;
> +       u8 num_mbss_vif;
>         u8 num_sta_vif;
>         u8 num_sta_assoc_vif;
>         u8 num_ap_vif;
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> index f42d2eb..263f9b7 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> @@ -28,7 +28,8 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
>
>         ath9k_hw_get_txq_props(ah, priv->beaconq, &qi);
>
> -       if (priv->ah->opmode == NL80211_IFTYPE_AP) {
> +       if (priv->ah->opmode == NL80211_IFTYPE_AP ||
> +           priv->ah->opmode == NL80211_IFTYPE_MESH_POINT) {
>                 qi.tqi_aifs = 1;
>                 qi.tqi_cwmin = 0;
>                 qi.tqi_cwmax = 0;
> @@ -628,6 +629,13 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
>         case NL80211_IFTYPE_ADHOC:
>                 ath9k_htc_beacon_config_adhoc(priv, cur_conf);
>                 break;
> +       case NL80211_IFTYPE_MESH_POINT:
> +               /* 802.11s defines a different beaconing method for
> +                * mesh points that closely resembles AP-style
> +                * beaconing.  Until that is implemented, just use
> +                * AP-style beaconing for mesh points.
> +                */
> +               /* Fall through */
>         case NL80211_IFTYPE_AP:
>                 ath9k_htc_beacon_config_ap(priv, cur_conf);
>                 break;
> @@ -649,6 +657,13 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
>         case NL80211_IFTYPE_ADHOC:
>                 ath9k_htc_beacon_config_adhoc(priv, cur_conf);
>                 break;
> +       case NL80211_IFTYPE_MESH_POINT:
> +               /* 802.11s defines a different beaconing method for
> +                * mesh points that closely resembles AP-style
> +                * beaconing.  Until that is implemented, just use
> +                * AP-style beaconing for mesh points.
> +                */
> +               /* Fall through */
>         case NL80211_IFTYPE_AP:
>                 ath9k_htc_beacon_config_ap(priv, cur_conf);
>                 break;
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index d98255e..9c5c63c 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -707,6 +707,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>                 IEEE80211_HW_SUPPORTS_PS |
>                 IEEE80211_HW_PS_NULLFUNC_STACK |
>                 IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> +               IEEE80211_HW_SUPPORTS_PER_STA_GTK |
> +               IEEE80211_HW_MFP_CAPABLE |
>                 IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
>
>         hw->wiphy->interface_modes =
> @@ -714,9 +716,11 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>                 BIT(NL80211_IFTYPE_ADHOC) |
>                 BIT(NL80211_IFTYPE_AP) |
>                 BIT(NL80211_IFTYPE_P2P_GO) |
> -               BIT(NL80211_IFTYPE_P2P_CLIENT);
> +               BIT(NL80211_IFTYPE_P2P_CLIENT) |
> +               BIT(NL80211_IFTYPE_MESH_POINT);
>
>         hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +       hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>
>         hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |

Ahem. Antonio added this in:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/84066,
but that patch also seems to suggest per-STA GTKs are not supported by
the HW, so we shouldn't claim support above?

>                             WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index ca78e33..d763423 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -178,6 +178,8 @@ static void ath9k_htc_set_opmode(struct ath9k_htc_priv *priv)
>                 priv->ah->opmode = NL80211_IFTYPE_ADHOC;
>         else if (priv->num_ap_vif)
>                 priv->ah->opmode = NL80211_IFTYPE_AP;
> +       else if (priv->num_mbss_vif)
> +               priv->ah->opmode = NL80211_IFTYPE_MESH_POINT;
>         else
>                 priv->ah->opmode = NL80211_IFTYPE_STATION;
>
> @@ -1048,6 +1050,13 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>                 return -ENOBUFS;
>         }
>
> +       if (priv->num_mbss_vif ||
> +           (priv->nvifs && vif->type == NL80211_IFTYPE_MESH_POINT)) {
> +               ath_err(common, "Mesh BSS coexistence with other modes is not allowed\n");
> +               mutex_unlock(&priv->mutex);
> +               return -ENOBUFS;
> +       }
> +
>         if (((vif->type == NL80211_IFTYPE_AP) ||
>              (vif->type == NL80211_IFTYPE_ADHOC)) &&
>             ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
> @@ -1070,6 +1079,10 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>         case NL80211_IFTYPE_AP:
>                 hvif.opmode = HTC_M_HOSTAP;
>                 break;
> +       case NL80211_IFTYPE_MESH_POINT:
> +               /* close enough */
> +               hvif.opmode = HTC_M_WDS;
> +               break;
>         default:
>                 ath_err(common,
>                         "Interface type %d not yet supported\n", vif->type);
> @@ -1102,6 +1115,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>         INC_VIF(priv, vif->type);
>
>         if ((vif->type == NL80211_IFTYPE_AP) ||
> +           (vif->type == NL80211_IFTYPE_MESH_POINT) ||
>             (vif->type == NL80211_IFTYPE_ADHOC))
>                 ath9k_htc_assign_bslot(priv, vif);
>
> --
> 1.7.5.4
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
