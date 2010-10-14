Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28723 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab0JNIpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 04:45:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 01:45:15 -0700
Date: Thu, 14 Oct 2010 14:21:14 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k_hw: remove enum wireless_mode and its users
Message-ID: <20101014085107.GA6101@vmraj-lnx.users.atheros.com>
References: <20101014082135.GG21903@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101014082135.GG21903@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
>  				struct ieee80211_tx_rate *rate);
>  
> @@ -1203,35 +1192,21 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
>  					     bool is_ht,
>  					     bool is_cw_40)
>  {
unused argument is_cw_40 needs to e removed.

- Rajkumar
> -	int mode = 0;
>  	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>  
>  	switch(band) {
>  	case IEEE80211_BAND_2GHZ:
> -		mode = ATH9K_MODE_11G;
>  		if (is_ht)
> -			mode = ATH9K_MODE_11NG_HT20;
> -		if (is_cw_40)
> -			mode = ATH9K_MODE_11NG_HT40PLUS;
> -		break;
> +			return &ar5416_11ng_ratetable;
> +		return &ar5416_11g_ratetable;
>  	case IEEE80211_BAND_5GHZ:
> -		mode = ATH9K_MODE_11A;
>  		if (is_ht)
> -			mode = ATH9K_MODE_11NA_HT20;
> -		if (is_cw_40)
> -			mode = ATH9K_MODE_11NA_HT40PLUS;
> -		break;
> +			return &ar5416_11na_ratetable;
> +		return &ar5416_11a_ratetable;

