Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB42C65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8FA20882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C8FA20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbeJGQwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:52:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53125 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbeJGQwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 12:52:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id 189-v6so5391840wmw.2
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hpw0h6YE90iluS2P7mAuYi1Cj36ZWf4PEBxGP/9Pj20=;
        b=I4yCYa9kAvUhcniXqtrgfWkVyr5xfGm+wT2zQzn2qn3F7qNCsjSOGLIS1FaASBy3bX
         lzAY+OV1g+L+8InGM6O923Y1bwUQTN2mfJ+PaOGaEV+VVz9kUkkAxFguowsaLAIMlyL3
         2Zyw0hvNLRYQgnflhebP7lvuWtzf8b9ljDzfUhysYarWgnbgFxryPpaX5k92MpUBNrji
         xVHQaf/GQcLmw2tnCa7kLlPihKKJZaZQUMEw/MCBiCXdmLSn2BnJaf6tl+zUR+1arhKW
         xfmBVdhJ6lXvfzS4Zq4wkUIKalVp5MrVWQPXeWox4YNGsWeco0BzbQPAhMFcemjKjy6F
         CzvA==
X-Gm-Message-State: ABuFfohDjKBz5vpxm98Cxj1kaWw/HnC8dY7Xy9C7+NdfY7CrvmT+0GmB
        a75jBqxrNWx6tl8uhJW/Wsb4pQB5KXI=
X-Google-Smtp-Source: ACcGV61LX2rcLODN0nAGmFdrG/DWI6bNdUXQd7FF//ogcZIPDhk1GNjTZ+qhpwxdFYgic19H5fWxJQ==
X-Received: by 2002:a1c:e0d7:: with SMTP id x206-v6mr11845768wmg.93.1538905529133;
        Sun, 07 Oct 2018 02:45:29 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id q135-v6sm6149599wmd.4.2018.10.07.02.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:45:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] use mt76x02_dev instead of mt76_dev as reference
Date:   Sun,  7 Oct 2018 11:45:17 +0200
Message-Id: <20181007094524.12656-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02 code
instead of mt76_dev one

Lorenzo Bianconi (7):
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mcu.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_phy.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_util.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_usb_mcu.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mac.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_txrx.c
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_eeprom.c

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  53 ++++---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  34 +++--
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  13 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   |  33 ++---
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  20 +--
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 129 +++++++++---------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  31 +++--
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  |  74 +++++-----
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  14 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  89 ++++++------
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |   8 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  29 ++--
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |   8 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  27 ++--
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 120 ++++++++--------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  80 +++++------
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |   5 +-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  18 +--
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  32 ++---
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  17 ++-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  11 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   |   6 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |   4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  18 ++-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  28 ++--
 34 files changed, 456 insertions(+), 477 deletions(-)

-- 
2.19.0

