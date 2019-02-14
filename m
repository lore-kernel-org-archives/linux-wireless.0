Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DFAC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2406A21928
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550163043;
	bh=PM3zKWeZ4906EZzc2iigvY9+cUEOzs64V5/LFhINxLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Jh5XEmQeH7mmvh1NuKRD2PMmmmiUqZUrXFRSuyAXMSSuSwCpZ/1YkKhyE0DJC2+Uo
	 roaIMVi1m4PJ5Y3p+E2yiH/Ebz1MRu4pq8Voi2HW3StK9cX01y3V+s2IxqWLE2cGjp
	 SJEm6VRcHWHkmD2DXGg7ZODPhqSSv9TB1hRx3mno=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393529AbfBNQum (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfBNQum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 11:50:42 -0500
Received: from localhost.localdomain (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E9521928;
        Thu, 14 Feb 2019 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550163040;
        bh=PM3zKWeZ4906EZzc2iigvY9+cUEOzs64V5/LFhINxLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0A/RaASjuf75pg33BrHRqBeixKyQtybcBTlacTJi/wyzGZr1xxRbeywZfdOu5vukM
         hfyhv8vQ3Wt1UNF158imGXPUbZd/vCpjM3KwZ/C1dXo8EKqQfo3r7s5tElrZiEXqnS
         McVMIB4tuNXQgUoXzk1p67vd+PNjUUobXPYjJNR8=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 1/2] mt76: mmio: move mt76x02_set_irq_mask in mt76 module
Date:   Thu, 14 Feb 2019 17:50:19 +0100
Message-Id: <28d5bf3d92042cd457a5bf3510a9705562766a02.1550162430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550162430.git.lorenzo@kernel.org>
References: <cover.1550162430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76x02_set_irq_mask in mt76 module in order to be reused
adding support for mt7603 driver and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mmio.c         | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h         |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02.h      |  5 ++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 12 ------------
 4 files changed, 17 insertions(+), 15 deletions(-)

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
index 13f6febc9b0f..01f06b5766d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -779,4 +779,6 @@ void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
 
+void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr, u32 clear, u32 set);
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3464b4ca2ea8..ecbdb4385885 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -182,7 +182,6 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
-void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
 void mt76x02_init_debugfs(struct mt76x02_dev *dev);
@@ -196,12 +195,12 @@ static inline bool is_mt76x2(struct mt76x02_dev *dev)
 
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
index 374bc9d91f12..c86af8c85fd4 100644
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

