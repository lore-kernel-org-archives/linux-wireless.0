Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbZBJUla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:41:30 -0500
Message-Id: <20090210202556.865386356@sipsolutions.net> (sfid-20090210_214136_756642_B66673B1)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/27] cfg80211: allow users to request removing a BSS
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces cfg80211_unlink_bss, a function to
allow a driver to remove a BSS from the internal list and
make it not show up in scan results any more -- this is
to be used when the driver detects that the BSS is no
longer available.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   11 +++++++++++
 net/wireless/scan.c    |   21 +++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- wireless-testing.orig/include/net/cfg80211.h	2009-02-10 20:59:37.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-02-10 20:59:37.000000000 +0100
@@ -791,5 +791,16 @@ struct cfg80211_bss *cfg80211_get_mesh(s
 				       const u8 *meshid, size_t meshidlen,
 				       const u8 *meshcfg);
 void cfg80211_put_bss(struct cfg80211_bss *bss);
+/**
+ * cfg80211_unlink_bss - unlink BSS from internal data structures
+ * @wiphy: the wiphy
+ * @bss: the bss to remove
+ *
+ * This function removes the given BSS from the internal data structures
+ * thereby making it no longer show up in scan results etc. Use this
+ * function when you detect a BSS is gone. Normally BSSes will also time
+ * out, so it is not necessary to use this function at all.
+ */
+void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/scan.c	2009-02-10 20:59:37.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-02-10 20:59:37.000000000 +0100
@@ -432,6 +432,27 @@ void cfg80211_put_bss(struct cfg80211_bs
 }
 EXPORT_SYMBOL(cfg80211_put_bss);
 
+void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
+{
+	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
+	struct cfg80211_internal_bss *bss;
+
+	if (WARN_ON(!pub))
+		return;
+
+	bss = container_of(pub, struct cfg80211_internal_bss, pub);
+
+	spin_lock_bh(&dev->bss_lock);
+
+	list_del(&bss->list);
+	rb_erase(&bss->rbn, &dev->bss_tree);
+
+	spin_unlock_bh(&dev->bss_lock);
+
+	kref_put(&bss->ref, bss_release);
+}
+EXPORT_SYMBOL(cfg80211_unlink_bss);
+
 #ifdef CONFIG_WIRELESS_EXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,

-- 

