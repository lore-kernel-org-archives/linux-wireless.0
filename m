Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EACC7112C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB9DF205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB9DF205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbeJORSN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39950 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbeJORSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id d2-v6so20468507wro.7
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ex/cgddlPC4n3wjZFtymOXdMXH0PtyWG8WllSSECOkU=;
        b=fPLWL8/0MnVATdGK1776XkWv+27x54A0fZR/VLnsf54zhWnZHhYNKsq+OgdJ0YQZyd
         heyesX59x4nAEBHHtolvZa4Jv5e82FJI4ff1RhLTpUUDngX9MEKhOe00RSDRwLzhA1eH
         00cngRPWnUVEM4jXjQ5POVatWKYvPr/zMKFX9m5bT+iLB5JhsAWF8iZk8e/8pRQ3fCcC
         O30y5hMs8hH113oO6tIBz1I5ZQaXAbgHbF/tVConX2lWjCOyaruYuDwfzCW6CjZ9Cqaj
         vnfi6/tdQ/oFmMf9aZzy+FcUEx3sOzRGYZwgEvTHZialxFV3CjgDhE4uDJAI20ADV0lZ
         WFyA==
X-Gm-Message-State: ABuFfogxoDkHwLJSJWDrv8PMxmiZpOvIHSYyHCMbf5RHvhNfVQzO4EpS
        rLLMYx9HpuqUVqSVzIYizX4iJQ==
X-Google-Smtp-Source: ACcGV63Q+X7YEODVQ5S+0a8uefmMdwu92KCNNOgKpMB9q3WmQu4FaldOdJuP+3CqITt15a9X7C2/kg==
X-Received: by 2002:adf:80a3:: with SMTP id 32-v6mr14630375wrl.231.1539596022572;
        Mon, 15 Oct 2018 02:33:42 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:41 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] mt76: move mt76x02_mac_work routine in mt76x02-lib module
Date:   Mon, 15 Oct 2018 11:33:12 +0200
Message-Id: <093d5bed144cfc83e77a27b0e15039a7c7c0278a.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_work routine in mt76x02_mac.c in order to be reused by
mt76x0 driver to read device statistics

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 19 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  2 --
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 18 ------------------
 8 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index f27335ccb582..17fc7206c55d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -28,8 +28,6 @@
 #include "../mt76x02.h"
 #include "eeprom.h"
 
-#define MT_CALIBRATE_INTERVAL		(4 * HZ)
-
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 47c42c607964..189c697973bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -26,6 +26,8 @@
 #include "mt76x02_dfs.h"
 #include "mt76x02_dma.h"
 
+#define MT_CALIBRATE_INTERVAL	HZ
+
 struct mt76x02_mac_stats {
 	u64 rx_stat[6];
 	u64 tx_stat[6];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e6d6ddaa5a07..c7666f4c432f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -753,3 +753,22 @@ void mt76x02_update_channel(struct mt76_dev *mdev)
 	spin_unlock_bh(&dev->mt76.cc_lock);
 }
 EXPORT_SYMBOL_GPL(mt76x02_update_channel);
+
+void mt76x02_mac_work(struct work_struct *work)
+{
+	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
+					       mac_work.work);
+	int i, idx;
+
+	mt76x02_update_channel(&dev->mt76);
+	for (i = 0, idx = 0; i < 16; i++) {
+		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
+
+		dev->aggr_stats[idx++] += val & 0xffff;
+		dev->aggr_stats[idx++] += val >> 16;
+	}
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 6bce18bcbf36..c1936e2277d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -227,4 +227,5 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			     struct mt76_queue_entry *e, bool flush);
 void mt76x02_update_channel(struct mt76_dev *mdev);
+void mt76x02_mac_work(struct work_struct *work);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index a31bd49ae6cb..2dc2b9d5dc8f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -32,6 +32,4 @@ int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
 void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
 
-void mt76x2_mac_work(struct work_struct *work);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 72c365040be1..eca142ac656d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -31,8 +31,6 @@
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
 #define MT7662_EEPROM_SIZE	512
 
-#define MT_CALIBRATE_INTERVAL	HZ
-
 #include "../mt76x02.h"
 #include "mac.h"
 #include "dfs.h"
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 279edc612119..0dea7d7b17a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -467,7 +467,7 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	int i, ret;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
 
 	mt76x2_init_device(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 15620d4d425e..97128ea6bd7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -137,24 +137,6 @@ void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev,
 		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
 
-void mt76x2_mac_work(struct work_struct *work)
-{
-	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
-					       mac_work.work);
-	int i, idx;
-
-	mt76x02_update_channel(&dev->mt76);
-	for (i = 0, idx = 0; i < 16; i++) {
-		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
-
-		dev->aggr_stats[idx++] += val & 0xffff;
-		dev->aggr_stats[idx++] += val >> 16;
-	}
-
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
-}
-
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
 {
 	u32 data = 0;
-- 
2.19.0

