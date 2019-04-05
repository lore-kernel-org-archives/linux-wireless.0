Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C95C282CE
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1810320700
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 23:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="Ob/lnvjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfDEXwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 19:52:14 -0400
Received: from vps.xff.cz ([195.181.215.36]:53656 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfDEXvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 19:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554507920; bh=/RoD9OslD/yH1LdQ1birMG0d1kCxzgoTgbE7QUS3/ao=;
        h=From:To:Cc:Subject:Date:From;
        b=Ob/lnvjyHnDCHFdGL4m9OAOCZQ+hTOU0LtDUeDDCOCxSTXdVumlPR+1Lj241Sk+pq
         wmXkz4DjC9lr1l9VAswR2aYVPinTak6n4kEm/mnUg3rujq9xxxDUkaM7Rx6sqX3/rz
         3xb02Cr1CIYuPZzZLx14lJAIOHvaThXuE23Pvw+g=
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
Subject: [PATCH 00/12] Add support for Orange Pi 3
Date:   Sat,  6 Apr 2019 01:45:02 +0200
Message-Id: <20190405234514.6183-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

This series implements support for Xunlong Orange Pi 3 board.

Unfortunately, this board needs some small driver patches, so I have
split the boards DT patch into chunks that require patches for drivers
in various subsystems:

- Basic DT for the board  (patch 1)
- HDMI support            (patches 2, 3, 4)
- Ethernet support        (patches 5, 6, 7)
- WiFi support            (patches 8, 9, 10, 11, 12)

This patch is also needed to not get segfault on boot: 
  https://lkml.org/lkml/2019/4/5/856

Please take a look.

regards,
  Ondrej Jirman

Icenowy Zheng (2):
  net: stmmac: sun8i: add support for Allwinner H6 EMAC
  net: stmmac: sun8i: force select external PHY when no internal one

Ondrej Jirman (10):
  arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
  drm: sun4i: Add support for enabling DDC I2C bus to dw_hdmi glue
  dt-bindings: display: sun4i-drm: Add DDC power supply
  arm64: dts: allwinner: orange-pi-3: Enable HDMI output
  arm64: dts: allwinner: orange-pi-3: Enable ethernet
  arm64: dts: allwinner: h6: Add MMC1 pins
  pinctrl: sunxi: Prepare for alternative bias voltage setting methods
  pinctrl: sunxi: Support I/O bias voltage setting on H6
  brcmfmac: Loading the correct firmware for brcm43456
  arm64: dts: allwinner: orange-pi-3: Enable WiFi

 .../bindings/display/sunxi/sun4i-drm.txt      |   1 +
 arch/arm64/boot/dts/allwinner/Makefile        |   1 +
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 339 ++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   9 +
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         |  17 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  22 ++
 .../broadcom/brcm80211/brcmfmac/sdio.c        |   4 +-
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c     |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c         |  50 ++-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h         |   7 +-
 12 files changed, 433 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts

-- 
2.21.0

