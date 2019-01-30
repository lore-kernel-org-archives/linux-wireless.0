Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52552C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C6E5207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbfA3QCd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:02:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbfA3QCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:02:32 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40C444E93D;
        Wed, 30 Jan 2019 16:02:32 +0000 (UTC)
Received: from localhost (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C037D452C;
        Wed, 30 Jan 2019 16:02:31 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 6/7] mt76: beaconing fixes for USB
Date:   Wed, 30 Jan 2019 17:02:18 +0100
Message-Id: <1548864139-27729-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
References: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 30 Jan 2019 16:02:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure beaconing on USB devices without PS buffering support.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v3:
- do not disable HOST_BROADCAST_PS_BUFFERING, we will not enable AP mode
- allocate skb only when enabling beacon

 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 29 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +--
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  8 ++---
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ae1727e433f3..2dc80ea26752 100644
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
+	else if (val)
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
index 4bc0520da1c6..724b13d91898 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -705,12 +705,8 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
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

