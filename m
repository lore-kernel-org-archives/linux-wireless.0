Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46739 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3ATWFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 17:05:12 -0500
MIME-Version: 1.0
In-Reply-To: <1358715322-46447-2-git-send-email-nbd@openwrt.org>
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org>
	<1358715322-46447-2-git-send-email-nbd@openwrt.org>
Date: Sun, 20 Jan 2013 14:05:10 -0800
Message-ID: <CAJ-Vmontz33Fzx5_=D=LDFoWEkmWSO5iku3aiv5S+gQJCDD3og@mail.gmail.com> (sfid-20130120_230517_479504_C4B852E8)
Subject: Re: [PATCH 3.8 2/3] ath9k_hw: fix chain swap setting when setting rx
 chainmask to 5
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

What's the motivation behind this?

The reason why the PHY analog swapping is done when the chainmask set
to 0x5 is because pre-AR9280 chips didn't support arbitrary chainmask
configurations for TX.
So it could either be 0x1, 0x3, or 0x7.

The AR5416 2-TX 3-TX reference design has TX antenna on chain 0 and 2
(hence 0x5, as you know), so:

* One should never be allowed to configure a TX chainmask enabling
chain 1, as that plain won't work (there's no actual TX bits on the
card itself; it only has the RX related switch/amp/etc);
* If the chainmask is set to 0x3 or 0x5 on a device that has 3 TX
chains (ie, anything AR93xx and later with 3 chains and 3 TX capable
switches/amplifiers on the NIC itself) then _strictly speaking_ I
don't think it's necessary to do the analog swap, but that's when
you'd do it.

The AR9130 and AR9160 have the same limitation. The AR9280 and later
don't, but the AR92xx chips are one or two chain, so this doesn't
(strictly speaking) need to happen.

For FreeBSD, I'm going to add code to enforce that the configured
chainmask doesn't conflict with the EEPROM chainmask, in case people
try to do stupid things.

Thanks,

Adrian


On 20 January 2013 12:55, Felix Fietkau <nbd@openwrt.org> wrote:
> Chain swapping should only be enabled when the EEPROM chainmask is set to 5,
> regardless of what the runtime chainmask is.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c | 25 ++++++-------------------
>  1 file changed, 6 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 8290edd..3afc24b 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -588,30 +588,17 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
>
>  void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
>  {
> -       switch (rx) {
> -       case 0x5:
> +       if (ah->caps.tx_chainmask == 5 || ah->caps.rx_chainmask == 5)
>                 REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
>                             AR_PHY_SWAP_ALT_CHAIN);
> -       case 0x3:
> -       case 0x1:
> -       case 0x2:
> -       case 0x7:
> -               REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
> -               REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
> -               break;
> -       default:
> -               break;
> -       }
> +
> +       REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
> +       REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
>
>         if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
> -               REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
> -       else
> -               REG_WRITE(ah, AR_SELFGEN_MASK, tx);
> +               tx = 3;
>
> -       if (tx == 0x5) {
> -               REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
> -                           AR_PHY_SWAP_ALT_CHAIN);
> -       }
> +       REG_WRITE(ah, AR_SELFGEN_MASK, tx);
>  }
>
>  /*
> --
> 1.8.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
