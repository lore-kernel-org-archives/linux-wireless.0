Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48662 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbcCAC6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 21:58:50 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 0/8] ath9k GPIO & BT-Coex bug fixes
Date: Tue,  1 Mar 2016 10:58:27 +0800
Message-Id: <1456801115-16636-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160301_035853_583269_15444AB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

ath9k GPIO & BT-Coex bug fixes.

Miaoqing Pan (8):
  ath9k: define correct GPIO numbers and bits mask
  ath9k: make GPIO API to support both of WMAC and SOC
  ath9k: free GPIO resource for SOC GPIOs
  ath9k: cleanup led_pin initial
  ath9k: Allow platform override BTCoex pin
  ath9k: add bits definition of BTCoex MODE2/3 for SOC chips
  ath9k: fix BTCoex access invalid registers for SOC chips
  ath9k: fix BTCoex configuration for SOC chips

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c    |  39 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h         |   4 -
 drivers/net/wireless/ath/ath9k/btcoex.c        | 138 +++++++++----
 drivers/net/wireless/ath/ath9k/btcoex.h        |   2 +
 drivers/net/wireless/ath/ath9k/gpio.c          |  69 ++++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c  |   8 +-
 drivers/net/wireless/ath/ath9k/hw.c            | 263 ++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/hw.h            |  11 +-
 drivers/net/wireless/ath/ath9k/init.c          |   1 -
 drivers/net/wireless/ath/ath9k/main.c          |   9 +-
 drivers/net/wireless/ath/ath9k/reg.h           |  90 +++++++--
 include/linux/ath9k_platform.h                 |   4 +
 13 files changed, 432 insertions(+), 210 deletions(-)

-- 
1.9.1

