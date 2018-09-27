Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322ADC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E06482156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E06482156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbeI0PTP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45245 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbeI0PTP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id m16so1664287wrx.12
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tZNjzmF0w8Ozhx/wibP7uz66byt38VphoeXJMIg2DWw=;
        b=lU0pj/zb1Sxz7pRXU+2PIcG/7IxaV08dalkO/zIzaYcwR9HHKFdJkXX4M1u5YvUnb5
         c/ZxpatL4yKbPrlmFTkoIY9BkCFlkIZUtyBT3OXlmVzDzbMixR+Lelb8HhRGojWFr5yL
         hz/4WAn+yWB6qGXNEpzZwmKRAJjCzx9Gaq7pgbJEbydyaD33ZBjQ4dBytwVdk+4y2aVn
         rbxi+IAJV38am2Rm88VPhYsUrh/4hDwQC5mMW+CiiBsNg2S3yEL11tf4ueiV6eBdi1qh
         kK54K5pwu4AwDdM6aL/MO+0DjUMVH6lYcVSD+TobsNVdRJmZbNNryYBTKJ8gah8nu3fe
         tUgA==
X-Gm-Message-State: ABuFfoiLXqf7tzsKIODbDxyFbIoBnU6MZjJPGPHAoSfti4kyx6jKqDPs
        kqluPkHlzYd32LjDXnYpDnZ8sg==
X-Google-Smtp-Source: ACcGV62zQOBU14qkoE6yTrifJh8+bYl0rMdIZDUIJ4AsWmEdquqVd2BQ2RtWgxJY+CRfWZuXYT25jg==
X-Received: by 2002:a5d:4b84:: with SMTP id b4-v6mr8317491wrt.168.1538038921647;
        Thu, 27 Sep 2018 02:02:01 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:01 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/26] add mt76x0e hw initialization support
Date:   Thu, 27 Sep 2018 11:01:29 +0200
Message-Id: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add hw initialization support for mt76x0e driver.
Remove usb dependency from generic init code (there is a
usb dependency in tx generic code not fixed yet).
Fix memory leak in mt76x0u_probe

Lorenzo Bianconi (26):
  mt76x0: use mt76_poll in mt76x0_set_wlan_state
  mt76: move wait_for_wpdma in mt76x02_dma.h
  mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
  mt76: move mt76x02_set_irq_mask in mt76x02_core.c
  mt76: move queue initialization in mt76x02_dma.c
  mt76: move mt76x02_beacon_offset in mt76x02_core.c
  mt76: mmio: add implementation of wr_rp and rd_rp
  mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
  mt76x0: update initvals to latest version of verndor driver
  mt76x0: pci: move mcu code in pci_mcu.c
  mt76x0: usb: move mcu code in usb_mcu.c
  mt76x0: use mt76x02 utility routines in mt76x0 init code
  mt76x0: init: remove duplicated initialization
  mt76x0: init: remove MT_PBF_SYS_CTRL configuration in
    mt76x0_reset_csr_bbp
  mt76x0: init: reset beacon offset during bootstrap
  mt76x0: init rx filter in mt76x0_init_hardware
  mt76: add mt76x02_mac_start routine
  mt76x0: usb: move initialization code in usb_init.c
  mt76x0: pci: add hw initialization at bootstrap
  mt76x0: phy: set antenna parameter according to wireless band
  mt76: move set_{tx,rx}_path routines in mt76x02-lib module
  mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature
  mt76x0: pci: add mt76x0e_start callback
  mt76x0: pci: add mt76x0e_stop callback
  mt76: move eeprom_load routines in mt76x02_eeprom.c
  mt76x0: introduce mt76x0{e,u}_eeprom_init routines

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 drivers/net/wireless/mediatek/mt76/mmio.c     |  27 ++
 drivers/net/wireless/mediatek/mt76/mt76.h     |   7 +-
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   4 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  21 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 205 ++-------
 .../wireless/mediatek/mt76/mt76x0/initvals.h  | 405 ++++++++----------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  84 ++--
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   2 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  30 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 115 +----
 .../wireless/mediatek/mt76/mt76x0/pci_init.c  | 126 ++++++
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   | 146 +++++++
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  62 +--
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 190 +-------
 .../wireless/mediatek/mt76/mt76x0/usb_init.c  | 197 +++++++++
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 176 ++++++++
 .../net/wireless/mediatek/mt76/mt76x02_core.c |  72 ++++
 .../net/wireless/mediatek/mt76/mt76x02_dma.c  | 136 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  17 +
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 154 +++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  15 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  38 ++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  22 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  39 +-
 .../net/wireless/mediatek/mt76/mt76x2_core.c  |  28 +-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  91 +---
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 157 +------
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |  75 +---
 .../mediatek/mt76/mt76x2_init_common.c        |  17 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   |  14 +-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |   2 +-
 .../mediatek/mt76/mt76x2_mcu_common.c         |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |   2 -
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  16 +-
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  |  33 --
 43 files changed, 1483 insertions(+), 1263 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.c

-- 
2.17.1

