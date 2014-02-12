Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40377 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaBLPND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 10:13:03 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21243.36697.649170.35540@gargle.gargle.HOWL> (sfid-20140212_161307_860489_CBAE87D3)
Date: Wed, 12 Feb 2014 20:42:25 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: implement p2p client powersave support
In-Reply-To: <1392113890-5097-2-git-send-email-nbd@openwrt.org>
References: <1392113890-5097-1-git-send-email-nbd@openwrt.org>
	<1392113890-5097-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> +	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
> +		NULL, sc, AR_FIRST_NDP_TIMER);
> +
>  	ath9k_cmn_init_crypto(sc->sc_ah);
>  	ath9k_init_misc(sc);
>  	ath_fill_led_pin(sc);
> @@ -1067,6 +1070,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
>  {
>  	int i = 0;
>  
> +	if (sc->p2p_ps_timer)
> +		ath_gen_timer_free(sc->sc_ah, sc->p2p_ps_timer);
> +

Why do this in the global init/deinit routines ? Wouldn't the
add/remove interface callbacks be a better place for this (based on
vif->p2p), since this timer is needed only for p2p interfaces ?

> +	if (sc->ps_flags & PS_BEACON_SYNC)
> +		return;

I think sc_pm_lock is required to use sc->ps_flags.

Sujith
