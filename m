Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727595AbeIDTHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:35 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 11/22] mt76x0: remove vif_mask
Date: Tue,  4 Sep 2018 16:41:04 +0200
Message-Id: <1536072075-6990-12-git-send-email-sgruszka@redhat.com> (sfid-20180904_164250_901392_E7D7C2EE)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make remove_interface more similar to mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 11 +----------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 --
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index f87103aea868..a818a47f8e4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -56,14 +56,7 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	unsigned int idx;
-
-	idx = ffs(~dev->vif_mask);
-	if (!idx || idx > 8)
-		return -ENOSPC;
-
-	idx--;
-	dev->vif_mask |= BIT(idx);
+	unsigned int idx = 0;
 
 	mt76x02_vif_init(&dev->mt76, vif, idx);
 	return 0;
@@ -73,9 +66,7 @@ static void mt76x0_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 
-	dev->vif_mask &= ~BIT(mvif->idx);
 	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index e65e6c09877c..c3669735965b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -134,8 +134,6 @@ struct mt76x0_dev {
 	u8 in_ep[__MT_EP_IN_MAX];
 	u16 in_max_packet;
 
-	unsigned long vif_mask;
-
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-- 
2.7.5
