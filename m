Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53558 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZCNRPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:15:00 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v2 2/4] mac80211: track beacons separately from the rx
	path activity
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 14 Mar 2009 19:14:38 +0200
Message-ID: <20090314171438.11126.30330.stgit@tikku> (sfid-20090314_181501_622295_8F8FABBD)
In-Reply-To: <20090314171234.11126.21125.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separate beacon and rx path tracking in preparation for the beacon filtering
support. At the same time change ieee80211_associated() to look a bit simpler.

Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
is now set to 60 seconds.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   79 ++++++++++++++++++++++++++------------------
 net/mac80211/rx.c          |    6 +++
 3 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 74c4e13..5d3d0bf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -305,6 +305,7 @@ struct ieee80211_if_managed {
 	unsigned long request;
 
 	unsigned long last_probe;
+	unsigned long last_beacon;
 
 	unsigned int flags;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 397a2e7..c235d39 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -30,7 +30,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
-#define IEEE80211_PROBE_INTERVAL (60 * HZ)
+#define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 
 /* utils */
@@ -925,7 +925,7 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int disassoc;
+	bool disassoc = false;
 
 	/* TODO: start monitoring current AP signal quality and number of
 	 * missed beacons. Scan other channels every now and then and search
@@ -940,36 +940,39 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 	if (!sta) {
 		printk(KERN_DEBUG "%s: No STA entry for own AP %pM\n",
 		       sdata->dev->name, ifmgd->bssid);
-		disassoc = 1;
-	} else {
-		disassoc = 0;
-		if (time_after(jiffies,
-			       sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {
-			if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
-				printk(KERN_DEBUG "%s: No ProbeResp from "
-				       "current AP %pM - assume out of "
-				       "range\n",
-				       sdata->dev->name, ifmgd->bssid);
-				disassoc = 1;
-			} else
-				ieee80211_send_probe_req(sdata, ifmgd->bssid,
-							 ifmgd->ssid,
-							 ifmgd->ssid_len,
-							 NULL, 0);
-			ifmgd->flags ^= IEEE80211_STA_PROBEREQ_POLL;
-		} else {
-			ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
-			if (time_after(jiffies, ifmgd->last_probe +
-				       IEEE80211_PROBE_INTERVAL)) {
-				ifmgd->last_probe = jiffies;
-				ieee80211_send_probe_req(sdata, ifmgd->bssid,
-							 ifmgd->ssid,
-							 ifmgd->ssid_len,
-							 NULL, 0);
-			}
-		}
+		disassoc = true;
+		goto unlock;
+	}
+
+	if ((ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) &&
+	    time_after(jiffies, sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {
+		printk(KERN_DEBUG "%s: no probe response from AP %pM "
+		       "- disassociating\n",
+		       sdata->dev->name, ifmgd->bssid);
+		disassoc = true;
+		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+		goto unlock;
+	}
+
+	if (time_after(jiffies,
+		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
+		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
+		       "- sending probe request\n",
+		       sdata->dev->name, ifmgd->bssid);
+		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
+					 ifmgd->ssid_len, NULL, 0);
+		goto unlock;
+
+	}
+
+	if (time_after(jiffies, sta->last_rx + IEEE80211_PROBE_IDLE_TIME)) {
+		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
+					 ifmgd->ssid_len, NULL, 0);
 	}
 
+ unlock:
 	rcu_read_unlock();
 
 	if (disassoc)
@@ -977,7 +980,7 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
 	else
 		mod_timer(&ifmgd->timer, jiffies +
-				      IEEE80211_MONITORING_INTERVAL);
+			  IEEE80211_MONITORING_INTERVAL);
 }
 
 
@@ -1358,6 +1361,12 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	bss_conf->assoc_capability = capab_info;
 	ieee80211_set_associated(sdata, changed);
 
+	/*
+	 * initialise the time of last beacon to be the association time,
+	 * otherwise beacon loss check will trigger immediately
+	 */
+	ifmgd->last_beacon = jiffies;
+
 	ieee80211_associated(sdata);
 }
 
@@ -1405,9 +1414,12 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 					 size_t len,
 					 struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_if_managed *ifmgd;
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
+	ifmgd = &sdata->u.mgd;
+
 	if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
 
@@ -1422,11 +1434,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 
 	/* direct probe may be part of the association flow */
 	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
-	    &sdata->u.mgd.request)) {
+			       &ifmgd->request)) {
 		printk(KERN_DEBUG "%s direct probe responded\n",
 		       sdata->dev->name);
 		ieee80211_authenticate(sdata);
 	}
+
+	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL)
+		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
 }
 
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 25982c0..4990e76 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -849,7 +849,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		 * Mesh beacons will update last_rx when if they are found to
 		 * match the current local configuration when processed.
 		 */
-		sta->last_rx = jiffies;
+		if (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    ieee80211_is_beacon(hdr->frame_control)) {
+			rx->sdata->u.mgd.last_beacon = jiffies;
+		} else
+			sta->last_rx = jiffies;
 	}
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))

