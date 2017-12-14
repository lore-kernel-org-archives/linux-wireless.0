Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45534 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753275AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 00/14] mt76 fixes
Date: Thu, 14 Dec 2017 16:39:04 +0100
Message-Id: <20171214153918.43774-1-nbd@nbd.name> (sfid-20171214_163945_732830_22704DA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau (10):
  mt76x2: remove some harmless WARN_ONs in tx status and rx path
  mt76x2: fix transmission of encrypted management frames
  mt76x2: increase OFDM SIFS time
  mt76x2: add channel argument to eeprom tx power functions
  mt76x2: initialize channel power limits at probe time
  mt76x2: convert between per-chain tx power and combined output
  mt76x2: remove MAC address limitation for multi-vif setups
  mt76x2: clean up MAC/BSSID address initialization
  mt76x2: drop wiphy->addresses
  mt76x2: configure rx filter based on monitor mode setting

Fengguang Wu (2):
  mt76: fix debugfs_simple_attr.cocci warnings
  mt76: fix returnvar.cocci warnings

Lorenzo Bianconi (2):
  mt76x2: init: disable APCLI by default
  mt76x2: init: fix rx filter default value during init

 drivers/net/wireless/mediatek/mt76/debugfs.c       |  7 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 41 ++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |  7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 67 ++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 85 +++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 57 +++++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 30 ++------
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   |  8 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |  6 +-
 12 files changed, 204 insertions(+), 109 deletions(-)

-- 
2.14.2
