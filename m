Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EBDC282DF
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 01:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C3FC20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 01:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="INCFqXG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfDHBb2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Apr 2019 21:31:28 -0400
Received: from vps.xff.cz ([195.181.215.36]:48768 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbfDHBb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Apr 2019 21:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554687084; bh=NXl+t2nMVmJm864zGj/Rwn3yI5gstNPEbnRkBMnxNOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=INCFqXG+pVkDfq9KNQ6q9PPzWZPzHl44jzTaFwxv8Ll8NbTywUclqj+63QDQT+T/2
         THt8810rUP8LZ8r7EW0CsRrBZpFmFVr1At6HOBVDwm4NmyrMaDcbcO9DsvKyWVmA5B
         7tij9SIiid05ohHLv0YI6QVkItV0ojKrraA+ONvc=
Date:   Mon, 8 Apr 2019 03:31:24 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        David Airlie <airlied@linux.ie>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        brcm80211-dev-list@cypress.com, Jose Abreu <joabreu@synopsys.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        devicetree@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-gpio@vger.kernel.org, Wright Feng <wright.feng@cypress.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel@lists.infradead.org,
        Franky Lin <franky.lin@broadcom.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/12] pinctrl: sunxi: Support I/O bias voltage setting
 on H6
Message-ID: <20190408013124.y7rvhmmwsqw3i2mz@core.my.home>
Mail-Followup-To: linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        David Airlie <airlied@linux.ie>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        brcm80211-dev-list@cypress.com, Jose Abreu <joabreu@synopsys.com>,
        Naveen Gupta <naveen.gupta@cypress.com>, devicetree@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-gpio@vger.kernel.org, Wright Feng <wright.feng@cypress.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel@lists.infradead.org,
        Franky Lin <franky.lin@broadcom.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-11-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190405234514.6183-11-megous@megous.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 06, 2019 at 01:45:12AM +0200, verejna wrote:
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

I'll drop this logging in v2. I forgot it here, after testing the patch.

	o.

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
>  
>  struct sunxi_desc_function {
>  	unsigned long	variant;
> -- 
> 2.21.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
