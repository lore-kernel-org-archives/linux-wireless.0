Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab2AJPdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 10:33:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RkdhI-0000lO-97
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 16:33:12 +0100
Message-Id: <20120110153239.983642800@sipsolutions.net> (sfid-20120110_163317_536583_F68CA564)
Date: Tue, 10 Jan 2012 16:30:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT 2/3] cfg80211: export cfg80211_ref_bss
References: <20120110153048.612308160@sipsolutions.net>
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

--- a/include/net/cfg80211.h	2012-01-09 13:57:47.000000000 +0100
+++ b/include/net/cfg80211.h	2012-01-09 14:40:09.000000000 +0100
@@ -2709,6 +2709,20 @@ struct cfg80211_bss *cfg80211_get_mesh(s
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
--- a/net/wireless/core.h	2012-01-09 13:57:47.000000000 +0100
+++ b/net/wireless/core.h	2012-01-09 14:41:13.000000000 +0100
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
--- a/net/wireless/scan.c	2012-01-09 12:40:53.000000000 +0100
+++ b/net/wireless/scan.c	2012-01-09 14:40:58.000000000 +0100
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


