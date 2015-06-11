Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbFKKxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 06:53:54 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 47BD62DC3D6
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 10:53:54 +0000 (UTC)
Received: from localhost (dhcp-27-216.brq.redhat.com [10.34.27.216])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t5BArr49013079
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 06:53:53 -0400
Date: Thu, 11 Jun 2015 12:53:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] rt2800: fix assigning same WCID for different stations
Message-ID: <20150611105344.GB18173@redhat.com> (sfid-20150611_125359_143987_FC17D257)
References: <1433946037-11347-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433946037-11347-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some hardware reading WCID entries table results getting 0xff
numbers, no matter of value written there before. This cause assigning
the same WCID for different stations and makes not possible to connect
to more than one station.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
  - handle also places where wcid was -1
  - use non-atomic bit operations

 drivers/net/wireless/rt2x00/rt2800.h    | 10 ++++++
 drivers/net/wireless/rt2x00/rt2800lib.c | 57 ++++++++++-----------------------
 drivers/net/wireless/rt2x00/rt2x00mac.c | 16 +--------
 3 files changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ebd5625..95c1d7c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2961,6 +2961,15 @@ enum rt2800_eeprom_word {
 #define BCN_TBTT_OFFSET 64
 
 /*
+ * Hardware has 255 WCID table entries. First 32 entries are reserved for
+ * shared keys. Since parts of the pairwise key table might be shared with
+ * the beacon frame buffers 6 & 7 we could only use the first 222 entries.
+ */
+#define WCID_START	33
+#define WCID_END	222
+#define STA_IDS_SIZE	(WCID_END - WCID_START + 2)
+
+/*
  * RT2800 driver data structure
  */
 struct rt2800_drv_data {
@@ -2971,6 +2980,7 @@ struct rt2800_drv_data {
 	u8 txmixer_gain_24g;
 	u8 txmixer_gain_5g;
 	unsigned int tbtt_tick;
+	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
 };
 
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index be2d54f..caff221 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1381,38 +1381,6 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_config_shared_key);
 
-static inline int rt2800_find_wcid(struct rt2x00_dev *rt2x00dev)
-{
-	struct mac_wcid_entry wcid_entry;
-	int idx;
-	u32 offset;
-
-	/*
-	 * Search for the first free WCID entry and return the corresponding
-	 * index.
-	 *
-	 * Make sure the WCID starts _after_ the last possible shared key
-	 * entry (>32).
-	 *
-	 * Since parts of the pairwise key table might be shared with
-	 * the beacon frame buffers 6 & 7 we should only write into the
-	 * first 222 entries.
-	 */
-	for (idx = 33; idx <= 222; idx++) {
-		offset = MAC_WCID_ENTRY(idx);
-		rt2800_register_multiread(rt2x00dev, offset, &wcid_entry,
-					  sizeof(wcid_entry));
-		if (is_broadcast_ether_addr(wcid_entry.mac))
-			return idx;
-	}
-
-	/*
-	 * Use -1 to indicate that we don't have any more space in the WCID
-	 * table.
-	 */
-	return -1;
-}
-
 int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 			       struct rt2x00lib_crypto *crypto,
 			       struct ieee80211_key_conf *key)
@@ -1425,7 +1393,7 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		 * Allow key configuration only for STAs that are
 		 * known by the hw.
 		 */
-		if (crypto->wcid < 0)
+		if (crypto->wcid > WCID_END)
 			return -ENOSPC;
 		key->hw_key_idx = crypto->wcid;
 
@@ -1455,11 +1423,13 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 {
 	int wcid;
 	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 
 	/*
-	 * Find next free WCID.
+	 * Search for the first free WCID entry and return the corresponding
+	 * index.
 	 */
-	wcid = rt2800_find_wcid(rt2x00dev);
+	wcid = find_first_zero_bit(drv_data->sta_ids, STA_IDS_SIZE) + WCID_START;
 
 	/*
 	 * Store selected wcid even if it is invalid so that we can
@@ -1471,9 +1441,11 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 	 * No space left in the device, however, we can still communicate
 	 * with the STA -> No error.
 	 */
-	if (wcid < 0)
+	if (wcid > WCID_END)
 		return 0;
 
+	__set_bit(wcid - WCID_START, drv_data->sta_ids);
+
 	/*
 	 * Clean up WCID attributes and write STA address to the device.
 	 */
@@ -1487,11 +1459,16 @@ EXPORT_SYMBOL_GPL(rt2800_sta_add);
 
 int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	if (wcid > WCID_END)
+		return 0;
 	/*
 	 * Remove WCID entry, no need to clean the attributes as they will
 	 * get renewed when the WCID is reused.
 	 */
 	rt2800_config_wcid(rt2x00dev, NULL, wcid);
+	__clear_bit(wcid - WCID_START, drv_data->sta_ids);
 
 	return 0;
 }
@@ -7967,11 +7944,11 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	/*
 	 * Don't allow aggregation for stations the hardware isn't aware
 	 * of because tx status reports for frames to an unknown station
-	 * always contain wcid=255 and thus we can't distinguish between
-	 * multiple stations which leads to unwanted situations when the
-	 * hw reorders frames due to aggregation.
+	 * always contain wcid=WCID_END+1 and thus we can't distinguish
+	 * between multiple stations which leads to unwanted situations
+	 * when the hw reorders frames due to aggregation.
 	 */
-	if (sta_priv->wcid < 0)
+	if (sta_priv->wcid > WCID_END)
 		return 1;
 
 	switch (action) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 300876d..f8990d8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -539,16 +539,8 @@ int rt2x00mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
 
-	/*
-	 * If there's no space left in the device table store
-	 * -1 as wcid but tell mac80211 everything went ok.
-	 */
-	if (rt2x00dev->ops->lib->sta_add(rt2x00dev, vif, sta))
-		sta_priv->wcid = -1;
-
-	return 0;
+	return rt2x00dev->ops->lib->sta_add(rt2x00dev, vif, sta);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_sta_add);
 
@@ -558,12 +550,6 @@ int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
 
-	/*
-	 * If we never sent the STA to the device no need to clean it up.
-	 */
-	if (sta_priv->wcid < 0)
-		return 0;
-
 	return rt2x00dev->ops->lib->sta_remove(rt2x00dev, sta_priv->wcid);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_sta_remove);
-- 
1.8.4.2

