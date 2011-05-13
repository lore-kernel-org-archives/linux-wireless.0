Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30840 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab1EMO54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:57:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:57:27 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH 0/9] ath9k: Add Antenna diversity support for AR9485
Date: Fri, 13 May 2011 20:27:38 +0530
Message-ID: <1305298667-3212-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_165801_144372_39768AF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

*This patch set adds Antenna diversity support for AR9485, previously
 antenna diversity is only supported in AR9285
*The basic antenna diversity algorithm remains the same
*slight change in the diversity field in eeprom
*introduction of main/alt gain table and lna1_lna2 delta fields
*initially set LNA1 for main antenna
*introduction of diversity group
*based on diversity group, fast diversity bias parmaters and
lna1_lna2_delta varies
*implement an API to take the decision of swapping main/ALT LNA's
for AR9485
*configure fast diversity bias based on diversity group

Mohammed Shafi Shajakhan (9):
  ath9k_hw: make antenna diversity modules chip specific
  ath9k_hw: enable Antenna diversity for AR9485
  ath9k_hw: define registers/macros to support Antenna diversity
  ath9k_hw: config diversity based on eeprom contents
  ath9k_hw: define modules to get/set Antenna diversity paramaters
  ath9k_hw: define antenna diversity group
  ath9k: Implement an API to swap main/ALT LNA's
  ath9k: configure fast_div_bias based on diversity group
  ath9k: make sure main_rssi is positive

 drivers/net/wireless/ath/ath9k/ar9002_phy.c    |   44 +++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   50 +++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |   46 +++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   22 +++
 drivers/net/wireless/ath/ath9k/ath9k.h         |    1 -
 drivers/net/wireless/ath/ath9k/hw-ops.h        |   12 ++
 drivers/net/wireless/ath/ath9k/hw.c            |   16 ++
 drivers/net/wireless/ath/ath9k/hw.h            |   13 +-
 drivers/net/wireless/ath/ath9k/recv.c          |  211 ++++++++++++++++++------
 9 files changed, 337 insertions(+), 78 deletions(-)

