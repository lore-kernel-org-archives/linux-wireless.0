Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BE4C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4455920652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4455920652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbeJEP0Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44433 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEP0Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id 63-v6so12598820wra.11
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=804hgexCb1d8aqTpl63NiRpmXvGFLj1eKDGalA1G+q0=;
        b=m8mqbJbrYa/T/cTfKOWHEgHU856zEWkXJDJNrygh4ccxH+zyBQci+gynv9XoxY8Ys3
         wUsIsr5IttV/SC0daUTgZzbCPiAugXjAqQ5o8iyn0LogKaZcmyAZd1PYBR2PYUFzali+
         J3Q1Nxdoh5fVeytlalhflQFhtQBApaXLuu+HmIwiFUVj2Zxi//wjKRiXOfHSBXKBAM0Q
         yzjErIeBvGP2PeNVurZ9e/qgZsNL3YSujzziWUgCAnChebBDco+xcwWdeSz0Y9Gdfw4r
         o94Sxf5CScPPfAiSf8uBsClMzzxxuCzvxk5Sj/WE1xHYH5WDaoE8SdMjEFITGEZTJvxn
         LIsw==
X-Gm-Message-State: ABuFfohXTrFodnuRqtWTZ1xsrCWJHnUqCMsZatcyOk2/SqHsO0F7aMrU
        17DPkcqxL0jH7YYGstKf7kFYvwaT+eM=
X-Google-Smtp-Source: ACcGV62VIFL4f1sQJN4qB5u7Udn3AK6njLNOpMsFkT2PYxd1nlX9lSdal/sTSMre7/Y0nZ7B2TtKKg==
X-Received: by 2002:adf:f941:: with SMTP id q1-v6mr7093352wrr.151.1538728124755;
        Fri, 05 Oct 2018 01:28:44 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:44 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] unify rx datapath between mt76x0 and mt76x2 drivers
Date:   Fri,  5 Oct 2018 10:28:30 +0200
Message-Id: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_irq_handler irq handler in mt76x02-lib module in order
to unify rx datapath between mt76x0 and mt76x2 drivers and remove
duplicated code

Changes since rfc:
- drop patch 9/9 ("mt76x0: pci: add mt76x0_register_device in
  mt76x0e_register_device") for the moment
- rebase on top of 'unify rxwi parsing between mt76x0 and mt76x2 drivers'
  https://marc.info/?l=linux-wireless&m=153869000528661&w=2

Lorenzo Bianconi (8):
  mt76: move tpc routines in mt76x02-lib module
  mt76: move mt76x02_tx_prepare_skb in mt76x02_txrx.c
  mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
  mt76: move mt76x02_mac_poll_tx_status in mt76x02-lib moudle
  mt76: move mt76x02_tx_complete in mt76x02-lib module
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mmio.c
  mt76: move tx_tasklet management in mt76x02-lib moudle
  mt76: move irq handler in mt76x02-lib moudle

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |   6 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  18 +-
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |   8 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  70 ++++++-
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  20 ++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 174 ++++++++++++++----
 .../{mt76x2/pci_trace.c => mt76x02_trace.c}   |   2 +-
 .../mt76/{mt76x2/trace.h => mt76x02_trace.h}  |  21 +--
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  72 ++++++--
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |   2 +
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  18 ++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   7 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  20 --
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  16 --
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |   3 +-
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  |  75 --------
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |  37 ----
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  24 +--
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  73 +-------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  31 ----
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    |  49 -----
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
 27 files changed, 355 insertions(+), 414 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/pci_trace.c => mt76x02_trace.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/trace.h => mt76x02_trace.h} (94%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/tx.c

-- 
2.17.1

