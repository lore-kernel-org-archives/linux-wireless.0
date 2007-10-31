Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:6712 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXJaSKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 14:10:44 -0400
Received: by py-out-1112.google.com with SMTP id u77so442085pyb
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 11:10:43 -0700 (PDT)
Message-ID: <43e72e890710311110l4a301f8cpb67b21bd90e251b4@mail.gmail.com> (sfid-20071031_181047_033201_926B19BB)
Date: Wed, 31 Oct 2007 14:10:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 4/7] ath5k: Add SREV values for newer chips
In-Reply-To: <20071027232033.GD5973@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027232033.GD5973@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:

> * Give more infos about mac/phy/radio revision during attach.

> @@ -535,10 +568,24 @@ ath5k_pci_probe(struct pci_dev *pdev,
>         if (ret)
>                 goto err_ah;
>
> -       dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
> -                       ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
> -                       sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
> -                       sc->ah->ah_phy_revision & 0xf);
> +       dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
> +                       ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
> +                                       sc->ah->ah_mac_srev,
> +                                       sc->ah->ah_phy_revision);
> +
> +       if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
> +               dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
> +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                       sc->ah->ah_radio_5ghz_revision);
> +       } else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> +               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> +                                       sc->ah->ah_radio_5ghz_revision);
> +               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> +                                       sc->ah->ah_radio_2ghz_revision);
> +       }
> +
>
>         /* ready to process interrupts */
>         __clear_bit(ATH_STAT_INVALID, sc->status);
>

I have ACK'd this as I believe its a lot more useful information than
what we had before but I am confused by what some different prints may
yield. For example, on AR5213, I get:

ath5k_pci 0001:11:02.0: Atheros AR5213 chip found: MAC 0x56, PHY: 0x41
ath5k_pci 0001:11:02.0: RF5111 5GHz radio found (0x17)
ath5k_pci 0001:11:02.0: RF2111 2GHz radio found (0x23)

On my Cardbus card, I then get:

ath5k_pci 0000:15:00.0: Atheros AR5213A chip found: MAC 0x59, PHY: 0x43
ath5k_pci 0000:15:00.0: RF5112A radio found (0x36)

Now, both are capable of 2 GHz and 5 GHz though and only one prints a
line which shows the type of RF both for 2 GHz and 5 GHz. Essentially
my ah_radio_2ghz_revision is 0x00 for that card. What exactly does
having a print for both RFs here indicate besides the fact we are
indicating the type of radio and revision? And in the Cardbus card I
have where only one RF line is printed what does that indicate?

  Luis
