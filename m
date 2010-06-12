Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/24] ath9k: new ANI, PAPrD and few fixes and cleanups
Date: Sat, 12 Jun 2010 00:33:38 -0400
Message-Id: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses the missing features for AR9003
support. On its way we found a few fixes, some which did
apply to older families. One of the features is a new
ANI implementation, enabled only for AR9003 for now but
which will later also be used for our older families.
PAPrD gets implemented and added for AR9003, which should
result in a ~3.5 dB improvement in output power [1].

All patches have been sparse and checkpatch.pl tested.

You can download the all-in-one git am'able patch
from:

http://bombadil.infradead.org/~mcgrof/tmp/handle-paprd-calib-timeout.patch

Felix Fietkau (13):
  ath9k: fix mac80211 queue lookup for waking up queues
  ath9k_htc: use common WMM AC definitions instead of ath9k ones
  ath9k: remove duplicate WMM AC definitions
  ath9k: remove declarations of some nonexistant functions
  ath9k: make ath_get_hal_qnum static
  ath9k: fix extending the rx timestamp with the hardware TSF
  ath9k: fix queue stopping threshold
  ath9k: add a debugfs entry for ignoring CCA on the extension channel
    in HT40
  ath9k_hw: remove a useless function for setting the mac address
  ath9k_hw: add register definitions related to PA predistortion
  ath9k_hw: add support for parsing PA predistortion related EEPROM
    fields
  ath9k_hw: add functions for controlling PA predistortion calibration
  ath9k: implement PA predistortion support

Luis R. Rodriguez (11):
  ath9k_hw: move clock definitions from hw.c to hw.h
  ath9k_hw: fix clock rate calculations for ANI
  ath9k_hw: clear MIB interrupt causes when skipping ANI adjustments
  ath9k_hw: allow for spliting up ANI operations by family
  ath9k_hw: add register definitions for the new ANI
  ath9k_hw: inform ANI calibration when scanning
  ath9k: add new ANI implementation for AR9003
  ath9k_hw: enable ANI for AR9003
  ath9k_hw: reduce delay on programming INI on AR9003
  ath9k_hw: update 5 GHz tx gain tables for femless and high power PA
  ath9k: enable AR9003 PCI IDs

[1] http://www.atheros.com/pt/whitepapers/11nNetworksSustainingSignals_whitepaper.pdf

 drivers/net/wireless/ath/ath9k/Makefile            |    3 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  742 ++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ani.h               |   78 ++-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |  361 ++++++++++-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    9 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    7 +
 .../net/wireless/ath/ath9k/ar9003_2p0_initvals.h   |  248 ++++----
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  248 ++++----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   13 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    8 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |  714 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  395 ++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  232 ++++++-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   21 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    3 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   12 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    3 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   18 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   16 +
 drivers/net/wireless/ath/ath9k/hw.c                |   48 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   64 ++-
 drivers/net/wireless/ath/ath9k/init.c              |   11 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    5 +-
 drivers/net/wireless/ath/ath9k/mac.h               |   13 +-
 drivers/net/wireless/ath/ath9k/main.c              |  148 ++++-
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/recv.c              |   24 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  116 ++--
 36 files changed, 2973 insertions(+), 617 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_paprd.c

