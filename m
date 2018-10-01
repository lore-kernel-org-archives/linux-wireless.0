Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E9AC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2098A20645
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2098A20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbeJBFOu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 01:14:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38819 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbeJBFOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 01:14:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id a13-v6so4995686wrt.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWF1DGL10RLnWjs2qzmFKzwT0RR7mD9qm1t9qVYRnlU=;
        b=LDMfoIaaL8wlrq+EDt47d+8L/RyiBtVDutprifQpAhaDURG0Ncn8//l5oUucNbbEr6
         eeZHLcumeJSftD70JFqdeGuY1w+JIurtg/xweRqAHIeOleiX7C1VUWDXwlui3uCzCAYX
         T/NWP6Acd156aI5eb8crd486IWpjHzV9beD2giTuDLUiCbnImGbaaVOJr1UR9slM0VBK
         Xf1IAB24IA26OZz65XCRVeK5Ztf6WxG5LZzywDywi7XhYRKTtKZvR6bzO35nOG1AZ+yd
         rrNujbz3TI9WeVMlVViKNHtMb+l4eiU3LHf6/GwtWprzao1JjRY3V95vJSVa0PxrB8Hq
         K8jQ==
X-Gm-Message-State: ABuFfoiCNixGmoNSaEADjNTflQoEK48eu7RuZwNMp5KWY8Y4b+TuAx3A
        jgeSUoAFtQpNHWohoDA4FaSukn9X6Zw=
X-Google-Smtp-Source: ACcGV617FWpLL+6qr4NVqpqEamPZV1ES4hurt2m49rCtkUHX0VEYLje14tAoMM8/T9zfllWHtdAW2w==
X-Received: by 2002:adf:9e09:: with SMTP id u9-v6mr7727931wre.51.1538433288083;
        Mon, 01 Oct 2018 15:34:48 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 184-v6sm22231093wmv.6.2018.10.01.15.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:34:47 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] split code in mt76x02_util.{c,h}
Date:   Tue,  2 Oct 2018 00:34:26 +0200
Message-Id: <20181001223429.21061-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move shared tx/rx code in mt76x02_txrx.c. Moreover rename
mt76x02_util.h in mt76x02.h since now it contains most
relevant mt76x02 data structures

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
2.19.0

