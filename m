Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57258 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1DSN7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:13 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:58:46 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 00/22] Add support for AR9340
Date: Tue, 19 Apr 2011 19:28:58 +0530
Message-ID: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This patch set mainly adds support for AR9340 which is a built in
wireless mac in ar934x SOCs. It is 2x2, 2.4Ghz only in ar9341 SOC and
dual band in ar9342/ar9344 SOCs. This V2 has updated patch 03/22.

Vasanth

Vasanthakumar Thiagarajan (22):
  ath9k_hw: Define devid and mac version for AR9340
  ath9k_hw: Take care of few host interface register changes for AR9340
  ath9k_hw: Get AHB clock information from ath9k_platform_data
  ath9k_hw: Configure pll control register accordingly for AR9340
  ath9k_hw: Add initvals.h for ar9340
  ath9k_hw: Initialize mode registers from initvals.h for AR9340
  ath9k_hw: Don't do ani initialization for AR9340
  ath9k_hw: Initialize tx and rx gain table from initvals.h for ar9340
  ath9k_hw: Read spur frequency information from eeprom for AR9340
  ath9k_hw: Configure RF channel freqency for AR9340
  ath9k_hw: Clean up rx/tx chain configuration before AGC/IQ cal
  ath9k_hw: Fix register offset AR_PHY_65NM_CH0_THERM for AR9340
  ath9k_hw: Don't configure AR_CH0_THERM for AR9340
  ath9k_hw: Skip internal regulator configuration for AR9340
  ath9k_hw: Configure tuning capacitance value for AR9340 as well
  ath9k_hw: Enable byte Tx/Rx data swap for AR9340
  ath9k_hw: Configure chain switch table and attenuation control only
    for active chains
  ath9k_hw: Read iq calibration data only for active chains
  ath9k: Add AR9340 platform id to id table
  ath9k_hw: Assign macversion based on devid for built-in wmac
  ath9k_hw: Disable INTR_HOST1_FATAL to avoid interrupt strom with
    ar9430
  ath9k_hw: Enable AR9340 support

 drivers/net/wireless/ath/ath9k/ahb.c             |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |   37 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |   59 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  101 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |   30 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h | 1525 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c              |   82 +-
 drivers/net/wireless/ath/ath9k/hw.h              |    6 +-
 drivers/net/wireless/ath/ath9k/init.c            |    1 +
 drivers/net/wireless/ath/ath9k/mac.c             |   10 +-
 drivers/net/wireless/ath/ath9k/phy.h             |    3 +
 drivers/net/wireless/ath/ath9k/reg.h             |   81 +-
 include/linux/ath9k_platform.h                   |    2 +
 14 files changed, 1842 insertions(+), 101 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9340_initvals.h

