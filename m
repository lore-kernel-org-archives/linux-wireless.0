Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3D4C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A782C2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfA1MWN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1MWM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:22:12 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10D2186671;
        Mon, 28 Jan 2019 12:22:12 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66635D977;
        Mon, 28 Jan 2019 12:22:08 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 6/7] mt76: beaconing fixes for USB
Date:   Mon, 28 Jan 2019 13:21:47 +0100
Message-Id: <1548678108-9526-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 28 Jan 2019 12:22:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure beaconing on USB devices without PS buffering support.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2: move some code 
 drivers/net/wireless/mediatek/mt76/mac80211.c |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 29 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +--
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  8 ++---
 4 files changed, 32 insertions(+), 12 deletions(-)

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
index ae1727e433f3..3b8dc6757df1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -1060,8 +1060,9 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 	return 0;
 }
 
-void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
-				   u8 vif_idx, bool val)
+static void
+__mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
+				bool val, struct sk_buff *skb)
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
@@ -1079,14 +1082,34 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 
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
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
+				   struct ieee80211_vif *vif, bool val)
+{
+	u8 vif_idx = ((struct mt76x02_vif *)vif->drv_priv)->idx;
+	struct sk_buff *skb = NULL;
+
+	if (mt76_is_mmio(dev))
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+	else
+		skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+
+	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
+
+	if (mt76_is_mmio(dev))
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 76e564b8f5da..3b04b1bd0abd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -204,8 +204,8 @@ void mt76x02_mac_work(struct work_struct *work);
 void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr);
 int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			   struct sk_buff *skb);
-void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
-				   bool val);
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
+				   struct ieee80211_vif *vif, bool val);
 
 void mt76x02_edcca_init(struct mt76x02_dev *dev);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 793258616831..edc84699d621 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -695,12 +695,8 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID)
 		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		tasklet_disable(&dev->pre_tbtt_tasklet);
-		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
-					      info->enable_beacon);
-		tasklet_enable(&dev->pre_tbtt_tasklet);
-	}
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		mt76x02_mac_set_beacon_enable(dev, vif, info->enable_beacon);
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt76x02_mac_set_tx_protection(dev, info->use_cts_prot,
-- 
2.19.2

