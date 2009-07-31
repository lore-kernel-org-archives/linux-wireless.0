Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:55040 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGaSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:11:40 -0400
Received: by yxe5 with SMTP id 5so261578yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:11:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090731180238.GA7963@makis>
References: <20090731180238.GA7963@makis>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 11:11:20 -0700
Message-ID: <43e72e890907311111k10cce08et84510866c68e0297@mail.gmail.com>
Subject: Re: [PATCH 1/4]: Check EEPROM before tweaking SERDES
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:02 AM, Nick
Kossifidis<mick@madwifi-project.org> wrote:
>  * Read PCI-E infos offset from EEPROM and if it points to
>   serdes section (0x40), enable serdes programming (further
>   tweaking of serdes values during attach). This follows
>   Legacy and Sam's HAL sources.
>
> ---
>  drivers/net/wireless/ath/ath5k/attach.c |   56 +++++++++++++++++++------------
>  drivers/net/wireless/ath/ath5k/eeprom.c |   10 +++++
>  drivers/net/wireless/ath/ath5k/eeprom.h |    4 ++
>  3 files changed, 48 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
> index 9a84d94..6263065 100644
> --- a/drivers/net/wireless/ath/ath5k/attach.c
> +++ b/drivers/net/wireless/ath/ath5k/attach.c
> @@ -253,28 +253,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>        }
>
>        /*
> -        * Write PCI-E power save settings
> -        */
> -       if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
> -               ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
> -               ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
> -               /* Shut off RX when elecidle is asserted */
> -               ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
> -               ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
> -               /* TODO: EEPROM work */
> -               ath5k_hw_reg_write(ah, 0xe5980579, AR5K_PCIE_SERDES);
> -               /* Shut off PLL and CLKREQ active in L1 */
> -               ath5k_hw_reg_write(ah, 0x001defff, AR5K_PCIE_SERDES);
> -               /* Preserce other settings */
> -               ath5k_hw_reg_write(ah, 0x1aaabe40, AR5K_PCIE_SERDES);
> -               ath5k_hw_reg_write(ah, 0xbe105554, AR5K_PCIE_SERDES);
> -               ath5k_hw_reg_write(ah, 0x000e3007, AR5K_PCIE_SERDES);
> -               /* Reset SERDES to load new settings */
> -               ath5k_hw_reg_write(ah, 0x00000000, AR5K_PCIE_SERDES_RESET);
> -               mdelay(1);
> -       }
> -
> -       /*
>         * POST
>         */
>        ret = ath5k_hw_post(ah);


Can the changes for the code be done before the move, or after so that
way the actual code changes to the section can be easily readable?

> @@ -295,6 +273,40 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>                goto err_free;
>        }
>
> +       /*
> +        * Write PCI-E power save settings
> +        */
> +       if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
> +               struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
> +
> +               ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
> +               ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
> +
> +               /* Shut off RX when elecidle is asserted */
> +               ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
> +               ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
> +
> +               /* If serdes programing is enabled, increase PCI-E
> +                * tx power for systems with long trace from host
> +                * to minicard connector. */

This is just comment-picky mind using this style for comments for > 1 lines?

/*
 * foo bleh buh
 * bar
 * qwerty
 */

  Luis
