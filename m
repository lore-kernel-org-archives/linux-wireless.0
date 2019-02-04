Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C921EC282CB
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32DD20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfBDQvx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:51:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39364 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbfBDQvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 11:51:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id y8so628331wmi.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 08:51:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Er+EG25qbqCxgZ0UsdhRkpKuc2EML60rltznHK4Kunw=;
        b=hAUr5JMZi9y+K7a7izJ2fCRfsYoauKf0YACuZd6ETa80R543HMs2DdYc/TIkUWiqsI
         SsEc6Yz3IUXkl4ud2W+QiEjrW+yaIBptaYxcu9njiK66EimplDN87ZpokgeFF7+xKovA
         G9FTwXxV4iBAz9O4kuwHUTgnrgAzfOGN/xcuO1CzGTEUlGdj2A50dvPkkDMGbHmSkSxR
         H/YP4fCCTR6kQqHPbHYWvMNyfYqoG69h97PymqAgj0u3WSpishUkR5ESO5k/0SuOjL1i
         WZNd5Xwig7X0+n9A+eoTEP2GKyj7sA0JPEg4bwHdSIVfVmjo7p6Fjvoxb9T2tpjyRMPd
         QP4Q==
X-Gm-Message-State: AHQUAuaW8Je4o3YFn/+SIfn2cGTQ45NKFbMh6xYdxiSMPKMgYksNh0dz
        +oB+b2ZKPvT9oAsvXao6sjyBGQ==
X-Google-Smtp-Source: AHgI3IY8lrCSyujLIBaOhWzdxAVLHDBDYKanLrk7/T2q3RnbOyZxVvudkuekqymSWAu5cPgKyNbTqQ==
X-Received: by 2002:a1c:a755:: with SMTP id q82mr286296wme.6.1549299111572;
        Mon, 04 Feb 2019 08:51:51 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r22sm11233707wmh.2.2019.02.04.08.51.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 04 Feb 2019 08:51:50 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 2/3] mt76: move mt76_mcu_get_response in mt76-core
Date:   Mon,  4 Feb 2019 17:51:28 +0100
Message-Id: <fccafac5c67013a1cfcfd3030fe0f47e57acc9d1.1549298196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
References: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_mcu_get_response in mt76-core module and remove duplicated
code. mt76_mcu_get_response will be reused adding support for mt7603
driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mcu.c        | 17 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h       |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c    | 17 +----------------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mcu.c b/drivers/net/wireless/mediatek/mt76/mcu.c
index f4c38ec78654..0fd71a97a197 100644
--- a/drivers/net/wireless/mediatek/mt76/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mcu.c
@@ -34,3 +34,20 @@ mt76_mcu_msg_alloc(const void *data, int head_len,
 	return skb;
 }
 EXPORT_SYMBOL_GPL(mt76_mcu_msg_alloc);
+
+/* mmio */
+struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
+				      unsigned long expires)
+{
+	unsigned long timeout;
+
+	if (!time_is_after_jiffies(expires))
+		return NULL;
+
+	timeout = expires - jiffies;
+	wait_event_timeout(dev->mmio.mcu.wait,
+			   !skb_queue_empty(&dev->mmio.mcu.res_q),
+			   timeout);
+	return skb_dequeue(&dev->mmio.mcu.res_q);
+}
+EXPORT_SYMBOL_GPL(mt76_mcu_get_response);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 725991f748b4..c43c78d45493 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -776,6 +776,8 @@ void mt76u_queues_deinit(struct mt76_dev *dev);
 struct sk_buff *
 mt76_mcu_msg_alloc(const void *data, int head_len,
 		   int data_len, int tail_len);
+struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
+				      unsigned long expires);
 
 void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index d184551b9845..b44d128f6f93 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -21,21 +21,6 @@
 
 #include "mt76x02_mcu.h"
 
-static struct sk_buff *
-mt76x02_mcu_get_response(struct mt76x02_dev *dev, unsigned long expires)
-{
-	unsigned long timeout;
-
-	if (!time_is_after_jiffies(expires))
-		return NULL;
-
-	timeout = expires - jiffies;
-	wait_event_timeout(dev->mt76.mmio.mcu.wait,
-			   !skb_queue_empty(&dev->mt76.mmio.mcu.res_q),
-			   timeout);
-	return skb_dequeue(&dev->mt76.mmio.mcu.res_q);
-}
-
 static int
 mt76x02_tx_queue_mcu(struct mt76x02_dev *dev, enum mt76_txq_id qid,
 		     struct sk_buff *skb, int cmd, int seq)
@@ -94,7 +79,7 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 		u32 *rxfce;
 		bool check_seq = false;
 
-		skb = mt76x02_mcu_get_response(dev, expires);
+		skb = mt76_mcu_get_response(&dev->mt76, expires);
 		if (!skb) {
 			dev_err(mdev->dev,
 				"MCU message %d (seq %d) timed out\n", cmd,
-- 
2.20.1

