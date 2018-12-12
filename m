Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D53DC67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8CD20849
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA8CD20849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbeLLVwD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 16:52:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33082 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeLLVwD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 16:52:03 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so12429829wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 13:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hi/htyE6quhyrKHfHuxx0AOhI7mAooL1+c/4iJpe7dM=;
        b=BQ3deSp0re4+ydWpmJMegmk6vLDoRmzVoA9VzrRAeq7kHY3AMCLmjdmShYDZATWCgT
         cSx1IiZrdVEkabgtULTb7Js2pWgW6kfIIEY6vSLZ3vMOkQdLdjkpeAqHSKdW2AesEvYK
         eyh4R5sUh+YgfMV/Q0wjnlXOle3Cilg7Z3WZgQbFY3l8JwXjs2oaihnw6s83pqd9hpO6
         EVM84nCD13Y8kEvNNS6bzhPJGr7R29W4wXFRt6QZe1S0eIKFXPsxHzmDNfd5SUxAlX7b
         8nfup51x0sibsOTNrM52j5yIEPse78JPYiEI7IMzvrOcIGnjPHOa4C2prylv+F//o6cz
         C1Lg==
X-Gm-Message-State: AA+aEWaciAQs/2ke8nYoJm4VEHpSxZy4hzeA4jxZK+p46iEB1YPyeZRU
        jK2YLSILAP1wKTykiSouDcv4cw==
X-Google-Smtp-Source: AFSGD/VbB3xotVgyp5IcuZ3uchx5DxVwvd4VmGxr852o5ikyPfD02h1temvWDOles2ZNpdjpHm52Dw==
X-Received: by 2002:a1c:7706:: with SMTP id t6mr7413505wmi.57.1544651521782;
        Wed, 12 Dec 2018 13:52:01 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id o17sm225615wmg.35.2018.12.12.13.52.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 13:52:01 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 0/3] add EDCCA support to mt76x{0,2}e drivers
Date:   Wed, 12 Dec 2018 22:51:52 +0100
Message-Id: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce EDCCA support to mt76 driver in order to prevent transmission
if detected energy is above the threshold.
This series is based on "mt76x0: pci: fix ACS support"
(https://patchwork.kernel.org/patch/10721037/)

Lorenzo Bianconi (3):
  mt76: dfs: run mt76x02_dfs_set_domain atomically
  mt76x2: init: set default value for MT_TX_LINK_CFG
  mt76: add energy detect CCA support to mt76x{0,2}e drivers

 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  6 ++
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  6 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 85 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_regs.h |  8 ++
 .../net/wireless/mediatek/mt76/mt76x2/init.c  |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +
 10 files changed, 114 insertions(+)

-- 
2.19.2

