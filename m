Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33825 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbeETIPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 04:15:31 -0400
Received: by mail-wr0-f194.google.com with SMTP id j1-v6so2069542wrm.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2018 01:15:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v2 00/18] add mt76x2u support to mt76 driver
Date: Sun, 20 May 2018 10:15:04 +0200
Message-Id: <20180520081522.10163-1-lorenzo.bianconi@redhat.com> (sfid-20180520_101539_479388_5221956D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add usb layer to mt76 driver in order to support mt76x2u based devices.
Move common code between pci and usb in mt76x2-common module in order to
remove pci dependency from usb driver

Changes since RFCv1:
- added power management support
- updated usb_device_id list
- fixed 5GHz frequencies scan
- fixed various races during module load/unload
- implemented dynamic AGC tuning based on false packet detection count
- use netdev_alloc_frag/build_skb to get rid of rx frames copies
- addressed comments from Stanislaw 
- added bss configuration support
- added tx power configuration support
- patchset rebased on top of current wireless-drivers-next master branch

Lorenzo Bianconi (18):
  mt76x2: use completion instead of wait_queue for mcu rx queue
  mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in
    mcu.h
  mt76x2: move utility routines in mt76x2.h
  mt76x2: introduce mt76x2_init_device routine
  mt76x2: move currently mt76x2u unsupported features to mt76x2_init
  mt76x2: introduce mt76x2_mac_load_tx_status routine
  mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete
    signatures
  mt76x2: add buffer len to mt76x2_mac_write_txwi signature
  mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
  mt76: introduce mt76x2-common module
  mt76: add mt76x2_tx_common to mt76x2-common module
  mt76: add mt76x2_mac_common to mt76x2-common module
  mt76: add mt76x2_init_common to mt76x2-common module
  mt76: add mt76x2_common to mt76x2-common module
  mt76: add mt76x2_phy_common to mt76x2-common module
  mt76: move mt76x2_debugfs in mt76-common module
  mt76: add usb support to mt76 layer
  mt76: add driver code for MT76x2u based devices

 drivers/net/wireless/mediatek/mt76/Kconfig         |  13 +
 drivers/net/wireless/mediatek/mt76/Makefile        |  18 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   3 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   5 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  27 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          | 125 +++-
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  92 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 348 +++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |  23 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 311 +---------
 .../wireless/mediatek/mt76/mt76x2_init_common.c    | 253 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 611 +-----------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 683 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 305 ---------
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    |  17 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 290 ---------
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c | 302 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   |  35 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     | 125 +---
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  | 149 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c    | 138 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2u.h       |  99 +++
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  | 195 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  | 317 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   | 240 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  | 182 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c   | 667 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c   | 311 ++++++++++
 drivers/net/wireless/mediatek/mt76/tx.c            |   9 +-
 drivers/net/wireless/mediatek/mt76/usb.c           | 613 ++++++++++++++++++
 36 files changed, 4849 insertions(+), 1696 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb.c

-- 
2.16.3
