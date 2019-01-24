Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD26EC282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A505521872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfAXPoe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:44:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfAXPod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 10:44:33 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E753880E7B;
        Thu, 24 Jan 2019 15:44:32 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E068D10D8223;
        Thu, 24 Jan 2019 15:44:26 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 6/7] mt76: beaconing fixes for USB
Date:   Thu, 24 Jan 2019 16:44:08 +0100
Message-Id: <1548344649-10404-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 24 Jan 2019 15:44:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure beaconing on USB devices without PS buffering support.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c     |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 24 ++++++++++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  8 +++++---
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ee3b65a14870..65433d9aca83 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -317,7 +317,6 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
-	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
@@ -329,6 +328,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	ieee80211_hw_set(hw, AP_LINK_PS);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
+	if (dev->bus->type == MT76_BUS_MMIO)
+		ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 
 	wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ae1727e433f3..632c76acbbda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -1060,8 +1060,9 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 	return 0;
 }
 
-void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
-				   u8 vif_idx, bool val)
+static void
+__mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
+			        bool val, struct sk_buff *skb)
 {
 	u8 old_mask = dev->beacon_mask;
 	bool en;
@@ -1069,6 +1070,8 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 
 	if (val) {
 		dev->beacon_mask |= BIT(vif_idx);
+		if (skb)
+			mt76x02_mac_set_beacon(dev, vif_idx, skb);
 	} else {
 		dev->beacon_mask &= ~BIT(vif_idx);
 		mt76x02_mac_set_beacon(dev, vif_idx, NULL);
@@ -1079,14 +1082,29 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 
 	en = dev->beacon_mask;
 
-	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
 	reg = MT_BEACON_TIME_CFG_BEACON_TX |
 	      MT_BEACON_TIME_CFG_TBTT_EN |
 	      MT_BEACON_TIME_CFG_TIMER_EN;
 	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
 
+	if (mt76_is_usb(dev))
+		return;
+
+	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
 	if (en)
 		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 	else
 		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
+
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
+			           bool val, struct sk_buff *skb)
+{
+	if (mt76_is_mmio(dev))
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+
+	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
+
+	if (mt76_is_mmio(dev))
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 76e564b8f5da..a15fc71e3d55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -205,7 +205,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			   struct sk_buff *skb);
 void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
-				   bool val);
+				   bool val, struct sk_buff *skb);
 
 void mt76x02_edcca_init(struct mt76x02_dev *dev);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 741ecd723b8e..8732e07c01ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -687,6 +687,7 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76x02_dev *dev = hw->priv;
+	struct sk_buff *skb;
 
 	mutex_lock(&dev->mt76.mutex);
 
@@ -694,10 +695,11 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		tasklet_disable(&dev->pre_tbtt_tasklet);
+		skb = NULL;
+		if (info->enable_beacon && mt76_is_usb(dev))
+			skb = ieee80211_beacon_get(hw, vif);
 		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
-					      info->enable_beacon);
-		tasklet_enable(&dev->pre_tbtt_tasklet);
+					      info->enable_beacon, skb);
 	}
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
-- 
1.9.3

