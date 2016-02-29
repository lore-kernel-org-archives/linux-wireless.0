Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbcB2NZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/12] mac80211: Add API to report nan function match
Date: Mon, 29 Feb 2016 15:25:11 +0200
Message-Id: <1456752313-5792-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142950_005526_FD1C9EEC)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Provide an API to report nan function match. Mac80211 will lookup the
corresponding cookie and report the match to cfg80211.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 14 ++++++++++++++
 net/mac80211/cfg.c     | 28 ++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d2ebefab..0fbe6b1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5675,4 +5675,18 @@ void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
 				   enum nl80211_nan_func_term_reason reason,
 				   gfp_t gfp);
 
+/**
+ * ieee80211_nan_func_match - notify about NAN function match event.
+ *
+ * This function is used to notify mac80211 about nan function match. The
+ * cookie inside the match struct will be assigned by mac80211.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @match: match event information
+ * @gfp: allocation flags
+ */
+void ieee80211_nan_func_match(struct ieee80211_vif *vif,
+			      struct cfg80211_nan_match_params *match,
+			      gfp_t gfp);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6686922..53f1122 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3563,6 +3563,34 @@ void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_nan_func_terminated);
 
+void ieee80211_nan_func_match(struct ieee80211_vif *vif,
+			      struct cfg80211_nan_match_params *match,
+			      gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_nan_func *func;
+	struct wireless_dev *wdev;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
+		return;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	func = ieee80211_find_nan_func(sdata, match->inst_id);
+	if (WARN_ON(!func)) {
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		return;
+	}
+	match->cookie = func->func.cookie;
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	wdev = ieee80211_vif_to_wdev(vif);
+	if (!WARN_ON_ONCE(!wdev))
+		cfg80211_nan_match(wdev, match, gfp);
+}
+EXPORT_SYMBOL(ieee80211_nan_func_match);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
-- 
2.5.0

