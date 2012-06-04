Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35788 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2FDK6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:58:11 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38015.498868.190388@gargle.gargle.HOWL> (sfid-20120604_125816_772488_408C79F0)
Date: Mon, 4 Jun 2012 16:27:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 00/20] ath9k patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is v3 of the earlier series, the difference being:

* Drop the patch, "ath9k: always perform ani calibration at poll"
* Change "ath9k: Use separate operational flags for BTCOEX" to use atomic ops.

Sujith


Rajkumar Manoharan (10):
  ath9k_hw: update ar9462 initval table to fix rx nfcal
  ath9k: cleanup MCI indentation
  ath9k_hw: fix IQ calibration chain index
  ath9k_hw: program BT to control SPDT
  ath9k_hw: configure ar9462 switching regulator discontinuous mode
  ath9k_hw: fix BT RF performance
  ath9k: BT coex performance tuning for AR9462
  ath: do not update cycle counters with sleep mode results
  ath9k_hw: fix power state for MCI
  ath9k: improve BT FTP/PAN performance

Sujith Manoharan (10):
  ath9k: Prune ath9k_init_device
  ath9k: Handle ASPM properly
  ath9k: Setup MCI interrupts properly
  ath9k_hw: Fix AR_RTC_KEEP_AWAKE usage
  ath9k_hw: Fix MCI usage
  ath9k_hw: Cleanup power mode API
  ath9k: Add MCI interrupt to debugfs statistics
  ath9k_hw: Fix variable usage
  ath9k: Remove SC_OP_OFFCHANNEL
  ath9k: Use separate operational flags for BTCOEX

 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   20 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |  457 ++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    4 +
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   19 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   10 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |    4 +
 drivers/net/wireless/ath/ath9k/debug.c             |    3 +
 drivers/net/wireless/ath/ath9k/debug.h             |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c              |   36 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  212 ++++-----
 drivers/net/wireless/ath/ath9k/hw.h                |   10 +-
 drivers/net/wireless/ath/ath9k/init.c              |   18 +-
 drivers/net/wireless/ath/ath9k/main.c              |   15 +-
 drivers/net/wireless/ath/ath9k/mci.c               |   65 ++-
 drivers/net/wireless/ath/ath9k/mci.h               |   11 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    5 +
 drivers/net/wireless/ath/ath9k/recv.c              |    5 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    2 +
 21 files changed, 481 insertions(+), 431 deletions(-)

-- 
1.7.10.3

