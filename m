Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:55887 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbXJGKUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 06:20:51 -0400
Received: by py-out-1112.google.com with SMTP id u77so1820534pyb
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2007 03:20:50 -0700 (PDT)
Message-ID: <40f31dec0710070320u5f632e72p6c61ffd1618bc995@mail.gmail.com> (sfid-20071007_112056_102880_D9B0BE1A)
Date: Sun, 7 Oct 2007 03:20:49 -0700
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath5k: Enhance reporting on probe
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071006020150.GA1607@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006020150.GA1607@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have you checked out this ?

http://madwifi.org/changeset/2703

check out the table with the names here...
http://madwifi.org/browser/branches/ath5k/ath5k.h?rev=2709#L161

and the code that uses this table here...
http://madwifi.org/browser/branches/ath5k/ath5k_hw.c?rev=2709#L400

Where is the problem with this approach ???

2007/10/5, Luis R. Rodriguez <mcgrof@gmail.com>:
> Enhance reporting of devices. I tried getting revisions for
> ah_radio_2ghz_revision but it seems to be empty.
>
> Oh and AR5210 no longer locks now with the interrupt fixes. But now we get:
>
> ath5k_hw_reset: failed to reset TX queue #1
> unable to reset hardware: -22
>
> We'll need to fix this.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   32 ++++++++++++++++++++++++++++----
>  1 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 97a7613..6097763 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2330,11 +2330,26 @@ static const char *ath_chip_name(u8 mac_version)
>         return "Unknown";
>  }
>
> +static const char *ath_phy_name(enum ath5k_radio radio)
> +{
> +       switch (radio) {
> +       case AR5K_RF5110:
> +               return "RF5110";
> +       case AR5K_RF5111:
> +               return "RF5111";
> +       case AR5K_RF5112:
> +               return "RF5112";
> +       default:
> +               return "Unknown";
> +       }
> +}
> +
>  static int __devinit ath_pci_probe(struct pci_dev *pdev,
>                 const struct pci_device_id *id)
>  {
>         void __iomem *mem;
>         struct ath_softc *sc;
> +       struct ath_hw *ah;
>         struct ieee80211_hw *hw;
>         int ret;
>         u8 csz;
> @@ -2444,14 +2459,23 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
>                 goto err_irq;
>         }
>
> +       ah = sc->ah;
> +
>         ret = ath_attach(pdev, hw);
>         if (ret)
>                 goto err_ah;
>
> -       dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
> -                       ath_chip_name(id->driver_data), sc->ah->ah_mac_version,
> -                       sc->ah->ah_mac_version, sc->ah->ah_phy_revision >> 4,
> -                       sc->ah->ah_phy_revision & 0xf);
> +       dev_info(&pdev->dev, "MAC:\t\t%s %u.%u\n",
> +               ath_chip_name(id->driver_data),
> +               ah->ah_mac_version,
> +               ah->ah_mac_revision);
> +       dev_info(&pdev->dev, "Phy:\t\t%s %u.%u\n",
> +               ath_phy_name(ah->ah_radio),
> +               ah->ah_phy_revision >> 4,
> +               ah->ah_phy_revision & 0xf);
> +       dev_info(&pdev->dev, "Radio:\t%u.%u\n",
> +               ah->ah_radio_5ghz_revision >> 4,
> +               ah->ah_radio_5ghz_revision & 0xf);
>
>         /* ready to process interrupts */
>         __clear_bit(ATH_STAT_INVALID, sc->status);
> --
> 1.5.2.5
>
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
