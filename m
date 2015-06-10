Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964993AbbFJOUp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 10:20:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2800: fix assigning same WCID for different stations
Date: Wed, 10 Jun 2015 16:20:37 +0200
Message-Id: <1433946037-11347-1-git-send-email-sgruszka@redhat.com> (sfid-20150610_162049_036966_ED1F5528)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some hardware reading WCID entries table results getting 0xff
numbers, no matter of value written there before. This cause assigning
the same WCID for different stations and makes not possible to connect
to more than one station.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    | 10 ++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c | 45 ++++++++-------------------------
 2 files changed, 20 insertions(+), 35 deletions(-)

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
index be2d54f..47c4b19 100644
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
 
+	set_bit(wcid - WCID_START, drv_data->sta_ids);
+
 	/*
 	 * Clean up WCID attributes and write STA address to the device.
 	 */
@@ -1487,11 +1459,14 @@ EXPORT_SYMBOL_GPL(rt2800_sta_add);
 
 int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
 	/*
 	 * Remove WCID entry, no need to clean the attributes as they will
 	 * get renewed when the WCID is reused.
 	 */
 	rt2800_config_wcid(rt2x00dev, NULL, wcid);
+	clear_bit(wcid - WCID_START, drv_data->sta_ids);
 
 	return 0;
 }
-- 
1.8.4.2

