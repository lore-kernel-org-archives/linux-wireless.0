Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3421FC10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F317A208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="CJ2f6ZSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfDYIiv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:38:51 -0400
Received: from nbd.name ([46.4.11.11]:59696 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729865AbfDYIir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zRsSV1coro/Prf0r5PSHAT4hvguWh35vaFX3rZNtw9o=; b=CJ2f6ZSnaybmYncWZ5G2UmGVNT
        GG08zdFnMjRLcgm/18oW6LEOKpMc4CIh1MASz+Hk8eo49zXzkB3ZUPiQqvSlkw2lZ52Jghxdw4IR+
        vFjeghZoIapkTvD8X3EX+COobJdba1d7Ble9gYpAMcVjgRUOu6UlfjkPyEeKCqa3LIXc=;
Received: from p54ae9e78.dip0.t-ipconnect.de ([84.174.158.120] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hJZu1-0002Bp-Mc
        for linux-wireless@vger.kernel.org; Thu, 25 Apr 2019 10:38:45 +0200
Received: by maeck-2.local (Postfix, from userid 501)
        id 0E3E159A337A; Thu, 25 Apr 2019 10:38:44 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/5] mt76: only schedule txqs from the tx tasklet
Date:   Thu, 25 Apr 2019 10:38:44 +0200
Message-Id: <20190425083844.14186-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190425083844.14186-1-nbd@nbd.name>
References: <20190425083844.14186-1-nbd@nbd.name>
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
index e4a5b34915bf..5c592566acbb 100644
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
index 958b2a3e4878..af308c0ef395 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -162,6 +162,9 @@ static void mt76x02_tx_tasklet(unsigned long data)
 		mt76_queue_tx_cleanup(dev, i, false);
 
 	mt76x02_mac_poll_tx_status(dev, false);
+
+	mt76_txq_schedule_all(&dev->mt76);
+
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE_ALL);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index dd0c583ab5b1..638b83903c56 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -595,7 +595,7 @@ void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 	if (!test_bit(MT76_STATE_RUNNING, &dev->state))
 		return;
 
-	mt76_txq_schedule(dev, txq->ac);
+	tasklet_schedule(&dev->tx_tasklet);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
-- 
2.17.0

