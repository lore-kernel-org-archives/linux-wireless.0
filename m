Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:58171 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3LEKZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:25:21 -0500
Message-ID: <52A05325.2070501@openwrt.org> (sfid-20131205_112523_897088_4907AC69)
Date: Thu, 05 Dec 2013 11:19:17 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 08/12] ath9k: Use a separate TX gain table for WZR-HP-G450H
References: <1386233177-11132-1-git-send-email-sujith@msujith.org> <1386233177-11132-9-git-send-email-sujith@msujith.org>
In-Reply-To: <1386233177-11132-9-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.12.05. 9:46 keltezéssel, Sujith Manoharan írta:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The Buffalo device WZR-HP-G450H uses the index 3 for TX gain,
> which is set to the high_power table currently. Later variants
> of the router use the same index, but instead refer to the
> low_ob_db gain table. This is not handled in the driver since
> there is no way to distinguish board revisions and the high_power
> table is used (incorrectly) for the newer variants.
> 
> By default, devices based on AR9300 using the TX gain index 3 have
> to use the high_power table. To make sure that WZR-HP-G450H is not
> broken when the high_power table is updated, use a separate array
> based on information obtained from the platform data.
> 
> The current situation where only the original variant of WZR-HP-G450H
> works properly stays unchanged.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

<...>

> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 8f4c167..998335c 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -554,7 +554,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
>  	sc->spec_config.fft_period = 0xF;
>  }
>  
> -static void ath9k_init_platform(struct ath_softc *sc)
> +static void ath9k_init_pcoem_platform(struct ath_softc *sc)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct ath9k_hw_capabilities *pCap = &ah->caps;
> @@ -664,6 +664,27 @@ static void ath9k_eeprom_release(struct ath_softc *sc)
>  	release_firmware(sc->sc_ah->eeprom_blob);
>  }
>  
> +static int ath9k_init_soc_platform(struct ath_softc *sc)
> +{
> +	struct ath9k_platform_data *pdata = sc->dev->platform_data;
> +	struct ath_hw *ah = sc->sc_ah;
> +	int ret = 0;
> +
> +	if (!pdata)
> +		return 0;
> +
> +	if (pdata->eeprom_name) {
> +		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (pdata->tx_gain_buffalo)

The ath9k_platform_data structure in 'include/linux/ath9k_platform.h' should be
updated as well. Otherwise this will cause a build error.

> +		ah->config.tx_gain_buffalo = true;
> +
> +	return ret;
> +}
> +

-Gabor
