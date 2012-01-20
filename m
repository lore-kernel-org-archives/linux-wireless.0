Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2ATM66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:58 -0500
Message-Id: <20120120125741.524447357@sipsolutions.net> (sfid-20120120_135902_021740_63CFA459)
Date: Fri, 20 Jan 2012 13:55:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] cfg80211: export cfg80211_ref_bss
References: <20120120125516.000124996@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is needed by mac80211 to keep a reference
to a BSS alive for the auth process. Remove the
old version of cfg80211_ref_bss() since it's
not actually used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   14 ++++++++++++++
 net/wireless/core.h    |    5 -----
 net/wireless/scan.c    |   12 ++++++++++++
 3 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/net/cfg80211.h	2012-01-20 13:54:20.000000000 +0100
+++ b/include/net/cfg80211.h	2012-01-20 13:54:21.000000000 +0100
@@ -2711,6 +2711,20 @@ struct cfg80211_bss *cfg80211_get_mesh(s
 				       struct ieee80211_channel *channel,
 				       const u8 *meshid, size_t meshidlen,
 				       const u8 *meshcfg);
+/**
+ * cfg80211_ref_bss - reference BSS struct
+ * @bss: the BSS struct to reference
+ *
+ * Increments the refcount of the given BSS struct.
+ */
+void cfg80211_ref_bss(struct cfg80211_bss *bss);
+
+/**
+ * cfg80211_put_bss - unref BSS struct
+ * @bss: the BSS struct
+ *
+ * Decrements the refcount of the given BSS struct.
+ */
 void cfg80211_put_bss(struct cfg80211_bss *bss);
 
 /**
--- a/net/wireless/core.h	2012-01-20 13:54:20.000000000 +0100
+++ b/net/wireless/core.h	2012-01-20 13:54:21.000000000 +0100
@@ -144,11 +144,6 @@ static inline struct cfg80211_internal_b
 	return container_of(pub, struct cfg80211_internal_bss, pub);
 }
 
-static inline void cfg80211_ref_bss(struct cfg80211_internal_bss *bss)
-{
-	kref_get(&bss->ref);
-}
-
 static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
 {
 	atomic_inc(&bss->hold);
--- a/net/wireless/scan.c	2012-01-20 13:54:09.000000000 +0100
+++ b/net/wireless/scan.c	2012-01-20 13:54:21.000000000 +0100
@@ -861,6 +861,18 @@ cfg80211_inform_bss_frame(struct wiphy *
 }
 EXPORT_SYMBOL(cfg80211_inform_bss_frame);
 
+void cfg80211_ref_bss(struct cfg80211_bss *pub)
+{
+	struct cfg80211_internal_bss *bss;
+
+	if (!pub)
+		return;
+
+	bss = container_of(pub, struct cfg80211_internal_bss, pub);
+	kref_get(&bss->ref);
+}
+EXPORT_SYMBOL(cfg80211_ref_bss);
+
 void cfg80211_put_bss(struct cfg80211_bss *pub)
 {
 	struct cfg80211_internal_bss *bss;


