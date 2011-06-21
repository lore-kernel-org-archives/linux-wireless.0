Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41645 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1FUJYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:54 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/32] ath9k: add initial support for AR9330
Date: Tue, 21 Jun 2011 11:23:20 +0200
Message-Id: <1308648232-9906-1-git-send-email-juhosg@openwrt.org> (sfid-20110621_112458_447924_4CFE72CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch set adds initial support for the AR9330 wireless MAC 
which can be found in the Atheros AR933{0,1} SoCs. 
It is a 1x1 chip and supports 2.4GHz only.

Gabor Juhos (32):
  ath9k: define mac version for AR9330
  ath9k: define device id for AR9330
  ath9k: add MAC revision detection for AR9330
  ath9k: add platform device id for AR9330
  ath9k: add AR9330 initvals
  ath9k: initialize mode registers for AR9330
  ath9k: initialize tx gain table for AR9330
  ath9k: initialize rx gain table for AR9330
  ath9k: add AR9330 specific PLL initialization
  ath9k: use different BB watchdog timeout value for AR9330
  ath9k: don't enable LDPC for AR9330
  ath9k: read spur frequency information from eeprom for AR9330
  ath9k: fix channel frequency calculation for AR9340
  ath9k: configure RF channel frequency for AR9330
  ath9k: enable TX/RX data byte swap for AR9330
  ath9k: skip internal regulator configuration for AR9330
  ath9k: enable tuning capacitance configuration for AR9330
  ath9k: use correct EEPROM base for AR9330
  ath9k: configure xpa bias level for AR9330
  ath9k: set NF limits for AR9330
  ath9k: enable antenna diversity for AR9330
  ath9k: use correct max_streams for AR9330
  ath9k: add a missing case statement to ath_ant_div_comb_alt_check
  ath9k: fix antenna diversity configuration for non AR9485 chips
  ath9k: remove superfluous parentheses
  ath9k: add fast_div_bias configuration for diversity group 1
  ath9k: set diversity group for AR9330
  ath9k: fix few register offsets for AR9330
  ath9k: configure diversity based on eeprom contents for AR9330
  ath9k: configure internal regulator for AR9330
  ath9k: add external_reset callback to ath9k_platfom_data for AR9330
  ath9k: enable support for AR9330

 drivers/net/wireless/ath/ath9k/ahb.c               |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   35 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  182 +++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   41 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    6 +-
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   | 1147 ++++++++++++++++++++
 .../net/wireless/ath/ath9k/ar9330_1p2_initvals.h   | 1080 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c                |   96 ++-
 drivers/net/wireless/ath/ath9k/hw.h                |    3 +
 drivers/net/wireless/ath/ath9k/init.c              |    4 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  146 ++-
 drivers/net/wireless/ath/ath9k/reg.h               |   16 +
 include/linux/ath9k_platform.h                     |    2 +
 13 files changed, 2698 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h

-- 
1.7.2.1

