Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091EAC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67E12085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfCSKiQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A37295946E;
        Tue, 19 Mar 2019 10:38:15 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B91A01001E71;
        Tue, 19 Mar 2019 10:38:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 06/12] mt76x02u: add sta_ps
Date:   Tue, 19 Mar 2019 11:37:41 +0100
Message-Id: <1552991867-5087-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 19 Mar 2019 10:38:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add sta_ps callback but dont set WCID drop sicne registers for USB
can not be accessed from tasklet context.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c   | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c   | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 7f3113b91498..0348a1b38d2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -222,6 +222,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
+		.sta_ps = mt76x02_sta_ps,
 		.sta_add = mt76x02_sta_add,
 		.sta_remove = mt76x02_sta_remove,
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 1026939d6b63..168c62a90361 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -615,7 +615,8 @@ void mt76x02_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta,
 	int idx = msta->wcid.idx;
 
 	mt76_stop_tx_queues(&dev->mt76, sta, true);
-	mt76x02_mac_wcid_set_drop(dev, idx, ps);
+	if (mt76_is_mmio(dev))
+		mt76x02_mac_wcid_set_drop(dev, idx, ps);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_ps);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 7a5d539873ca..1f0b1bebed79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -40,6 +40,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
+		.sta_ps = mt76x02_sta_ps,
 		.sta_add = mt76x02_sta_add,
 		.sta_remove = mt76x02_sta_remove,
 	};
-- 
1.9.3

