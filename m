Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/14] ath9k: initial work for hardware layering
Date: Wed, 10 Mar 2010 20:28:17 -0500
Message-Id: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my first series which starts the work of adding a new layering for
abstraction for hardware access. The goal is to enable the AR9003 hardware
family to be supported by sharing as much code as is possible. To do that
we abstract away all calls which do reads/writes.

I'll next address more abstraction on ANI/mac/hw calls. The final
move will be to rename reg.h to ar92002_reg.h and ensure no common
hardware code uses it. We then should be able to start adding
ar9003 hardware family code support and the rest of the core
driver changes required.

It should be technically possible to even share some stuff like ANI
with ath5k but that's my own priority right now but I welcome others
to review that. If its not clear how that's possible now perhaps
it will be on my next series where I'll dabble a bit more on ANI.

I've rebased this on top of the ath9k_htc patches, and tested this
with AR9280 (ath9k) and AR9271 (ath9k_htc).

Luis R. Rodriguez (14):
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

 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  247 ++++--
 drivers/net/wireless/ath/ath9k/ani.h               |    2 -
 .../ath/ath9k/{btcoex.c => ar9002_btcoex.c}        |   46 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |  827 +++++++++++++++
 .../net/wireless/ath/ath9k/ar9002_calib_settings.c |  388 +++++++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  818 +++++++++++++++
 .../ath/ath9k/{initvals.h => ar9002_initvals.h}    |    0
 drivers/net/wireless/ath/ath9k/btcoex.h            |   10 -
 drivers/net/wireless/ath/ath9k/calib.c             | 1099 +-------------------
 drivers/net/wireless/ath/ath9k/calib.h             |   15 +-
 drivers/net/wireless/ath/ath9k/common.h            |    1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h            |  166 +++
 drivers/net/wireless/ath/ath9k/hw.c                |  908 ++---------------
 drivers/net/wireless/ath/ath9k/hw.h                |  114 ++-
 drivers/net/wireless/ath/ath9k/init.c              |    9 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   14 +
 17 files changed, 2616 insertions(+), 2053 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{btcoex.c => ar9002_btcoex.c} (82%)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib_settings.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9002_initvals.h} (100%)
 create mode 100644 drivers/net/wireless/ath/ath9k/hw-ops.h

