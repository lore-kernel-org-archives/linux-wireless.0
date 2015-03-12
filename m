Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39084 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbbCLMJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:09:28 -0400
Received: by wiwl15 with SMTP id l15so47088832wiw.4
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 05:09:27 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v6 0/6] wlcore: add device-tree support
Date: Thu, 12 Mar 2015 14:09:08 +0200
Message-Id: <1426162154-8716-1-git-send-email-eliad@wizery.com> (sfid-20150312_130940_057839_FFB9ACF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device-tree support to the wlcore (wl12xx/wl18xx)
driver.

Update the current users to use the bindings instead
of pdata-quirks.

Finally, remove the deprecated wl12xx_platform_data
struct (along with the da850 board file code that
still uses it)

NOTE: all the platform patches were compile-tested
only. I'm looking for some wl12xx card (that i should
have somewhere) to test the wl12xx changes (wrt. clocks),
but haven't found it yet.

v6:
* Add Luca's patches to pass irq_trigger/freq
* Support wl12xx as well
* Update all relevant platforms

Eliad Peller (4):
  dt: bindings: add TI's wilink wireless device
  wlcore: add device-tree support
  ARM: dts: add wl12xx/wl18xx bindings
  wlcore: remove wl12xx_platform_data

Luciano Coelho (2):
  wlcore: set irq_trigger in board files instead of hiding behind a
    quirk
  wl12xx: use frequency instead of enumerations for pdata clocks

 .../devicetree/bindings/net/wireless/ti,wlcore.txt |  47 +++++++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |  11 ++
 arch/arm/boot/dts/omap3-cm-t3517.dts               |  10 ++
 arch/arm/boot/dts/omap3-cm-t3730.dts               |  10 ++
 arch/arm/boot/dts/omap3-evm-common.dtsi            |  10 ++
 arch/arm/boot/dts/omap3-igep0020-rev-f.dts         |   9 ++
 arch/arm/boot/dts/omap3-igep0030-rev-g.dts         |   9 ++
 arch/arm/boot/dts/omap3-zoom3.dts                  |  10 ++
 arch/arm/boot/dts/omap4-panda-common.dtsi          |  10 ++
 arch/arm/boot/dts/omap4-sdp.dts                    |  11 ++
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi     |  10 ++
 arch/arm/mach-davinci/Kconfig                      |  11 --
 arch/arm/mach-davinci/board-da850-evm.c            | 112 ---------------------
 arch/arm/mach-omap2/pdata-quirks.c                 |  79 ---------------
 drivers/net/wireless/ti/wilink_platform_data.c     |  25 -----
 drivers/net/wireless/ti/wl12xx/main.c              |  63 ++++++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h            |  28 ++++++
 drivers/net/wireless/ti/wlcore/boot.c              |   1 -
 drivers/net/wireless/ti/wlcore/debugfs.c           |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |  31 +++---
 drivers/net/wireless/ti/wlcore/sdio.c              |  64 ++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h            |   5 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   8 +-
 include/linux/wl12xx.h                             |  49 ---------
 24 files changed, 313 insertions(+), 312 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt

-- 
1.8.5.2.229.g4448466.dirty

