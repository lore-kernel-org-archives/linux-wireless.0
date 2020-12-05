Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38684C433FE
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 10:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E684822D6F
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 10:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgLEKiP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Dec 2020 05:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgLEKgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Dec 2020 05:36:31 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: sdio: remove wake logic in mt76s_process_tx_queue
Date:   Sat,  5 Dec 2020 11:35:26 +0100
Message-Id: <d2d7d9d437f4dec2ef1df0ed070b9cf299f021ad.1607164041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607164041.git.lorenzo@kernel.org>
References: <cover.1607164041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Similar to mmio/usb code path, remove wake logic in mt76s_process_tx_queue
routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 62b5b912818f..7cd995118257 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -157,7 +157,7 @@ static void mt76s_net_worker(struct mt76_worker *w)
 
 static int mt76s_process_tx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	bool wake, mcu = q == dev->q_mcu[MT_MCUQ_WM];
+	bool mcu = q == dev->q_mcu[MT_MCUQ_WM];
 	struct mt76_queue_entry entry;
 	int nframes = 0;
 
@@ -177,21 +177,12 @@ static int mt76s_process_tx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 		nframes++;
 	}
 
-	wake = q->stopped && q->queued < q->ndesc - 8;
-	if (wake)
-		q->stopped = false;
-
 	if (!q->queued)
 		wake_up(&dev->tx_wait);
 
-	if (mcu)
-		goto out;
-
-	mt76_txq_schedule(&dev->phy, q->qid);
+	if (!mcu)
+		mt76_txq_schedule(&dev->phy, q->qid);
 
-	if (wake)
-		ieee80211_wake_queue(dev->hw, q->qid);
-out:
 	return nframes;
 }
 
-- 
2.28.0

