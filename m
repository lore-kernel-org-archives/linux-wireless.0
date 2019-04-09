Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410F0C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CF5720883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="nKtWc8/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfDIA0P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:26:15 -0400
Received: from vps.xff.cz ([195.181.215.36]:36212 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfDIAZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 20:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554769501; bh=VkQoH6CXHm1XnyYK3skp3BPEyuZWDtRMncNrhU7EJQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKtWc8/E61ajiGcGZpBIZNCU5X4yb8KE9vahtA/sTeMLvt5a7SE6EuJRnM91ypW2V
         OSr6+SuVmvfNZcnvEaDJGib+YIbUiwqFDWVNx7F8re37hTShYYo01xjWZl3M7jcHjT
         AH+5eR0zzPeBOUm279pyPepZXbz4CuPOzFF+8c3A=
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
Subject: [PATCH v2 08/13] drm: sun4i: Add support for enabling DDC I2C bus to dw_hdmi glue
Date:   Tue,  9 Apr 2019 02:24:47 +0200
Message-Id: <20190409002452.14551-9-megous@megous.com>
In-Reply-To: <20190409002452.14551-1-megous@megous.com>
References: <20190409002452.14551-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
transistors, before it can be used. Model this as a power supply for DDC
(via regulator framework).

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 17 ++++++++++++++++-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index dc47720c99ba..a1518525fa2f 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -146,16 +146,28 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		return PTR_ERR(hdmi->regulator);
 	}
 
+	hdmi->ddc_regulator = devm_regulator_get(dev, "ddc");
+	if (IS_ERR(hdmi->ddc_regulator)) {
+		dev_err(dev, "Couldn't get ddc regulator\n");
+		return PTR_ERR(hdmi->ddc_regulator);
+	}
+
 	ret = regulator_enable(hdmi->regulator);
 	if (ret) {
 		dev_err(dev, "Failed to enable regulator\n");
 		return ret;
 	}
 
+	ret = regulator_enable(hdmi->ddc_regulator);
+	if (ret) {
+		dev_err(dev, "Failed to enable ddc regulator\n");
+		goto err_disable_regulator;
+	}
+
 	ret = reset_control_deassert(hdmi->rst_ctrl);
 	if (ret) {
 		dev_err(dev, "Could not deassert ctrl reset control\n");
-		goto err_disable_regulator;
+		goto err_disable_ddc_regulator;
 	}
 
 	ret = clk_prepare_enable(hdmi->clk_tmds);
@@ -208,6 +220,8 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 	clk_disable_unprepare(hdmi->clk_tmds);
 err_assert_ctrl_reset:
 	reset_control_assert(hdmi->rst_ctrl);
+err_disable_ddc_regulator:
+	regulator_disable(hdmi->ddc_regulator);
 err_disable_regulator:
 	regulator_disable(hdmi->regulator);
 
@@ -223,6 +237,7 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	sun8i_hdmi_phy_remove(hdmi);
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
+	regulator_disable(hdmi->ddc_regulator);
 	regulator_disable(hdmi->regulator);
 }
 
diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
index 720c5aa8adc1..6e93d55560b6 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -188,6 +188,7 @@ struct sun8i_dw_hdmi {
 	struct sun8i_hdmi_phy		*phy;
 	struct dw_hdmi_plat_data	plat_data;
 	struct regulator		*regulator;
+	struct regulator		*ddc_regulator;
 	const struct sun8i_dw_hdmi_quirks *quirks;
 	struct reset_control		*rst_ctrl;
 };
-- 
2.21.0

