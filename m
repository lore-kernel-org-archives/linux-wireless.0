Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0GFAjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:39:11 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 00/15] wlan+omap+mmc: out-of-the-box WLAN support for ZOOM2/3
Date: Tue,  6 Jul 2010 03:37:31 +0300
Message-Id: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

The ZOOM2/3 boards include TI's wl1271 wlan sdio device,
hardwired to the 3rd mmc controller.

These patches add support for WLAN on the ZOOM2/3 boards
using only mainline components (most notably mac80211 and wl1271).

Patches were tested on both ZOOM2 and ZOOM3.

In short, these patches add software control for emulating
card detect events, add board configurations to support the
wl1271 device, and update the wl1271 driver to make use of
these new mechanisms.

Software card detect emulation is based on Android's
EMBEDDED_SDIO patch by San Mehat <san@google.com> (thanks, San!).

These patches span over several differnt subsystems, but since
they are highly dependent on each other, it is preferrable
to pull them all together into a single tree (once approved).

Patches are available at:

git://wizery.com/pub/linux-2.6.git wl1271

And will also be sent as a follow-on to this message to the
omap, mmc, arm and wireless mailing lists.

Patches are based on mainline 2.6.35-rc4, but can easily be applied
on wireless-testing (with two minor conflicts). If desired, I can
rebase to wireless-testing and resend.

Note: last missing part for full mainline community support
of the wl1271 on ZOOM is the firmware, and for that there is already
on-going TI work to provide it in linux-firmware. Hopefully
that would be resolved soon.

Thanks,

Ohad Ben-Cohen (15):
  sdio: add TI + wl1271 ids
  wireless: wl1271: remove SDIO IDs from driver
  omap: mmc: prepare for software card detect support
  mmc: support embedded data field in mmc_host
  omap: hsmmc: add virtual card detect support
  omap zoom2: wlan board muxing
  omap zoom3: wlan board muxing
  wireless: wl1271: make wl12xx.h common to both spi and sdio
  wireless: wl12xx: support pdata SDIO handlers
  wireless: wl1271: support return value for the set power func
  wireless: wl1271: introduce platform device support
  wireless: wl1271: take irq info from platform data
  wireless: wl1271: make ref_clock configurable by board
  omap: zoom: add WLAN device
  omap: zoom: enable WLAN device

 arch/arm/mach-omap2/Kconfig                   |    5 +
 arch/arm/mach-omap2/Makefile                  |    1 +
 arch/arm/mach-omap2/board-zoom-peripherals.c  |   15 ++
 arch/arm/mach-omap2/board-zoom-wlan.c         |  129 ++++++++++++++++
 arch/arm/mach-omap2/board-zoom2.c             |   15 ++
 arch/arm/mach-omap2/board-zoom3.c             |   15 ++
 arch/arm/mach-omap2/hsmmc.c                   |    4 +
 arch/arm/mach-omap2/hsmmc.h                   |    5 +
 arch/arm/mach-omap2/include/mach/board-zoom.h |    5 +
 arch/arm/plat-omap/include/plat/mmc.h         |    5 +
 drivers/mmc/core/Kconfig                      |    8 +
 drivers/mmc/host/omap_hsmmc.c                 |   37 +++++-
 drivers/net/wireless/wl12xx/Kconfig           |    1 +
 drivers/net/wireless/wl12xx/wl1251_sdio.c     |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c      |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h          |    8 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c     |   13 +-
 drivers/net/wireless/wl12xx/wl1271_boot.h     |    1 -
 drivers/net/wireless/wl12xx/wl1271_io.h       |    8 +-
 drivers/net/wireless/wl12xx/wl1271_main.c     |    4 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c     |  204 +++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_spi.c      |    8 +-
 include/linux/mmc/host.h                      |   16 ++
 include/linux/mmc/sdio_ids.h                  |    3 +
 include/linux/spi/wl12xx.h                    |   34 ----
 include/linux/wl12xx.h                        |   37 +++++
 26 files changed, 486 insertions(+), 99 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-zoom-wlan.c
 delete mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/linux/wl12xx.h

