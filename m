Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E1BC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E26C7214C4
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E26C7214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbeJTSvD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:51:03 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40505 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbeJTSvD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:51:03 -0400
Received: by mail-wr1-f53.google.com with SMTP id d2-v6so39924914wro.7
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJnbuMGLweM2nPZNG3RKcG5L2U49lFzjQdOBbegWLDc=;
        b=MkAU5jS62gNo8zpzgASsogePsToJpFymtTpYmqoLyiJR5W00a0ez/LmrIfpmeurtXZ
         jr0hcdQ9sanrb6cIStEroWhx2fp5UE1FWrLBtrC51WvPC4Z07dwVYhAXM3nFRXYWx9Hg
         mSBCMPXiQr7JiInQLktCGSZTVVD7noaESDSFbOCNWJJCGgYmBZ8U3VTNKgW+xV+ImEef
         EQizDkQf1w8s5X4Kw7BLnSRya3iJuq2nqy+pBezClz6GUMDzPkq4ql9mF80eqy3xaKkU
         mLO+ca+cQ9GQZN0/RmHWDG0ObbrmjlKuXTBPvbRDbRpFTy/Yl5iyDpHQ1azd1+RFWvnL
         Nwjg==
X-Gm-Message-State: AGRZ1gL0eiTfcepBrvTOCPoSj1AW8Uj3dC/FwHIq7j6v6J/7fQ9GDugp
        PuD1QZlf/SqvTwiK45Bs3jZgoV2M0h4=
X-Google-Smtp-Source: AJdET5fXSTqKmgjWz2cMYSfKAjU2Q4FHQySmbUrNralnyu+lSLqtoxJC6E4xWvbOxMNUb7K4+s1hzQ==
X-Received: by 2002:adf:e5c8:: with SMTP id a8-v6mr1796748wrn.321.1540032062105;
        Sat, 20 Oct 2018 03:41:02 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id x17-v6sm23205207wrs.84.2018.10.20.03.41.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:41:01 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] unify drv_bss_info_changed between mt76x0 and mt76x2
Date:   Sat, 20 Oct 2018 12:40:51 +0200
Message-Id: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify drv_bss_info_changed mac80211 callback between mt76x0 and mt76x2.
Move ack timeout and protection utility routines in mt76x02-lib module.

This series is based on top of 'enable AP support in mt76x0e driver' one:
https://patchwork.kernel.org/cover/10650335/

Lorenzo Bianconi (4):
  mt76: move mt76x02_set_tx_ackto in mt76x02-lib module
  mt76x0: update init vals for MT_TX_PROT registers
  mt76: move tx protection routines in mt76x02-lib module
  mt76: move mt76x02_bss_info_changed in mt76x02-lib module

 .../wireless/mediatek/mt76/mt76x0/Makefile    |  3 +-
 .../wireless/mediatek/mt76/mt76x0/initvals.h  | 15 ++--
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 77 ----------------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 63 --------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  8 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  4 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 30 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 87 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  3 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 19 +---
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 50 -----------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 69 +--------------
 16 files changed, 147 insertions(+), 300 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c

-- 
2.19.1

