Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38383 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbDGL5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 07:57:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: move IE split utilities here from mac80211
Date: Tue,  7 Apr 2015 13:56:59 +0200
Message-Id: <1428407820-4099-1-git-send-email-johannes@sipsolutions.net> (sfid-20150407_135711_304303_23F47CFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the next patch will require the IE splitting utility functions
in cfg80211, move them there from mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h     | 28 ----------------------
 net/mac80211/ieee80211_i.h |  4 ----
 net/mac80211/util.c        | 40 --------------------------------
 net/wireless/util.c        | 41 ++++++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 72 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 441306436569..f8d6813cd5b2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5001,6 +5001,64 @@ int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
 			  u8 *buf, unsigned int bufsize);
 
 /**
+ * ieee80211_ie_split_ric - split an IE buffer according to ordering (with RIC)
+ * @ies: the IE buffer
+ * @ielen: the length of the IE buffer
+ * @ids: an array with element IDs that are allowed before
+ *	the split
+ * @n_ids: the size of the element ID array
+ * @after_ric: array IE types that come after the RIC element
+ * @n_after_ric: size of the @after_ric array
+ * @offset: offset where to start splitting in the buffer
+ *
+ * This function splits an IE buffer by updating the @offset
+ * variable to point to the location where the buffer should be
+ * split.
+ *
+ * It assumes that the given IE buffer is well-formed, this
+ * has to be guaranteed by the caller!
+ *
+ * It also assumes that the IEs in the buffer are ordered
+ * correctly, if not the result of using this function will not
+ * be ordered correctly either, i.e. it does no reordering.
+ *
+ * The function returns the offset where the next part of the
+ * buffer starts, which may be @ielen if the entire (remainder)
+ * of the buffer should be used.
+ */
+size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
+			      const u8 *ids, int n_ids,
+			      const u8 *after_ric, int n_after_ric,
+			      size_t offset);
+
+/**
+ * ieee80211_ie_split - split an IE buffer according to ordering
+ * @ies: the IE buffer
+ * @ielen: the length of the IE buffer
+ * @ids: an array with element IDs that are allowed before
+ *	the split
+ * @n_ids: the size of the element ID array
+ * @offset: offset where to start splitting in the buffer
+ *
+ * This function splits an IE buffer by updating the @offset
+ * variable to point to the location where the buffer should be
+ * split.
+ *
+ * It assumes that the given IE buffer is well-formed, this
+ * has to be guaranteed by the caller!
+ *
+ * It also assumes that the IEs in the buffer are ordered
+ * correctly, if not the result of using this function will not
+ * be ordered correctly either, i.e. it does no reordering.
+ *
+ * The function returns the offset where the next part of the
+ * buffer starts, which may be @ielen if the entire (remainder)
+ * of the buffer should be used.
+ */
+size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+			  const u8 *ids, int n_ids, size_t offset);
+
+/**
  * cfg80211_report_wowlan_wakeup - report wakeup from WoWLAN
  * @wdev: the wireless device reporting the wakeup
  * @wakeup: the wakeup report
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3578da96b41a..b4bef1152c05 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5380,34 +5380,6 @@ int ieee80211_reserve_tid(struct ieee80211_sta *sta, u8 tid);
 void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
 
 /**
- * ieee80211_ie_split - split an IE buffer according to ordering
- *
- * @ies: the IE buffer
- * @ielen: the length of the IE buffer
- * @ids: an array with element IDs that are allowed before
- *	the split
- * @n_ids: the size of the element ID array
- * @offset: offset where to start splitting in the buffer
- *
- * This function splits an IE buffer by updating the @offset
- * variable to point to the location where the buffer should be
- * split.
- *
- * It assumes that the given IE buffer is well-formed, this
- * has to be guaranteed by the caller!
- *
- * It also assumes that the IEs in the buffer are ordered
- * correctly, if not the result of using this function will not
- * be ordered correctly either, i.e. it does no reordering.
- *
- * The function returns the offset where the next part of the
- * buffer starts, which may be @ielen if the entire (remainder)
- * of the buffer should be used.
- */
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset);
-
-/**
  * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 04b32f3e0395..ab46ab4a7249 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1965,10 +1965,6 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata);
 
-size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
-			      const u8 *ids, int n_ids,
-			      const u8 *after_ric, int n_after_ric,
-			      size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 482b85c19a36..79412f16b61d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2194,46 +2194,6 @@ void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
-static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
-{
-	int i;
-
-	for (i = 0; i < n_ids; i++)
-		if (ids[i] == id)
-			return true;
-	return false;
-}
-
-size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
-			      const u8 *ids, int n_ids,
-			      const u8 *after_ric, int n_after_ric,
-			      size_t offset)
-{
-	size_t pos = offset;
-
-	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos])) {
-		if (ies[pos] == WLAN_EID_RIC_DATA && n_after_ric) {
-			pos += 2 + ies[pos + 1];
-
-			while (pos < ielen &&
-			       !ieee80211_id_in_list(after_ric, n_after_ric,
-						     ies[pos]))
-				pos += 2 + ies[pos + 1];
-		} else {
-			pos += 2 + ies[pos + 1];
-		}
-	}
-
-	return pos;
-}
-
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset)
-{
-	return ieee80211_ie_split_ric(ies, ielen, ids, n_ids, NULL, 0, offset);
-}
-EXPORT_SYMBOL(ieee80211_ie_split);
-
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
 {
 	size_t pos = offset;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f218b151530a..70051ab52f4f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1290,6 +1290,47 @@ int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
 }
 EXPORT_SYMBOL(cfg80211_get_p2p_attr);
 
+static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
+{
+	int i;
+
+	for (i = 0; i < n_ids; i++)
+		if (ids[i] == id)
+			return true;
+	return false;
+}
+
+size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
+			      const u8 *ids, int n_ids,
+			      const u8 *after_ric, int n_after_ric,
+			      size_t offset)
+{
+	size_t pos = offset;
+
+	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos])) {
+		if (ies[pos] == WLAN_EID_RIC_DATA && n_after_ric) {
+			pos += 2 + ies[pos + 1];
+
+			while (pos < ielen &&
+			       !ieee80211_id_in_list(after_ric, n_after_ric,
+						     ies[pos]))
+				pos += 2 + ies[pos + 1];
+		} else {
+			pos += 2 + ies[pos + 1];
+		}
+	}
+
+	return pos;
+}
+EXPORT_SYMBOL(ieee80211_ie_split_ric);
+
+size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+			  const u8 *ids, int n_ids, size_t offset)
+{
+	return ieee80211_ie_split_ric(ies, ielen, ids, n_ids, NULL, 0, offset);
+}
+EXPORT_SYMBOL(ieee80211_ie_split);
+
 bool ieee80211_operating_class_to_band(u8 operating_class,
 				       enum ieee80211_band *band)
 {
-- 
2.1.4

