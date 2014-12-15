Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56980 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaLOFMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 00:12:01 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/5] ath10k: Add thermal mitigation support
Date: Mon, 15 Dec 2014 10:41:09 +0530
Message-ID: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141215_061206_832515_E6F4290C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches add thermal sensor and thermal cooling device
support in ath10k. For sensor, hwmon interface is used. For controlling
temperature cooling device interface is used. For thermal mitigation,
tx throttling is done using hw MAC quiet time setting.

WMI support for reading temperature is available from 10.2.4 firmware
onwards. The firmware can be downloaded from

https://github.com/kvalo/ath10k-firmware/tree/master/10.2.4/untested

Rajkumar Manoharan (5):
  ath10k: add 10.2.4 firmware support
  ath10k: add wmi support for pdev_set_quiet_mode
  ath10k: add thermal cooling device support
  ath10k: add wmi interface for pdev_get_temperature
  ath10k: add thermal sensor device support

 drivers/net/wireless/ath/ath10k/Makefile  |   1 +
 drivers/net/wireless/ath/ath10k/core.c    |  20 ++-
 drivers/net/wireless/ath/ath10k/core.h    |   8 +
 drivers/net/wireless/ath/ath10k/hw.h      |   1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 238 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/thermal.h |  58 ++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  39 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  62 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  20 ++-
 10 files changed, 448 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.c
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.h

-- 
2.1.3

