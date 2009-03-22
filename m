Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22201 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZCVT6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:58:09 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 4/5] cfg80211: add feature to hold bss
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:57:28 +0200
Message-ID: <20090322195727.26460.70624.stgit@tikku> (sfid-20090322_205812_294340_9782D708)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

In beacon filtering there needs to be a way to not expire the BSS even
when no beacons are received. Add an interface to cfg80211 to hold
BSS and make sure that it's not expired.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/cfg80211.h |   18 ++++++++++++++++++
 net/wireless/core.h    |    2 ++
 net/wireless/scan.c    |   27 ++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dca4a6b..5389afd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -539,6 +539,7 @@ enum cfg80211_signal_type {
  *	is no guarantee that these are well-formed!)
  * @len_information_elements: total length of the information elements
  * @signal: signal strength value (type depends on the wiphy's signal_type)
+ * @hold: BSS should not expire
  * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
@@ -940,4 +941,21 @@ void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf,
 void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
 			       size_t len);
 
+/**
+ * cfg80211_hold_bss - exclude bss from expiration
+ * @bss: bss which should not expire
+ *
+ * In a case when the BSS is not updated but it shouldn't expire this
+ * function can be used to mark the BSS to be excluded from expiration.
+ */
+void cfg80211_hold_bss(struct cfg80211_bss *bss);
+
+/**
+ * cfg80211_unhold_bss - remove expiration exception from the BSS
+ * @bss: bss which can expire again
+ *
+ * This function marks the BSS to be expirable again.
+ */
+void cfg80211_unhold_bss(struct cfg80211_bss *bss);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6acd483..97a6fd8 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -90,6 +90,8 @@ struct cfg80211_internal_bss {
 	struct rb_node rbn;
 	unsigned long ts;
 	struct kref ref;
+	bool hold;
+
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
 };
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 280dbcd..2a00e36 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -80,7 +80,8 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 	bool expired = false;
 
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
-		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
+		if (bss->hold ||
+		    !time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
 			continue;
 		list_del(&bss->list);
 		rb_erase(&bss->rbn, &dev->bss_tree);
@@ -471,6 +472,30 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
+void cfg80211_hold_bss(struct cfg80211_bss *pub)
+{
+	struct cfg80211_internal_bss *bss;
+
+	if (!pub)
+		return;
+
+	bss = container_of(pub, struct cfg80211_internal_bss, pub);
+	bss->hold = true;
+}
+EXPORT_SYMBOL(cfg80211_hold_bss);
+
+void cfg80211_unhold_bss(struct cfg80211_bss *pub)
+{
+	struct cfg80211_internal_bss *bss;
+
+	if (!pub)
+		return;
+
+	bss = container_of(pub, struct cfg80211_internal_bss, pub);
+	bss->hold = false;
+}
+EXPORT_SYMBOL(cfg80211_unhold_bss);
+
 #ifdef CONFIG_WIRELESS_EXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,

