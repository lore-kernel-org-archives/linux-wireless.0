Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E782C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CBF620821
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CBF620821
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbeLJKyD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:54:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeLJKyC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 05:54:02 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24E4B307D845;
        Mon, 10 Dec 2018 10:54:02 +0000 (UTC)
Received: from localhost (ovpn-204-245.brq.redhat.com [10.40.204.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90FA519C7F;
        Mon, 10 Dec 2018 10:53:59 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] mt76x02: do not set protection on set_rts_threshold callback
Date:   Mon, 10 Dec 2018 11:53:55 +0100
Message-Id: <1544439238-4118-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 10 Dec 2018 10:54:02 +0000 (UTC)
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
v2: rebase on top of:
https://lore.kernel.org/linux-wireless/bfcac7be8f989b99b1efb11c3e541d1d1167d524.1541802405.git.lorenzo.bianconi@redhat.com/

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
index 38bd466cff16..364e7b2ebf99 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -463,7 +463,7 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 		return -EINVAL;
 
 	mutex_lock(&dev->mt76.mutex);
-	mt76x02_mac_set_tx_protection(dev, val);
+	mt76x02_mac_set_rts_thresh(dev, val);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
-- 
2.7.5

