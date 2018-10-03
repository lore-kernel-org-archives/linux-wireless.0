Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFE5C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEECC20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEECC20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbeJCOgO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38775 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeJCOgO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id 193-v6so4558160wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:48:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TyJpkgWp0hf/PQYvLHFGlQBvjCYN+aJPSS0XqNNu65I=;
        b=o7/UygFcOZM8Crf77ZCIC/LeIzD2rE2LTEhjKHyBHN35xpMIkH3Kk5zxLqJ2C7CWIA
         HYC8hY9HDphZb9VHlfKMoDg18swBEZdju76ENJ6oIDUl6UI6pdCIQny6Do6mgPY7UnUr
         Kug5c3PXU8tcfol6++pLREvBcDMCm64uJS2cCrhCHwOdRhTap48c2Nq7H9HTDgMmo4ne
         pdWXHBdeP5+DUzDijcSAqcKW1UMfh5zHUD37B64Rt7xU3OT6sd2O4hOHpZ49hg5TTb8j
         aMHbpTzqfVP+wYOMrCuUrX+SnhL+6KYLp3XaKOt3BrmDehjCZh7e2TzTWhqi8AL/cl6L
         AQ1w==
X-Gm-Message-State: ABuFfohnyJXvb7Y8RZ95C+PmACCQ6F5VLhNbFnfC1ySKK7xVctySRPOJ
        NvR+ushnCSPhfa6RRFkCpmdjnw==
X-Google-Smtp-Source: ACcGV63NrB4x1frBvshzRQLLsRi2/Jj6dzd5H2SLksB430XwvUG0TsyF1WcivOyT8iabmtnZFS6VnQ==
X-Received: by 2002:a1c:dc0a:: with SMTP id t10-v6mr522315wmg.105.1538552938980;
        Wed, 03 Oct 2018 00:48:58 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.48.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:48:58 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/9] unify rx datapath between mt76x0 and mt76x2 drivers
Date:   Wed,  3 Oct 2018 09:48:42 +0200
Message-Id: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_irq_handler irq handler in mt76x02-lib module in order
to unify rx datapath between mt76x0 and mt76x2 drivers and remove
duplicated code

Lorenzo Bianconi (9):
  mt76: move tpc routines in mt76x02-lib module
  mt76: move mt76x02_tx_prepare_skb in mt76x02_txrx.c
  mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
  mt76: move mt76x02_mac_poll_tx_status in mt76x02-lib moudle
  mt76: move mt76x02_tx_complete in mt76x02-lib module
  mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mmio.c
  mt76: move tx_tasklet management in mt76x02-lib moudle
  mt76: move irq handler in mt76x02-lib moudle
  mt76x0: pci: add mt76x0_register_device in mt76x0e_register_device

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |   6 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  28 ++-
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
 27 files changed, 374 insertions(+), 415 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/pci_trace.c => mt76x02_trace.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/trace.h => mt76x02_trace.h} (94%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/tx.c

-- 
2.17.1

