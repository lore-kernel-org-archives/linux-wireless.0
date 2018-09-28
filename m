Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C92CC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC3821547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FC3821547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbeI1SCx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54521 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeI1SCw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id c14-v6so1883072wmb.4
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZvK/kGsQRPgQg66cnzvoqQP1UbS9ApdF6I5lec10jlc=;
        b=RFsAga20+LH/0rjiVZK3NKSoTLqZdR3hUNUiKMwkA5cLOoZLNxs4/2WM9b3G7VB2k1
         oJkb4/3ryJe4inwTBvwfv7/k/xIDCrGcZPvp8/lgfNhUuUreeSlD6vfCJ3IZngDKbaQ5
         NFOkULTYqSnONQuQW1VRvi7yMSn+rRaUuowgG3QbzROg8gxAjFplJd/fZsrPbhe+Q1e6
         av88F+dcKxo/qRcelq+9XzwaQ6JbIw8kmIO/zoZGWUcktVZzJVpCcE/7/8Rzpuj9rZPK
         bqe+IKKZX+DLsocEUXyrcDcBbPas6JplkxyP7WYXpoLRwXxuCpGZd7hRIlz4YSIsNXyG
         1lGA==
X-Gm-Message-State: ABuFfoi39zmjfKKUeUUqogLu7C2LcJDr+SKLX90bW5X4uwVy1+MqcHQV
        DfHP7uw4agw6NPGqF5YZLGX4nzveJCI=
X-Google-Smtp-Source: ACcGV61VkcIEHDi42To/NE/e3pBMcQmjXYi+nfW0JIVJg51RnuSj0LMXaTq4urOT2zd9dw6siznndQ==
X-Received: by 2002:a1c:8e81:: with SMTP id q123-v6mr1560559wmd.56.1538134769435;
        Fri, 28 Sep 2018 04:39:29 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 13/24] mt76x0: init: remove duplicated initialization
Date:   Fri, 28 Sep 2018 13:38:56 +0200
Message-Id: <b1027856830c196a574a01ea2270a11edb75a1fb.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove MT_HEADER_TRANS_CTRL_REG/MT_TSO_CTRL configuration
since they are already initialized in mt76x0_init_mac_registers
routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 8870f9225424..6a76fcee8de3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -363,9 +363,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	mt76x0_reset_csr_bbp(dev);
 	mt76x0_init_usb_dma(dev);
 
-	mt76_wr(dev, MT_HEADER_TRANS_CTRL_REG, 0x0);
-	mt76_wr(dev, MT_TSO_CTRL, 0x0);
-
 	ret = mt76x02_mcu_function_select(&dev->mt76, Q_SELECT, 1, false);
 	if (ret)
 		return ret;
-- 
2.17.1

