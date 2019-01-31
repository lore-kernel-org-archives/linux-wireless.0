Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA516C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56DE218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbfAaQ4P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39557 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfAaQ4O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:14 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so4104527wra.6
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 08:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsVPqCQwcKQGeBVk9xOjkaAB8Y9A4S+yhHfEGHbL0fk=;
        b=sQoeG/QpuUTm7A+Jp8GCxNtoVGYDDbeZ2kozkpKGy1jjBf83h6poA4E7BcqyOOpyg2
         kMICOepyD2FcG/dQT0q1BmOZb5iZSHmdh2DYS1NQ9hkimo4YYxYxfljT4a792sBSxvV1
         dyp7o5NY2CVSjNb4aIbtP/EXVJPbGc0SnWBWqxoh9KAydpkawzHlia3J6gakyZqjupDz
         Q9omBK3HVtDKsHQ2RccJjnna75qBSJ0mWIyffXdn8jKPGZFRLkKd4QWv3dJXxeP4htC2
         SpMbOL678VVRFf/SqdMNKn0iqo28qWU6e+b80AfwwVxDx0qxEzSx/YqJq8/50pT8b1mv
         J/TA==
X-Gm-Message-State: AJcUukdZK+sysIpqr5VjVyk1hqMbvHnYIYL60L75ErC14sOqRSPa8vOE
        oRv3JGXfofM4wYnGIL6ZRXNjDA==
X-Google-Smtp-Source: ALg8bN73/9RwpXxNcl9HKEzBYi77k001eroC8L3/cveFEjMliS8nvOJKX16c43Hf79COnpqgHMQ7mQ==
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr34933492wrw.215.1548953772573;
        Thu, 31 Jan 2019 08:56:12 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k128sm9502889wmd.37.2019.01.31.08.56.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 31 Jan 2019 08:56:11 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 1/4] mt76: move alloc_device common code in mt76_alloc_device
Date:   Thu, 31 Jan 2019 17:55:54 +0100
Message-Id: <49a0e9a805c6179b0396956627da69125e9ef284.1548952312.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
References: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x{0,2} alloc_device common code in mt76_alloc_device and
remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c        | 7 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h            | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c     | 5 +----
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 5 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 5 ++---
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 489953a47646..07dee83658d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -269,7 +269,9 @@ mt76_check_sband(struct mt76_dev *dev, int band)
 }
 
 struct mt76_dev *
-mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
+mt76_alloc_device(struct device *pdev, unsigned int size,
+		  const struct ieee80211_ops *ops,
+		  const struct mt76_driver_ops *drv_ops)
 {
 	struct ieee80211_hw *hw;
 	struct mt76_dev *dev;
@@ -280,6 +282,9 @@ mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
 
 	dev = hw->priv;
 	dev->hw = hw;
+	dev->dev = pdev;
+	dev->drv = drv_ops;
+
 	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->lock);
 	spin_lock_init(&dev->cc_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 844d5183ecee..01130c9f8643 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -603,8 +603,9 @@ mt76_channel_state(struct mt76_dev *dev, struct ieee80211_channel *c)
 	return &msband->chan[idx];
 }
 
-struct mt76_dev *mt76_alloc_device(unsigned int size,
-				   const struct ieee80211_ops *ops);
+struct mt76_dev *mt76_alloc_device(struct device *pdev, unsigned int size,
+				   const struct ieee80211_ops *ops,
+				   const struct mt76_driver_ops *drv_ops);
 int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 87b575fe1c74..34db3ec24e6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -270,13 +270,10 @@ mt76x0_alloc_device(struct device *pdev,
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
-	mdev = mt76_alloc_device(sizeof(*dev), ops);
+	mdev = mt76_alloc_device(pdev, sizeof(*dev), ops, drv_ops);
 	if (!mdev)
 		return NULL;
 
-	mdev->dev = pdev;
-	mdev->drv = drv_ops;
-
 	dev = container_of(mdev, struct mt76x02_dev, mt76);
 	mutex_init(&dev->phy_mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 4347d5e7a915..be2f53604311 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -331,13 +331,12 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
-	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2_ops);
+	mdev = mt76_alloc_device(pdev, sizeof(*dev), &mt76x2_ops,
+				 &drv_ops);
 	if (!mdev)
 		return NULL;
 
 	dev = container_of(mdev, struct mt76x02_dev, mt76);
-	mdev->dev = pdev;
-	mdev->drv = &drv_ops;
 
 	return dev;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 0be3784f44fb..523a308dd490 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -147,13 +147,12 @@ struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
-	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2u_ops);
+	mdev = mt76_alloc_device(pdev, sizeof(*dev), &mt76x2u_ops,
+				 &drv_ops);
 	if (!mdev)
 		return NULL;
 
 	dev = container_of(mdev, struct mt76x02_dev, mt76);
-	mdev->dev = pdev;
-	mdev->drv = &drv_ops;
 
 	return dev;
 }
-- 
2.20.1

