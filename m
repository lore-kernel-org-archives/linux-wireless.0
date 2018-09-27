Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41685C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0436A2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0436A2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbeI0PT3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37283 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PT3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so1703415wrr.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TrSL7pDDT3K3e6J3BldreeTfoSmvX/hizDWYQt2NsCE=;
        b=mU7mwxCqmFveonki81ZM/9TOVKyQpIO7MDXGaAJuPN2KgyuEWOFzWImZWvoH14ak7m
         A4vDmg2dVhHxWFpb28clCixzqPlxdtfyi4KkCTH86vm/SNtWv3JojlAy5yqTk0diKDaC
         dfYXVrkaZkXMrvi/uZMIOjNZsOHCcT40B3EJyCxyzC8ts20FnKQ0tWsKL31OYQeDLWEK
         agiL7noPKIKQPibk0w1WsKzJwSPO7Xh8hIfP9YU024aJBuR/olS9T2WGfK4u9Gf7MlIq
         V+cI7xdARKoFhf2S71eh1Rh72TQ+uZSQhpZh3nvNAkXBvzo5evbFjVFgjuSh0sc5D93S
         XoDw==
X-Gm-Message-State: ABuFfohYTT7kY7BlH4zLqLM2jWb9rf8a+uEWptXwmbCgdod7hQToc1XO
        xLmDcgs8VcobJgrPfOjjdAXxQA==
X-Google-Smtp-Source: ACcGV63wmnQ547OWoc43H6L5LKi3OeeSvlgISLTGHnPToYsN5/TeFbEDBZ2iQssDSdjBHdHBQFpLxQ==
X-Received: by 2002:adf:de05:: with SMTP id b5-v6mr7835869wrm.185.1538038935535;
        Thu, 27 Sep 2018 02:02:15 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:15 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 14/26] mt76x0: init: remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp
Date:   Thu, 27 Sep 2018 11:01:43 +0200
Message-Id: <c1a6d558a9b7cd1b5cc29226d736ef5f812c1c4c.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp since
it is already initialized in mt76x0_init_mac_registers routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index f04fd0163f94..03211fd0db33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -103,15 +103,9 @@ EXPORT_SYMBOL_GPL(mt76x0_chip_onoff);
 
 static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 {
-	u32 val;
-
-	val = mt76_rr(dev, MT_PBF_SYS_CTRL);
-	val &= ~0x2000;
-	mt76_wr(dev, MT_PBF_SYS_CTRL, val);
-
-	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR |
-					 MT_MAC_SYS_CTRL_RESET_BBP);
-
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_RESET_CSR |
+		MT_MAC_SYS_CTRL_RESET_BBP);
 	msleep(200);
 }
 
-- 
2.17.1

