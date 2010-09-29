Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47151 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0I2Iyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 04:54:43 -0400
Received: by fxm14 with SMTP id 14so301327fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 01:54:42 -0700 (PDT)
Message-ID: <4CA2FEE1.7030104@wizery.com>
Date: Wed, 29 Sep 2010 10:54:57 +0200
From: Eliad Peller <eliad@wizery.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7] ath5k: Allow ath5k to support virtual STA and AP interfaces.
References: <1285720744-26246-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285720744-26246-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 02:39 AM, greearb@candelatech.com wrote:
> @@ -2687,31 +2784,79 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
> +
> +	/* Set combined mode - when APs are configured, operate in AP mode.
> +	 * Otherwise use the mode of the new interface. This can currently
> +	 * only deal with combinations of APs and STAs I think ...
> +	 * TODO:  What to do about mixed ADHOC + STA ?
> +	 */
> +	if (sc->num_ap_vifs)
> +		sc->opmode = NL80211_IFTYPE_AP;
> +	else
> +		sc->opmode = vif->type;
> +
> +	ath5k_hw_set_opmode(ah, sc->opmode);
> +
> +	/* Any MAC address is fine, all others are included through the
> +	 * filter.
> +	 */
> +	memcpy(&sc->lladdr, vif->addr, ETH_ALEN);
>   	ath5k_hw_set_lladdr(sc->ah, vif->addr);
> -	ath5k_mode_setup(sc);
> +
> +	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
> +
> +	ath5k_mode_setup(sc, vif);
>    

i guess you'd also like to add similar logic upon interface removal.
> @@ -2724,15 +2869,29 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>   			struct ieee80211_vif *vif)
>   {
>   	struct ath5k_softc *sc = hw->priv;
> -	u8 mac[ETH_ALEN] = {};
> +	struct ath5k_vif *avf = (void *)vif->drv_priv;
> +	unsigned int i;
>
>   	mutex_lock(&sc->lock);
> -	if (sc->vif != vif)
> -		goto end;
> +	sc->nvifs--;
> +
> +	if (avf->bbuf) {
> +		ath5k_txbuf_free_skb(sc, avf->bbuf);
> +		list_add_tail(&avf->bbuf->list,&sc->bcbuf);
> +		for (i = 0; i<  ATH_BCBUF; i++) {
> +			if (sc->bslot[i] == vif) {
> +				sc->bslot[i] = NULL;
> +				break;
> +			}
> +		}
> +		avf->bbuf = NULL;
> +	}
> +	if (avf->opmode == NL80211_IFTYPE_AP)
> +		sc->num_ap_vifs--;
> +	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
> +		sc->num_adhoc_vifs--;
>
> -	ath5k_hw_set_lladdr(sc->ah, mac);
> -	sc->vif = NULL;
> -end:
> +	ath5k_update_bssid_mask(sc, NULL);
>   	mutex_unlock(&sc->lock);
>   }
>
>    

Eliad.
