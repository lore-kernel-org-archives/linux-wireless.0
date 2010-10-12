Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:46120 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755583Ab0JLBob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 21:44:31 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0693107869
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 10:44:29 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: greearb@candelatech.com
Subject: Re: [PATCH v2] ath5k:  Adjust opmode when interfaces are removed.
Date: Tue, 12 Oct 2010 10:44:39 +0900
Cc: linux-wireless@vger.kernel.org
References: <1286564475-10105-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1286564475-10105-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201010121044.39093.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat October 9 2010 04:01:15 greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, if there is an AP and a STATION, and AP
> is removed, the NIC will not revert back to STATION mode.
> 
> Reported-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v1 -> v2:  Make setting opmode un-conditional, rename
>     method to:  ath5k_update_bssid_mask_and_opmode
> 
> :100644 100644 dad7265... c9732a6...
> :M	drivers/net/wireless/ath/ath5k/base.c
> 
>  drivers/net/wireless/ath/ath5k/base.c |   66
> ++++++++++++++++++++------------- 1 files changed, 40 insertions(+), 26
> deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index dad7265..c9732a6 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -62,6 +62,7 @@
>  #include "reg.h"
>  #include "debug.h"
>  #include "ani.h"
> +#include "../debug.h"
> 
>  static int modparam_nohwcrypt;
>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> @@ -517,12 +518,14 @@ struct ath_vif_iter_data {
>  	bool		need_set_hw_addr;
>  	bool		found_active;
>  	bool		any_assoc;
> +	enum nl80211_iftype opmode;
>  };
> 
>  static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
>  {
>  	struct ath_vif_iter_data *iter_data = data;
>  	int i;
> +	struct ath5k_vif *avf = (void *)vif->drv_priv;
> 
>  	if (iter_data->hw_macaddr)
>  		for (i = 0; i < ETH_ALEN; i++)
> @@ -539,13 +542,34 @@ static void ath_vif_iter(void *data, u8 *mac, struct
> ieee80211_vif *vif) iter_data->need_set_hw_addr = false;
> 
>  	if (!iter_data->any_assoc) {
> -		struct ath5k_vif *avf = (void *)vif->drv_priv;
>  		if (avf->assoc)
>  			iter_data->any_assoc = true;
>  	}
> +
> +	/* Calculate combined mode - when APs are active, operate in AP mode.
> +	 * Otherwise use the mode of the new interface. This can currently
> +	 * only deal with combinations of APs and STAs. Only one ad-hoc
> +	 * interfaces is allowed above.

the comment reference to "above" does not make sense here any more.

> +	 */
> +	if (avf->opmode == NL80211_IFTYPE_AP)
> +		iter_data->opmode = NL80211_IFTYPE_AP;
> +	else
> +		if (iter_data->opmode == NL80211_IFTYPE_UNSPECIFIED)
> +			iter_data->opmode = avf->opmode;
>  }
> 
> -void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif
> *vif) +static void ath_do_set_opmode(struct ath5k_softc *sc)
> +{
> +	struct ath5k_hw *ah = sc->ah;
> +	ath5k_hw_set_opmode(ah, sc->opmode);
> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
> +		  sc->opmode,
> +		  ath_opmode_to_string(sc->opmode) ?
> +		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
> +}

what's the point of this function? just to add the debug print? 

> +void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
> +					struct ieee80211_vif *vif)
>  {
>  	struct ath_common *common = ath5k_hw_common(sc->ah);
>  	struct ath_vif_iter_data iter_data;
> @@ -558,6 +582,7 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc,
> struct ieee80211_vif *vif) memset(&iter_data.mask, 0xff, ETH_ALEN);
>  	iter_data.found_active = false;
>  	iter_data.need_set_hw_addr = true;
> +	iter_data.opmode = NL80211_IFTYPE_UNSPECIFIED;
> 
>  	if (vif)
>  		ath_vif_iter(&iter_data, vif->addr, vif);
> @@ -567,10 +592,18 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc,
> struct ieee80211_vif *vif) &iter_data);
>  	memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
> 
> +	sc->opmode = iter_data.opmode;
> +	if (sc->opmode == NL80211_IFTYPE_UNSPECIFIED)
> +		/* Nothing active, default to station mode */
> +		sc->opmode = NL80211_IFTYPE_STATION;
> +
> +	ath_do_set_opmode(sc);
>  	if (iter_data.need_set_hw_addr && iter_data.found_active)
>  		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);
> 
> -	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
> +	if (ath5k_hw_hasbssidmask(sc->ah))
> +		ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
>  }
> 
>  static void
> @@ -582,15 +615,9 @@ ath5k_mode_setup(struct ath5k_softc *sc, struct
> ieee80211_vif *vif) /* configure rx filter */
>  	rfilt = sc->filter_flags;
>  	ath5k_hw_set_rx_filter(ah, rfilt);
> -
> -	if (ath5k_hw_hasbssidmask(ah))
> -		ath5k_update_bssid_mask(sc, vif);
> -
> -	/* configure operational mode */
> -	ath5k_hw_set_opmode(ah, sc->opmode);
> -
> -	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
>  	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
> +
> +	ath5k_update_bssid_mask_and_opmode(sc, vif);
>  }
> 
>  static inline int
> @@ -2688,7 +2715,7 @@ ath5k_attach(struct pci_dev *pdev, struct
> ieee80211_hw *hw) SET_IEEE80211_PERM_ADDR(hw, mac);
>  	memcpy(&sc->lladdr, mac, ETH_ALEN);
>  	/* All MAC address bits matter for ACKs */
> -	ath5k_update_bssid_mask(sc, NULL);
> +	ath5k_update_bssid_mask_and_opmode(sc, NULL);
> 
>  	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
>  	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
> @@ -2786,7 +2813,6 @@ static int ath5k_add_interface(struct ieee80211_hw
> *hw, {
>  	struct ath5k_softc *sc = hw->priv;
>  	int ret;
> -	struct ath5k_hw *ah = sc->ah;
>  	struct ath5k_vif *avf = (void *)vif->drv_priv;
> 
>  	mutex_lock(&sc->lock);
> @@ -2850,18 +2876,6 @@ static int ath5k_add_interface(struct ieee80211_hw
> *hw, sc->num_adhoc_vifs++;
>  	}
> 
> -	/* Set combined mode - when APs are configured, operate in AP mode.
> -	 * Otherwise use the mode of the new interface. This can currently
> -	 * only deal with combinations of APs and STAs. Only one ad-hoc
> -	 * interfaces is allowed above.
> -	 */
> -	if (sc->num_ap_vifs)
> -		sc->opmode = NL80211_IFTYPE_AP;
> -	else
> -		sc->opmode = vif->type;
> -
> -	ath5k_hw_set_opmode(ah, sc->opmode);
> -

i think it makes sense to set the opmode here. and also do the same in 
ath5k_remove_interface. that way we figure out the opmode when interfaces are 
added/removed.

>  	/* Any MAC address is fine, all others are included through the
>  	 * filter.
>  	 */
> @@ -2905,7 +2919,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>  	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
>  		sc->num_adhoc_vifs--;
> 
> -	ath5k_update_bssid_mask(sc, NULL);
> +	ath5k_update_bssid_mask_and_opmode(sc, NULL);
>  	mutex_unlock(&sc->lock);
>  }

