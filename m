Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:4156 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0CIMSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:18:23 -0500
Received: by ey-out-2122.google.com with SMTP id 25so939262eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:18:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075544.30616.17222.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075544.30616.17222.stgit@void>
Date: Tue, 9 Mar 2010 14:18:20 +0200
Message-ID: <40f31dec1003090418y1fa6a9f8i218b629e6bba5b72@mail.gmail.com>
Subject: Re: [PATCH 06/13] ath5k: remove ah_magic
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> it's never used. probably a leftover from the old OpenHAL days...
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
>  drivers/net/wireless/ath/ath5k/desc.c   |    6 ------
>  drivers/net/wireless/ath/ath5k/eeprom.h |    3 ---
>  3 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index cb79d44..3d63511 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1028,7 +1028,6 @@ struct ath5k_nfcal_hist
>
>  /* TODO: Clean up and merge with ath5k_softc */
>  struct ath5k_hw {
> -       u32                     ah_magic;
>        struct ath_common       common;
>
>        struct ath5k_softc      *ah_sc;
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
> index dc30a2b..dff58e2 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -668,12 +668,6 @@ int ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
>                ah->ah_version != AR5K_AR5212)
>                        return -ENOTSUPP;
>
> -       /* XXX: What is this magic value and where is it used ? */
> -       if (ah->ah_version == AR5K_AR5212)
> -               ah->ah_magic = AR5K_EEPROM_MAGIC_5212;
> -       else if (ah->ah_version == AR5K_AR5211)
> -               ah->ah_magic = AR5K_EEPROM_MAGIC_5211;
> -
>        if (ah->ah_version == AR5K_AR5212) {
>                ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
>                ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
> index 473a483..1a65683 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.h
> @@ -24,9 +24,6 @@
>                                                 * SERDES infos are present */
>  #define AR5K_EEPROM_MAGIC              0x003d  /* EEPROM Magic number */
>  #define AR5K_EEPROM_MAGIC_VALUE                0x5aa5  /* Default - found on EEPROM */
> -#define AR5K_EEPROM_MAGIC_5212         0x0000145c /* 5212 */
> -#define AR5K_EEPROM_MAGIC_5211         0x0000145b /* 5211 */
> -#define AR5K_EEPROM_MAGIC_5210         0x0000145a /* 5210 */
>
>  #define        AR5K_EEPROM_IS_HB63             0x000b  /* Talon detect */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
