Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60327 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab3FYUd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 16:33:29 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <tony@atomide.com>
Subject: [PATCH 0/5] wilink: add device tree support
Date: Tue, 25 Jun 2013 23:33:21 +0300
Message-ID: <1372192406-29430-1-git-send-email-coelho@ti.com> (sfid-20130625_224207_163287_2288A67B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch series add device tree support to the wlcore_sdio driver,
which is used by WiLink6, WiLink7 and WiLink8.

The first patches do some clean-up to make the data needed in the
wilink device tree node smaller.  The last patch implements the actual
device tree node parsing in wlcore_sdio.

The DTS file changes will be sent separately, since they need to go
via different trees.

--
Luca.

Luciano Coelho (5):
  wl1251: split wl251 platform data to a separate structure
  wlcore: use irq_flags in pdata instead of hiding it behing a quirk
  wlcore: remove pwr_in_suspend from platform data
  wlcore: always use one-shot IRQ
  wlcore: add device tree support to the sdio module

 arch/arm/mach-davinci/board-da850-evm.c        |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c            |    1 +
 arch/arm/mach-omap2/board-omap3evm.c           |    1 +
 arch/arm/mach-omap2/board-omap3pandora.c       |    4 +-
 arch/arm/mach-omap2/board-omap4panda.c         |    1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c   |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c   |    1 +
 drivers/net/wireless/ti/wilink_platform_data.c |   37 ++++++++++--
 drivers/net/wireless/ti/wl1251/sdio.c          |   12 ++--
 drivers/net/wireless/ti/wl1251/spi.c           |    2 +-
 drivers/net/wireless/ti/wlcore/debugfs.c       |    2 +-
 drivers/net/wireless/ti/wlcore/main.c          |   16 ++---
 drivers/net/wireless/ti/wlcore/sdio.c          |   77 +++++++++++++++++++++---
 drivers/net/wireless/ti/wlcore/wlcore.h        |    5 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h      |    1 +
 include/linux/wl12xx.h                         |   28 +++++++--
 16 files changed, 147 insertions(+), 45 deletions(-)

-- 
1.7.10.4

