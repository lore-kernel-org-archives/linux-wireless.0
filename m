Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30202 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab0IMMO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:14:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 05:14:53 -0700
Date: Mon, 13 Sep 2010 17:44:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
Message-ID: <20100913121428.GA15567@vasanth-laptop>
References: <4C8A8FF8.4030900@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C8A8FF8.4030900@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  	/* configure operational mode */
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index b32c8f0..4ce4029 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -110,7 +110,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
>  static void ath_opmode_init(struct ath_softc *sc)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
> -	struct ath_common *common = ath9k_hw_common(ah);
>  
>  	u32 rfilt, mfilt[2];
>  
> @@ -118,9 +117,15 @@ static void ath_opmode_init(struct ath_softc *sc)
>  	rfilt = ath_calcrxfilter(sc);
>  	ath9k_hw_setrxfilter(ah, rfilt);
>  
> -	/* configure bssid mask */
> -	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
> -		ath_hw_setbssidmask(common);
> +	/* configure bssid mask, if ah->hw is configured.
> +	 * it is NOT configured when mac80211 is calling
> +	 * ieee80211_do_open, but probably just as well since
> +	 * this STA isn't in the list yet.
> +	 */
> +	if (ah->hw) {

This seems bogus. why a check for hw at this point??. IIRS hw of
ah is not initialized at all, in that case this would fail always.
Did you test with these code?

> +	int avifs = ieee80211_count_sta_atomic(sc->hw);

If your aim here is to get the number of virtual interfaces
associated to a hw, sc->nvifs should work.
