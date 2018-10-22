Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32D1C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB1F720652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB1F720652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbeJWGCk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:02:40 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:51033 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbeJWGCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 02:02:40 -0400
Received: by mail-wm1-f47.google.com with SMTP id i8-v6so11720723wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 14:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X0URGo7MdZN4BgVNc4nDKKuEvdDJFIy+Sc7NHwQpVMQ=;
        b=cmOMRUU+OB+XbPteavFMxgRd94TuGaXSa/3LX5O4/cMJUoarOkKjzHr4b1R4VnJdtC
         6DahAJ1gUMQAoaQqR3bmij1Ct5OWkU2p+f2QbIPSWNVJzF9vUMtS+bXr5lrFlS0mM3Mi
         uHLlXi5uxiWvl0lG/sY5PUxDN8Bnv6thv3IwUfrXQ8CjCjBvKdZXMboAw/DePDN80vTh
         P5dAYUHgNWC6yxu8LMCmFTBQ1GR13B4uXUYoKTkhZEab0w89Kme8E67hElm6KCsaFA5d
         vGq+NDMaWGMOAL69GKP2WGdZ4InK9poacV/ad3+YwShkMRPz9YrJF4f9++aauUkQWyx0
         IXFg==
X-Gm-Message-State: ABuFfoiE3ZcmRT5/WpuXPt49a9y72vg+mkF4SYZJ+PRNKDOtYMRg7i7y
        LTu9hNR9RAAXz0ouKe3VPEYhPw==
X-Google-Smtp-Source: ACcGV60QOdh+edbjzG4Vka9zpmyL3J8mpzndvnTLF4cNeHmFDGK+0Af+zY6O9gtCjUlyvTtpOFjX1Q==
X-Received: by 2002:a1c:870c:: with SMTP id j12-v6mr18110301wmd.40.1540244540313;
        Mon, 22 Oct 2018 14:42:20 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id l125-v6sm21857187wmb.1.2018.10.22.14.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 14:42:19 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] add dfs support to mt76x0e driver
Date:   Mon, 22 Oct 2018 23:42:11 +0200
Message-Id: <cover.1540243910.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce {sw,hw} dfs detector to mt76x0e driver in order to
properly unlock radar frequencies
This series is based on top of 'unify drv_bss_info_changed
between mt76x0 and mt76x2' one:
https://patchwork.kernel.org/cover/10650357/

Lorenzo Bianconi (2):
  mt76: move dfs support in mt76x02-lib module
  mt76x0: pci: add DFS support

 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  11 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |   4 +
 .../mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c}  | 162 +++++++++++-------
 .../net/wireless/mediatek/mt76/mt76x02_dfs.h  |   5 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c |   5 +
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |  25 ---
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  16 --
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  23 +--
 12 files changed, 128 insertions(+), 131 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/pci_dfs.c => mt76x02_dfs.c} (83%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h

-- 
2.19.1

