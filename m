Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56466 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2BUJWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:22:21 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25137.666646.112510@gargle.gargle.HOWL> (sfid-20120221_102233_259763_96800DA7)
Date: Tue, 21 Feb 2012 14:51:53 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 00/22] ath9k/ath9k_htc BTCOEX cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series cleans up the existing BTCOEX code in ath9k/ath9k_htc.

Proper abstraction is added and a facility (CONFIG_ATH9K_BTCOEX_SUPPORT)
to optionally disable BTCOEX support at compile time is properly used.
Both ath9k and ath9k_htc make use of the same config option.
MCI, which is an AR9462-specific feature has been cleaned up a little,
more needs to be done, though. The checks for MCI/BTCOEX which were
present in various places have been removed since it makes the BT code
a tad hard to read and makes adding support for future chips/profiles
difficult.

Please review.

Sujith

Sujith Manoharan (22):
  ath9k: Remove AR9462 v1.0 support
  ath9k: Cleanup MCI init/deinit routines
  ath9k: Initialize MCI params using a helper
  ath9k: Move BTCOEX init/deinit functions to gpio.c
  ath9k: Use proper start/stop routines for BTCOEX
  ath9k: Process BTCOEX interrupts using a helper
  ath9k: Calculate ampdu limit using a helper
  ath9k: Use CONFIG_ATH9K_BTCOEX_SUPPORT
  ath9k: Initialize BTCOEX scheme using a helper
  ath9k_hw: Use a helper function to get MCI ISR
  ath9k_hw: Handle MCI power state using a helper
  ath9k_hw: Setup MCI calibration using a helper
  ath9k_hw: Cleanup MCI bits from ath9k_hw_reset()
  ath9k_hw: Cleanup MCI bits from hw.h
  ath9k_hw: Cleanup MCI function declarations
  ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
  ath9k_htc: Start/stop btcoex using a helper
  ath9k_htc: Init BTCOEX inside htc_drv_gpio.c
  ath9k_htc: Use CONFIG_ATH9K_BTCOEX_SUPPORT
  ath9k: Remove ATH_BTCOEX_CFG_NONE checks
  ath9k: Remove ATH9K_HW_CAP_MCI checks
  ath9k: Modify ATH9K_BTCOEX_SUPPORT

 drivers/net/wireless/ath/ath9k/Kconfig             |   16 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   42 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    4 -
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   88 +--
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   30 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        | 1096 +++++++++-------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h        |  231 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    6 +-
 .../net/wireless/ath/ath9k/ar9462_1p0_initvals.h   | 1439 --------------------
 drivers/net/wireless/ath/ath9k/ath9k.h             |   35 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   77 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |    4 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |  123 ++-
 drivers/net/wireless/ath/ath9k/htc.h               |   21 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |   73 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   15 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  178 +---
 drivers/net/wireless/ath/ath9k/hw.h                |  199 +---
 drivers/net/wireless/ath/ath9k/init.c              |   67 +-
 drivers/net/wireless/ath/ath9k/main.c              |   26 +-
 drivers/net/wireless/ath/ath9k/mci.c               |   77 +-
 drivers/net/wireless/ath/ath9k/mci.h               |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   19 +-
 25 files changed, 1231 insertions(+), 2682 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h

-- 
1.7.9.1

