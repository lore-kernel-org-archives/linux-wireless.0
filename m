Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBECC282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058F7208E3
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 07:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfDHHmc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:42:32 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:51895 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfDHHmb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 03:42:31 -0400
X-Originating-IP: 90.88.30.125
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 7D03E1BF20F;
        Mon,  8 Apr 2019 07:42:23 +0000 (UTC)
Date:   Mon, 8 Apr 2019 09:42:22 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 10/12] pinctrl: sunxi: Support I/O bias voltage setting
 on H6
Message-ID: <20190408074222.ksyxorajs6goowmf@flea>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-11-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v4lezedvh2vii7fg"
Content-Disposition: inline
In-Reply-To: <20190405234514.6183-11-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--v4lezedvh2vii7fg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 06, 2019 at 01:45:12AM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
>
> H6 SoC has a "pio group withstand voltage mode" register (datasheet
> description), that needs to be used to select either 1.8V or 3.3V
> I/O mode, based on what voltage is powering the respective pin
> banks and is thus used for I/O signals.
>
> Add support for configuring this register according to the voltage
> of the pin bank regulator (if enabled).
>
> This is similar to the support for I/O bias voltage setting patch
> for A80 and the same concerns apply. (see commit 402bfb3c135213dc
> Support I/O bias voltage setting on A80).
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c |  1 +
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 14 ++++++++++++++
>  drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  3 +++
>  3 files changed, 18 insertions(+)
>
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
> index ef4268cc6227..30b1befa8ed8 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
> +++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
> @@ -591,6 +591,7 @@ static const struct sunxi_pinctrl_desc h6_pinctrl_data = {
>  	.irq_banks = 4,
>  	.irq_bank_map = h6_irq_bank_map,
>  	.irq_read_needs_mux = true,
> +	.io_bias_cfg_variant = IO_BIAS_CFG_V2,
>  };
>
>  static int h6_pinctrl_probe(struct platform_device *pdev)
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> index 9f329fec77cf..59a4ed396d92 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> @@ -607,6 +607,8 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
>  					 unsigned pin,
>  					 struct regulator *supply)
>  {
> +	unsigned short bank = pin / PINS_PER_BANK;
> +	unsigned long flags;
>  	u32 val, reg;
>  	int uV;
>
> @@ -639,6 +641,18 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
>  		reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
>  		reg &= ~IO_BIAS_MASK;
>  		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
> +	} else if (pctl->desc->io_bias_cfg_variant == IO_BIAS_CFG_V2) {
> +		val = uV <= 1800000 ? 1 : 0;
> +
> +		dev_info(pctl->dev,
> +			 "Setting voltage bias to %sV on bank P%c\n",
> +			 val ? "1.8" : "3.3", 'A' + bank);
> +
> +		raw_spin_lock_irqsave(&pctl->lock, flags);
> +		reg = readl(pctl->membase + PIO_POW_MOD_SEL_REG);
> +		reg &= ~(1 << bank);
> +		writel(reg | val << bank, pctl->membase + PIO_POW_MOD_SEL_REG);
> +		raw_spin_unlock_irqrestore(&pctl->lock, flags);
>  	}
>
>  	return 0;
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> index 476772f91dba..3a66376f141b 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> @@ -95,7 +95,10 @@
>  #define PINCTRL_SUN7I_A20	BIT(7)
>  #define PINCTRL_SUN8I_R40	BIT(8)
>
> +#define PIO_POW_MOD_SEL_REG	0x340
> +
>  #define IO_BIAS_CFG_V1		1
> +#define IO_BIAS_CFG_V2		2

Can you document what V1 and V2 means exactly?

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--v4lezedvh2vii7fg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKr7XgAKCRDj7w1vZxhR
xapEAQCWH9HfWZ6/aNAfUpdW6frNrD0g7cn/TZt9VsoUSuXpbAD/VP7jCcNn46+7
TUIA3ewrDthfu+aIwNwpw3KpD1EbhQE=
=GWQk
-----END PGP SIGNATURE-----

--v4lezedvh2vii7fg--
