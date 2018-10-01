Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0769AC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFAE2089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAFAE2089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbeJBE7Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37047 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbeJBE7Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so15652210wrr.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=voxwI1vlIfYsmLeOzUKSe3bKpo0jMuNbb5cDGCbL6wQ=;
        b=YCoMSpR/PTm0gxnIruh1+VWY+tYx72Nj4kN3otIZo69tefgNJ8Jtnt0T/QJivd2avl
         eQ9vktpgtOF6s9+33VPH4WNy07FxYhQ3RwP9TMuOpi140fFOjmnILaVHi3XSpHuzsF4P
         xrLtTKWQPyWSjyaZ5or8qeFFt6tEIwsgUp5kT0s8BJHr+3uAvQ8RagTI7fzOfgJsEtYK
         v8cZ48m85WbDRdgdD73cUv4QRYOiHrucdYnEgGo9cxHezxhML7rOt6JagQvobKhOajmg
         W9dnfK2MfLBx0vROfWUn7fP5evNhFoRa0H9n1JQdawcdWZsd6Fsx+0VP+5OjYh6U96/r
         4W8g==
X-Gm-Message-State: ABuFfohUA2nKA5Tq7BmAD6FqBXhU8gSTVsjhL5goCClXw/ZLd1ds+hlg
        gRkKqERiLuxE0H2gS9z0dpuy/gST9QE=
X-Google-Smtp-Source: ACcGV61qTtvsY+6PlrSI3YBPuw/XCeC7LsQ6kVk8PjeR16wz8D/BlwdLySWcWpTOwZ18sHoMQsiKiA==
X-Received: by 2002:adf:b743:: with SMTP id n3-v6mr184035wre.274.1538432365940;
        Mon, 01 Oct 2018 15:19:25 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/10] mt76x0: remove unused variable in mt76x0_dev
Date:   Tue,  2 Oct 2018 00:19:02 +0200
Message-Id: <20181001221908.16005-5-lorenzo.bianconi@redhat.com>
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

