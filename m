Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22181 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZCVT5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:57:37 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 2/5] mac80211: track beacons separately from the rx path
	activity
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:57:14 +0200
Message-ID: <20090322195714.26460.4434.stgit@tikku> (sfid-20090322_205738_875479_8364487A)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Separate beacon and rx path tracking in preparation for the beacon filtering
support. At the same time change ieee80211_associated() to look a bit simpler.

Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
is now set to 60 seconds.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   77 ++++++++++++++++++++++++++------------------
 net/mac80211/rx.c          |    6 +++
 3 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7b13ea..73226a9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -307,6 +307,7 @@ struct ieee80211_if_managed {
 	unsigned long request;
 
 	unsigned long last_probe;
+	unsigned long last_beacon;
 
 	unsigned int flags;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ce1ad7c..b3f784f 100644
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
@@ -931,7 +931,7 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int disassoc;
+	bool disassoc = false;
 
 	/* TODO: start monitoring current AP signal quality and number of
 	 * missed beacons. Scan other channels every now and then and search
@@ -946,36 +946,39 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
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
@@ -1375,6 +1378,12 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	bss_conf->assoc_capability = capab_info;
 	ieee80211_set_associated(sdata, changed);
 
+	/*
+	 * initialise the time of last beacon to be the association time,
+	 * otherwise beacon loss check will trigger immediately
+	 */
+	ifmgd->last_beacon = jiffies;
+
 	ieee80211_associated(sdata);
 	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
 }
@@ -1423,9 +1432,12 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
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
 
@@ -1440,11 +1452,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 
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
index 4298e86..fd264d9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -850,7 +850,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
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

