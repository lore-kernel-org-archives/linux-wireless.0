Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10F3C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C0802172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C0802172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbeI1NCl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55649 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1NCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id 206-v6so1028428wmb.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vr6cRcTgN6zw5y1ipI5XfFdgx2MRWGm4iwaXwsAtHjo=;
        b=ke7i4Rp5lrE3eX1vINW1a03pqI6zfolZ/zK2OIwezo8CLAxgp1NjMsxbY1mI9dnkxE
         wYD3V4ll4l59pAfgIWjp+KC0EfKoHuakEHlfuL1EBVB+j4cGvSIh8vJgsClMbW3MJIQ1
         AcY/Dk6Rvv+4yHXAqWp+j4W3WsqUW06cXKWJJEff4syD5/a17p1fnxEURtKedhLIe8U4
         Yt6AiNuLjblEGH9+dP1ixMETvpGcpfb5AjNgP39/uTyd0tTVJ4xX8XInfajpk10YZ7+R
         v6s4bGYBnAxpf1sDiAF53crZvUGx2l5DRLLnKUR0hzdkZ9B72d5U8MhV0RadQv3WdCH8
         JUng==
X-Gm-Message-State: ABuFfoiHukB6S9ZD4Z8w9nI05NDpgDPMYIUswmxCYJO20jkOYCOR1LlM
        PJAno8CnwsZwogCW92+op/WTMxr8wvY=
X-Google-Smtp-Source: ACcGV62qgm2qr0kK71YCkZcxe1Es0wSd1Ye9iXhd8O0i6hfHe8nmOb0WiSCOyiy+Lj3N+bl+IfF2eA==
X-Received: by 2002:a1c:a685:: with SMTP id p127-v6mr637640wme.68.1538116827348;
        Thu, 27 Sep 2018 23:40:27 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/24] add mt76x0e hw initialization support
Date:   Fri, 28 Sep 2018 08:39:53 +0200
Message-Id: <20180928064017.26870-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add hw initialization support for mt76x0e driver.
Remove usb dependency from generic init code (there is a
usb dependency in tx generic code not fixed yet).
Fix memory leak in mt76x0u_probe

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
2.19.0

