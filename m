Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879BCC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE8320C01
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfB1P1e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:27:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732744AbfB1PLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 10:11:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C02703088A60;
        Thu, 28 Feb 2019 15:11:11 +0000 (UTC)
Received: from localhost (ovpn-204-193.brq.redhat.com [10.40.204.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 045B263B8C;
        Thu, 28 Feb 2019 15:11:07 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH] mt76x02: fix hdr pointer in write txwi for USB
Date:   Thu, 28 Feb 2019 16:11:06 +0100
Message-Id: <1551366666-28477-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 28 Feb 2019 15:11:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we add txwi at the begining of skb->data, it no longer point
to ieee80211_hdr. This breaks settings TS bit for probe response and
beacons.

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I do not cc: stable since it does not fix critical issue.

 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index fdd6a021914d..bcf3126efda9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -85,8 +85,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 	mt76x02_insert_hdr_pad(skb);
 
-	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
+	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+	skb_push(skb, sizeof(struct mt76x02_txwi));
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
-- 
2.20.1

