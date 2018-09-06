Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbeIFNxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:34 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 00/42] mt76 patches 2018-09-06
Date: Thu,  6 Sep 2018 11:18:16 +0200
Message-Id: <1536225538-16454-1-git-send-email-sgruszka@redhat.com> (sfid-20180906_111912_276964_6009C0EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all I know that I should post small set of about 12 patches max,
but let say this is last exception. Starting from now, I'll not gathering
patches on my github tree and mt76 patches need to be posted directly to
linux-wireless mailing list.
  
The set include:
- more of mt76x0/mt76x2 integration
- various cleanups
- split between mmio and usb bus modules 
- initial mt76x0e bus probe/remove functions.

This is on top of my previous set:
https://marc.info/?l=linux-wireless&m=153607208328431&w=2

Lorenzo's patches were reviewed and tested by me and my patches were
hopefully reviewed by Lorenzo. If some issues will be found in this
or previous set, I hope the issues could by addressed by incremental 
patch(es) on top of this set.

Lorenzo Bianconi (35):
  mt76x2: change mt76x2_tx_complete routine signature
  mt76: move mt76x2_tx_complete routine in mt76x02-lib module
  mt76: move mt76x2u_remove_dma_hdr in mt76x02-lib module
  mt76: move mt76x2u_tx_complete_skb in mt76x02-lib moudule
  mt76: move mt76_qsel definition in dma.h
  mt76: move mt76x2u_set_txinfo in mt76x02-lib module
  mt76x0: introduce mt76x0_tx_prepare_skb routine
  mt76: move mt76x2u_tx_status_data in mt76x02-lib module
  mt76x0: init mt76_driver_ops callbacks
  mt76x0: use mt76_alloc_device for device allocation
  mt76x0: disable usb rx bulk aggregation
  mt76x0: mark device as running in mt76x0_start
  mt76x0: simplify mt76_mac_process_rx signature
  mt76x0: add mt76x0_queue_rx_skb routine
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

Stanislaw Gruszka (7):
  mt76x0: trim rx skb to proper length
  mt76x0: inital split between pci and usb
  mt76: initial separation of mmio part
  mt76: move some irq code to common mmio module
  mt76x0: remove unused mt76x0_wcid
  mt76x0: remove some usb specific code from mt76x0_register_device
  mt76x0: make device allocation bus neutral

 drivers/net/wireless/mediatek/mt76/Kconfig         |  31 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |  10 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  68 +++
 drivers/net/wireless/mediatek/mt76/dma.h           |   7 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 -
 drivers/net/wireless/mediatek/mt76/mmio.c          |  32 +-
 drivers/net/wireless/mediatek/mt76/mmio.h          |  34 ++
 drivers/net/wireless/mediatek/mt76/mmio_trace.c    |  23 +
 drivers/net/wireless/mediatek/mt76/mmio_trace.h    |  71 +++
 drivers/net/wireless/mediatek/mt76/mt76.h          |  20 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |  11 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    | 526 ---------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  26 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |   3 -
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 332 ++++---------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  14 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  92 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  81 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 122 ++---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  63 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  98 ++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |   8 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  18 -
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c   |  26 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    |  29 --
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  11 +-
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |  29 --
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  18 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h       |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  59 +--
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |   9 +-
 drivers/net/wireless/mediatek/mt76/trace.c         |  23 -
 drivers/net/wireless/mediatek/mt76/trace.h         |  71 ---
 drivers/net/wireless/mediatek/mt76/tx.c            |  66 ---
 42 files changed, 725 insertions(+), 1369 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio_trace.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/trace.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/trace.h

-- 
2.7.5
