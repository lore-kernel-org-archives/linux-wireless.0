Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A156EC64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBE820892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DBE820892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbeLGN1R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:27:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeLGN1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 08:27:17 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF35F3082E09;
        Fri,  7 Dec 2018 13:27:16 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CFB21001F3C;
        Fri,  7 Dec 2018 13:27:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 1/5] mt76x02: do not set protection on set_rts_threshold  callback
Date:   Fri,  7 Dec 2018 14:27:07 +0100
Message-Id: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 07 Dec 2018 13:27:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use set_rts_threshold calback to enable/disable threshold only for
legacy traffic.

Protection for HT and VHT traffic is defined by HT operation element
and it's provided by remote AP or by hostapd.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 16 +---------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index c08bf371e527..9693d6140b3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -715,7 +715,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
 
-void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
+void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
 {
 	u32 data = 0;
 
@@ -729,20 +729,6 @@ void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
 		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
 	mt76_rmw(dev, MT_OFDM_PROT_CFG,
 		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_MM20_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_MM40_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_GF20_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_GF40_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG6,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG7,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG8,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
 }
 
 void mt76x02_update_channel(struct mt76_dev *mdev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 4e597004c445..d1a8ed171537 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -194,7 +194,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
-void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
+void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val);
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3a70e5bf7d42..e7ee2cc76edf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -463,7 +463,7 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 		return -EINVAL;
 
 	mutex_lock(&dev->mutex);
-	mt76x02_mac_set_tx_protection(dev, val);
+	mt76x02_mac_set_rts_thresh(dev, val);
 	mutex_unlock(&dev->mutex);
 
 	return 0;
-- 
1.9.3

