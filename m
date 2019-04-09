Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1866FC10F13
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F8C20883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="DO5FDGeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfDIAZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:25:08 -0400
Received: from vps.xff.cz ([195.181.215.36]:36190 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfDIAZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 20:25:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554769499; bh=JpGB1j4bKjS5JKZ8a+EeovxzVXl5mm5N0cUQvx+o8l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO5FDGeY4ss5t7xhkKEehGZ8v01iNEP3Whizwp4WVG4HebkxKNElYBRh1bx75XYuj
         B1M36DfUw1hRE+ZDfi0HweF0RgBkSDQATghyDnEbHSbngiaBB/L9pFRU9H/2mjvvbC
         chDD3Fga5Akr4Cn/hEcasRSNCNkz9bl8IxW5DUFk=
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
Subject: [PATCH v2 05/13] pinctrl: sunxi: Prepare for alternative bias voltage setting methods
Date:   Tue,  9 Apr 2019 02:24:44 +0200
Message-Id: <20190409002452.14551-6-megous@megous.com>
In-Reply-To: <20190409002452.14551-1-megous@megous.com>
References: <20190409002452.14551-1-megous@megous.com>
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
 drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 41 +++++++++++++----------
 drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  5 ++-
 3 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
index da37d594a13d..3aa210079b18 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c
@@ -722,7 +722,7 @@ static const struct sunxi_pinctrl_desc sun9i_a80_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun9i_a80_pins),
 	.irq_banks = 5,
 	.disable_strict_mode = true,
-	.has_io_bias_cfg = true,
+	.io_bias_cfg_variant = IO_BIAS_CFG_V1,
 };
 
 static int sun9i_a80_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 8dd25caea2cf..b8dd58ef33b7 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -610,7 +610,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 	u32 val, reg;
 	int uV;
 
-	if (!pctl->desc->has_io_bias_cfg)
+	if (!pctl->desc->io_bias_cfg_variant)
 		return 0;
 
 	uV = regulator_get_voltage(supply);
@@ -621,23 +621,28 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
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
+	if (pctl->desc->io_bias_cfg_variant == IO_BIAS_CFG_V1) {
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
+	}
 
 	return 0;
 }
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index ee15ab067b5f..642f667e99d2 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -95,6 +95,9 @@
 #define PINCTRL_SUN7I_A20	BIT(7)
 #define PINCTRL_SUN8I_R40	BIT(8)
 
+/* Bias voltage configuration done via Pn_GRP_CONFIG registers. */
+#define IO_BIAS_CFG_V1		1
+
 struct sunxi_desc_function {
 	unsigned long	variant;
 	const char	*name;
@@ -117,7 +120,7 @@ struct sunxi_pinctrl_desc {
 	const unsigned int		*irq_bank_map;
 	bool				irq_read_needs_mux;
 	bool				disable_strict_mode;
-	bool				has_io_bias_cfg;
+	int				io_bias_cfg_variant;
 };
 
 struct sunxi_pinctrl_function {
-- 
2.21.0

