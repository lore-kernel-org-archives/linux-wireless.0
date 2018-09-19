Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52478 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbeISQTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:19:01 -0400
From: Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76 2018-09-19
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <e184434e-04a0-18a9-0693-42eca0a45268@nbd.name> (sfid-20180919_124146_649766_E4727585)
Date: Wed, 19 Sep 2018 12:41:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here's a large batch of mt76 code cleanup / deduplication / fixes,
rebased to your latest wireless-drivers-next. This replaces the previous
pull request.

- Felix

The following changes since commit 43e2f2904160b9a95aad77df9cbc1622910b8598:

  Merge wireless-drivers into wireless-drivers-next (2018-09-17 17:41:02 +0300)

are available in the Git repository at:

  https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-09-19

for you to fetch changes up to bf3741ada33bb4fabec99538b8014c054854912b:

  mt76x0: usb: remove mt76_fw definition (2018-09-19 12:31:49 +0200)

----------------------------------------------------------------
mt76 patches for 4.20

* lots of mt76x0 cleanups / fixes
* mt76x2u fixes
* unify code between mt76x0, mt76x2e and mt76x2u
* rename mt76x0 to mt76x0u
* improve rx buffer allocation for all variants
* prepare for adding mt76x0e (pci-e variant) support
  add CONFIG_MT76x0E kconfig symbol

----------------------------------------------------------------
Felix Fietkau (1):
      mt76: use a per rx queue page fragment cache

Lorenzo Bianconi (58):
      mt76x2: change mt76x2_tx_complete routine signature
      mt76: move mt76x2_tx_complete routine in mt76x02-lib module
      mt76: move mt76x2u_remove_dma_hdr in mt76x02-lib module
      mt76: move mt76x2u_tx_complete_skb in mt76x02-lib moudule
      mt76: move mt76_qsel definition in dma.h
      mt76: move mt76x2u_set_txinfo in mt76x02-lib module
      mt76x0: introduce mt76x0_tx_prepare_skb routine
      mt76: move mt76x2u_tx_status_data in mt76x02-lib module
      mt76x0: disable usb rx bulk aggregation
      mt76x0: mark device as running in mt76x0_start
      mt76x0: simplify mt76_mac_process_rx signature
      mt76x0: add mt76x0_queue_rx_skb routine
      mt76x0: init mt76_driver_ops callbacks
      mt76x0: use mt76_alloc_device for device allocation
      mt76x0: unify tx/rx datapath with mt76x2u driver
      mt76x0: stop stat workqueue at hw stop
      mt76x0: set max fragments size
      mt76x0: remove unused dma.c source file
      mt76x0: remove unused stat work_queue
      mt76x0: remove unused {tx/rx}_queue definitions
      mt76x0: remove unused mt76x0_tx_status routine
      mt76x0: remove unused endpoint definitions
      mt76x0: remove unused stat_work
      mt76x0: enable per-sta tx queueing
      mt76x0: init hw capabilities
      mt76: remove unused MT76_MORE_STATS state
      mt76x0: remove mt76x0_stop_hardware routine
      mt76: move mt76 rate definitions in mt76x02-lib module
      mt76x0: alloc mcu buffers first in mt76x0_mcu_cmd_init
      mt76x0: fix memory leak during hw probe
      mt76x0: move stop related routines in mt76x0_mac_stop
      mt76x0: move mt76x0_init_hardware in mt76x0_register_device
      mt76x0: do not free/alloc buffers during suspend/resume
      mt76x0: remove has_{2,5}ghz fields of mt76x0_eeprom_params
      mt76x0: use mt76_register_device for device registration
      mt76x0: run vco calibration for each channel configuration
      mt76: move mt76x0 and mt76x2 mcu shared defs in mt76x02_mcu.h
      mt76: add mt76_mcu_ops data structure for mcu related pointers
      mt76: usb: use common helpers for mcu_alloc_msg()/mcu_send_msg()
      mt76: usb: move mt76x02 mcu code in mt76x02-usb module
      mt76: usb: move mt76u_skb_dma_info in mt76x02_usb_core.c
      mt76x02: move TXD/RXD/MCU definitions in mt76x02_dma.h
      mt76x02: add static qualifier to mt76x02_remove_dma_hdr
      mt76: usb: remove skb check in mt76x{0,2}u mcu routines
      mt76x2: use mt76_dev instead of mt76x2_dev in mt76x2_tx_queue_mcu
      mt76x2: remove leftover mt76u_buf data structure in mt76x2_mcu
      mt76: introduce mmio data structure in mt76_dev
      mt76: move __iomem regs in mt76_mmio
      mt76x2: use mt76_dev instead of mt76x2_dev in mt76x2_mcu_msg_send
      mt76x2: use common helpers for mcu_alloc_msg()/mcu_send_msg()
      mt76: unify firmware header between mt76x0 and mt76x2
      mt76: move mt76{0,2} mcu shared code in mt76x02_mcu.c
      mt76x2: move mt76x2 mcu shared code in mt76x2_mcu_common.c
      mt76: move shared mcu_calibrate routine in mt76x02-lib module
      mt76x2: move mt76x2_phy_tssi_compensate in mt76x2-common module
      mt76x0: remove mcu source file
      mt76x0: remove unused usb header file
      mt76x0: usb: remove mt76_fw definition

Stanislaw Gruszka (30):
      mt76: move wcid fields to common mt76_dev struct
      mt76: unify sta_add / sta_remove
      mt76: pratially unify add_interface
      mt76: unify ampdu_action
      mt76: unify set_key
      mt76x0: remove empty sta_notify
      mt76: unify AC to hw queue mapping
      mt76: unify conf_tx
      mt76x0: remove vif_mask
      mt76: unify remove_interface
      mt76: unify add_interface
      mt76: unify sta_rate_tbl_update and related helpers
      mt76: unify txwi and rxwi structures
      mt76: unify load_tx_status
      mt76: unify send_tx_status and related helpers
      mt76: use mt76_rx_status in mt76x0
      mt76: unify mac_process_rate
      mt76x0: reserve enough space in mac80211
      mt76: unify {insert/remove}_hdr_pad
      mt76: partially unify filling txwi fields
      mt76x0: trim rx skb to proper length
      mt76x0: inital split between pci and usb
      mt76x0: remove unused mt76x0_wcid
      mt76x0: remove some usb specific code from mt76x0_register_device
      mt76x0: make device allocation bus neutral
      mt76: add usb implementation of {wr,rd}_rp
      mt76: add rd_rp and wr_rp to bus_ops/mcu_ops
      mt76x0: remove unused mt76x0_burst_read_regs
      mt76x0: remove mt76x0_burst_write_regs()
      mt76x0: usb: move firmware loading to usb.c

 drivers/net/wireless/mediatek/mt76/Kconfig                         |  27 +++-
 drivers/net/wireless/mediatek/mt76/Makefile                        |   9 +-
 drivers/net/wireless/mediatek/mt76/dma.c                           |  16 +-
 drivers/net/wireless/mediatek/mt76/dma.h                           |  41 +----
 drivers/net/wireless/mediatek/mt76/mac80211.c                      |   3 +-
 drivers/net/wireless/mediatek/mt76/mmio.c                          |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h                          |  81 +++++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile                 |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c                    | 524 ---------------------------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c                 |  26 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h                 |   3 -
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c                   | 378 ++++++++++++---------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c                    | 323 +++------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h                    | 132 +---------------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c                   | 228 +++------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c                    | 395 -----------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h                    |  60 +-------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h                 | 125 ++-------------
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c                    |  81 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c                    |  37 ++---
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h                  |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c                     | 245 ++++++-----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c                    | 232 +++++++++++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h                    |  46 ------
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c                   |  42 -----
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h                   |  60 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                   | 347 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h                   | 122 ++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c                   | 213 ++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h                   | 100 ++++++++++++
 drivers/net/wireless/mediatek/mt76/{mt76x2_dma.h => mt76x02_usb.h} |  22 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c              |  72 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c               | 359 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                  | 401 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h                  |  29 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h                        |  42 +----
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c                 | 259 +------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c                    |  55 +------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c                   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c            |  33 +---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c                    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h                    | 110 +-------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c             | 368 ++------------------------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c                   |  50 +-----
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c                    | 261 ++-----------------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h                    |  68 +--------
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c             | 124 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c                    |  65 ++------
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c             |  49 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c                     |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c              |  39 +----
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c                    |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2u.h                       |  16 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c                  |  69 +--------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c                  |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c                  |  22 +--
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c                   | 210 +++----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c                   |  67 ++------
 drivers/net/wireless/mediatek/mt76/tx.c                            |  16 ++
 drivers/net/wireless/mediatek/mt76/usb.c                           | 105 ++++++++-----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c                       | 242 -----------------------------
 61 files changed, 2759 insertions(+), 4374 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dma.h => mt76x02_usb.h} (58%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
