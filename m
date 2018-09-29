Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B7CC43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D992620879
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D992620879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbeI3AAF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 20:00:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52220 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbeI3AAF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 20:00:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id y25-v6so4966071wmi.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 10:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YKZ2NjTnd0KXHc/oopoOqxT42iKZhzAuvp860pmp7g=;
        b=nJlyEkpfHiJXnZM4MXfU5P3x42opgqEMoaN2DHoew+q2QzgBM+t+XO/s0LiwKV3T6p
         Q77G/8ea4coQITWdJUaG4+J5xsOl3/JQUZEDdq7oRZStT1540+PHMDSLWIh9smPhGbJt
         SExlaGEIvjzkIitAIM2/Bv6nrbOcivbTSIjXrnDaZXv++iN3nWIQNkttNZHod6hSTDV+
         w/XzDWAA9KZwZOtlQ4e1Rpd1USvcBGmNUuRih4IEI7oioMEqBjx/nlO6xqh/S2TSxnPL
         F8e0E50KhKFrRbawMk+dLd6s0jH2xkBUlWu496Hxu9uY95SH56VxSYy1Txb4JpnLLUZv
         4WEg==
X-Gm-Message-State: ABuFfoiw5xLgrxg38glhzgTe/m1Hxor8glpn0OmShNGlYHjbgd0MJWgd
        reiwmAeMoI+IhjXalPs0jrmPkw==
X-Google-Smtp-Source: ACcGV634rcJgx/IsG5aDY1lLZiy4VpjEc664Kv77abAUOJ256jimVk14aysYP1wz7XiB+1NCogGhcQ==
X-Received: by 2002:a1c:e141:: with SMTP id y62-v6mr5150296wmg.138.1538242249453;
        Sat, 29 Sep 2018 10:30:49 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e64-v6sm3823631wmg.0.2018.09.29.10.30.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 10:30:48 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: init: intrduce MT_H2M_* definitions
Date:   Sat, 29 Sep 2018 19:30:32 +0200
Message-Id: <20180929173032.32747-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add MT_H2M_BBP_AGENT, MT_H2M_MAILBOX_CSR and MT_H2M_INT_SRC and
remove magic numbers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c  | 8 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index edfd5d94d197..4b8314844d36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -174,10 +174,10 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_WMM_CTRL, reg);
 
 	/* TODO: Probably not needed */
-	mt76_wr(dev, 0x7028, 0);
-	mt76_wr(dev, 0x7010, 0);
-	mt76_wr(dev, 0x7024, 0);
-	msleep(10);
+	mt76_wr(dev, MT_H2M_BBP_AGENT, 0);
+	mt76_wr(dev, MT_H2M_MAILBOX_CSR, 0);
+	mt76_wr(dev, MT_H2M_INT_SRC, 0);
+	usleep_range(10000, 20000);
 }
 
 static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index f8003ee03a89..217bb0ac12fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -622,8 +622,11 @@
 
 #define MT_SRAM_BASE			0x4000
 
+#define MT_H2M_MAILBOX_CSR		0x7010
 #define MT_H2M_MAILBOX_CID		0x7014
 #define MT_H2M_MAILBOX_STATUS		0x701c
+#define MT_H2M_INT_SRC			0x7024
+#define MT_H2M_BBP_AGENT		0x7028
 
 #define MT_WCID_KEY_BASE		0x8000
 #define MT_WCID_KEY(_n)			(MT_WCID_KEY_BASE + (_n) * 32)
-- 
2.19.0

