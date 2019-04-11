Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196C2C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE53920818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="UZ/3N3NX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfDKKVO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:21:14 -0400
Received: from vps.xff.cz ([195.181.215.36]:48474 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbfDKKT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977996; bh=//Y9g6FyC9JeT0oJjFckG39umOxcy3nQRVaTbv9yQdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ/3N3NXudgSWaEaZ1WVknpjen7QYUsm4mZNrs58RmLQ18Ej7tvtbPgC6oq7sKny9
         2XVrvVT34Wjo64BNOwZHuiV6o+DGFfcFQ7O1PdrXXffByd+rm0l/veBWY4GstRbEYN
         c9wniYueWtPlirCLW3VcFr3X1C3sR8EDNRzkeANc=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Ondrej Jirman <megous@megous.com>, David Airlie <airlied@linux.ie>,
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
Subject: [PATCH v3 04/11] pinctrl: sunxi: Support I/O bias voltage setting on H6
Date:   Thu, 11 Apr 2019 12:19:44 +0200
Message-Id: <20190411101951.30223-5-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

H6 SoC has a "pio group withstand voltage mode" register (datasheet
description), that needs to be used to select either 1.8V or 3.3V I/O mode,
based on what voltage is powering the respective pin banks and is thus used
for I/O signals.

Add support for configuring this register according to the voltage of the
pin bank regulator (if enabled).

This is similar to the support for I/O bias voltage setting patch for A80
and the same concerns apply. See:

  commit 402bfb3c1352 ("Support I/O bias voltage setting on A80")

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c |  1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 11 +++++++++++
 drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  5 +++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
index ef4268cc6227..3cc1121589c9 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c
@@ -591,6 +591,7 @@ static const struct sunxi_pinctrl_desc h6_pinctrl_data = {
 	.irq_banks = 4,
 	.irq_bank_map = h6_irq_bank_map,
 	.irq_read_needs_mux = true,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_SEL,
 };
 
 static int h6_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 98c4de5f4019..0cbca30b75dc 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -614,6 +614,8 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 					 unsigned pin,
 					 struct regulator *supply)
 {
+	unsigned short bank = pin / PINS_PER_BANK;
+	unsigned long flags;
 	u32 val, reg;
 	int uV;
 
@@ -651,6 +653,15 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		reg &= ~IO_BIAS_MASK;
 		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
 		return 0;
+	case BIAS_VOLTAGE_PIO_POW_MODE_SEL:
+		val = uV <= 1800000 ? 1 : 0;
+
+		raw_spin_lock_irqsave(&pctl->lock, flags);
+		reg = readl(pctl->membase + PIO_POW_MOD_SEL_REG);
+		reg &= ~(1 << bank);
+		writel(reg | val << bank, pctl->membase + PIO_POW_MOD_SEL_REG);
+		raw_spin_unlock_irqrestore(&pctl->lock, flags);
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index 4bfc8a6d9dce..36186906f0a7 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -95,11 +95,16 @@
 #define PINCTRL_SUN7I_A20	BIT(7)
 #define PINCTRL_SUN8I_R40	BIT(8)
 
+#define PIO_POW_MOD_SEL_REG	0x340
+
 enum sunxi_desc_bias_voltage {
 	BIAS_VOLTAGE_NONE,
 	/* Bias voltage configuration is done through
 	 * Pn_GRP_CONFIG registers, as seen on A80 SoC. */
 	BIAS_VOLTAGE_GRP_CONFIG,
+	/* Bias voltage is set through PIO_POW_MOD_SEL_REG
+	 * register, as seen on H6 SoC, for example. */
+	BIAS_VOLTAGE_PIO_POW_MODE_SEL,
 };
 
 struct sunxi_desc_function {
-- 
2.21.0

