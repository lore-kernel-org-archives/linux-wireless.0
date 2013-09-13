Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab3IMKiL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 4/5] mac80211: add generic quiesce procedure
Date: Fri, 13 Sep 2013 12:36:07 +0200
Message-Id: <1379068568-27552-5-git-send-email-sgruszka@redhat.com> (sfid-20130913_123820_651597_6CC2956C)
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add function ieee80211_quiesce() end export it to allow be used by
drivers. It is intended to be used before restart_hw to stop mac80211
timers/works . Reverse quiesce on ieee80211_reconfig().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h | 10 ++++++++++
 net/mac80211/ibss.c    |  2 --
 net/mac80211/main.c    | 33 +++++++++++++++++++++++++++++++++
 net/mac80211/mesh.c    |  2 --
 net/mac80211/mlme.c    |  2 --
 net/mac80211/util.c    | 19 ++++++++++++++++++-
 6 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4be8785..a428ee7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3054,6 +3054,16 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw);
 void ieee80211_free_hw(struct ieee80211_hw *hw);
 
 /**
+ * ieee80211_quiesce - quiesce hardware
+ *
+ * Call this function to stop pending mac80211 activities before
+ * restarting hardware by ieee80211_restart_hw().
+ *
+ * @hw: the hardware to quiesce
+ */
+void ieee80211_quiesce(struct ieee80211_hw *hw);
+
+/**
  * ieee80211_restart_hw - restart hardware completely
  *
  * Call this function when the hardware was restarted for some reason
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 91d1b29..bf2b5a9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1166,7 +1166,6 @@ static void ieee80211_ibss_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
-#ifdef CONFIG_PM
 void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -1184,7 +1183,6 @@ void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
 		ifibss->timer_running = false;
 	}
 }
-#endif
 
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..978f364 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -263,6 +263,39 @@ static void ieee80211_restart_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+/* return value indicates whether the driver should be further notified */
+void ieee80211_quiesce(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	local->quiescing = true;
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			ieee80211_sta_quiesce(sdata);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ieee80211_ibss_quiesce(sdata);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			ieee80211_mesh_quiesce(sdata);
+			break;
+		default:
+			break;
+		}
+
+		cancel_work_sync(&sdata->work);
+	}
+
+	local->quiescing = false;
+}
+EXPORT_SYMBOL(ieee80211_quiesce);
+
 void ieee80211_restart_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e131293..b950d8d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -624,7 +624,6 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
-#ifdef CONFIG_PM
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -651,7 +650,6 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 		add_timer(&ifmsh->mesh_path_root_timer);
 	ieee80211_mesh_root_setup(ifmsh);
 }
-#endif
 
 static int
 ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b308855..66cec97 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3678,7 +3678,6 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-#ifdef CONFIG_PM
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -3742,7 +3741,6 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 	ieee80211_restart_sta_timer(sdata);
 	mutex_unlock(&sdata->local->mtx);
 }
-#endif
 
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..ee5a0b4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1742,11 +1742,28 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_restart(sdata);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ieee80211_ibss_restart(sdata);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			ieee80211_mesh_restart(sdata);
+			break;
+		default:
+			break;
+		}
 	}
 
 	mod_timer(&local->sta_cleanup, jiffies + 1);
+
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list)
+		mesh_plink_restart(sta);
+	mutex_unlock(&local->sta_mtx);
 #else
 	WARN_ON(1);
 #endif
-- 
1.8.3.1

