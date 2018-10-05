Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0BAC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6577F20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6577F20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbeJEO61 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:58:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53424 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeJEO61 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:58:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id b19-v6so941919wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eWzE+n1iAZWUqSs3FtDjui8qKYg7qsYOgNwO8uSHw4E=;
        b=QPQINBqCcRX7jNomi5+NenwN/+L7wfuGB2fC+uIhbwc42OmEpj0GfvhOmhArdXQmXc
         sGSJbCvzFeNS1lTzdfFKwmp0LYWVnak0U+zWuzW1NA7ca8YNwavekqSRrMfaepmoO0b/
         HqcQFS+DR6jT6uyCh2PMhGVzuS50urKHs0ykBxH1q6Z4uVt6w0onxe368nH0hG5cWIPB
         4Z/SvLoLvw16tHntk5a5sAFicUzeT055QmcsQDPIGXcrUyF/bHG5zGyriD4Vp/fTa/0X
         iE0/Q1QpqN1xeGzzqV6zBwTx0WVJwA3u6RbOyGzYYKzrtV+Goc9OSiaO5s9OSJ1eabU/
         QL8g==
X-Gm-Message-State: ABuFfojRGn/25o8KMuhByIne2v7+fv3YAmV6wUeqeetnlrNxwUcRQDlP
        cfMwjKm85rweCsdnRRWnMNMp5+UTlv4=
X-Google-Smtp-Source: ACcGV60x569Z2S9CcV9XeqzK+4RipyhL4XcUeFLd/0Hw+59+dfVjq3f05Y8nm+8UB/sekElolS7qqQ==
X-Received: by 2002:a1c:9d43:: with SMTP id g64-v6mr6600635wme.26.1538726452677;
        Fri, 05 Oct 2018 01:00:52 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d2-v6sm4826947wrn.20.2018.10.05.01.00.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:00:52 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/3] split code in mt76x02_util.{c,h}
Date:   Fri,  5 Oct 2018 10:00:31 +0200
Message-Id: <cover.1538726002.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move shared tx/rx code in mt76x02_txrx.c. Moreover rename
mt76x02_util.h in mt76x02.h since now it contains most
relevant mt76x02 data structures

Changes since v1:
- Rebase on top of 'unify rxwi parsing between mt76x0 and mt76x2 drivers'
  https://marc.info/?l=linux-wireless&m=153869000528661&w=2

Lorenzo Bianconi (3):
  mt76: move txrx shared routines in mt76x02_txrx.c
  mt76: rename mt76x02_util.h in mt76x02.h
  mt76x2: remove leftover function declatarions

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   3 -
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |   3 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   5 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   2 -
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   1 -
 .../mt76/{mt76x02_util.h => mt76x02.h}        |   3 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |   5 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   5 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 159 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   5 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 145 +---------------
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   |   1 -
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |   3 +-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |   1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  14 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |   2 -
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |   1 -
 28 files changed, 175 insertions(+), 203 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x02_util.h => mt76x02.h} (98%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c

-- 
2.17.1

