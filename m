Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7465 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2EXDxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 23:53:53 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45186.165189.999838@gargle.gargle.HOWL> (sfid-20120524_055357_052293_B2BDE6E4)
Date: Thu, 24 May 2012 09:22:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/22] ath9k updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

These are the pending patches for ath9k, rebased over
current -wt.

Sujith

Rajkumar Manoharan (11):
  ath9k_hw: update ar9462 initval table to fix rx nfcal
  ath9k: cleanup MCI indentation
  ath9k_hw: fix IQ calibration chain index
  ath9k_hw: program BT to control SPDT
  ath9k_hw: configure ar9462 switching regulator discontinuous mode
  ath9k_hw: fix BT RF performance
  ath9k: BT coex performance tuning for AR9462
  ath: do not update cycle counters with sleep mode results
  ath9k: always perform ani calibration at poll interval
  ath9k_hw: fix power state for MCI
  ath9k: improve BT FTP/PAN performance

Sujith Manoharan (11):
  ath9k: Prune ath9k_init_device
  ath9k: Handle ASPM properly
  ath9k: Setup MCI interrupts properly
  ath9k_hw: Fix AR_RTC_KEEP_AWAKE usage
  ath9k_hw: Fix MCI usage
  ath9k_hw: Cleanup power mode API
  ath9k: Add MCI interrupt to debugfs statistics
  ath9k_hw: Fix variable usage
  ath9k: Handle fatal interrupts properly
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
 drivers/net/wireless/ath/ath9k/gpio.c              |   30 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  212 ++++-----
 drivers/net/wireless/ath/ath9k/hw.h                |   10 +-
 drivers/net/wireless/ath/ath9k/init.c              |   19 +-
 drivers/net/wireless/ath/ath9k/main.c              |   34 +-
 drivers/net/wireless/ath/ath9k/mci.c               |   65 ++-
 drivers/net/wireless/ath/ath9k/mci.h               |   11 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    5 +
 drivers/net/wireless/ath/ath9k/recv.c              |    5 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    2 +
 21 files changed, 493 insertions(+), 433 deletions(-)

-- 
1.7.10.2

