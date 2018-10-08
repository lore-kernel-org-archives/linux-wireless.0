Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507BFC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203DE20841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:22:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 203DE20841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeJHSdU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 14:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbeJHSdT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 14:33:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 969FF308212C;
        Mon,  8 Oct 2018 11:22:04 +0000 (UTC)
Received: from localhost (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79534D736;
        Mon,  8 Oct 2018 11:22:01 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: reserve enough room for USB tx skbs
Date:   Mon,  8 Oct 2018 13:22:00 +0200
Message-Id: <1538997720-13926-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 08 Oct 2018 11:22:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reserve enough room for USB skb, so we don not need to check
the room every time we send frame.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c      |  5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 17 +----------------
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c      |  3 +++
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 578f1b34f0f1..4a9408801260 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -368,7 +368,10 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
-	hw->extra_tx_headroom = sizeof(struct mt76x02_txwi) + 4 + 2;
+	hw->extra_tx_headroom = 2;
+	if (mt76_is_usb(dev))
+		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
+					 MT_DMA_HDR_LEN;
 
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index e43c53e8e6be..dc2226c722dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -34,17 +34,6 @@ void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_complete_skb);
 
-static int mt76x02u_check_skb_rooms(struct sk_buff *skb)
-{
-	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	u32 need_head;
-
-	need_head = sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN;
-	if (hdr_len % 4)
-		need_head += 2;
-	return skb_cow(skb, need_head);
-}
-
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 {
 	struct sk_buff *iter, *last = skb;
@@ -106,11 +95,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
-	int err, len = skb->len;
-
-	err = mt76x02u_check_skb_rooms(skb);
-	if (err < 0)
-		return -ENOMEM;
+	int len = skb->len;
 
 	mt76x02_insert_hdr_pad(skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index ccd9bc9d3e1e..3c73fdeaf30f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -167,6 +167,9 @@ void mt76x2_init_device(struct mt76x02_dev *dev)
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
 	hw->extra_tx_headroom = 2;
+	if (mt76_is_usb(dev))
+		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
+					 MT_DMA_HDR_LEN;
 
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
-- 
2.7.5

