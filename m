Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:42761 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760791AbXKOSiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:38:23 -0500
Received: by py-out-1112.google.com with SMTP id u77so3664559pyb
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 10:38:22 -0800 (PST)
Message-ID: <43e72e890711151038k68d102f9m7f421ea301433cf@mail.gmail.com> (sfid-20071115_183848_841461_9D57A90F)
Date: Thu, 15 Nov 2007 13:38:20 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 2/4] ath5k: Fix device info reporting
In-Reply-To: <20071114161440.GB6365@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071114161440.GB6365@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 14, 2007 11:14 AM, Nick Kossifidis <mick@madwifi.org> wrote:
> *Fix device info code
>
> Changes-licensed-under: 3-clause-BSD
> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 4c4837f..0d0e060 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -570,22 +570,40 @@ ath5k_pci_probe(struct pci_dev *pdev,
>         if (ret)
>                 goto err_ah;
>
> -       dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
> +       dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
>                         ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
>                                         sc->ah->ah_mac_srev,
>                                         sc->ah->ah_phy_revision);
>
> -       if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
> -               dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
> -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> -                                       sc->ah->ah_radio_5ghz_revision);
> -       } else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> -               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> -                                       sc->ah->ah_radio_5ghz_revision);
> -               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> -                                       sc->ah->ah_radio_2ghz_revision);
> +       if(!sc->ah->ah_single_chip){

I'm a bit confused here you check for not single chip

> +               /* Single chip radio (!RF5111) */
> +               if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {

And here you say it is. Can you elaborate a bit on this?

> +                       /* No 5GHz support -> report 2GHz radio */
> +                       if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
> +                               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                                       sc->ah->ah_radio_5ghz_revision);
> +                       /* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
> +                       } else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
> +                               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                                       sc->ah->ah_radio_5ghz_revision);
> +                       /* Multiband radio */
> +                       } else {
> +                               dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
> +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                                       sc->ah->ah_radio_5ghz_revision);
> +                       }
> +               }
> +               /* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
> +               else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> +                       dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +                               ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                               sc->ah->ah_radio_5ghz_revision);
> +                       dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +                               ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> +                                               sc->ah->ah_radio_2ghz_revision);
> +               }
>         }
>

Thanks,

  Luis
