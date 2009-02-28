Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:38654 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZB1CB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 21:01:58 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1028829yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 18:01:56 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18856.39652.66588.791696@gargle.gargle.HOWL> (sfid-20090228_030206_822102_DFAA96C1)
Date: Sat, 28 Feb 2009 07:31:08 +0530
To: "Alina Friedrichsen" <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
In-Reply-To: <20090227220215.254900@gmx.net>
References: <20090227220215.254900@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alina Friedrichsen wrote:
> diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
> index 5ec416b..4d930c7 100644
> --- a/drivers/net/wireless/ath9k/hw.h
> +++ b/drivers/net/wireless/ath9k/hw.h
> @@ -441,6 +441,7 @@ struct ath_hw {
>  	u32 btactive_gpio;
>  	u32 wlanactive_gpio;
>  	u32 ah_flags;
> +	bool bcn_prbresp_promisc;
>  
>  	enum nl80211_iftype opmode;
>  	enum ath9k_power_mode power_mode;
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index f5f5739..c0d5336 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -2397,11 +2397,12 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
>  	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
>  
>  	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
> -		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
> -			memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
> -			sc->curaid = 0;
> -			ath9k_hw_write_associd(sc);
> -		}
> +		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
> +			sc->sc_ah->bcn_prbresp_promisc = true;
> +		else
> +			sc->sc_ah->bcn_prbresp_promisc = false;
> +
> +		ath9k_hw_write_associd(sc);
>  	}

You don't need a new variable in ath_hal. The RX filter is already cached in
ath_softc during a configure_filter() call.

Sujith
