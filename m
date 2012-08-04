Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36502 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab2HDIOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2012 04:14:44 -0400
Message-ID: <501CD9F3.4000903@net.t-labs.tu-berlin.de> (sfid-20120804_101451_188224_7BE17246)
Date: Sat, 04 Aug 2012 10:14:43 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: nbd@nbd.name, Nick Kossifidis <mickflemm@gmail.com>
CC: jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After several experiments on cm9 and dcma82 cards, I figured out that
this patch does not solve the max_power calibration problem as intended.

The partly reduction to 8 with this:
#define AR5K_EEPROM_N_5GHZ_CHAN		10
#define AR5K_EEPROM_N_5GHZ_RATE_CHAN	8

... creates a wrong power curve on the card, as function
ath5k_eeprom_read_freq_list() runs its while loop still 10 times, which
results in wrong AR5K_EEPROM_READ(o++, val) readings, leading the card
to use a very low power level over all.
This should also be limited to 8, as I tested it.

My suggestion is to just set:
#define AR5K_EEPROM_N_5GHZ_CHAN		8

.. without introducing a separate variable, it is not needed.
I will send a v2.

While I am browsing through /ath5k/eeprom.c there are several other
suspicious places where 10 eeprom lines of chips like 5111, 5112, 2413
depending on their EEPROM Version are read. I can not test this, as I
have only CM9 and DCMA82 over here, but I guess those 10 line reads are
also wrong. Can someone test this ?


Greetings Thomas


> --- a/drivers/net/wireless/ath/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.c
> @@ -1482,7 +1482,7 @@ ath5k_eeprom_read_target_rate_pwr_info(struct ath5k_hw *ah, unsigned int mode)
>  	case AR5K_EEPROM_MODE_11A:
>  		offset += AR5K_EEPROM_TARGET_PWR_OFF_11A(ee->ee_version);
>  		rate_pcal_info = ee->ee_rate_tpwr_a;
> -		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_5GHZ_CHAN;
> +		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_5GHZ_RATE_CHAN;
>  		break;
>  	case AR5K_EEPROM_MODE_11B:
>  		offset += AR5K_EEPROM_TARGET_PWR_OFF_11B(ee->ee_version);
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
> index dc2bcfe..94a9bbe 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.h
> @@ -182,6 +182,7 @@
>  #define AR5K_EEPROM_EEP_DELTA		10
>  #define AR5K_EEPROM_N_MODES		3
>  #define AR5K_EEPROM_N_5GHZ_CHAN		10
> +#define AR5K_EEPROM_N_5GHZ_RATE_CHAN	8
>  #define AR5K_EEPROM_N_2GHZ_CHAN		3
>  #define AR5K_EEPROM_N_2GHZ_CHAN_2413	4
>  #define	AR5K_EEPROM_N_2GHZ_CHAN_MAX	4

