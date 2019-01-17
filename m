Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA25BC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CC220851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YTB5I9sh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfAQNvm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:42 -0500
Received: from nbd.name ([46.4.11.11]:56460 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h8T9Z5gKWNRUECa43uzNz4l8WO+DfrJR2TNUPq1gbPM=; b=YTB5I9shucjvZB+j5czW90Yclb
        HYEQLu5NIePTzfUR2HYrqAerpCbr9vSs5xZOtPvIzsVfrz8yEtx5jA7WEV1RJD+jobzWIS/cqxE2L
        gmPWyRqUuSj4vNQZOP+blWsvZZzJqFST53hrxlMKGDFQ74GRhr3wRL31C72DEGBbn8hg=;
Received: by maeck.lan (Postfix, from userid 501)
        id 359964C6F04F; Thu, 17 Jan 2019 14:51:33 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] mt76: move mt76x02_phy_get_min_avg_rssi to mt76 core
Date:   Thu, 17 Jan 2019 14:51:30 +0100
Message-Id: <20190117135133.2753-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This will be used by mt7603 as well

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  8 +++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  8 ++++
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  5 --
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  6 ---
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 47 -------------------
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  1 -
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 -
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  4 +-
 drivers/net/wireless/mediatek/mt76/util.c     | 42 +++++++++++++++++
 10 files changed, 62 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 467b5a692ed1..226f98fff6ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -548,7 +548,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 }
 
 static void
-mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
+mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -567,6 +567,9 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 
 	sta = container_of((void *) wcid, struct ieee80211_sta, drv_priv);
 
+	ewma_signal_add(&wcid->rssi, status->signal);
+	wcid->inactive_count = 0;
+
 	if (!test_bit(MT_WCID_FLAG_CHECK_PS, &wcid->flags))
 		return;
 
@@ -626,7 +629,7 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
 	__skb_queue_head_init(&frames);
 
 	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL) {
-		mt76_check_ps(dev, skb);
+		mt76_check_sta(dev, skb);
 		mt76_rx_aggr_reorder(skb, &frames);
 	}
 
@@ -660,6 +663,7 @@ mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		mt76_txq_init(dev, sta->txq[i]);
 	}
 
+	ewma_signal_init(&wcid->rssi);
 	rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 16b342f63d29..2267163d2445 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -23,6 +23,7 @@
 #include <linux/skbuff.h>
 #include <linux/leds.h>
 #include <linux/usb.h>
+#include <linux/average.h>
 #include <net/mac80211.h>
 #include "util.h"
 
@@ -174,6 +175,8 @@ enum mt76_wcid_flags {
 
 #define MT76_N_WCIDS 128
 
+DECLARE_EWMA(signal, 10, 8);
+
 struct mt76_wcid {
 	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
 
@@ -181,6 +184,9 @@ struct mt76_wcid {
 
 	unsigned long flags;
 
+	struct ewma_signal rssi;
+	int inactive_count;
+
 	u8 idx;
 	u8 hw_key_idx;
 
@@ -680,6 +686,8 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
+int mt76_get_min_avg_rssi(struct mt76_dev *dev);
+
 int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     int *dbm);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index b2b38b9fcac7..5a4c6f34267e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1077,7 +1077,9 @@ mt76x0_phy_update_channel_gain(struct mt76x02_dev *dev)
 	u8 gain_delta;
 	int low_gain;
 
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
+	dev->cal.avg_rssi_all = mt76_get_min_avg_rssi(&dev->mt76);
+	if (!dev->cal.avg_rssi_all)
+		dev->cal.avg_rssi_all = -75;
 
 	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 38cd77d30f5c..68d01e136fa0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -656,11 +656,6 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
 	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
 
-	if (sta) {
-		ewma_signal_add(&sta->rssi, status->signal);
-		sta->inactive_count = 0;
-	}
-
 	return mt76x02_mac_process_rate(status, rate);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 735fe96440ba..940c07f665cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -18,8 +18,6 @@
 #ifndef __MT76X02_MAC_H
 #define __MT76X02_MAC_H
 
-#include <linux/average.h>
-
 struct mt76x02_dev;
 
 struct mt76x02_tx_status {
@@ -41,8 +39,6 @@ struct mt76x02_vif {
 	u8 idx;
 };
 
-DECLARE_EWMA(signal, 10, 8);
-
 struct mt76x02_sta {
 	struct mt76_wcid wcid; /* must be first */
 
@@ -50,8 +46,6 @@ struct mt76x02_sta {
 	struct mt76x02_tx_status status;
 	int n_frames;
 
-	struct ewma_signal rssi;
-	int inactive_count;
 };
 
 #define MT_RXINFO_BA			BIT(0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index 977a8e7e26df..a020c757ba5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -132,53 +132,6 @@ void mt76x02_phy_set_txpower(struct mt76x02_dev *dev, int txp_0, int txp_1)
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_txpower);
 
-int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev)
-{
-	struct mt76x02_sta *sta;
-	struct mt76_wcid *wcid;
-	int i, j, min_rssi = 0;
-	s8 cur_rssi;
-
-	local_bh_disable();
-	rcu_read_lock();
-
-	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid_mask); i++) {
-		unsigned long mask = dev->mt76.wcid_mask[i];
-
-		if (!mask)
-			continue;
-
-		for (j = i * BITS_PER_LONG; mask; j++, mask >>= 1) {
-			if (!(mask & 1))
-				continue;
-
-			wcid = rcu_dereference(dev->mt76.wcid[j]);
-			if (!wcid)
-				continue;
-
-			sta = container_of(wcid, struct mt76x02_sta, wcid);
-			spin_lock(&dev->mt76.rx_lock);
-			if (sta->inactive_count++ < 5)
-				cur_rssi = ewma_signal_read(&sta->rssi);
-			else
-				cur_rssi = 0;
-			spin_unlock(&dev->mt76.rx_lock);
-
-			if (cur_rssi < min_rssi)
-				min_rssi = cur_rssi;
-		}
-	}
-
-	rcu_read_unlock();
-	local_bh_enable();
-
-	if (!min_rssi)
-		return -75;
-
-	return min_rssi;
-}
-EXPORT_SYMBOL_GPL(mt76x02_phy_get_min_avg_rssi);
-
 void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
 {
 	int core_val, agc_val;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index 2b316cf7c70c..d2971db06f13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -51,7 +51,6 @@ void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
 int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev);
 void mt76x02_phy_set_txdac(struct mt76x02_dev *dev);
-int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
 void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
 			  bool primary_upper);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 59f50a957cd5..0bd23d64db24 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -250,8 +250,6 @@ int mt76x02_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
 
-	ewma_signal_init(&msta->rssi);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_add);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index c9634a774705..e2ee5e498da7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -284,7 +284,9 @@ void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	int low_gain;
 	u32 val;
 
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
+	dev->cal.avg_rssi_all = mt76_get_min_avg_rssi(&dev->mt76);
+	if (!dev->cal.avg_rssi_all)
+		dev->cal.avg_rssi_all = -75;
 
 	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
index 0c35b8db58cd..6242421c6011 100644
--- a/drivers/net/wireless/mediatek/mt76/util.c
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -75,4 +75,46 @@ int mt76_wcid_alloc(unsigned long *mask, int size)
 }
 EXPORT_SYMBOL_GPL(mt76_wcid_alloc);
 
+int mt76_get_min_avg_rssi(struct mt76_dev *dev)
+{
+	struct mt76_wcid *wcid;
+	int i, j, min_rssi = 0;
+	s8 cur_rssi;
+
+	local_bh_disable();
+	rcu_read_lock();
+
+	for (i = 0; i < ARRAY_SIZE(dev->wcid_mask); i++) {
+		unsigned long mask = dev->wcid_mask[i];
+
+		if (!mask)
+			continue;
+
+		for (j = i * BITS_PER_LONG; mask; j++, mask >>= 1) {
+			if (!(mask & 1))
+				continue;
+
+			wcid = rcu_dereference(dev->wcid[j]);
+			if (!wcid)
+				continue;
+
+			spin_lock(&dev->rx_lock);
+			if (wcid->inactive_count++ < 5)
+				cur_rssi = ewma_signal_read(&wcid->rssi);
+			else
+				cur_rssi = 0;
+			spin_unlock(&dev->rx_lock);
+
+			if (cur_rssi < min_rssi)
+				min_rssi = cur_rssi;
+		}
+	}
+
+	rcu_read_unlock();
+	local_bh_enable();
+
+	return min_rssi;
+}
+EXPORT_SYMBOL_GPL(mt76_get_min_avg_rssi);
+
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.17.0

