Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55041 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbeIVRjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id c14-v6so5408995wmb.4
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:47 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] unify tx power eeprom parsing for mt76x{0,2}
Date: Sat, 22 Sep 2018 13:45:28 +0200
Message-Id: <20180922114537.24004-1-lorenzo.bianconi@redhat.com> (sfid-20180922_134901_097839_C94A4327)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the second of two series that unify eeprom code between
mt76x2 and mt76x0 drivers. In particular this series unifies
tx power eeprom parsing. That patchset will be used to properly
support mt76x0e chipsets without duplicating the code.

Lorenzo Bianconi (9):
  mt76: move mt76_rate_power in mt76_dev
  mt76: add mt76x02_phy_set_txpower utility routine
  mt76: move rate_txpower handler in mt76 debugfs
  mt76: move mt76x02_rate_power_val in mt76x02-lib module
  mt76x0: remove mt76x0_phy_set_tx_power and mt76x0_extra_power_over_mac
  mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
  mt76x0: remove eeprom dependency from mt76x0_get_power_info
  mt76x0: use shared debugfs implementation
  mt76x0: phy: introduce mt76x0_phy_set_txpower routine

 drivers/net/wireless/mediatek/mt76/Makefile   |   2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c  |  19 ++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  30 ++-
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  79 +-----
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 253 ++++++++++--------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  43 +--
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |   7 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  74 +----
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  20 +-
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  97 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  27 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |   3 -
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   |  10 -
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    |  77 ++----
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    |   1 -
 .../mediatek/mt76/mt76x2_init_common.c        |   3 +-
 .../mediatek/mt76/mt76x2_mac_common.c         |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |   8 +-
 .../mediatek/mt76/mt76x2_phy_common.c         |  64 +----
 .../wireless/mediatek/mt76/mt76x2_tx_common.c |  14 +-
 .../net/wireless/mediatek/mt76/mt76x2u_main.c |   4 +-
 22 files changed, 398 insertions(+), 443 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h

-- 
2.18.0
