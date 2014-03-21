Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:65272 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbaCUNhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:37:18 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so1822653eek.6
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:37:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/4] mac80211: split CSA finalize function
Date: Fri, 21 Mar 2014 14:31:13 +0100
Message-Id: <1395408675-26013-3-git-send-email-michal.kazior@tieto.com> (sfid-20140321_143729_308895_C75CE6CB)
In-Reply-To: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improves readability and modularity.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 61 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7737884..65768ef 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3051,25 +3051,11 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
+					  u32 *changed)
 {
-	struct ieee80211_local *local = sdata->local;
-	int err, changed = 0;
-
-	sdata_assert_lock(sdata);
-	lockdep_assert_held(&local->mtx);
-
-	sdata->radar_required = sdata->csa_radar_required;
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		return;
-
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		ieee80211_hw_config(local, 0);
-	}
+	int err;
 
-	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
@@ -3077,30 +3063,57 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		sdata->u.ap.next_beacon = NULL;
 
 		if (err < 0)
-			return;
-		changed |= err;
+			return err;
+		*changed |= err;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		err = ieee80211_ibss_finish_csa(sdata);
 		if (err < 0)
-			return;
-		changed |= err;
+			return err;
+		*changed |= err;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
-			return;
-		changed |= err;
+			return err;
+		*changed |= err;
 		break;
 #endif
 	default:
 		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	u32 changed = 0;
+	int err;
+
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
+
+	sdata->radar_required = sdata->csa_radar_required;
+	err = ieee80211_vif_change_channel(sdata, &changed);
+	if (WARN_ON(err < 0))
 		return;
+
+	if (!local->use_chanctx) {
+		local->_oper_chandef = sdata->csa_chandef;
+		ieee80211_hw_config(local, 0);
 	}
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+	sdata->vif.csa_active = false;
+
+	err = ieee80211_set_after_csa_beacon(sdata, &changed);
+	if (err)
+		return;
 
+	ieee80211_bss_info_change_notify(sdata, changed);
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 }
 
-- 
1.8.5.3

