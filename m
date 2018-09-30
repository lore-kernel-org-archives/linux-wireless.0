Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA33C64EB1
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAF62082A
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABAF62082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbeI3Q3l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:29:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38699 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeI3Q3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:29:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id 193-v6so4451538wme.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 02:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oj/fN/8wRU4HKnNMV6QBXYgho9cjcHHTq7INafrwVuc=;
        b=D1f6Wab69/+0n+2o6aXLrnyX5Rfi507+j3CUw/tJzQG+iuVVfiKFALZvbvecJANccM
         5a5ohAk+g0irlBho/yUT5bWtu/JOqhVYj+TvhD0do3+2uqI8Qug1YL4B+SDB1V0KFw7u
         sHG8MDRTMiO7Pi9RtetqgFkPUOkh/KfzxxfULdZ0UHo7te9IWqP2zO2CVMs+6/8oof3i
         C7Ev7BfJZdvp9M1luo9K4WGl6EIPz6wTUl2CZ1qzHPu0gTQ71FiqycwHL25uVk7AqDa/
         Iwv4DXESTrlvrmIO31L1FU4ON5HZMbbqrCSuIhQ53LNp7a6DTxk6bVyMuhngI8y6vh7N
         qGNA==
X-Gm-Message-State: ABuFfohp1pUZGEJC2hNyFCljIH5xOxWJzCAq8yL4OpAmIfN057ZZnk57
        3JcltPziyBhi6R2NXuHJbBtOLw==
X-Google-Smtp-Source: ACcGV62+R0TN0WckAW7q9BJonkcGT8NaG8/bh+AnG20FVzpOCppkiVARv4dQI396nnmYqLdK7mqkJA==
X-Received: by 2002:a1c:be09:: with SMTP id o9-v6mr903096wmf.109.1538301438809;
        Sun, 30 Sep 2018 02:57:18 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 12-v6sm4898375wms.11.2018.09.30.02.57.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:57:18 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 04/10] mt76x0: remove unused variable in mt76x0_dev
Date:   Sun, 30 Sep 2018 11:57:00 +0200
Message-Id: <20180930095706.28428-5-lorenzo.bianconi@redhat.com>
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
index a67a82670901..07992d59ed09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -353,7 +353,6 @@ mt76x0_alloc_device(struct device *pdev,
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

