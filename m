Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:39269 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751409AbdJCRAd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 13:00:33 -0400
From: Icenowy Zheng <icenowy@aosc.io>
To: Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH v3 0/2] Allwinner XR819 SDIO Wi-Fi DT binding and OPi Zero XR819 IRQ
Date: Wed,  4 Oct 2017 00:59:42 +0800
Message-Id: <20171003165944.13056-1-icenowy@aosc.io> (sfid-20171003_190143_205533_662CF974)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Allwinner XR819 SDIO Wi-Fi chip supports an out-of-band interrupt line,
and the in-band interrupt is also supported.

However the current out-of-tree driver uses the out-of-band interrupt by
default.

This patchset adds the device tree binding for the chip as well as the
out-of-band interrupt, then adds the interrupt to the device tree of
Orange Pi Zero.

Icenowy Zheng (1):
  dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi

Sergey Matyukevich (1):
  ARM: sun8i: h2+: specify wifi interrupts for Orange Pi Zero

 .../bindings/net/wireless/allwinner,xr819.txt      | 38 ++++++++++++++++++++++
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts  |  3 ++
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt

-- 
2.13.5
