Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34587 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1BOTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:00:36 -0500
Date: Tue, 15 Feb 2011 13:58:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com,
	Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
Message-ID: <20110215185810.GH2557@tuxdriver.com>
References: <AANLkTi=6jVGZx0oQdMQmndCB9k_xPywfntsB1LS_4ekM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=6jVGZx0oQdMQmndCB9k_xPywfntsB1LS_4ekM@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 09:49:24PM +0300, Nikolay Ledovskikh wrote:
> This patch fixes seqfault on ar2316 and other AHB based chips.
> (I don't know why it's not in archives)
> 
> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/
> ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index 707cde1..35d5273 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -34,7 +34,7 @@ static void ath5k_ahb_read_cachesize(struct ath_common
> *common, int *csz)
>  bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
>  {
>      struct ath5k_softc *sc = common->priv;
> -    struct platform_device *pdev = to_platform_device(sc->dev);
> +    struct platform_device *pdev =
> to_platform_device(wiphy_dev(sc->hw->wiphy));
>      struct ar231x_board_config *bcfg = pdev->dev.platform_data;
>      u16 *eeprom, *eeprom_end;
> 

Please use a mailer that doesn't do whitespace damage to patches --
I'll never live long enough to make-up for the time I've already
spent fixing-up broken patches...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
