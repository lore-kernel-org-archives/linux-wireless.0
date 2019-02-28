Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA18C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C1E82171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbfB1IEI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:04:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfB1IEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:04:08 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B604F3022FCF;
        Thu, 28 Feb 2019 08:04:07 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FD65D77D;
        Thu, 28 Feb 2019 08:04:03 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 05/12] mt76x02: generalize some mmio beaconing functions
Date:   Thu, 28 Feb 2019 09:03:26 +0100
Message-Id: <1551341013-24519-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 28 Feb 2019 08:04:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move some TBTT mmio functions to mt76x02_beacon.c and create new ones
in order to be reused by USB pre-TBTT.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  11 ++
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 102 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  91 +---------------
 3 files changed, 115 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 46c4635cd66a..356ea5e443d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -192,8 +192,19 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 			      struct ieee80211_bss_conf *info, u32 changed);
 
 extern const u16 mt76x02_beacon_offsets[16];
+struct beacon_bc_data {
+	struct mt76x02_dev *dev;
+	struct sk_buff_head q;
+	struct sk_buff *tail[8];
+};
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
 void mt76x02e_init_beacon_config(struct mt76x02_dev *dev);
+void mt76x02_resync_beacon_timer(struct mt76x02_dev *dev);
+void mt76x02_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
+void mt76x02_enqueue_buffered_bc(struct mt76x02_dev *dev,
+				 struct beacon_bc_data *data,
+				 int max_nframes);
+
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index 42798a918c0c..28102082772b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -184,6 +184,108 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 	dev->beacon_ops->pre_tbtt_enable(dev, true);
 }
 
+void
+mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
+{
+	u32 timer_val = dev->beacon_int << 4;
+
+	dev->tbtt_count++;
+
+	/*
+	 * Beacon timer drifts by 1us every tick, the timer is configured
+	 * in 1/16 TU (64us) units.
+	 */
+	if (dev->tbtt_count < 63)
+		return;
+
+	/*
+	 * The updated beacon interval takes effect after two TBTT, because
+	 * at this point the original interval has already been loaded into
+	 * the next TBTT_TIMER value
+	 */
+	if (dev->tbtt_count == 63)
+		timer_val -= 1;
+
+	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
+
+	if (dev->tbtt_count >= 64) {
+		dev->tbtt_count = 0;
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_resync_beacon_timer);
+
+void
+mt76x02_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt76x02_dev *dev = (struct mt76x02_dev *)priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct sk_buff *skb = NULL;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	mt76x02_mac_set_beacon(dev, mvif->idx, skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_update_beacon_iter);
+
+static void
+mt76x02_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct beacon_bc_data *data = priv;
+	struct mt76x02_dev *dev = data->dev;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
+	info->control.vif = vif;
+	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+	mt76_skb_set_moredata(skb, true);
+	__skb_queue_tail(&data->q, skb);
+	data->tail[mvif->idx] = skb;
+}
+
+void
+mt76x02_enqueue_buffered_bc(struct mt76x02_dev *dev, struct beacon_bc_data *data,
+			    int max_nframes)
+{
+	int i, nframes;
+
+	data->dev = dev;
+	__skb_queue_head_init(&data->q);
+
+	do {
+		nframes = skb_queue_len(&data->q);
+		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+			IEEE80211_IFACE_ITER_RESUME_ALL,
+			mt76x02_add_buffered_bc, data);
+	} while (nframes != skb_queue_len(&data->q) &&
+		 skb_queue_len(&data->q) < max_nframes);
+
+	if (!skb_queue_len(&data->q))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(data->tail); i++) {
+		if (!data->tail[i])
+			continue;
+		mt76_skb_set_moredata(data->tail[i], false);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_enqueue_buffered_bc);
+
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 {
 	int i;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index f83a633144ab..e6723bd44e04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -21,97 +21,16 @@
 #include "mt76x02.h"
 #include "mt76x02_trace.h"
 
-struct beacon_bc_data {
-	struct mt76x02_dev *dev;
-	struct sk_buff_head q;
-	struct sk_buff *tail[8];
-};
-
-static void
-mt76x02_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = (struct mt76x02_dev *)priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-	struct sk_buff *skb = NULL;
-
-	if (!(dev->beacon_mask & BIT(mvif->idx)))
-		return;
-
-	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
-	if (!skb)
-		return;
-
-	mt76x02_mac_set_beacon(dev, mvif->idx, skb);
-}
-
-static void
-mt76x02_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct beacon_bc_data *data = priv;
-	struct mt76x02_dev *dev = data->dev;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-	struct ieee80211_tx_info *info;
-	struct sk_buff *skb;
-
-	if (!(dev->beacon_mask & BIT(mvif->idx)))
-		return;
-
-	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
-	if (!skb)
-		return;
-
-	info = IEEE80211_SKB_CB(skb);
-	info->control.vif = vif;
-	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
-	mt76_skb_set_moredata(skb, true);
-	__skb_queue_tail(&data->q, skb);
-	data->tail[mvif->idx] = skb;
-}
-
-static void
-mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
-{
-	u32 timer_val = dev->beacon_int << 4;
-
-	dev->tbtt_count++;
-
-	/*
-	 * Beacon timer drifts by 1us every tick, the timer is configured
-	 * in 1/16 TU (64us) units.
-	 */
-	if (dev->tbtt_count < 63)
-		return;
-
-	/*
-	 * The updated beacon interval takes effect after two TBTT, because
-	 * at this point the original interval has already been loaded into
-	 * the next TBTT_TIMER value
-	 */
-	if (dev->tbtt_count == 63)
-		timer_val -= 1;
-
-	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
-		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
-
-	if (dev->tbtt_count >= 64) {
-		dev->tbtt_count = 0;
-		return;
-	}
-}
-
 static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 {
 	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
 	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
-	int i, nframes;
+	int i;
 
 	mt76x02_resync_beacon_timer(dev);
 
-	data.dev = dev;
-	__skb_queue_head_init(&data.q);
-
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 		IEEE80211_IFACE_ITER_RESUME_ALL,
 		mt76x02_update_beacon_iter, dev);
@@ -121,13 +40,7 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 	if (dev->mt76.csa_complete)
 		return;
 
-	do {
-		nframes = skb_queue_len(&data.q);
-		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
-			IEEE80211_IFACE_ITER_RESUME_ALL,
-			mt76x02_add_buffered_bc, &data);
-	} while (nframes != skb_queue_len(&data.q) &&
-		 skb_queue_len(&data.q) < 8);
+	mt76x02_enqueue_buffered_bc(dev, &data, 8);
 
 	if (!skb_queue_len(&data.q))
 		return;
-- 
2.20.1

