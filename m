Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61917 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab2JYSol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 14:44:41 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1010361wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 11:44:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVNfvcy90tWqFqMDbQqHQmr1X5j6XSyvehspZ0PftzLE-A@mail.gmail.com>
References: <1351108774-7450-1-git-send-email-javier@cozybit.com>
 <1351108774-7450-2-git-send-email-javier@cozybit.com> <CAG6hwVNfvcy90tWqFqMDbQqHQmr1X5j6XSyvehspZ0PftzLE-A@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Oct 2012 11:44:19 -0700
Message-ID: <CAPjQAd9BgoE_sHyWoeUHmsqeOMm+-AwNGvAdV8Gf0NMBg4f9pA@mail.gmail.com> (sfid-20121025_204446_082168_4A42B293)
Subject: Re: [PATCH 1/2] ath9k_htc: Add support for NL80211_IFTYPE_MESH_POINT interfaces
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas,

On Wed, Oct 24, 2012 at 3:17 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> + ath9k-devel
>
> On Wed, Oct 24, 2012 at 12:59 PM, Javier Cardona <javier@cozybit.com> wrote:
>> More specifically, enable AP-style beaconing on mesh ifaces, honor
>> FIF_OTHER_BSS filter and change the hw capabilities to reflect mesh
>> support.
>>
>> Also enable IEEE80211_HW_SUPPORTS_PER_STA_GTK, IEEE80211_HW_MFP_CAPABLE
>> and WIPHY_FLAG_IBSS_RSN.  Probably these should depend on the
>> capabilities of the hardware but I don't know which hardware supports
>> what.  But these are required for secured mesh and work fine on our
>> TL-WN821N
>>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/htc.h            |    7 +++++++
>>  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   17 ++++++++++++++++-
>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    6 +++++-
>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   14 ++++++++++++++
>>  4 files changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
>> index b30596f..c64dd0f 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -207,6 +207,9 @@ struct ath9k_htc_target_rx_stats {
>>                 case NL80211_IFTYPE_AP:         \
>>                         _priv->num_ap_vif++;    \
>>                         break;                  \
>> +               case NL80211_IFTYPE_MESH_POINT: \
>> +                       _priv->num_mbss_vif++;  \
>> +                       break;                  \
>>                 default:                        \
>>                         break;                  \
>>                 }                               \
>> @@ -223,6 +226,9 @@ struct ath9k_htc_target_rx_stats {
>>                 case NL80211_IFTYPE_AP:         \
>>                         _priv->num_ap_vif--;    \
>>                         break;                  \
>> +               case NL80211_IFTYPE_MESH_POINT: \
>> +                       _priv->num_mbss_vif--;  \
>> +                       break;                  \
>>                 default:                        \
>>                         break;                  \
>>                 }                               \
>> @@ -449,6 +455,7 @@ struct ath9k_htc_priv {
>>         u8 sta_slot;
>>         u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
>>         u8 num_ibss_vif;
>> +       u8 num_mbss_vif;
>>         u8 num_sta_vif;
>>         u8 num_sta_assoc_vif;
>>         u8 num_ap_vif;
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
>> index f42d2eb..263f9b7 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
>> @@ -28,7 +28,8 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
>>
>>         ath9k_hw_get_txq_props(ah, priv->beaconq, &qi);
>>
>> -       if (priv->ah->opmode == NL80211_IFTYPE_AP) {
>> +       if (priv->ah->opmode == NL80211_IFTYPE_AP ||
>> +           priv->ah->opmode == NL80211_IFTYPE_MESH_POINT) {
>>                 qi.tqi_aifs = 1;
>>                 qi.tqi_cwmin = 0;
>>                 qi.tqi_cwmax = 0;
>> @@ -628,6 +629,13 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
>>         case NL80211_IFTYPE_ADHOC:
>>                 ath9k_htc_beacon_config_adhoc(priv, cur_conf);
>>                 break;
>> +       case NL80211_IFTYPE_MESH_POINT:
>> +               /* 802.11s defines a different beaconing method for
>> +                * mesh points that closely resembles AP-style
>> +                * beaconing.  Until that is implemented, just use
>> +                * AP-style beaconing for mesh points.
>> +                */
>> +               /* Fall through */
>>         case NL80211_IFTYPE_AP:
>>                 ath9k_htc_beacon_config_ap(priv, cur_conf);
>>                 break;
>> @@ -649,6 +657,13 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
>>         case NL80211_IFTYPE_ADHOC:
>>                 ath9k_htc_beacon_config_adhoc(priv, cur_conf);
>>                 break;
>> +       case NL80211_IFTYPE_MESH_POINT:
>> +               /* 802.11s defines a different beaconing method for
>> +                * mesh points that closely resembles AP-style
>> +                * beaconing.  Until that is implemented, just use
>> +                * AP-style beaconing for mesh points.
>> +                */
>> +               /* Fall through */
>>         case NL80211_IFTYPE_AP:
>>                 ath9k_htc_beacon_config_ap(priv, cur_conf);
>>                 break;
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> index d98255e..9c5c63c 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> @@ -707,6 +707,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>>                 IEEE80211_HW_SUPPORTS_PS |
>>                 IEEE80211_HW_PS_NULLFUNC_STACK |
>>                 IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>> +               IEEE80211_HW_SUPPORTS_PER_STA_GTK |
>> +               IEEE80211_HW_MFP_CAPABLE |
>>                 IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
>>
>>         hw->wiphy->interface_modes =
>> @@ -714,9 +716,11 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>>                 BIT(NL80211_IFTYPE_ADHOC) |
>>                 BIT(NL80211_IFTYPE_AP) |
>>                 BIT(NL80211_IFTYPE_P2P_GO) |
>> -               BIT(NL80211_IFTYPE_P2P_CLIENT);
>> +               BIT(NL80211_IFTYPE_P2P_CLIENT) |
>> +               BIT(NL80211_IFTYPE_MESH_POINT);
>>
>>         hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>> +       hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>>
>>         hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
>
> Ahem. Antonio added this in:
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/84066,
> but that patch also seems to suggest per-STA GTKs are not supported by
> the HW, so we shouldn't claim support above?

(Just to let the list know what we just discussed in person...)

I removed the redundant WIPHY_FLAG_IBSS_RSN and the setting of
IEEE80211_HW_SUPPORTS_PER_STA_GTK.  We'll retest the series and
resubmit.
If anyone interested, the reworked series lives here:
https://github.com/cozybit/open80211s/tree/ft-ath9k-htc-support

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
