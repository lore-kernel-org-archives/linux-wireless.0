Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 00/20] ath9k_hw: ar93xx initial abstraction work
Date: Wed, 17 Mar 2010 18:27:53 -0400
Message-Id: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's what I have so far, this is rebased on top of Senthil's patches
for ath9k_htc posted today. Just tested it on my AR9280, it doesn't
break anything.

Luis R. Rodriguez (20):
  ath9k: start building an abstraction layer for hardware routines
  ath9k: initial move of ar9002 specific code to its own file
  ath9k: rename initvals.h to ar9002_initvals.h
  ath9k_hw: rename getNoiseFloorThresh() to ath9k_hw_getnf_thres()
  ath9k_hw: move < AR9002 specific calibration stuff to its own file
  ath9k_hw: move calibration settings to ar9002_calib_settings.c
  ath9k_hw: consolidate the pci express checks on __ath9k_hw_init()
  ath9k_hw: move ar9002 bluetooth coexistence code to its own file
  ath9k_hw: Use a helper for setting phy error masks
  ath9k_hw: add helpers for writing phy errors counts
  ath9k_hw: add a helper for phy error counter reads
  ath9k_hw: add documentation for the TPC register
  ath9k_hw: remove unused and buggy ath9k_hw_GetMibCycleCountsPct()
  ath9k_hw: add a helper for retrieving the MIB cycle counters
  ath9k_hw: provide a helper for clearing the MIB counters
  ath9k_hw: simplify reseting of the MIB control register
  ath9k_hw: provide a helper for managing the MIB control register
  ath9k_hw: move common defines for ANI into ath/reg.h
  ath9k_hw: move ar9002 ANI code to its own file
  ath9k_hw: remove wrapper ath9k_hw_write_regs()

 drivers/net/wireless/ath/ath9k/Makefile            |    6 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  403 +-
 drivers/net/wireless/ath/ath9k/ani.h               |   22 +-
 drivers/net/wireless/ath/ath9k/ar9002_ani.c        |  356 +
 drivers/net/wireless/ath/ath9k/ar9002_btcoex.c     |  239 +
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |  826 +++
 .../net/wireless/ath/ath9k/ar9002_calib_settings.c |  388 ++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  821 +++
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   | 7115 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.c            |  227 -
 drivers/net/wireless/ath/ath9k/btcoex.h            |   10 -
 drivers/net/wireless/ath/ath9k/calib.c             | 1095 +---
 drivers/net/wireless/ath/ath9k/calib.h             |   15 +-
 drivers/net/wireless/ath/ath9k/common.h            |    1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h            |  235 +
 drivers/net/wireless/ath/ath9k/hw.c                |  911 +---
 drivers/net/wireless/ath/ath9k/hw.h                |  149 +-
 drivers/net/wireless/ath/ath9k/init.c              |    9 +-
 drivers/net/wireless/ath/ath9k/initvals.h          | 7115 --------------------
 drivers/net/wireless/ath/ath9k/phy.c               |   15 -
 drivers/net/wireless/ath/ath9k/phy.h               |    3 -
 drivers/net/wireless/ath/ath9k/reg.h               |   17 +-
 drivers/net/wireless/ath/reg.h                     |    5 +
 23 files changed, 10382 insertions(+), 9601 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_ani.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_initvals.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/btcoex.c
 create mode 100644 drivers/net/wireless/ath/ath9k/hw-ops.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/initvals.h

