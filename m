Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AAEC10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E712E20818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="jj4C1apl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDKKV1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:21:27 -0400
Received: from vps.xff.cz ([195.181.215.36]:48438 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfDKKT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977995; bh=DdOJz/KUHvzyoOqY/X/p8VGDaZGkFFOEFng4t6EKayc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj4C1aplFLTIhC+zesYBGtAgQarcYkxVN/3bdGBb6on/rJ3BytYOg8T5nHOIR2me7
         ZxiqsSpiAQVKG1AmXYY6PB4+mjxspzXnWHLQL9icIf2jA8uDt22aUXsFxAaipBRG9i
         8idxt9JEfJYf62x2x7cTjCFf0c3K4NJugm1yl4GQ=
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
Subject: [PATCH v3 03/11] pinctrl: sunxi: Prepare for alternative bias voltage setting methods
Date:   Thu, 11 Apr 2019 12:19:43 +0200
Message-Id: <20190411101951.30223-4-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

H6 has a different I/O voltage bias setting method than A80. Prepare
existing code for using alternative bias voltage setting methods.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c |  2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 47 +++++++++++++----------
 drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  9 ++++-
 3 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
index da37d594a13d..0633a03d5e13 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
@@ -722,7 +722,7 @@ static const struct sunxi_pinctrl_desc sun9i_a80_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun9i_a80_pins),
 	.irq_banks = 5,
 	.disable_strict_mode = true,
-	.has_io_bias_cfg = true,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_GRP_CONFIG,
 };
 
 static int sun9i_a80_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index be04223591d4..98c4de5f4019 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -617,7 +617,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 	u32 val, reg;
 	int uV;
 
-	if (!pctl->desc->has_io_bias_cfg)
+	if (!pctl->desc->io_bias_cfg_variant)
 		return 0;
 
 	uV = regulator_get_voltage(supply);
@@ -628,25 +628,32 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 	if (uV == 0)
 		return 0;
 
-	/* Configured value must be equal or greater to actual voltage */
-	if (uV <= 1800000)
-		val = 0x0; /* 1.8V */
-	else if (uV <= 2500000)
-		val = 0x6; /* 2.5V */
-	else if (uV <= 2800000)
-		val = 0x9; /* 2.8V */
-	else if (uV <= 3000000)
-		val = 0xA; /* 3.0V */
-	else
-		val = 0xD; /* 3.3V */
-
-	pin -= pctl->desc->pin_base;
-
-	reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
-	reg &= ~IO_BIAS_MASK;
-	writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
-
-	return 0;
+	switch (pctl->desc->io_bias_cfg_variant) {
+	case BIAS_VOLTAGE_GRP_CONFIG:
+		/*
+		 * Configured value must be equal or greater to actual
+		 * voltage.
+		 */
+		if (uV <= 1800000)
+			val = 0x0; /* 1.8V */
+		else if (uV <= 2500000)
+			val = 0x6; /* 2.5V */
+		else if (uV <= 2800000)
+			val = 0x9; /* 2.8V */
+		else if (uV <= 3000000)
+			val = 0xA; /* 3.0V */
+		else
+			val = 0xD; /* 3.3V */
+
+		pin -= pctl->desc->pin_base;
+
+		reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
+		reg &= ~IO_BIAS_MASK;
+		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static int sunxi_pmx_get_funcs_cnt(struct pinctrl_dev *pctldev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index ee15ab067b5f..4bfc8a6d9dce 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -95,6 +95,13 @@
 #define PINCTRL_SUN7I_A20	BIT(7)
 #define PINCTRL_SUN8I_R40	BIT(8)
 
+enum sunxi_desc_bias_voltage {
+	BIAS_VOLTAGE_NONE,
+	/* Bias voltage configuration is done through
+	 * Pn_GRP_CONFIG registers, as seen on A80 SoC. */
+	BIAS_VOLTAGE_GRP_CONFIG,
+};
+
 struct sunxi_desc_function {
 	unsigned long	variant;
 	const char	*name;
@@ -117,7 +124,7 @@ struct sunxi_pinctrl_desc {
 	const unsigned int		*irq_bank_map;
 	bool				irq_read_needs_mux;
 	bool				disable_strict_mode;
-	bool				has_io_bias_cfg;
+	int				io_bias_cfg_variant;
 };
 
 struct sunxi_pinctrl_function {
-- 
2.21.0

