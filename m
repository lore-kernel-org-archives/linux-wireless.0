Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40002 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab2GCRN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:13:59 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/20] ath9k: add support for AR9550
Date: Tue,  3 Jul 2012 19:13:14 +0200
Message-Id: <1341335614-15419-1-git-send-email-juhosg@openwrt.org> (sfid-20120703_191403_453392_5BBEBDD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch-set adds initial support for the AR9550
wireless MAC into ath9k. This wireless MAC can be
found in the Qualcomm Atheros QCA955X SoCs. It is
a 3x3 chip and it supports both 2.4GHz and 5Ghz.

Gabor Juhos (20):
  ath9k: define DEVID for QCA955x
  ath9k: define MAC version for AR9550
  ath9k: set MAC version for AR9550
  ath9k: add platform_device_id for AR9550
  ath9k: add BB name string for AR9550
  ath9k: clear pciexpress flag for AR9550
  ath9k: enable TX/RX data byte swap for AR9550
  ath9k: add initvals for AR9550
  ath9k: add mode register initialization code for AR9550
  ath9k: read spur frequency information from eeprom for AR9550
  ath9k: fix XPABIASLEVEL settings for AR9550
  ath9k: fix antenna control configuration for AR9550
  ath9k: fix PAPRD settings for AR9550
  ath9k: fix RF channel frequency configuration for AR9550
  ath9k: disable SYNC_HOST1_FATAL interrupts for AR9550
  ath9k: skip internal regulator configuration for AR9550
  ath9k: fix PLL initialization for AR9550
  ath9k: enable PLL workaround for AR9550
  ath9k: set 4ADDRESS bit in RX filter for AR9550
  ath9k: enable support for AR9550

 drivers/net/wireless/ath/ath9k/ahb.c               |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    7 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   87 ++-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   72 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    6 +-
 .../net/wireless/ath/ath9k/ar955x_1p0_initvals.h   | 1284 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c                |   40 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +
 drivers/net/wireless/ath/ath9k/mac.c               |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    1 +
 drivers/net/wireless/ath/ath9k/main.c              |    3 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    3 +
 drivers/net/wireless/ath/ath9k/reg.h               |    4 +
 14 files changed, 1492 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h

-- 
1.7.2.1

