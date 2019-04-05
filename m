Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377A6C282CE
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F9D20700
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="Vdywhg2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfDEXvt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 19:51:49 -0400
Received: from vps.xff.cz ([195.181.215.36]:53662 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfDEXvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 19:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554507922; bh=g7ekrFktYb/u2XNA4S7sLVfjVJZ1r8B0jkp+qyuXKEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vdywhg2oduEzZOSmd83SRokQOx3H1JVCVuuB3RLE9N89S7MZcnWeaLizonwnvlpg3
         oL3nnUzJLzAaOXwRGMbBNO8XWNdSy/+FCHMawmOSwl/ZtawJx5oCbPwbUEuarPMq0u
         wNro3RhJYERSrCUeG77eA9HP7+TuNGF07hscEImE=
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
Subject: [PATCH 03/12] dt-bindings: display: sun4i-drm: Add DDC power supply
Date:   Sat,  6 Apr 2019 01:45:05 +0200
Message-Id: <20190405234514.6183-4-megous@megous.com>
In-Reply-To: <20190405234514.6183-1-megous@megous.com>
References: <20190405234514.6183-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Some Allwinner SoC using boards need to enable a regulator
for the DDC bus to be usable.

Add binding documentation for it.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 Documentation/devicetree/bindings/display/sunxi/sun4i-drm.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/display/sunxi/sun4i-drm.txt b/Documentation/devicetree/bindings/display/sunxi/sun4i-drm.txt
index 31ab72cba3d4..31474fb92313 100644
--- a/Documentation/devicetree/bindings/display/sunxi/sun4i-drm.txt
+++ b/Documentation/devicetree/bindings/display/sunxi/sun4i-drm.txt
@@ -104,6 +104,7 @@ Required properties:
     output, usually to an HDMI connector.
 
 Optional properties:
+  - ddc-supply: the VCC power supply for the DDC bus
   - hvcc-supply: the VCC power supply of the controller
 
 DWC HDMI PHY
-- 
2.21.0

