Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2412C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E9C20836
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfCDJs7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 04:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfCDJs6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 04:48:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86E218552E;
        Mon,  4 Mar 2019 09:48:58 +0000 (UTC)
Received: from localhost (unknown [10.40.205.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03331A8E2;
        Mon,  4 Mar 2019 09:48:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 08/11] mt76x02u: implement pre TBTT work for USB
Date:   Mon,  4 Mar 2019 10:48:13 +0100
Message-Id: <1551692896-7062-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 04 Mar 2019 09:48:58 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
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
 .../wireless/mediatek/mt76/mt76x02_beacon.c   |  2 ++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 36 +++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index 28102082772b..63e2926cdd0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -38,6 +38,7 @@ const u16 mt76x02_beacon_offsets[16] = {
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
index 427d231c32f3..1e67d53098b0 100644
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
2.20.1

