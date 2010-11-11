Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:8312 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756719Ab0KKBKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 20:10:09 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0646377805
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 10:10:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k:  Cleanup opmode setting logic.
Date: Thu, 11 Nov 2010 10:10:20 +0900
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
References: <1289418231-2427-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1289418231-2427-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011111010.20543.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu November 11 2010 04:43:51 greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> An earlier review suggested moving the code in a small
> method that was only called once inline.  This patch
> accomplishes that.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> :100644 100644 b9f93fb... afd3094...
> :M	drivers/net/wireless/ath/ath5k/base.c
> 
>  drivers/net/wireless/ath/ath5k/base.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index b9f93fb..afd3094 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -549,7 +549,7 @@ static void ath_vif_iter(void *data, u8 *mac, struct
> ieee80211_vif *vif) /* Calculate combined mode - when APs are active,
> operate in AP mode. * Otherwise use the mode of the new interface. This
> can currently * only deal with combinations of APs and STAs. Only one
> ad-hoc
> -	 * interfaces is allowed above.
> +	 * interfaces is allowed.
>  	 */
>  	if (avf->opmode == NL80211_IFTYPE_AP)
>  		iter_data->opmode = NL80211_IFTYPE_AP;
> @@ -558,14 +558,6 @@ static void ath_vif_iter(void *data, u8 *mac, struct
> ieee80211_vif *vif) iter_data->opmode = avf->opmode;
>  }
> 
> -static void ath_do_set_opmode(struct ath5k_softc *sc)
> -{
> -	struct ath5k_hw *ah = sc->ah;
> -	ath5k_hw_set_opmode(ah, sc->opmode);
> -	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
> -		  sc->opmode, ath_opmode_to_string(sc->opmode));
> -}
> -
>  static void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
>  					       struct ieee80211_vif *vif)
>  {
> @@ -595,7 +587,9 @@ static void ath5k_update_bssid_mask_and_opmode(struct
> ath5k_softc *sc, /* Nothing active, default to station mode */
>  		sc->opmode = NL80211_IFTYPE_STATION;
> 
> -	ath_do_set_opmode(sc);
> +	ath5k_hw_set_opmode(sc->ah, sc->opmode);
> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
> +		  sc->opmode, ath_opmode_to_string(sc->opmode));
> 
>  	if (iter_data.need_set_hw_addr && iter_data.found_active)
>  		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);

Thanks!

Acked-by: Bruno Randolf <br1@einfach.org>
