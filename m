Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C92FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465902085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfCSKiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C95230BC650;
        Tue, 19 Mar 2019 10:38:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8590B60FAB;
        Tue, 19 Mar 2019 10:38:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 08/12] mt76x02u: implement pre TBTT work for USB
Date:   Tue, 19 Mar 2019 11:37:43 +0100
Message-Id: <1552991867-5087-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 19 Mar 2019 10:38:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Program beacons data and PS buffered frames on TBTT work for USB.
We do not have MT_TXQ_PSD queue available via USB endpoints. The way
we can send PS broadcast frames in timely manner before PS stations go
sleep again is program them in beacon data area. Hardware do not modify
those frames since TXWI is properly configured. mt76x02_mac_set_beacon()
already handle this and free no longer used frames.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 36 ++++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index d77088b7659e..c0be90988f82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -38,6 +38,7 @@
 	0xc000,
 	0xc000,
 };
+EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
 
 static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 {
@@ -134,6 +135,7 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 		       bcn_idx - 1);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x02_mac_set_beacon);
 
 static void
 __mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 82b78cc5b362..89249621bcec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -164,9 +164,32 @@ static void mt76x02u_pre_tbtt_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev =
 		container_of(work, struct mt76x02_dev, pre_tbtt_work);
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	struct beacon_bc_data data = {};
+	struct sk_buff *skb;
+	int i, nbeacons;
 
 	if (!dev->beacon_mask)
 		return;
+
+	mt76x02_resync_beacon_timer(dev);
+
+	ieee80211_iterate_active_interfaces(mt76_hw(dev),
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		mt76x02_update_beacon_iter, dev);
+
+	nbeacons = hweight8(dev->beacon_mask);
+	mt76x02_enqueue_buffered_bc(dev, &data, 8 - nbeacons);
+
+	for (i = nbeacons; i < 8; i++) {
+		skb = __skb_dequeue(&data.q);
+		if (skb && skb->len >= beacon_len) {
+			dev_kfree_skb(skb);
+			skb = NULL;
+		}
+		mt76x02_mac_set_beacon(dev, i, skb);
+	}
+
 	mt76x02u_restart_pre_tbtt_timer(dev);
 }
 
@@ -190,13 +213,20 @@ static void mt76x02u_pre_tbtt_enable(struct mt76x02_dev *dev, bool en)
 
 static void mt76x02u_beacon_enable(struct mt76x02_dev *dev, bool en)
 {
+	int i;
+
 	if (WARN_ON_ONCE(!dev->beacon_int))
 		return;
 
-	if (en)
+	if (en) {
 		mt76x02u_start_pre_tbtt_timer(dev);
-
-	/* Nothing to do on disable as timer is already stopped */
+	} else {
+		/* Timer is already stopped, only clean up
+		 * PS buffered frames if any.
+		 */
+		for (i = 0; i < 8; i++)
+			mt76x02_mac_set_beacon(dev, i, NULL);
+	}
 }
 
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
-- 
1.9.3

