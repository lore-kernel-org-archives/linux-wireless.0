Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727266AbeIDTHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 13/22] mt76: unify add_interface
Date: Tue,  4 Sep 2018 16:41:06 +0200
Message-Id: <1536072075-6990-14-git-send-email-sgruszka@redhat.com> (sfid-20180904_164252_098862_09524C72)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make common add_interface for mt76x0 and mt76x2e. This change behavior
for mt76x0, but it should work with the new implementation.

mt76x2u has different implementation. Maybe it can use common one,
but for now leave it as is.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c  | 13 +---------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 30 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c  | 31 +----------------------
 4 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index d8efa009126c..809ee41e7121 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -51,17 +51,6 @@ static void mt76x0_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-
-static int mt76x0_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	unsigned int idx = 0;
-
-	mt76x02_vif_init(&dev->mt76, vif, idx);
-	return 0;
-}
-
 static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt76x0_dev *dev = hw->priv;
@@ -194,7 +183,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.tx = mt76x0_tx,
 	.start = mt76x0_start,
 	.stop = mt76x0_stop,
-	.add_interface = mt76x0_add_interface,
+	.add_interface = mt76x02_add_interface,
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 69f19ef361a1..04cd4dc394d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -127,6 +127,36 @@ void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
+int
+mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt76_dev *dev = hw->priv;
+	unsigned int idx = 0;
+
+	if (vif->addr[0] & BIT(1))
+		idx = 1 + (((dev->macaddr[0] ^ vif->addr[0]) >> 2) & 7);
+
+	/*
+	 * Client mode typically only has one configurable BSSID register,
+	 * which is used for bssidx=0. This is linked to the MAC address.
+	 * Since mac80211 allows changing interface types, and we cannot
+	 * force the use of the primary MAC address for a station mode
+	 * interface, we need some other way of configuring a per-interface
+	 * remote BSSID.
+	 * The hardware provides an AP-Client feature, where bssidx 0-7 are
+	 * used for AP mode and bssidx 8-15 for client mode.
+	 * We shift the station interface bss index by 8 to force the
+	 * hardware to recognize the BSSID.
+	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION)
+		idx += 8;
+
+	mt76x02_vif_init(dev, vif, idx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_add_interface);
+
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index a61c9f2b9a62..f8890ab7b04e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -28,6 +28,8 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		     unsigned int idx);
+int mt76x02_add_interface(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 128a1c1c0f64..99d9033efa15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -55,35 +55,6 @@ mt76x2_stop(struct ieee80211_hw *hw)
 }
 
 static int
-mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	unsigned int idx = 0;
-
-	if (vif->addr[0] & BIT(1))
-		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
-
-	/*
-	 * Client mode typically only has one configurable BSSID register,
-	 * which is used for bssidx=0. This is linked to the MAC address.
-	 * Since mac80211 allows changing interface types, and we cannot
-	 * force the use of the primary MAC address for a station mode
-	 * interface, we need some other way of configuring a per-interface
-	 * remote BSSID.
-	 * The hardware provides an AP-Client feature, where bssidx 0-7 are
-	 * used for AP mode and bssidx 8-15 for client mode.
-	 * We shift the station interface bss index by 8 to force the
-	 * hardware to recognize the BSSID.
-	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
-	 */
-	if (vif->type == NL80211_IFTYPE_STATION)
-		idx += 8;
-
-	mt76x02_vif_init(&dev->mt76, vif, idx);
-	return 0;
-}
-
-static int
 mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 {
 	int ret;
@@ -313,7 +284,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.tx = mt76x2_tx,
 	.start = mt76x2_start,
 	.stop = mt76x2_stop,
-	.add_interface = mt76x2_add_interface,
+	.add_interface = mt76x02_add_interface,
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x2_config,
 	.configure_filter = mt76x02_configure_filter,
-- 
2.7.5
