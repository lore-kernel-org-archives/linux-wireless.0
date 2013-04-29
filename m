Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3D2NaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 09:30:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
Date: Mon, 29 Apr 2013 15:30:07 +0200
Message-Id: <1367242207-28671-1-git-send-email-johannes@sipsolutions.net> (sfid-20130429_153025_106505_50F144FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since commit 12e7f517029dad819c45eca9ca01fdb9ba57616b,
IEEE80211_SDATA_DISCONNECT_RESUME no longer worked as
it would simply never be tested. Restore a bit of the
code removed there and in 9b7d72c1041ec5b20b24af487a9
to make it work again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 25 +++++++++++++++++++++++++
 net/mac80211/util.c        |  7 +++++++
 3 files changed, 33 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 158e6eb..44be28cfc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1267,6 +1267,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 				  __le16 fc, bool acked);
+void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 13bb814..b6d03da 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3623,6 +3623,31 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+#ifdef CONFIG_PM
+void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	mutex_lock(&ifmgd->mtx);
+	if (!ifmgd->associated) {
+		mutex_unlock(&ifmgd->mtx);
+		return;
+	}
+
+	if (sdata->flags & IEEE80211_SDATA_DISCONNECT_RESUME) {
+		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_RESUME;
+		mlme_dbg(sdata, "driver requested disconnect after resume\n");
+		ieee80211_sta_connection_lost(sdata,
+					      ifmgd->associated->bssid,
+					      WLAN_REASON_UNSPECIFIED,
+					      true);
+		mutex_unlock(&ifmgd->mtx);
+		return;
+	}
+	mutex_unlock(&sdata->local->mtx);
+}
+#endif
+
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3f87fa4..27e0715 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1740,6 +1740,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			ieee80211_sta_restart(sdata);
+	}
+
 	mod_timer(&local->sta_cleanup, jiffies + 1);
 #else
 	WARN_ON(1);
-- 
1.8.0

