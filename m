Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:06:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 00/22] mt76 patches 2018-09-04
Date: Tue,  4 Sep 2018 16:40:53 +0200
Message-Id: <1536072075-6990-1-git-send-email-sgruszka@redhat.com> (sfid-20180904_164132_336098_232D40FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More mt76x0/mt76x2 integration.

This set is quite big but I would like to move patches upstream
from my github tree as fast as possible. I have there 42 more
ready to post patches from me and Lorenzo.
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v3

Note this set include:
"mt76x0: fix wrong usage of wcid_mask in remove_interface"
patch with I posted as fix for 4.19 . I assume this will be
auto (or manually?) merged when -next will go to 4.20.

Stanislaw Gruszka (22):
  mt76: move wcid fields to common mt76_dev struct
  mt76: unify sta_add / sta_remove
  mt76: pratially unify add_interface
  mt76x0: fix wrong usage of wcid_mask in remove_interface
  mt76: unify ampdu_action
  mt76: unify set_key
  mt76x0: remove empty sta_notify
  mt76: unify AC to hw queue mapping
  mt76: remove q->hw_idx
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

 drivers/net/wireless/mediatek/mt76/mac80211.c      |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  23 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  14 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 310 +----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    | 130 --------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 215 +-----------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  26 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 144 +-------
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |  42 ---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 347 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   | 122 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 325 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  23 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  23 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 254 +-------------
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |  17 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |   3 +-
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 110 +-----
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 368 +--------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  50 +--
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   3 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  21 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  18 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  22 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  16 +
 drivers/net/wireless/mediatek/mt76/usb.c           |   6 +-
 33 files changed, 974 insertions(+), 1723 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c

-- 
2.7.5
