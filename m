Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1974C65BA7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1CF2084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF1CF2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbeJEEss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:48:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbeJEEss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 00:48:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1-v6so11482569wrt.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 14:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=voxwI1vlIfYsmLeOzUKSe3bKpo0jMuNbb5cDGCbL6wQ=;
        b=k3JPzxZOiU/eQPmBafhsbyhSJlIXu12nhDSKpq2+K5Izx1UnFv9mg6AYtDrIf3WlnM
         gn61WpgyGcN00TgQ/ws9ADwLbdaA8ZOmhwVS7I0HjdVbqgzY06gdvXaoal9ojwsrnSHl
         rRpfzodGXdL7HddnU2cZQwf8a0gxNQH+ejgThiZa3/6Lj4uM6uONEvvSMGfTITwx0Bbq
         uxALd9g9rCFCfvcyxHuC1UNvwkl7NbGUfQFxIZIgRhi5Womq2+nFV2j+GCMBCJnzW4AN
         uWxQ04Ov1uRGSmhIspo43/x5XNIanx8ZVD/XtE1wdexQTYmruytcBRocdPFOraYrgelc
         kK+w==
X-Gm-Message-State: ABuFfoiH+HiTrhqVloQfBT6CzyXbydIe1/WAquxinW+5p7jNx99wBUf4
        G15IuPYUyv5WA8aN5Xg7cT8nS2lbuiE=
X-Google-Smtp-Source: ACcGV63+hxP5ybLf6gCDGbJLgjPgVsaHjh2lqMaPJzq34ZfUdA6I95UUt+SKoazI7yhcyx1BWOLAjg==
X-Received: by 2002:adf:8461:: with SMTP id 88-v6mr5860630wrf.251.1538690006092;
        Thu, 04 Oct 2018 14:53:26 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e6-v6sm5696189wrc.70.2018.10.04.14.53.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 14:53:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 04/10] mt76x0: remove unused variable in mt76x0_dev
Date:   Thu,  4 Oct 2018 23:53:06 +0200
Message-Id: <20181004215312.3094-5-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove no longer used mac_lock spinlock and data array
in mt76x0_dev data structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index a2c38aea486e..c4ea89e61c40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -347,7 +347,6 @@ mt76x0_alloc_device(struct device *pdev,
 	dev = container_of(mdev, struct mt76x0_dev, mt76);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
-	spin_lock_init(&dev->mac_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
 
 	return dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 9060be6b071e..178fb4f085c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -69,7 +69,6 @@ enum mt_bw {
 /**
  * struct mt76x0_dev - adapter structure
  * @lock:		protects @wcid->tx_rate.
- * @mac_lock:		locks out mac80211's tx status and rx paths.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
  *			(accesses to RF and BBP).
@@ -79,13 +78,9 @@ enum mt_bw {
 struct mt76x0_dev {
 	struct mt76_dev mt76; /* must be first */
 
-	u8 data[32];
-
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-	spinlock_t mac_lock;
-
 	struct mt76x0_caldata caldata;
 
 	struct mutex reg_atomic_mutex;
-- 
2.19.0

