Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36589 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeFJKvd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 06:51:33 -0400
Received: by mail-wr0-f195.google.com with SMTP id f16-v6so17437894wrm.3
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2018 03:51:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v3 00/19] add mt76x2u support to mt76 driver
Date: Sun, 10 Jun 2018 12:51:07 +0200
Message-Id: <20180610105126.28425-1-lorenzo.bianconi@redhat.com> (sfid-20180610_125144_501600_EF7DA04B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add usb layer to mt76 driver in order to support mt76x2u based devices.
Move common code between pci and usb in mt76x2-common module in order to
remove pci dependency from usb driver

Changes since RFCv2:
- move usb layer in a separate module
- add usb scatter/gather to properly support A-MSDU
- rebase on top of wireless-drivers-next master branch
- rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb and move it in dma.c

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

Lorenzo Bianconi (19):
  mt76x2: use completion instead of wait_queue for mcu rx queue
  mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in
    mcu.h
  mt76x2: move utility routines in mt76x2.h
  mt76x2: introduce mt76x2_init_device routine
  mt76x2: move interface_modes definition in mt76x2_init
  mt76x2: introduce mt76x2_mac_load_tx_status routine
  mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete
    signatures
  mt76x2: add buffer len to mt76x2_mac_write_txwi signature
  mt76: rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb
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

 drivers/net/wireless/mediatek/mt76/Kconfig    |  19 +
 drivers/net/wireless/mediatek/mt76/Makefile   |  22 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/dma.c      |  77 +-
 drivers/net/wireless/mediatek/mt76/dma.h      |   5 +
 drivers/net/wireless/mediatek/mt76/mac80211.c |  20 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     | 140 +++-
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  92 ++-
 .../wireless/mediatek/mt76/mt76x2_common.c    | 348 +++++++++
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   |   1 +
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  23 +-
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    |  13 +-
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    |   1 +
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 305 +-------
 .../mediatek/mt76/mt76x2_init_common.c        | 253 +++++++
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   | 611 +--------------
 .../net/wireless/mediatek/mt76/mt76x2_mac.h   |   2 +-
 .../mediatek/mt76/mt76x2_mac_common.c         | 683 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_main.c  | 305 --------
 .../net/wireless/mediatek/mt76/mt76x2_mcu.c   |  20 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.h   |  17 +
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   | 290 --------
 .../mediatek/mt76/mt76x2_phy_common.c         | 302 ++++++++
 .../net/wireless/mediatek/mt76/mt76x2_regs.h  |  35 +
 .../net/wireless/mediatek/mt76/mt76x2_tx.c    | 128 +---
 .../wireless/mediatek/mt76/mt76x2_tx_common.c | 149 ++++
 .../net/wireless/mediatek/mt76/mt76x2_usb.c   | 140 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |  94 +++
 .../net/wireless/mediatek/mt76/mt76x2u_core.c | 226 ++++++
 .../net/wireless/mediatek/mt76/mt76x2u_init.c | 321 ++++++++
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  | 240 ++++++
 .../net/wireless/mediatek/mt76/mt76x2u_main.c | 185 +++++
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  | 665 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  | 311 ++++++++
 drivers/net/wireless/mediatek/mt76/tx.c       |  85 +--
 drivers/net/wireless/mediatek/mt76/usb.c      | 703 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/usb_trace.c    |  23 +
 .../net/wireless/mediatek/mt76/usb_trace.h    |  71 ++
 38 files changed, 5158 insertions(+), 1769 deletions(-)
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
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.h

-- 
2.17.1
