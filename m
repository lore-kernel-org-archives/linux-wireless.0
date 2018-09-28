Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D17C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3972A21547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3972A21547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbeI1SCl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:41 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53316 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbeI1SCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:40 -0400
Received: by mail-wm1-f43.google.com with SMTP id b19-v6so1883668wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G1VlB9M7ZTYJ0Ng8CJAYdeX3kQHwt9DygFUr33wh5SE=;
        b=NZQgbEUx61vhUNTiX8kk1A3VLlC4Le/P2bIpLHDTlPlhMz/pRlgWKYaoVnmBYM/JM0
         EM1ZYoH5Zdl6KkGdWzyHQnWFtjEf+nYTviclXVc4AyLQTTbpt/kXRTG0b8g2dZsfa5+x
         2hwaZPGiXmoIBxl5MhFEAv4v3NylPbUsEhEwjL7qsF1u3sXMrFmV+WT80mrSLOTOca17
         OqU8Grs7TMNrjprZpYj5Ri0svbaTFsEHJv+++svFeG4zykExRBAZjvBwZk53nAkNiEF9
         Six9iDLWrqWXVkhTK9zwP2A3gws/Dcue6Ljv2F+eOxbpSkNQ7nW9ZcN9xSji4yitA52T
         19uw==
X-Gm-Message-State: ABuFfoi3/xYUptqMxiWPz5/rT9cIZcT1GB4K/3opP7lIC7aoR0/HJxSS
        dSJw26UjTfqX6Vhh+GJtgXQ2jQ==
X-Google-Smtp-Source: ACcGV61j96oTaqJywKzLnhH7cGpb6zWRJNzl7YnzTjqnHaqt5XHRHc3HMRQx5qOMa8OaYQ4PrIxQcQ==
X-Received: by 2002:a1c:357:: with SMTP id 84-v6mr1417036wmd.8.1538134756337;
        Fri, 28 Sep 2018 04:39:16 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:15 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 00/24] add mt76x0e hw initialization support
Date:   Fri, 28 Sep 2018 13:38:43 +0200
Message-Id: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add hw initialization support for mt76x0e driver.
Remove usb dependency from generic init code (there is a
usb dependency in tx generic code not fixed yet).
Fix memory leak in mt76x0u_probe

Changes since v2:
- rename mt76x02_wait_for_txrx_active in mt76x02_wait_for_txrx_idle

Changes since v1:
- rename mt76x02_wait_for_bbp in mt76x02_wait_for_txrx_active
- drop patch 15/16: mt76x0: init: reset beacon offset during bootstrap
- move mt76x02_dma_enable/mt76x02_dma_disable in mt76x02_mmio.c
- move mt76x02_set_beacon_offsets in mt76x02_util.c
- move mt76x02_mac_start in mt76x02_mmio.c
- merge patch 23/26 (mt76x0: pci: add mt76x0e_start callback)
  and patch 24/26 (mt76x0: pci: add mt76x0e_stop callback)
- move {pci/usb} init code in {pci.c/usb.c}
- load eeprom data from mtd memory dy default
- add "mt76x0: usb: move mt76x0u_tx_prepare_skb in usb.c" to remove
  last usb dependency from generic code

Lorenzo Bianconi (24):
  mt76x0: use mt76_poll in mt76x0_set_wlan_state
  mt76: move wait_for_wpdma in mt76x02_dma.h
  mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
  mt76: move mt76x02_set_irq_mask in mt76x02_mmio.c
  mt76: move queue initialization in mt76x02_mmio.c
  mt76: move mt76x02_beacon_offset in mt76x02_util.c
  mt76: mmio: add implementation of wr_rp and rd_rp
  mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
  mt76x0: update initvals to latest version of vendor driver
  mt76x0: pci: move mcu code in pci_mcu.c
  mt76x0: usb: move mcu code in usb_mcu.c
  mt76x0: use mt76x02 utility routines in mt76x0 init code
  mt76x0: init: remove duplicated initialization
  mt76x0: init: remove MT_PBF_SYS_CTRL configuration in
    mt76x0_reset_csr_bbp
  mt76x0: init rx filter in mt76x0_init_hardware
  mt76: add mt76x02_mac_start routine
  mt76x0: usb: move initialization code in usb.c
  mt76x0: pci: add hw initialization at bootstrap
  mt76x0: phy: set antenna parameter according to wireless band
  mt76: move set_{tx,rx}_path routines in mt76x02-lib module
  mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature
  mt76x0: pci: add mt76x0e_{start/stop} callbacks
  mt76x0: eeprom: load eeprom data from mtd by default
  mt76x0: usb: move mt76x0u_tx_prepare_skb in usb.c

 drivers/net/wireless/mediatek/mt76/Makefile   |   2 +-
 drivers/net/wireless/mediatek/mt76/mmio.c     |  27 ++
 drivers/net/wireless/mediatek/mt76/mt76.h     |   7 +-
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   4 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  58 ++-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 191 ++-------
 .../wireless/mediatek/mt76/mt76x0/initvals.h  | 405 ++++++++----------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  91 +---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   2 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  28 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 178 ++++----
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   | 146 +++++++
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  62 +--
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |  24 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 297 ++++++-------
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 176 ++++++++
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  17 +
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 161 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  38 ++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  38 ++
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  24 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  39 +-
 .../net/wireless/mediatek/mt76/mt76x2_core.c  |  28 +-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  91 +---
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |  75 +---
 .../mediatek/mt76/mt76x2_init_common.c        |  17 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   |  14 +-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |   2 +-
 .../mediatek/mt76/mt76x2_mcu_common.c         |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |   2 -
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  16 +-
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  |  33 --
 36 files changed, 1226 insertions(+), 1081 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c

-- 
2.17.1

