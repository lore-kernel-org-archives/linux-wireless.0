Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9613DC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6803520684
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6803520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbeJDS75 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 14:59:57 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42723 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeJDS75 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 14:59:57 -0400
Received: by mail-wr1-f42.google.com with SMTP id g15-v6so7017367wru.9
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qp8ivDGHQQfuVDFj02iL8ibd2MfWB7sosKu1Jzj/Z+U=;
        b=Sb+9Yvq8DbCOqGIroOHs6LD+xRRMvBec4a2NpsmB71ro/jVr9qE58KGSG3y058HsSm
         m89ggIbFwcSp/4kYm/+Dd4D1oivpXtkH1MERIVsE2Kp7O49cNW0Vd18px17QpXQGmAyO
         g9NuYx0wyeLvjV8SSv/q5XQkqJ0ppu6lIZpt2v3fbokvMhTnTv5lv+UEbHAqAJG9oKZY
         vepPE4EMgqjVjlkmargVDnF2UW8M45Jy0rbtDrAMJ4ycvXGUTPTEdAKi/YsXLergzz3m
         Wm/KPU+BfU9VZX7Dpq502l1NsK+0qw7EG8hd6Q3WKcOZ5+qKLqJtodD7ZAFkWmfDgqqK
         ciAA==
X-Gm-Message-State: ABuFfoiWGQoUc5hJU+nHsFhXkw9o0D6CrPSyg4BwQk1MKGZHbYABxwt6
        /Y14G0Vs5fZNvCM2phoHntvtuw==
X-Google-Smtp-Source: ACcGV63eZ8Phx1OH/6rnz6HdX16a8HHfJilWwcUf5dGuKoPqWgGYudDEhVhroU3biOjdpin5EJR/wA==
X-Received: by 2002:adf:cf0b:: with SMTP id o11-v6mr4527710wrj.272.1538654816870;
        Thu, 04 Oct 2018 05:06:56 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:06:56 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/7] use mt76x02_dev instead of mt76_dev as reference
Date:   Thu,  4 Oct 2018 14:06:43 +0200
Message-Id: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
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

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  53 ++++----
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  34 +++--
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  10 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   |  33 +++--
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  20 +--
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 121 +++++++++---------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  24 ++--
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  |  74 ++++++-----
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  14 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  89 +++++++------
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |   8 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  29 ++---
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |   8 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  27 ++--
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 119 ++++++++---------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  80 ++++++------
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
 34 files changed, 445 insertions(+), 469 deletions(-)

-- 
2.17.1

