Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51324 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVMXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 08:23:02 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so1206284wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 05:23:00 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Export IE split function
Date: Wed, 22 Oct 2014 15:22:49 +0300
Message-Id: <1413980569-25501-1-git-send-email-egrumbach@gmail.com> (sfid-20141022_142307_007162_C0DDCDB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Export ieee80211_ie_split function, so it can be reused by drivers
which require to insert additional elements.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     | 28 ++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/util.c        | 26 +-------------------------
 3 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..52c94fa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4888,4 +4888,32 @@ void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
 void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
 				 enum nl80211_tdls_operation oper,
 				 u16 reason_code, gfp_t gfp);
+
+/**
+ * ieee80211_ie_split - split an IE buffer according to ordering
+ *
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
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c2aaec4..587b61d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1833,8 +1833,6 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata);
 
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c61060..b2ec3c38 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2052,31 +2052,6 @@ static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
 	return false;
 }
 
-/**
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
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset)
 {
@@ -2087,6 +2062,7 @@ size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 
 	return pos;
 }
+EXPORT_SYMBOL(ieee80211_ie_split);
 
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
 {
-- 
1.9.1

