Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55102 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756528AbcIPIdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 04:33:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 11:33:21 +0300
Message-Id: <20160916083321.5840-10-luca@coelho.fi> (sfid-20160916_103430_676661_D9211344)
In-Reply-To: <20160916083321.5840-1-luca@coelho.fi>
References: <20160916083321.5840-1-luca@coelho.fi>
Subject: [PATCH v2 9/9] mac80211: Add API to report NAN function match
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Provide an API to report NAN function match. Mac80211 will lookup the
corresponding cookie and report the match to cfg80211.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 16 ++++++++++++++++
 net/mac80211/cfg.c     | 25 +++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b74229..1b6271e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5777,4 +5777,20 @@ void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
 				   u8 inst_id,
 				   enum nl80211_nan_func_term_reason reason,
 				   gfp_t gfp);
+
+/**
+ * ieee80211_nan_func_match - notify about NAN function match event.
+ *
+ * This function is used to notify mac80211 about NAN function match. The
+ * cookie inside the match struct will be assigned by mac80211.
+ * Note that this function can't be called from hard irq.
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
index aee0e25c..20ac00f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3555,6 +3555,31 @@ void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_nan_func_terminated);
 
+void ieee80211_nan_func_match(struct ieee80211_vif *vif,
+			      struct cfg80211_nan_match_params *match,
+			      gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct cfg80211_nan_func *func;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
+		return;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	func = idr_find(&sdata->u.nan.function_inst_ids,  match->inst_id);
+	if (WARN_ON(!func)) {
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		return;
+	}
+	match->cookie = func->cookie;
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	cfg80211_nan_match(ieee80211_vif_to_wdev(vif), match, gfp);
+}
+EXPORT_SYMBOL(ieee80211_nan_func_match);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
-- 
2.9.3
