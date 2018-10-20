Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578F9C67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178F82150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 178F82150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbeJTSXh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:23:37 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40053 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbeJTSXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:23:36 -0400
Received: by mail-wr1-f48.google.com with SMTP id d2-v6so39880715wro.7
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+27fONX9vpxFQvet76TUlvJjHok+oRTxLwVavkrRBXU=;
        b=Ptn/VvIW9QVk0cCfHw7UAYlK6biMF8sIifv3qmpDAi4cQsNENaKGz3aHR1jtFEHwiB
         /boxvw485udLFEYy5VHC59y5W2talCVhl8OUnWcojm7f9kQ388rWxV625amxVuTCBNW1
         es9iHCnrkoGhQUWsUX+eJU+dr2CRc1hriNUphjRNllXkZrRr3OzCB68N0Tg85ONVPNKL
         pgdxNz214us1pbcsRMvuHj4A6ldlE5PwcZUzVUNQls3pAXTw/pzRQ1nyIA+7F2mQR8A/
         kvIUkZ8SKk74Ckzk/0u2Qk1fy09Mt4rHPNTDw3p3SnY5myuJcPUYoDLj6VZxF0z5/kiX
         aJwg==
X-Gm-Message-State: ABuFfoh1F7qbEqLeowX2St6adTD6EG16Z9YEzFYOjBSA8NTXgeR8E6UZ
        WzuJFsPC2SWP886QsPspCrI5UFd7srQ=
X-Google-Smtp-Source: ACcGV62kGiG1Jo/kweGUUN8ga9zfGQ10y7PTiZUc+w9AuOtH3ljdyqcvOlFWsirAUyTxa6hgbRt+7w==
X-Received: by 2002:a5d:488a:: with SMTP id g10-v6mr38026106wrq.0.1540030420751;
        Sat, 20 Oct 2018 03:13:40 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.13.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:13:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/9] enable AP support in mt76x0e driver
Date:   Sat, 20 Oct 2018 12:13:23 +0200
Message-Id: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
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
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   6 -
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
 22 files changed, 487 insertions(+), 550 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c

-- 
2.19.1

