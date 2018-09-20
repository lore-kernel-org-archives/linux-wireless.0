Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36402 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbeITOyx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id e1-v6so8600634wrt.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 00/20] unify mt76x2 and mt76x0 eeprom code
Date: Thu, 20 Sep 2018 11:11:47 +0200
Message-Id: <cover.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111248_508728_A895AD35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series unify most of eeprom parsing between mt76x2 and
mt76x0 driver. That patchset will be used to properly support
mt76x0e chipsets without duplicating the code.

Lorenzo Bianconi (19):
  mt76: move seq_put_array in mt76-core module
  mt76: move common eeprom definitions in mt76x02-lib module
  mt76: move eeprom utility routines in mt76x02_eeprom.h
  mt76: move mt76x2_eeprom_get in mt76x02_eeprom.h
  mt76: move mt76x02_mac_setaddr in mt76x02-lib module
  mt76: move mt76x2_get_efuse_data in mt76x02-lib module
  mt76: move mt76x2_ext_pa_enabled routine in mt76x02_eeprom.c
  mt76x0: remove mt76x0_set_country_reg routine
  mt76: add mt76x02_get_rx_gain and mt76x02_get_lna_gain utility
    routines
  mt76x0: unify lna_gain parsing
  mt76x0: unify rssi_offset parsing
  mt76x0: unify temperature offset parsing
  mt76x0: unify freq offset parsing
  mt76: move mt76x02_eeprom_parse_hw_cap in mt76x02-lib module
  mt76x0: unify parse hw capabilities
  mt76: move mt76x2_tssi_enabled in mt76x02_eeprom.h
  mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
  mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_chan
  mt76x0: use shared debugfs implementation

Felix Fietkau (1):
  mt76: add stbc entries to mt76_rate_power

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c  |  12 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |   5 +-
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  92 +---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 513 +++++++-----------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    | 119 +---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   5 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  68 +--
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 156 ++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 194 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  18 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   1 +
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   |  33 +-
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 239 +++-----
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    | 122 +----
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |   6 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.c   |   2 +-
 .../mediatek/mt76/mt76x2_mcu_common.c         |   5 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   |   8 +-
 .../mediatek/mt76/mt76x2_phy_common.c         |  16 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |   1 -
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |   5 +-
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  |  24 +-
 .../net/wireless/mediatek/mt76/mt76x2u_main.c |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  |   6 +-
 25 files changed, 740 insertions(+), 915 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h

-- 
2.17.1
