Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC0BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC0920657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552307753;
	bh=TxICkEZGYxeQzlJ9f2BqxLeiA0Uv/xJHqiIDyUmN+s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RUkS4gJQKWogbL9EKQnugmdZc5Db6PXMXegaXsjrDQ4wU1IDV7oEQnx310F79WDw5
	 1Em8m4bY0y9h7HJPSdh2HyqCpv0a3ifDR/ysuPtx9w2qjNI6hf2h7um+2RPkyxh8w1
	 T/McYh1t9D9dys+tCdvy30k3V6YgXoC3dt2RbGOQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfCKMfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfCKMfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 08:35:52 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D533820657;
        Mon, 11 Mar 2019 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552307750;
        bh=TxICkEZGYxeQzlJ9f2BqxLeiA0Uv/xJHqiIDyUmN+s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7mJ8zSSwEx5MtsYqwLEXMr4tOEB6NH8+WmA3SSnB1mTPK2oOkmBVitxbMdxx7NyA
         Tzt33jfROltusw4iN2AUJ+1QE/odd7MZP8F6C1DNjwVimN0jrItvlQujogJXnX4R1d
         MsrEJo6+DRHolcae5ZIXfu/pCT5xQyflnr53ZWpg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH 2/4] mt76: mmio: move mt76_insert_hdr_pad in mt76_dma_tx_queue_skb
Date:   Mon, 11 Mar 2019 13:35:24 +0100
Message-Id: <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552306908.git.lorenzo@kernel.org>
References: <cover.1552306908.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce tx_aligned4_skbs in mt76_driver_ops and move
mt76_insert_hdr_pad in mt76_dma_tx_queue_skb. This is a preliminary
patch in order to unify tx dma mapping for mt76x02 and new chipsets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c          |  3 +++
 drivers/net/wireless/mediatek/mt76/mt76.h         |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 13 +++++--------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a66832a02281..14dd6585bab4 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -300,6 +300,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	}
 
 	skb->prev = skb->next = NULL;
+	if (dev->drv->tx_aligned4_skbs)
+		mt76_insert_hdr_pad(skb);
+
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
 				DMA_TO_DEVICE);
 	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 971d968c1b5f..dc505d55409c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -288,6 +288,7 @@ struct mt76_hw_cap {
 };
 
 struct mt76_driver_ops {
+	bool tx_aligned4_skbs;
 	u16 txwi_size;
 
 	void (*update_survey)(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f302162036d0..e07a62246db7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -164,6 +164,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
+		.tx_aligned4_skbs = true,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index f574866c7e9d..708f2c65d3fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -152,23 +152,20 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			   u32 *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct mt76x02_txwi *txwi = txwi_ptr;
-	int qsel = MT_QSEL_EDCA;
-	int pid;
-	int ret;
+	int hdrlen, len, pid, qsel = MT_QSEL_EDCA;
 
 	if (qid == MT_TXQ_PSD && wcid && wcid->idx < 128)
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
 
-	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	len = skb->len - (hdrlen & 2);
+	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	ret = mt76_insert_hdr_pad(skb);
-	if (ret < 0)
-		return ret;
-
 	if (pid >= MT_PACKET_ID_FIRST)
 		qsel = MT_QSEL_MGMT;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 6274655e1f7e..4747f782417a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -32,6 +32,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
+		.tx_aligned4_skbs = true,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
-- 
2.20.1

