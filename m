Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51659 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0K0Aiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 19:38:46 -0500
Received: by wwa36 with SMTP id 36so2649074wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 16:38:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <12054859.501290765425878.JavaMail.wlan@CHBU500181>
References: <8993750.301290765190311.JavaMail.wlan@CHBU500181>
	<12054859.501290765425878.JavaMail.wlan@CHBU500181>
Date: Sat, 27 Nov 2010 02:38:44 +0200
Message-ID: <AANLkTin5Q51UVoNVLbneDqVWFKqn1dJOtAu-Ochr95e-@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] ath5k: Add a function to read chipset's MAC revision
From: Nick Kossifidis <mickflemm@gmail.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/26 Wojciech Dubowik <dubowoj@neratec.com>:
> From: Felix Fietkau <nbd@openwrt.org>
>
> Add bus dependent revision read function which is used to
> determine chipset's MAC before hardware is initialized.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h  |    5 +++--
>  drivers/net/wireless/ath/ath5k/attach.c |   11 +++++++----
>  drivers/net/wireless/ath/ath5k/pci.c    |    6 ++++++
>  3 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 946e54a..917deb4 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1035,6 +1035,7 @@ struct ath5k_hw {
>        u32                     ah_phy;
>        u32                     ah_mac_srev;
>        u16                     ah_mac_version;
> +       u16                     ah_mac_revision;
>        u16                     ah_phy_revision;
>        u16                     ah_radio_5ghz_revision;
>        u16                     ah_radio_2ghz_revision;
> @@ -1143,9 +1144,9 @@ void ath5k_hw_deinit(struct ath5k_hw *ah);
>  int ath5k_sysfs_register(struct ath5k_softc *sc);
>  void ath5k_sysfs_unregister(struct ath5k_softc *sc);
>
> -/*Chip id helper function */
> +/*Chip id helper functions */
>  const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
> -
> +int ath5k_bus_read_srev(struct ath5k_hw *ah);
>
>  /* LED functions */
>  int ath5k_init_leds(struct ath5k_softc *sc);
> diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
> index fe7e6f1..9b5f6e4 100644
> --- a/drivers/net/wireless/ath/ath5k/attach.c
> +++ b/drivers/net/wireless/ath/ath5k/attach.c
> @@ -128,7 +128,8 @@ int ath5k_hw_init(struct ath5k_softc *sc)
>        /*
>         * Find the mac version
>         */
> -       srev = ath5k_hw_reg_read(ah, AR5K_SREV);
> +       ath5k_bus_read_srev(ah);
> +       srev = ah->ah_mac_srev;
>        if (srev < AR5K_SREV_AR5311)
>                ah->ah_version = AR5K_AR5210;
>        else if (srev < AR5K_SREV_AR5212)
> @@ -136,6 +137,10 @@ int ath5k_hw_init(struct ath5k_softc *sc)
>        else
>                ah->ah_version = AR5K_AR5212;
>
> +       /* Get the MAC revision */
> +       ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
> +       ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
> +
>        /* Fill the ath5k_hw struct with the needed functions */
>        ret = ath5k_hw_init_desc_functions(ah);
>        if (ret)
> @@ -146,9 +151,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
>        if (ret)
>                goto err;
>
> -       /* Get MAC, PHY and RADIO revisions */
> -       ah->ah_mac_srev = srev;
> -       ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
> +       /* Get PHY and RADIO revisions */
>        ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
>                        0xffffffff;
>        ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
> diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
> index 3f26cf2..4eff891 100644
> --- a/drivers/net/wireless/ath/ath5k/pci.c
> +++ b/drivers/net/wireless/ath/ath5k/pci.c
> @@ -100,6 +100,12 @@ bool ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
>        return -ETIMEDOUT;
>  }
>
> +int ath5k_bus_read_srev(struct ath5k_hw *ah)
> +{
> +       ah->ah_mac_srev = ath5k_hw_reg_read(ah, AR5K_SREV);
> +       return 0;
> +}
> +
>  /* Common ath_bus_opts structure */
>  static const struct ath_bus_ops ath_pci_bus_ops = {
>        .ath_bus_type = ATH_PCI,
> --
> 1.7.1
>

Why not naming that ath5k_hw_read_srev_pci and the other one
ath5k_hw_read_srev_ahb and name both ath5k_bus_read_srev ? Also please
at least follow the naming scheme, all hw related functions are
ath5k_hw_*.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
