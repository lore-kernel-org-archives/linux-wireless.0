Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450C7C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1520220818
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 10:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="MhZ0fr/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfDKKT6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:19:58 -0400
Received: from vps.xff.cz ([195.181.215.36]:48320 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDKKT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 06:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554977994; bh=bN0P1L9l1XpY6c48XfUiL8gk+6ngeuIIwHpcEsC+Meo=;
        h=From:To:Cc:Subject:Date:From;
        b=MhZ0fr/ppGOJxv3I3/LxpAIy8Jnzcm/Evm8Xn7CV7SW/q6aX9ewmpw50h9gywEZMl
         WxWHn8n26JlfUD824TMmXqhLVIqkO5Sbc8msbaPqUBC2Fy7sB9VPpROc7geM9lFvRu
         6E+bAZirjliqN4iflerU484zihhqpxc/UdbVu0YI=
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
Subject: [PATCH v3 00/11] Add support for Orange Pi 3
Date:   Thu, 11 Apr 2019 12:19:40 +0200
Message-Id: <20190411101951.30223-1-megous@megous.com>
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
in various subsystems.

Suggested merging plan/dependencies:

- Pinctrl and stmmac patches are needed for ethernet support.
  (patches 1-5)
- HDMI support was changed, please review. (patches 6-8)
- brcmfmac patch 9, fixing firmware file selection, can be merged
  now, after review, as it doesn't depend on anything (please
  review :))
- mmc1 pinconf (patch 10) can probably be merged now, too (it will
  certainly be used soon by all the other WiFi featuring boards
  based on H6)
- WiFi dts patch will have to wait for H6 RTC patches, which in turn
  depend on ChenYu's RTC series, to be merged. That will take a
  while yet. I'm just keeping it in the series for completness.
  (patch 11)

This patch is also needed to not get segfault on boot (it was already
merged): 
  https://lkml.org/lkml/2019/4/5/856

Changes in v2:
- added dt-bindings documentation for the board's compatible string
  (suggested by Clement)
- addressed checkpatch warnings and code formatting issues (on Maxime's
  suggestions)
- stmmac: dropped useless parenthesis, reworded description of the patch
  (suggested by Sergei)
- drop useles dev_info() about the selected io bias voltage
- docummented io voltage bias selection variant macros
- wifi: marked WiFi DTS patch and realted mmc1_pins as "DO NOT MERGE",
  because wifi depends on H6 RTC support that's not merged yet (suggested
  by Clement)
- added missing signed-of-bys
- changed &usb2otg dr_mode to otg, and added a note about VBUS
- improved wording of HDMI driver's DDC power supply patch

Changes in v3:
- dropped already applied patches
- changed pinctrl I/O bias selection constants to enum and renamed
- added /omit-if-no-ref/ to mmc1_pins
- made mmc1_pins default pinconf for mmc1 in H6 dtsi
- move ddc-supply to HDMI connector node, updated patch descriptions,
  changed dt-bindings docs

Please take a look.

thank you and regards,
  Ondrej Jirman

Icenowy Zheng (2):
  net: stmmac: sun8i: add support for Allwinner H6 EMAC
  net: stmmac: sun8i: force select external PHY when no internal one

Ondrej Jirman (9):
  pinctrl: sunxi: Prepare for alternative bias voltage setting methods
  pinctrl: sunxi: Support I/O bias voltage setting on H6
  arm64: dts: allwinner: orange-pi-3: Enable ethernet
  dt-bindings: display: hdmi-connector: Add DDC power supply
  drm: sun4i: Add support for enabling DDC I2C bus power to dw_hdmi glue
  arm64: dts: allwinner: orange-pi-3: Enable HDMI output
  brcmfmac: Loading the correct firmware for brcm43456
  arm64: dts: allwinner: h6: Add MMC1 pins
  [DO NOT MERGE] arm64: dts: allwinner: orange-pi-3: Enable WiFi

 .../display/connector/hdmi-connector.txt      |   1 +
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 127 ++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |  11 ++
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         |  60 ++++++++-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  21 +++
 .../broadcom/brcm80211/brcmfmac/sdio.c        |   4 +-
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c     |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c         |  56 +++++---
 drivers/pinctrl/sunxi/pinctrl-sunxi.h         |  14 +-
 11 files changed, 275 insertions(+), 24 deletions(-)

-- 
2.21.0

