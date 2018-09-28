Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F67C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4016421547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4016421547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbeI1SCx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34019 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbeI1SCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id z4-v6so4660587wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U0bwOYyx3eQEuF63L5T3yFk6RCEcBnqnKD50I2mRyNs=;
        b=F2psqfj1zsWefWySWkG+xciXLXLlpx+3UrF4YflwwUcWUkrPsfNeKRjfi6YZMkah0c
         llUCNudRJZ7+5drHJ6q06wFbCN74VsizRoupXMlYh6T2Y8zY7IeGPg/bcmHm2eeFZbf0
         mEoLm6JuauFILDlM3MKdzTFdUYX7ot8v0haz2ftA8AnqVs4RS9D4Kvq4H3nsQAhgK/F1
         fVizcxi33jByavlOZQ4JgPUalhG5vms/uu6L3NqRqH4P5N604+dQ0LmDD5Kkp+dpu4vE
         fRFIb4ZhVbhdjhYa0xPjrOJKKI1XvNiTVnFn6G9Xj9Hh8Xvhf5NqdTp97CLMVeJjpenI
         LfGQ==
X-Gm-Message-State: ABuFfoh88F7amETErGh0sWf7KQk+ONWgFXrWCdhMl0/a/iO9mtshjsKn
        K9+XrvjxCu5yAjKSk1DwjOrlPQ==
X-Google-Smtp-Source: ACcGV60YxM7XImvUAxoXTvqlsJprelAgLHeqZyJqMsAZ1uKmP7QHdlZn8W0t9XqGWMzFku/L7bWgAQ==
X-Received: by 2002:adf:f1ce:: with SMTP id z14-v6mr2381356wro.214.1538134770299;
        Fri, 28 Sep 2018 04:39:30 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:29 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 14/24] mt76x0: init: remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp
Date:   Fri, 28 Sep 2018 13:38:57 +0200
Message-Id: <ef54f883cc71e560ef3fd8f3962fbb932598b7eb.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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
index 6a76fcee8de3..a53d25e826f1 100644
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

