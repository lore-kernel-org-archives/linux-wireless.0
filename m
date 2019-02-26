Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE863C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4F72147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="NCyZgrO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfBZJ3t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:49 -0500
Received: from nbd.name ([46.4.11.11]:60896 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfBZJ3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tMwHilh0/NoIXhk2bsjtsExuWmA0GIDgdN9aUmanf98=; b=NCyZgrO0vsvd4PSGeMdMwOYKhy
        wslBlmZJKsVaj+o8ZyTJgLR7F5VJ6kGxF1JzON99NdVSeQ8td8+TJDhr2AOhW3UQVgow0mvVaLKlr
        HoaJ2NOuae2Kk35a9QRwyK5B9xM9NDTeGnwknC8wf1fGYHYgXP1JdQNCrlVedemdKA3o=;
Received: by maeck.lan (Postfix, from userid 501)
        id BD4055047CF6; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] mt76: mt76x02: issue watchdog reset on MCU request timeout
Date:   Tue, 26 Feb 2019 10:29:42 +0100
Message-Id: <20190226092945.54738-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MCU request timeout usually indicates that the device is no longer responsive,
and it usually does not recover without a reset

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 28 +++++++++++++------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3464b4ca2ea8..6915cce5def9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -98,6 +98,7 @@ struct mt76x02_dev {
 
 	u32 tx_hang_reset;
 	u8 tx_hang_check;
+	u8 mcu_timeout;
 
 	struct mt76x02_calibration cal;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 4752c104abf3..6501b853b65c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -61,6 +61,7 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 				"MCU message %d (seq %d) timed out\n", cmd,
 				seq);
 			ret = -ETIMEDOUT;
+			dev->mcu_timeout = 1;
 			break;
 		}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index f0198eea2bb8..1229f19f2b02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -494,18 +494,28 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 static void mt76x02_check_tx_hang(struct mt76x02_dev *dev)
 {
 	if (mt76x02_tx_hang(dev)) {
-		if (++dev->tx_hang_check < MT_TX_HANG_TH)
-			return;
-
-		mt76x02_watchdog_reset(dev);
-
-		dev->tx_hang_reset++;
-		dev->tx_hang_check = 0;
-		memset(dev->mt76.tx_dma_idx, 0xff,
-		       sizeof(dev->mt76.tx_dma_idx));
+		if (++dev->tx_hang_check >= MT_TX_HANG_TH)
+			goto restart;
 	} else {
 		dev->tx_hang_check = 0;
 	}
+
+	if (dev->mcu_timeout)
+		goto restart;
+
+	return;
+
+restart:
+	mt76x02_watchdog_reset(dev);
+
+	mutex_lock(&dev->mt76.mmio.mcu.mutex);
+	dev->mcu_timeout = 0;
+	mutex_unlock(&dev->mt76.mmio.mcu.mutex);
+
+	dev->tx_hang_reset++;
+	dev->tx_hang_check = 0;
+	memset(dev->mt76.tx_dma_idx, 0xff,
+	       sizeof(dev->mt76.tx_dma_idx));
 }
 
 void mt76x02_wdt_work(struct work_struct *work)
-- 
2.17.0

