Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbeHXOto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 00/17] mt76 patches 2018-08-24
Date: Fri, 24 Aug 2018 13:15:04 +0200
Message-Id: <1535109321-17126-1-git-send-email-sgruszka@redhat.com> (sfid-20180824_131536_197822_51DDD3DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the begin work of integration between mt76x0 and mt76x2.

Further development can be seen here:
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2

Stanislaw Gruszka (17):
  mt76: unify wait_for_mac
  mt76: rename mt76x2_regs.h
  mt76: merge mt76x0/regs.h into mt76xx_regs.h
  mt76: create new mt76xx-lib module for common mt76x{0,2} code
  mt76: fix mt76xx-lib module license
  mt76: unify mac_get_key_info
  mt76: add helpers for register access with mt76_dev struct
  mt76: unify mac_shared_key_setup
  mt76: unify mt76xx_mac_wcid_set_key
  mt76: unify mac_wcid_setup
  mt76: use mac_wcid_set_drop in mt76x0
  mt76x0: use mt76_wcid_free in mt76x0
  mt76: unify mt76xx_vif struct
  mt76: unify sta stucture part 1
  mt76: unify sta structure part 2
  mt76x0: initalize custom tx queues
  mt76x0: use mt76xx_sta and mt76xx_tx_status

 drivers/net/wireless/mediatek/mt76/Kconfig         |   6 +
 drivers/net/wireless/mediatek/mt76/Makefile        |   3 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |  13 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  37 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 126 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 127 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  35 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   | 651 --------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  50 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  99 +--
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  15 +-
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  21 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 130 +---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  47 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   | 619 -------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   8 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  29 +-
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c    | 157 +++++
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h    |  85 +++
 drivers/net/wireless/mediatek/mt76/mt76xx_regs.h   | 685 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76xx_util.c   |  55 ++
 drivers/net/wireless/mediatek/mt76/mt76xx_util.h   |  25 +
 36 files changed, 1226 insertions(+), 1861 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_util.h

-- 
1.9.3
