Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A51EC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B06206C0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbfDIIoB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:44:01 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:43921 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfDIIoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:44:01 -0400
Received: from localhost (aaubervilliers-681-1-89-125.w90-88.abo.wanadoo.fr [90.88.30.125])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id C712D100006;
        Tue,  9 Apr 2019 08:43:51 +0000 (UTC)
Date:   Tue, 9 Apr 2019 10:43:51 +0200
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
Subject: Re: [PATCH v2 05/13] pinctrl: sunxi: Prepare for alternative bias
 voltage setting methods
Message-ID: <20190409084351.blyvkg47tjbjxwde@flea>
References: <20190409002452.14551-1-megous@megous.com>
 <20190409002452.14551-6-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="56xgcpawz766jjoo"
Content-Disposition: inline
In-Reply-To: <20190409002452.14551-6-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--56xgcpawz766jjoo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Apr 09, 2019 at 02:24:44AM +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
>
> H6 has a different I/O voltage bias setting method than A80. Prepare
> existing code for using alternative bias voltage setting methods.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c |  2 +-
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 41 +++++++++++++----------
>  drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  5 ++-
>  3 files changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
> index da37d594a13d..3aa210079b18 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
> +++ b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
> @@ -722,7 +722,7 @@ static const struct sunxi_pinctrl_desc sun9i_a80_pinctrl_data = {
>  	.npins = ARRAY_SIZE(sun9i_a80_pins),
>  	.irq_banks = 5,
>  	.disable_strict_mode = true,
> -	.has_io_bias_cfg = true,
> +	.io_bias_cfg_variant = IO_BIAS_CFG_V1,
>  };
>
>  static int sun9i_a80_pinctrl_probe(struct platform_device *pdev)
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> index 8dd25caea2cf..b8dd58ef33b7 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
> @@ -610,7 +610,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
>  	u32 val, reg;
>  	int uV;
>
> -	if (!pctl->desc->has_io_bias_cfg)
> +	if (!pctl->desc->io_bias_cfg_variant)
>  		return 0;
>
>  	uV = regulator_get_voltage(supply);
> @@ -621,23 +621,28 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
>  	if (uV == 0)
>  		return 0;
>
> -	/* Configured value must be equal or greater to actual voltage */
> -	if (uV <= 1800000)
> -		val = 0x0; /* 1.8V */
> -	else if (uV <= 2500000)
> -		val = 0x6; /* 2.5V */
> -	else if (uV <= 2800000)
> -		val = 0x9; /* 2.8V */
> -	else if (uV <= 3000000)
> -		val = 0xA; /* 3.0V */
> -	else
> -		val = 0xD; /* 3.3V */
> -
> -	pin -= pctl->desc->pin_base;
> -
> -	reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
> -	reg &= ~IO_BIAS_MASK;
> -	writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
> +	if (pctl->desc->io_bias_cfg_variant == IO_BIAS_CFG_V1) {
> +		/*
> +		 * Configured value must be equal or greater to actual
> +		 * voltage.
> +		 */
> +		if (uV <= 1800000)
> +			val = 0x0; /* 1.8V */
> +		else if (uV <= 2500000)
> +			val = 0x6; /* 2.5V */
> +		else if (uV <= 2800000)
> +			val = 0x9; /* 2.8V */
> +		else if (uV <= 3000000)
> +			val = 0xA; /* 3.0V */
> +		else
> +			val = 0xD; /* 3.3V */
> +
> +		pin -= pctl->desc->pin_base;
> +
> +		reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
> +		reg &= ~IO_BIAS_MASK;
> +		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
> +	}
>
>  	return 0;
>  }
> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> index ee15ab067b5f..642f667e99d2 100644
> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
> @@ -95,6 +95,9 @@
>  #define PINCTRL_SUN7I_A20	BIT(7)
>  #define PINCTRL_SUN8I_R40	BIT(8)
>
> +/* Bias voltage configuration done via Pn_GRP_CONFIG registers. */
> +#define IO_BIAS_CFG_V1		1
> +

Can we turn this into an enum, and give them proper name? Mentionning
an example in the commit would be great too.

Something like:

enum sunxi_desc_bias_voltage {
        /* Bias Voltage configuration is done through Pn_GRP_CONFIG registers, as seen on the A83t */
	BIAS_VOLTAGE_GRP_CONFIG,
};

etc.

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--56xgcpawz766jjoo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXKxbRwAKCRDj7w1vZxhR
xeaZAQDdcObvBXJGqx+5c2yDDZ/BRZDxHZ7AwgeemSZV8lsHgAD/fDqf3WSJQn7q
fsSgPVLlNkihJdSMVpkdwzbozfMMjA8=
=L+SO
-----END PGP SIGNATURE-----

--56xgcpawz766jjoo--
