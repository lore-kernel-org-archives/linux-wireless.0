Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1A6C5ACCC
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453A92145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 453A92145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbeJQFQD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:03 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41952 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbeJQFQC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:02 -0400
Received: by mail-wr1-f47.google.com with SMTP id x12-v6so27215994wru.8
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYeGcYCWv0ObdhKAVE4dFxlYIJ0yjxOxocG+din3EqA=;
        b=uS72r9FXOtbZ7bIV37CHnRUJgEAT1s1hoZuQmQqR7njpQn2V4mGHUu7nYkJCYgK0cq
         X91Jren1Bg2GuQLRVk3XJZ344yms5R5C2V6zSYlmXxw6fH0sYKay6uXUQ8gUa/ldcLHU
         ynZOcamRfSAWW3fouoUzdDsG/rOO2EpSEjv0cq8RXYmP3o0N3RBhkvzgVMdhx/8tHJwV
         PJEbEXyk4iO8ZyA3d4dwIxF0h7q2TBS/Dwnn4wTKoqEB7VmLRB0F1k3DKnEEyoxrvtv7
         5WL+LuL8LcGDRdjtSaDm04DgPtRABKRPt9MI6h6dPRUJjG5Rks9/vJVL/u+1jsrIYESy
         L2rg==
X-Gm-Message-State: ABuFfoj3kp9qksaRgWJr5tzFC9Z/sRfwTh1UGviC2hzEdxpuU5Q5rXh/
        1UYEqSAUciUYg2IU2PgNWdC0+yQhKL8=
X-Google-Smtp-Source: ACcGV606jP8GQfw+Mam/UHExnivoiozRiYIFjbgbIcDwWI4HYZNtZN02/ZdS9YApkV/56jH20loGlw==
X-Received: by 2002:adf:e842:: with SMTP id d2-v6mr18908979wrn.175.1539725024748;
        Tue, 16 Oct 2018 14:23:44 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:23:44 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/9] enable AP support in mt76x0e driver
Date:   Tue, 16 Oct 2018 23:23:22 +0200
Message-Id: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add beacon transmission/management support to mt76x0 driver.
Add missing mac80211 callbacks to mt76x0e driver in order
to enable AP support

Lorenzo Bianconi (9):
  mt76: move mt76x02_init_device in mt76x02-lib module
  mt76: move mac beacon routines in mt76x02-lib module
  mt76: move tx beacon routines in mt76x02-lib module
  mt76x0: pci: add pre_tbtt_tasklet support
  mt76: move mt76x02_sw_scan and mt76x02_sw_scan_complete in mt76x02-lib
    module
  mt76: move mt76x02_get_txpower in mt76x02_util.c
  mt76: move mt76x02_sta_ps in mt76x02-lib module
  mt76: introduce mt76x02_init_beacon_config routine
  mt76x0: pci: enable AP support

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |   2 -
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  44 +----
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |  20 ---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  52 ++----
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   5 -
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  24 ++-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  10 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 123 +++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   6 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 127 ++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 163 +++++++++++++++++-
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2/init.c  |  34 ----
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |   5 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   5 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  65 +------
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 118 -------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  55 +-----
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    | 142 ---------------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   5 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  22 +--
 22 files changed, 487 insertions(+), 549 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c

-- 
2.19.0

