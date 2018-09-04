Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727595AbeIDTHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:40 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 12/22] mt76: unify remove_interface
Date: Tue,  4 Sep 2018 16:41:05 +0200
Message-Id: <1536072075-6990-13-git-send-email-sgruszka@redhat.com> (sfid-20180904_164251_502538_3D7A6FEB)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use common remove_interface callback in mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 10 +---------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  9 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  9 ---------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 6 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a818a47f8e4e..d8efa009126c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -62,14 +62,6 @@ static int mt76x0_add_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void mt76x0_remove_interface(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif)
-{
-	struct mt76x0_dev *dev = hw->priv;
-
-	mt76_txq_remove(&dev->mt76, vif->txq);
-}
-
 static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt76x0_dev *dev = hw->priv;
@@ -203,7 +195,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.start = mt76x0_start,
 	.stop = mt76x0_stop,
 	.add_interface = mt76x0_add_interface,
-	.remove_interface = mt76x0_remove_interface,
+	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x0_bss_info_changed,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 706f522f11d9..69f19ef361a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -127,6 +127,15 @@ void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
+void mt76x02_remove_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct mt76_dev *dev = hw->priv;
+
+	mt76_txq_remove(dev, vif->txq);
+}
+EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
+
 int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_ampdu_params *params)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 54f895d8cdbe..a61c9f2b9a62 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -28,6 +28,8 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		     unsigned int idx);
+void mt76x02_remove_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
 
 int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_ampdu_params *params);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 5ce9fbc654a2..be4e00fe7586 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -18,15 +18,6 @@
 #include "mt76x2.h"
 #include "mt76x02_mac.h"
 
-void mt76x2_remove_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif)
-{
-	struct mt76x2_dev *dev = hw->priv;
-
-	mt76_txq_remove(&dev->mt76, vif->txq);
-}
-EXPORT_SYMBOL_GPL(mt76x2_remove_interface);
-
 void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 87302845d582..128a1c1c0f64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -314,7 +314,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.start = mt76x2_start,
 	.stop = mt76x2_stop,
 	.add_interface = mt76x2_add_interface,
-	.remove_interface = mt76x2_remove_interface,
+	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x2_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x2_bss_info_changed,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 1dcc6ced15a5..66a923a32e51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -164,7 +164,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.start = mt76x2u_start,
 	.stop = mt76x2u_stop,
 	.add_interface = mt76x2u_add_interface,
-	.remove_interface = mt76x2_remove_interface,
+	.remove_interface = mt76x02_remove_interface,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
-- 
2.7.5
