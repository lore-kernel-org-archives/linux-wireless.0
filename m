Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB1DC4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA7C20882
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554198498;
	bh=EgQ1tc/xvELyeBzm34bNPcQ+JpDcCklS2Fk94JtC3qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QovK9FPKH+Whs+DqxG8DCPXxZFjXrH/gZxobV6GBw9ICMOGC5+eEXZzG/L/4Hav4F
	 Qt0Ar3KNOC6eKb5PyrFnoshETHocD/F7ldZCGTrgVDnPCjf1MgP9woPSSRH4IMLqMc
	 JFtVrVnpPXiqlojz0cG9iqnHbHGDFXzl1lJCUYRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfDBJsR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfDBJsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:48:17 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FC0207E0;
        Tue,  2 Apr 2019 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554198496;
        bh=EgQ1tc/xvELyeBzm34bNPcQ+JpDcCklS2Fk94JtC3qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my4GkCn1q/IGL1uaGxepC9dsypyOGl1uR19px45xgqxzzhd+7Ay1Ao+uGTx3a0xmg
         f4IbaP0sGfn6ljcK35Izr01F63WzU4e7FAgqQ2KlJ382N/DQeJOeP6lkk4s58p6fmY
         UrUNVUsbIGi1MjZrKv3/R0q0x9LsG78o5rj/G0+M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/4] mt76: dma: introduce skb field in mt76_txwi_cache
Date:   Tue,  2 Apr 2019 11:47:58 +0200
Message-Id: <e11b8a2b13cee8de8c0b661c2ef5511e0b3f77d9.1554194917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554194917.git.lorenzo@kernel.org>
References: <cover.1554194917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce skb field in mt76_txwi_cache. Moreover add txwi_flags
to mt76_driver_ops since new chipsets will release mt76_txwi_cache/skbs
at tx completion instead of dma one.
This is a preliminary patch to add mt7615 support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/tx.c   | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 54e6d985d384..2bc5dd9a9e9f 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -176,7 +176,8 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 		}
 
 		if (entry.txwi) {
-			mt76_put_txwi(dev, entry.txwi);
+			if (!(dev->drv->txwi_flags & MT_TXWI_NO_FREE))
+				mt76_put_txwi(dev, entry.txwi);
 			wake = !flush;
 		}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 91f9433bf979..665f843008d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -231,6 +231,8 @@ struct mt76_txq {
 struct mt76_txwi_cache {
 	struct list_head list;
 	dma_addr_t dma_addr;
+
+	struct sk_buff *skb;
 };
 
 struct mt76_rx_tid {
@@ -284,8 +286,11 @@ struct mt76_hw_cap {
 	bool has_5ghz;
 };
 
+#define MT_TXWI_NO_FREE			BIT(0)
+
 struct mt76_driver_ops {
 	bool tx_aligned4_skbs;
+	u32 txwi_flags;
 	u16 txwi_size;
 
 	void (*update_survey)(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 08587d262469..6a0c4b8a649d 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -74,6 +74,7 @@ mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 	list_add(&t->list, &dev->txwi_cache);
 	spin_unlock_bh(&dev->lock);
 }
+EXPORT_SYMBOL_GPL(mt76_put_txwi);
 
 void mt76_tx_free(struct mt76_dev *dev)
 {
-- 
2.20.1

