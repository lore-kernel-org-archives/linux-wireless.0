Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA8DC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32982218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tehX69bu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfCPUmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:46 -0400
Received: from nbd.name ([46.4.11.11]:39536 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfCPUmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hvLRJFzcxyqgDxeALkAXLktjiAWcMR0OQZC8MRqUMZM=; b=tehX69buwOfr0s3EIp9/Z2+5Va
        JNaE3oAouHhd9xtbisjkRo8NmUsyZ2+aapdeb5z8WTLVBUOxs9e9Wg7L55WxEg/EdUCq6W6h6si5N
        YJ91BJhg3SNoz0ZSEruXr+YoxRRIuf0SLDMvv5XzDuzenasf0AaYfirhd840FgiMxxBE=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5G8h-0005S2-NV
        for linux-wireless@vger.kernel.org; Sat, 16 Mar 2019 21:42:43 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CAE6A530F04F; Sat, 16 Mar 2019 21:42:42 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] mt76: only schedule txqs from the tx tasklet
Date:   Sat, 16 Mar 2019 21:42:42 +0100
Message-Id: <20190316204242.73560-6-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316204242.73560-1-nbd@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reduces lock contention from the tx path and improves performance

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c          | 2 --
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c   | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 3 +++
 drivers/net/wireless/mediatek/mt76/tx.c           | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 7d8f9b8a81b5..35010915697c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -205,8 +205,6 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 
 	spin_unlock_bh(&q->lock);
 
-	if (!flush)
-		mt76_txq_schedule(dev, qid);
 	if (wake)
 		ieee80211_wake_queue(dev->hw, qid);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index f7e3566c96fd..27e2d9f90553 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -145,6 +145,8 @@ mt7603_tx_tasklet(unsigned long data)
 	for (i = MT_TXQ_MCU; i >= 0; i--)
 		mt76_queue_tx_cleanup(dev, i, false);
 
+	mt76_txq_schedule_all(&dev->mt76);
+
 	mt7603_irq_enable(dev, MT_INT_TX_DONE_ALL);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1e82b99d0789..7186a382c686 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -211,6 +211,9 @@ static void mt76x02_tx_tasklet(unsigned long data)
 		mt76_queue_tx_cleanup(dev, i, false);
 
 	mt76x02_mac_poll_tx_status(dev, false);
+
+	mt76_txq_schedule_all(&dev->mt76);
+
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE_ALL);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 534ad9fb8832..60bbb6561d8f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -594,7 +594,7 @@ void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 	if (!test_bit(MT76_STATE_RUNNING, &dev->state))
 		return;
 
-	mt76_txq_schedule(dev, txq->ac);
+	tasklet_schedule(&dev->tx_tasklet);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
-- 
2.17.0

