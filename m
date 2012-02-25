Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2BYUsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:48:10 -0500
Subject: [PATCH 1/2 v2] mac80211: fix auth/assoc data & timer leak
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120225204145.794866318@sipsolutions.net> (sfid-20120225_214404_329985_A211B0C9)
References: <20120225204044.168176239@sipsolutions.net>
	 <20120225204145.794866318@sipsolutions.net>
	 (sfid-20120225_214404_329985_A211B0C9)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Feb 2012 21:48:08 +0100
Message-ID: <1330202888.3509.1.camel@jlt3.sipsolutions.net> (sfid-20120225_214814_687112_03D66CA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When removing an interface while it is in the
process of authenticating or associating, we
leak the auth_data or assoc_data, and leave
the timer pending. The timer then crashes the
system when it fires as its data is gone.

Fix this by explicitly deleting all the data
when the interface is removed. This uncovered
another bug -- this problem should have been
detected by the sta_info_flush() warning but
that function doesn't ever return non-zero,
I'll fix that in a separate patch.

Reported-by: Hieu Nguyen <hieux.c.nguyen@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: also delete timer

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index feddd8a..38bfca3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1181,6 +1181,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
 void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mgd_teardown(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a495587..e2e45dc 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -654,6 +654,8 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_rmc_free(sdata);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		ieee80211_mgd_teardown(sdata);
 
 	flushed = sta_info_flush(local, sdata);
 	WARN_ON(flushed);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2d8a2b6..be35827 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3532,6 +3532,19 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+void ieee80211_mgd_teardown(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	mutex_lock(&ifmgd->mtx);
+	if (ifmgd->assoc_data)
+		ieee80211_destroy_assoc_data(sdata, false);
+	if (ifmgd->auth_data)
+		ieee80211_destroy_auth_data(sdata, false);
+	del_timer_sync(&ifmgd->timer);
+	mutex_unlock(&ifmgd->mtx);
+}
+
 void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       gfp_t gfp)


