Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17D9C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 993C820818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="rShVtDlm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfDKKUl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:20:41 -0400
Received: from vps.xff.cz ([195.181.215.36]:48598 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfDKKUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977997; bh=5oK+hUHvbPopzw2Jlb3qkR0ZnXTFnDc3XhhaDlcdJng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rShVtDlmYfsIffqn52CiTS0aaDYBAlJANuq/YRzukRqIi6d1SHXabea4uVW760pay
         pRvWPTfEPjc35EVA0vxz1Z3ShtAi/MtrfsKdGGcO1IIzWgcFL5whEH8Ecyyg5cPrNY
         BG6r3ulcBnlaCmXGbi7JFMwfMelCwQkTqSPPcVyY=
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
Subject: [PATCH v3 06/11] dt-bindings: display: hdmi-connector: Add DDC power supply
Date:   Thu, 11 Apr 2019 12:19:46 +0200
Message-Id: <20190411101951.30223-7-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
References: <20190411101951.30223-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Some Allwinner SoC using boards (Orange Pi 3 for example) need to enable
on-board voltage shifting logic for the DDC bus to be usable. Use
ddc-supply on the hdmi-connector to model this.

Add binding documentation for optional ddc-supply property.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../devicetree/bindings/display/connector/hdmi-connector.txt     | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt b/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
index 508aee461e0d..33085aeb0bb9 100644
--- a/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
+++ b/Documentation/devicetree/bindings/display/connector/hdmi-connector.txt
@@ -9,6 +9,7 @@ Optional properties:
 - label: a symbolic name for the connector
 - hpd-gpios: HPD GPIO number
 - ddc-i2c-bus: phandle link to the I2C controller used for DDC EDID probing
+- ddc-supply: the power supply for the DDC bus
 
 Required nodes:
 - Video port for HDMI input
-- 
2.21.0

