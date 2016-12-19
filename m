Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758306AbcLSKzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/11] rt2800: set MAX_PSDU len according to remote STAs capabilities
Date: Mon, 19 Dec 2016 11:52:50 +0100
Message-Id: <1482144777-16760-5-git-send-email-sgruszka@redhat.com> (sfid-20161219_115704_337433_825A36C8)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAX_LEN_CFG_MAX_PSDU specify maximum transmitted by HW AMPDU length
(0 - 8kB, 1 - 16kB, 2 - 32kB, 3 - 64kB). Set this option according to
remote stations capabilities (based on HT ampdu_factor). However limit
the value based our hardware TX capabilities as some chips can not send
more than 16kB (factor 1). Limit for all chips is currently 32kB
(factor 2), but perhaps for some chips this could be increased
to 64kB by setting drv_data->max_psdu to 3.

Since MAX_LEN_CFG_MAX_PSDU is global setting, on multi stations modes
(AP, IBSS, mesh) we limit according to less capable remote STA. We can
not set bigger value to speed up communication with some stations and
do not break communication with slow stations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |    2 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   45 ++++++++++++++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c |    3 +-
 5 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 95c1d7c..ec622a0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2979,7 +2979,9 @@ struct rt2800_drv_data {
 	u8 bbp26;
 	u8 txmixer_gain_24g;
 	u8 txmixer_gain_5g;
+	u8 max_psdu;
 	unsigned int tbtt_tick;
+	unsigned int ampdu_factor_cnt[4];
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
 };
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ef71722..a6f3f78 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1418,6 +1418,23 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_pairwise_key);
 
+static void rt2800_set_max_psdu_len(struct rt2x00_dev *rt2x00dev)
+{
+	u8 i, max_psdu;
+	u32 reg;
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	for (i = 0; i < 3; i++)
+		if (drv_data->ampdu_factor_cnt[i] > 0)
+			break;
+
+	max_psdu = min(drv_data->max_psdu, i);
+
+	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, max_psdu);
+	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
+}
+
 int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
 {
@@ -1426,6 +1443,17 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 
 	/*
+	 * Limit global maximum TX AMPDU length to smallest value of all
+	 * connected stations. In AP mode this can be suboptimal, but we
+	 * do not have a choice if some connected STA is not capable to
+	 * receive the same amount of data like the others.
+	 */
+	if (sta->ht_cap.ht_supported) {
+		drv_data->ampdu_factor_cnt[sta->ht_cap.ampdu_factor & 3]++;
+		rt2800_set_max_psdu_len(rt2x00dev);
+	}
+
+	/*
 	 * Search for the first free WCID entry and return the corresponding
 	 * index.
 	 */
@@ -1457,9 +1485,16 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(rt2800_sta_add);
 
-int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid)
+int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, struct ieee80211_sta *sta)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+	int wcid = sta_priv->wcid;
+
+	if (sta->ht_cap.ht_supported) {
+		drv_data->ampdu_factor_cnt[sta->ht_cap.ampdu_factor & 3]--;
+		rt2800_set_max_psdu_len(rt2x00dev);
+	}
 
 	if (wcid > WCID_END)
 		return 0;
@@ -4536,6 +4571,7 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
  */
 static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	u32 reg;
 	u16 eeprom;
 	unsigned int i;
@@ -4704,10 +4740,13 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E))
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E)) {
+		drv_data->max_psdu = 2;
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
-	else
+	} else {
+		drv_data->max_psdu = 1;
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
+	}
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 10);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 10);
 	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 83f1a44..0a8b4df 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -183,7 +183,7 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 			       struct ieee80211_key_conf *key);
 int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
-int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid);
+int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, struct ieee80211_sta *sta);
 void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			  const unsigned int filter_flags);
 void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index f68d492..01ce8a4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -627,7 +627,7 @@ struct rt2x00lib_ops {
 			struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta);
 	int (*sta_remove) (struct rt2x00_dev *rt2x00dev,
-			   int wcid);
+			   struct ieee80211_sta *sta);
 };
 
 /*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index 13da95a..d4b50fb 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -539,9 +539,8 @@ int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
 
-	return rt2x00dev->ops->lib->sta_remove(rt2x00dev, sta_priv->wcid);
+	return rt2x00dev->ops->lib->sta_remove(rt2x00dev, sta);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_sta_remove);
 
-- 
1.7.1
