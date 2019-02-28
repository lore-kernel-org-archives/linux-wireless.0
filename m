Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BA8C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F2F218CD
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551372904;
	bh=W08IkfhDT15bzvT82MWOQNwyxW3QivedE/T3S2379cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Sq6NlucBShMAv8AFLO3pRTk68IWccPWePtyNCErQPCS3ygDh/BkUrKakaiM/KZroO
	 k8fSVF7cp+Oma0v4inKcxRsRyd+kDy58icy9jvzk/M2eFJYZwvCdnmiR68tocEdcVC
	 HUgIhVg5lqvPNZqzBNTCzvZ4EB4txfSP2BvdHRJk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbfB1QzD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbfB1QzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 11:55:03 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4B22184A;
        Thu, 28 Feb 2019 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551372902;
        bh=W08IkfhDT15bzvT82MWOQNwyxW3QivedE/T3S2379cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4YN7RAGUM2gL0K74ARJXMIEGJWRfKKmHBEU5Y8FD5Z3XsFZ5T4SvIOAG0187GAWi
         WZQUDuWWp2lu6CiUsrwU21Zh6t83JIGTC7h+TWP8kNUMEf/RsvIt3GJXRpxm3efv1W
         Rxug13jTimrN0+376+gM/jmZ6Qc7Vr12sIwsdjcs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 1/2] mt76: mmio: move mt76x02_set_irq_mask in mt76 module
Date:   Thu, 28 Feb 2019 17:54:31 +0100
Message-Id: <dcfd268b4fa194f8b532bb85d88ec79b4392c864.1551370209.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551370209.git.lorenzo@kernel.org>
References: <cover.1551370209.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_set_irq_mask in mt76 module in order to be reused
adding support for mt7603 driver and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mmio.c          | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h          |  2 ++
 drivers/net/wireless/mediatek/mt76/mt7603/core.c   | 11 -----------
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  5 ++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 12 ------------
 6 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 1d6bbce76041..059f13bf9dff 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -70,6 +70,19 @@ static int mt76_mmio_rd_rp(struct mt76_dev *dev, u32 base,
 	return 0;
 }
 
+void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr,
+		       u32 clear, u32 set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->mmio.irq_lock, flags);
+	dev->mmio.irqmask &= ~clear;
+	dev->mmio.irqmask |= set;
+	mt76_mmio_wr(dev, addr, dev->mmio.irqmask);
+	spin_unlock_irqrestore(&dev->mmio.irq_lock, flags);
+}
+EXPORT_SYMBOL_GPL(mt76_set_irq_mask);
+
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 {
 	static const struct mt76_bus_ops mt76_mmio_ops = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5dfb0601f101..6376592e3cfd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -766,4 +766,6 @@ void mt76_mcu_rx_event(struct mt76_dev *dev, struct sk_buff *skb);
 struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 				      unsigned long expires);
 
+void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr, u32 clear, u32 set);
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/core.c b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
index 1086dcd376a0..e32a16f2ebe8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
@@ -2,17 +2,6 @@
 
 #include "mt7603.h"
 
-void mt7603_set_irq_mask(struct mt7603_dev *dev, u32 clear, u32 set)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
-	dev->mt76.mmio.irqmask &= ~clear;
-	dev->mt76.mmio.irqmask |= set;
-	mt76_wr(dev, MT_INT_MASK_CSR, dev->mt76.mmio.irqmask);
-	spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
-}
-
 void mt7603_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
 	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 79f332429432..dc9f2e9b20f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -179,16 +179,14 @@ void mt7603_dma_cleanup(struct mt7603_dev *dev);
 int mt7603_mcu_init(struct mt7603_dev *dev);
 void mt7603_init_debugfs(struct mt7603_dev *dev);
 
-void mt7603_set_irq_mask(struct mt7603_dev *dev, u32 clear, u32 set);
-
 static inline void mt7603_irq_enable(struct mt7603_dev *dev, u32 mask)
 {
-	mt7603_set_irq_mask(dev, 0, mask);
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, 0, mask);
 }
 
 static inline void mt7603_irq_disable(struct mt7603_dev *dev, u32 mask)
 {
-	mt7603_set_irq_mask(dev, mask, 0);
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
 }
 
 void mt7603_mac_dma_start(struct mt7603_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 6915cce5def9..3d93017c3227 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -183,7 +183,6 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
-void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
 void mt76x02_init_debugfs(struct mt76x02_dev *dev);
@@ -197,12 +196,12 @@ static inline bool is_mt76x2(struct mt76x02_dev *dev)
 
 static inline void mt76x02_irq_enable(struct mt76x02_dev *dev, u32 mask)
 {
-	mt76x02_set_irq_mask(dev, 0, mask);
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, 0, mask);
 }
 
 static inline void mt76x02_irq_disable(struct mt76x02_dev *dev, u32 mask)
 {
-	mt76x02_set_irq_mask(dev, mask, 0);
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
 }
 
 static inline bool
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1229f19f2b02..507f368ed3f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -335,18 +335,6 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 }
 EXPORT_SYMBOL_GPL(mt76x02_irq_handler);
 
-void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
-	dev->mt76.mmio.irqmask &= ~clear;
-	dev->mt76.mmio.irqmask |= set;
-	mt76_wr(dev, MT_INT_MASK_CSR, dev->mt76.mmio.irqmask);
-	spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
-}
-EXPORT_SYMBOL_GPL(mt76x02_set_irq_mask);
-
 static void mt76x02_dma_enable(struct mt76x02_dev *dev)
 {
 	u32 val;
-- 
2.20.1

