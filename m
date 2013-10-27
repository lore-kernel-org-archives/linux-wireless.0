Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:59072 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab3J0QO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 12:14:58 -0400
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>
Cc: Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felipe Balbi <balbi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Sebastian Reichel <sre@debian.org>
Subject: [PATCH 0/4] wl1251 device tree support
Date: Sun, 27 Oct 2013 17:14:25 +0100
Message-Id: <1382890469-25286-1-git-send-email-sre@debian.org> (sfid-20131027_171645_251941_1A942C8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following patchset adds device tree support to
the spi variant of the wl1251 driver.

Some notes:

The first patch is from Luciano's wilink DT support
patchset [0].

The third patch (vio regulator support) is optional. N900's
wifi also worked without this patch, but its probably cleaner
to have it.

The patchset has been tested using DT boot with the Nokia N900
and connecting to my wlan access point.

[0] https://lkml.org/lkml/2013/7/3/333

-- Sebastian

Luciano Coelho (1):
  wl1251: split wl251 platform data to a separate structure

Sebastian Reichel (3):
  wl1251: move power GPIO handling into the driver
  wl1251: spi: add vio regulator support
  wl1251: spi: add device tree support

 .../devicetree/bindings/net/wireless/ti,wl1251.txt | 36 +++++++++++
 arch/arm/mach-omap2/board-omap3pandora.c           |  6 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       | 15 ++---
 drivers/net/wireless/ti/wilink_platform_data.c     | 37 +++++++++--
 drivers/net/wireless/ti/wl1251/sdio.c              | 31 +++++++---
 drivers/net/wireless/ti/wl1251/spi.c               | 71 ++++++++++++++++------
 drivers/net/wireless/ti/wl1251/wl1251.h            |  4 +-
 include/linux/wl12xx.h                             | 24 +++++++-
 8 files changed, 175 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt

-- 
1.8.4.rc3

