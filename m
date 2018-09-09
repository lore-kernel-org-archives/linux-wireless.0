Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35770 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBXr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:47 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so19378539wmc.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] move mcu usb code in mt76x02-lib module
Date: Sun,  9 Sep 2018 22:32:35 +0200
Message-Id: <20180909203246.21608-1-lorenzo.bianconi@redhat.com> (sfid-20180909_223258_423141_C8E3DF0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first of two series that unify mcu code between pci and
usb drivers. That patchset will be used to properly support mt76x0e
chipsets without duplicating the code.
Moreover this patchset moves MT_TXD_INFO, MT_MCU_MSG and
MT_RX_FCE_INFO definitions in mt76x02-lib module since other chipsets
(e.g.  mt7603) use different dma definitions
The full series can be found at:
https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76_mcu_unify
This patchset is rebased on top of
https://marc.info/?l=linux-wireless&m=153635751522507&w=2
and
https://marc.info/?l=linux-wireless&m=153622554611313&w=2
(dropping patch 38/42 and 39/42)

Lorenzo Bianconi (7):
  mt76: move mt76x0 and mt76x2 mcu shared defs in mt76x02_mcu.h
  mt76: add mt76_mcu_ops data structure for mcu related pointers
  mt76: usb: use common helpers for mcu_alloc_msg()/mcu_send_msg()
  mt76: usb: move mt76x02 mcu code in mt76x02-usb module
  mt76: usb: move mt76u_skb_dma_info in mt76x02_usb_core.c
  mt76x02: move TXD/RXD/MCU definitions in mt76x02_dma.h
  mt76x02: add static qualifier to mt76x02_remove_dma_hdr

Stanislaw Gruszka (4):
  mt76: add usb implementation of {wr,rd}_rp
  mt76: add rd_rp and wr_rp to bus_ops/mcu_ops
  mt76x0: remove unused mt76x0_burst_read_regs
  mt76x0: remove mt76x0_burst_write_regs()

 drivers/net/wireless/mediatek/mt76/Kconfig    |   8 +-
 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +
 drivers/net/wireless/mediatek/mt76/dma.h      |  38 --
 drivers/net/wireless/mediatek/mt76/mt76.h     |  39 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  30 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 171 +--------
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |  51 +--
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   7 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |   9 +-
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  60 +++
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  71 ++++
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  29 ++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  72 ++++
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 359 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  26 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.h |   2 -
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.h   |  49 +--
 .../net/wireless/mediatek/mt76/mt76x2_tx.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2_usb.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2u_core.c |   3 +-
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  |  69 ++--
 drivers/net/wireless/mediatek/mt76/usb.c      |  92 +++--
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  | 242 ------------
 28 files changed, 764 insertions(+), 681 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c

-- 
2.18.0
