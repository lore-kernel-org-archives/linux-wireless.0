Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D0CC10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28D4420818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="SC6T5zFH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfDKKUk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:20:40 -0400
Received: from vps.xff.cz ([195.181.215.36]:48608 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfDKKUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977997; bh=6VLGBninVYhLf3SKuzVOvcFENaFxMRjZ/uyrW9t0ZFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SC6T5zFHak+HH758QTiX/0XdsteacPTzOO0BLxDh/pqZwl943jaz3s/nZICaiTPmp
         UkO0sF/Ggir//tPrEm1F3Wx6h3TSe4UAebDkyUgVgGFr3xRZIjJQ5jzdV5yQuq4d1d
         VNeQqNnGcT1QRDYPHwQQd/NG8lV2XqN/r0+csXWA=
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
Subject: [PATCH v3 07/11] drm: sun4i: Add support for enabling DDC I2C bus power to dw_hdmi glue
Date:   Thu, 11 Apr 2019 12:19:47 +0200
Message-Id: <20190411101951.30223-8-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Orange Pi 3 board requires enabling DDC I2C bus via some GPIO connected
transistors, before the bus can be used.

Model this as a power supply for DDC bus on the HDMI connector connected
to the output port (port 1) of the HDMI controller.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 60 ++++++++++++++++++++++++++-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h |  2 +
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 39d8509d96a0..1b6ffba41177 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -98,6 +98,30 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
 	return crtcs;
 }
 
+static int sun8i_dw_hdmi_find_connector_pdev(struct device *dev,
+					     struct platform_device **pdev_out)
+{
+	struct platform_device* pdev;
+	struct device_node *remote;
+
+	remote = of_graph_get_remote_node(dev->of_node, 1, -1);
+	if (!remote)
+		return -ENODEV;
+
+	if (!of_device_is_compatible(remote, "hdmi-connector")) {
+		of_node_put(remote);
+		return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(remote);
+	of_node_put(remote);
+	if (!pdev)
+		return -ENODEV;
+
+	*pdev_out = pdev;
+	return 0;
+}
+
 static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 			      void *data)
 {
@@ -151,16 +175,34 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		return PTR_ERR(hdmi->regulator);
 	}
 
+	ret = sun8i_dw_hdmi_find_connector_pdev(dev, &hdmi->connector_pdev);
+	if (!ret) {
+		hdmi->ddc_regulator = regulator_get(&hdmi->connector_pdev->dev, "ddc");
+		if (IS_ERR(hdmi->ddc_regulator)) {
+			platform_device_put(hdmi->connector_pdev);
+			dev_err(dev, "Couldn't get ddc regulator\n");
+			return PTR_ERR(hdmi->ddc_regulator);
+		}
+	}
+
 	ret = regulator_enable(hdmi->regulator);
 	if (ret) {
 		dev_err(dev, "Failed to enable regulator\n");
-		return ret;
+		goto err_unref_ddc_regulator;
+	}
+
+	if (hdmi->ddc_regulator) {
+		ret = regulator_enable(hdmi->ddc_regulator);
+		if (ret) {
+			dev_err(dev, "Failed to enable ddc regulator\n");
+			goto err_disable_regulator;
+		}
 	}
 
 	ret = reset_control_deassert(hdmi->rst_ctrl);
 	if (ret) {
 		dev_err(dev, "Could not deassert ctrl reset control\n");
-		goto err_disable_regulator;
+		goto err_disable_ddc_regulator;
 	}
 
 	ret = clk_prepare_enable(hdmi->clk_tmds);
@@ -213,8 +255,15 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 	clk_disable_unprepare(hdmi->clk_tmds);
 err_assert_ctrl_reset:
 	reset_control_assert(hdmi->rst_ctrl);
+err_disable_ddc_regulator:
+	if (hdmi->ddc_regulator)
+		regulator_disable(hdmi->ddc_regulator);
 err_disable_regulator:
 	regulator_disable(hdmi->regulator);
+err_unref_ddc_regulator:
+	if (hdmi->ddc_regulator)
+		regulator_put(hdmi->ddc_regulator);
+	platform_device_put(hdmi->connector_pdev);
 
 	return ret;
 }
@@ -229,6 +278,13 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
 	regulator_disable(hdmi->regulator);
+
+	if (hdmi->ddc_regulator) {
+		regulator_disable(hdmi->ddc_regulator);
+		regulator_put(hdmi->ddc_regulator);
+	}
+
+	platform_device_put(hdmi->connector_pdev);
 }
 
 static const struct component_ops sun8i_dw_hdmi_ops = {
diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
index 720c5aa8adc1..60f5200aee73 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -188,8 +188,10 @@ struct sun8i_dw_hdmi {
 	struct sun8i_hdmi_phy		*phy;
 	struct dw_hdmi_plat_data	plat_data;
 	struct regulator		*regulator;
+	struct regulator		*ddc_regulator;
 	const struct sun8i_dw_hdmi_quirks *quirks;
 	struct reset_control		*rst_ctrl;
+	struct platform_device		*connector_pdev;
 };
 
 static inline struct sun8i_dw_hdmi *
-- 
2.21.0

