Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 03/22] mt76: pratially unify add_interface
Date: Tue,  4 Sep 2018 16:40:56 +0200
Message-Id: <1536072075-6990-4-git-send-email-sgruszka@redhat.com> (sfid-20180904_164158_343008_2FE57F95)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create common mt76x02_vif_init function and use int on drivers
add_interface callback.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  7 +------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  9 ---------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  3 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 12 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  3 ---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  7 +------
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  8 +-------
 8 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index e248298563bc..12884504c833 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -56,7 +56,6 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int idx;
 
 	idx = ffs(~dev->vif_mask);
@@ -66,11 +65,7 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 	idx--;
 	dev->vif_mask |= BIT(idx);
 
-	mvif->idx = idx;
-	mvif->group_wcid.idx = GROUP_WCID(idx);
-	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(&dev->mt76, vif->txq);
-
+	mt76x02_vif_init(&dev->mt76, vif, idx);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index afe592cc7aa9..3fc2b6efeda3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -89,15 +89,6 @@ struct mt76x0_tx_queue {
 	unsigned int fifo_seq;
 };
 
-/* WCID allocation:
- *     0: mcast wcid
- *     1: bssid wcid
- *  1...: STAs
- * ...7e: group wcids
- *    7f: reserved
- */
-#define GROUP_WCID(idx)	(254 - idx)
-
 struct mt76x0_eeprom_params;
 
 #define MT_EE_TEMPERATURE_SLOPE		39
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 6712bb1f9181..551970da9025 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -31,6 +31,9 @@ struct mt76x02_tx_status {
 	u16 rate;
 } __packed __aligned(2);
 
+#define MT_VIF_WCID(_n)		(254 - ((_n) & 7))
+#define MT_MAX_VIFS		8
+
 struct mt76x02_vif {
 	u8 idx;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 07df1e979be5..6660ecf58d0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -115,4 +115,16 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
+void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		     unsigned int idx)
+{
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+
+	mvif->idx = idx;
+	mvif->group_wcid.idx = MT_VIF_WCID(idx);
+	mvif->group_wcid.hw_key_idx = -1;
+	mt76x02_txq_init(dev, vif->txq);
+}
+EXPORT_SYMBOL_GPL(mt76x02_vif_init);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 5d2acc685a35..9ed4404930c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -25,4 +25,7 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
 int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
+
+void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		     unsigned int idx);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 94c3f0cbee2a..b5cf720612e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -42,9 +42,6 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
-#define MT_MAX_VIFS		8
-#define MT_VIF_WCID(_n)		(254 - ((_n) & 7))
-
 #include "mt76.h"
 #include "mt76x02_regs.h"
 #include "mt76x2_mac.h"
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 9b1b3dfdd0dd..870ee01fe409 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -58,7 +58,6 @@ static int
 mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	unsigned int idx = 0;
 
 	if (vif->addr[0] & BIT(1))
@@ -80,11 +79,7 @@ mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_STATION)
 		idx += 8;
 
-	mvif->idx = idx;
-	mvif->group_wcid.idx = MT_VIF_WCID(idx);
-	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(&dev->mt76, vif->txq);
-
+	mt76x02_vif_init(&dev->mt76, vif, idx);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 6b110c695b4b..49818e290ccd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -49,17 +49,11 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-	unsigned int idx = 0;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
 		mt76x2u_mac_setaddr(dev, vif->addr);
 
-	mvif->idx = idx;
-	mvif->group_wcid.idx = MT_VIF_WCID(idx);
-	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(&dev->mt76, vif->txq);
-
+	mt76x02_vif_init(&dev->mt76, vif, 0);
 	return 0;
 }
 
-- 
2.7.5
