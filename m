Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60089 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaA2HBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:20 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so663041eaj.18
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:19 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] mac80211: batch CSA bss info notification
Date: Wed, 29 Jan 2014 07:56:17 +0100
Message-Id: <1390978581-13273-2-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080147_673107_42008B03)
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having
ieee80211_bss_info_change_notify() scattered all
over the place just call it once when finalizing
CSA.

As a side effect this patch adds missing error
checking for IBSS CSA beacon update.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c  | 14 +++++++++-----
 net/mac80211/ibss.c |  7 +++----
 net/mac80211/mesh.c |  5 +++--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cf27c62..b503f92 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3014,8 +3014,6 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		ieee80211_hw_config(local, 0);
 	}
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-
 	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -3026,17 +3024,21 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		changed |= err;
 		kfree(sdata->u.ap.next_beacon);
 		sdata->u.ap.next_beacon = NULL;
-
-		ieee80211_bss_info_change_notify(sdata, err);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ieee80211_ibss_finish_csa(sdata);
+		err = ieee80211_ibss_finish_csa(sdata);
+		if (err < 0)
+			return;
+
+		changed |= err;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
 			return;
+
+		changed |= err;
 		break;
 #endif
 	default:
@@ -3044,6 +3046,8 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	ieee80211_bss_info_change_notify(sdata, err);
+
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ed7eec3..82d3d14 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -530,7 +530,7 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct cfg80211_bss *cbss;
-	int err;
+	int err, changed = 0;
 	u16 capability;
 
 	sdata_assert_lock(sdata);
@@ -562,10 +562,9 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 	if (err < 0)
 		return err;
 
-	if (err)
-		ieee80211_bss_info_change_notify(sdata, err);
+	changed |= err;
 
-	return 0;
+	return changed;
 }
 
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 836ec01..bd55115 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1058,6 +1058,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_csa_settings *tmp_csa_settings;
 	int ret = 0;
+	int changed = 0;
 
 	/* Reset the TTL value and Initiator flag */
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
@@ -1072,11 +1073,11 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	if (ret)
 		return -EINVAL;
 
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	changed |= BSS_CHANGED_BEACON;
 
 	mcsa_dbg(sdata, "complete switching to center freq %d MHz",
 		 sdata->vif.bss_conf.chandef.chan->center_freq);
-	return 0;
+	return changed;
 }
 
 int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.3

