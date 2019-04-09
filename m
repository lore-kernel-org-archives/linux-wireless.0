Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A728C10F13
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC2CC20883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 00:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="QMEK3GyT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfDIAZB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:25:01 -0400
Received: from vps.xff.cz ([195.181.215.36]:35922 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfDIAZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 20:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554769497; bh=kTkUEE4b8KfN2+bg+NMY2jHHocg8Jgi0MH//+uZ9Pms=;
        h=From:To:Cc:Subject:Date:From;
        b=QMEK3GyT2a9UbuSHWmgQPnm3SRje+CVi5a11ZIqfocCP0AxDLCr5ilQSg+/cd5jKP
         s9JpuxALHqYyUpCF+Z8+sndfXkm3ZZE92cRv34K7vD3Mwl24gihECNaN+5I3D28o2d
         syLQAiRXlc9bVqyLxtlk5YGoOK6z9Akt+k+o3jJU=
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
Subject: [PATCH v2 00/13] Add support for Orange Pi 3
Date:   Tue,  9 Apr 2019 02:24:39 +0200
Message-Id: <20190409002452.14551-1-megous@megous.com>
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

In v2 of this series I've reordered the patches and I've put less
controversial patches first.

Suggested merging plan/dependencies:

- Basic board dts can work alone. (patches 1-2)
- Pinctrl and stmmac patches are needed for ethernet support.
  (patches 3-7)
- HDMI depends on sorting out how to model DDC voltage shifter
  in DT, which is not clear yet. (patches 8-10)
- WiFi stuff will have to wait for H6 RTC patches, which in turn
  depend on ChenYu's RTC series, to be merged. That will take a
  while yet. I'm just keeping them in the series for completness.
  (patches 11-13)

This patch is also needed to not get segfault on boot (it was already
merged a day ago or so): 
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

Open questions ATM:
- should mmc1_pins be default pinconf for mmc1?
- how to model DDC IO voltage shifter enable signal for HDMI? (it's not
  really a power supply, but it's modelled as one in the patches for now)


Please take a look.

thank you and regards,
  Ondrej Jirman

Icenowy Zheng (2):
  net: stmmac: sun8i: add support for Allwinner H6 EMAC
  net: stmmac: sun8i: force select external PHY when no internal one

Ondrej Jirman (11):
  dt-bindings: sunxi: Add compatible for OrangePi 3 board
  arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
  pinctrl: sunxi: Prepare for alternative bias voltage setting methods
  pinctrl: sunxi: Support I/O bias voltage setting on H6
  arm64: dts: allwinner: orange-pi-3: Enable ethernet
  drm: sun4i: Add support for enabling DDC I2C bus to dw_hdmi glue
  dt-bindings: display: sun4i-drm: Add DDC power supply
  arm64: dts: allwinner: orange-pi-3: Enable HDMI output
  brcmfmac: Loading the correct firmware for brcm43456
  [DO NOT MERGE] arm64: dts: allwinner: h6: Add MMC1 pins
  [DO NOT MERGE] arm64: dts: allwinner: orange-pi-3: Enable WiFi

 .../devicetree/bindings/arm/sunxi.yaml        |   5 +
 .../bindings/display/sunxi/sun4i-drm.txt      |   1 +
 arch/arm64/boot/dts/allwinner/Makefile        |   1 +
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 343 ++++++++++++++++++
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   8 +
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         |  17 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  21 ++
 .../broadcom/brcm80211/brcmfmac/sdio.c        |   4 +-
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c     |   2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c         |  49 ++-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h         |   9 +-
 13 files changed, 441 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts

-- 
2.21.0

