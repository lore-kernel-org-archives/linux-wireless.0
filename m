Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54956 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbCUIrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:47:33 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 00/18] reduce some of ath9k_htc performance problems
Date: Sat, 21 Mar 2015 09:47:03 +0100
Message-Id: <1426927641-18474-1-git-send-email-linux@rempel-privat.de> (sfid-20150321_094739_610982_ADDDA56F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds new WMI_RMW handler to reduce some of usb related
performance problems.

Oleksij Rempel (18):
  ath9k_htc: add new WMI_REG_RMW_CMDID command
  ath9k: ar9271_hw_pa_cal - use defs instead of magin numbers
  ath9k: ar9271_hw_pa_cal: use proper makroses.
  ath9k: ar9271_hw_pa_cal: use RMW buffer
  ath9k: add multi_read to be compatible with ath9k_htc
  ath9k: add new function ath9k_hw_read_array
  ath9k: ar9271_hw_pa_cal: use REG_READ_ARRAY
  ath9k: use one shot read in ath9k_hw_update_mibstats
  ath9k: ath9k_hw_loadnf: use REG_RMW
  ath9k: write buffer related optimisation in ar5008_hw_set_channel_regs
  ath9k: ath9k_hw_set_4k_power_cal_tabl: use rmw buffer
  ath9k: use rmw buffer in ath9k_hw_set_operating_mode and
    ath9k_hw_reset
  ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
  ath9k: ath9k_hw_analog_shift_rmw: use REG_RMW
  ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
  ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
  ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_board_values
  ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain

 drivers/net/wireless/ath/ath.h                |   3 +
 drivers/net/wireless/ath/ath9k/ani.c          |  20 +++-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   5 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |  77 +++++++-------
 drivers/net/wireless/ath/ath9k/calib.c        |  19 ++--
 drivers/net/wireless/ath/ath9k/eeprom.c       |   7 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |  36 ++++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c   |  34 +++---
 drivers/net/wireless/ath/ath9k/htc.h          |   5 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 142 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.c           |  24 +++++
 drivers/net/wireless/ath/ath9k/hw.h           |  15 +++
 drivers/net/wireless/ath/ath9k/init.c         |  11 ++
 drivers/net/wireless/ath/ath9k/wmi.c          |   3 +
 drivers/net/wireless/ath/ath9k/wmi.h          |  16 +++
 15 files changed, 314 insertions(+), 103 deletions(-)

-- 
1.9.1

