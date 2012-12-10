Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:58741 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751284Ab2LJNlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 08:41:25 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Date: Mon, 10 Dec 2012 14:40:24 +0100
Message-ID: <1355146824-25012-2-git-send-email-antonio@open-mesh.com> (sfid-20121210_144129_050221_D4355BC1)
In-Reply-To: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prevent race conditions between kernel state and
user-space application knowledge, it is better to wait for
a new peer to be completely authenticated before telling the
userspace that it is ready to start authorization
(IBSS/RSN).

Use the IBSS_STA event to tell userspace when a station is
authenticated and ready.

It could still be the case that the other node joining the
AD-HOC cell does not implement AUTH messages exchange,
therefore a fallback mechanism will authenticate the peer
after a timeout set for the purpose expires

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c     | 103 +++++++++++++++++++++++++++++++++++++++---------
 net/mac80211/sta_info.h |   2 +
 2 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 700d0ed..91956e3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -30,6 +30,7 @@
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
+#define IEEE80211_IBSS_AUTH_TIMEOUT (HZ / 2)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
@@ -273,8 +274,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  false);
 }
 
-static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
-						  bool auth)
+static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 	__acquires(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -284,32 +284,33 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 
 	ibss_dbg(sdata, "Adding new IBSS station %pM\n", addr);
 
-	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
-	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
-	/* authorize the station only if the network is not RSN protected. If
-	 * not wait for the userspace to authorize it */
-	if (!sta->sdata->u.ibss.control_port)
-		sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
-
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
-	if (auth && !sdata->u.ibss.auth_frame_registrations) {
+	if (!sdata->u.ibss.auth_frame_registrations) {
 		ibss_dbg(sdata,
 			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, 0, NULL, 0,
 				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+		/* store when the AUTH request has been sent so that this
+		 * station can eventually be authorise with the fall back
+		 * mechanism
+		 */
+		sta->last_auth = jiffies;
+	} else {
+		ieee80211_ibss_auth_sta(sta);
 	}
+
 	return sta;
 }
 
 static struct sta_info *
 ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 		       const u8 *bssid, const u8 *addr,
-		       u32 supp_rates, bool auth)
+		       u32 supp_rates)
 	__acquires(RCU)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -358,7 +359,23 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	return ieee80211_ibss_finish_sta(sta, auth);
+	return ieee80211_ibss_finish_sta(sta);
+}
+
+static void ieee80211_ibss_auth_sta(struct sta_info *sta)
+{
+	if (sta->sta_state > IEEE80211_STA_NONE)
+		return;
+
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	/* authorize the station only if the network is not RSN protected. If
+	 * not wait for the userspace to authorize it
+	 */
+	if (!sta->sdata->u.ibss.control_port)
+		sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+
+	cfg80211_ibss_sta(sta->sdata->dev, sta->sta.addr, GFP_KERNEL);
 }
 
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
@@ -395,13 +412,36 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 		 "RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
 		 mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
 
-	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
+	if (auth_alg != WLAN_AUTH_OPEN)
 		return;
 
-	sta_info_destroy_addr(sdata, mgmt->sa);
-	sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
+	rcu_read_lock();
+	sta = sta_info_get(sdata, mgmt->sa);
 	rcu_read_unlock();
 
+	if (auth_transaction == 2) {
+		ibss_dbg(sdata, "Authenticating STA %pM\n", sta->sta.addr);
+		ieee80211_ibss_auth_sta(sta);
+		return;
+	}
+
+	/* drop bogus auth frames (auth_transaction can be only 1 or 2) */
+	if (auth_transaction != 1)
+		return;
+
+	if (sta && sdata->u.ibss.control_port &&
+	    sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+		ibss_dbg(sdata, "Resetting STA %pM state for IBSS Encryption\n",
+			 sta->sta.addr);
+		sta_info_destroy_addr(sdata, mgmt->sa);
+		sta = NULL;
+	}
+
+	if (!sta) {
+		sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0);
+		rcu_read_unlock();
+	}
+
 	/*
 	 * if we have any problem in allocating the new station, we reply with a
 	 * DEAUTH frame to tell the other end that we had a problem
@@ -420,6 +460,8 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	 * However, try to reply to authentication attempts if someone
 	 * has actually implemented this.
 	 */
+	ibss_dbg(sdata, "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=2)\n",
+		 sdata->vif.addr, mgmt->sa, sdata->u.ibss.bssid);
 	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, 0, NULL, 0,
 			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0);
 }
@@ -481,7 +523,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else {
 				rcu_read_unlock();
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates, true);
+						mgmt->sa, supp_rates);
 			}
 		}
 
@@ -592,7 +634,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band, NULL);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, true);
+				       supp_rates);
 		rcu_read_unlock();
 	}
 
@@ -675,6 +717,29 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	return active;
 }
 
+static void ieee80211_ibss_auth_expire(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+
+		if (sta->sta_state > IEEE80211_STA_NONE)
+			continue;
+
+		if (time_after(jiffies,
+			       sta->last_auth + IEEE80211_IBSS_AUTH_TIMEOUT)) {
+			ibss_dbg(sdata,
+				 "Authenticating IBSS STA %pM by timeout\n",
+				 sta->sta.addr);
+			ieee80211_ibss_auth_sta(sta);
+		}
+	}
+}
+
+
 /*
  * This function is called with state == IEEE80211_IBSS_MLME_JOINED
  */
@@ -688,6 +753,8 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
+	ieee80211_ibss_auth_expire(sdata);
+
 	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
 
 	if (time_before(jiffies, ifibss->last_scan_completed +
@@ -976,7 +1043,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta, true);
+		ieee80211_ibss_finish_sta(sta);
 		rcu_read_unlock();
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1489bca..3c150a4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -244,6 +244,7 @@ struct sta_ampdu_mlme {
  * @rx_bytes: Number of bytes received from this STA
  * @wep_weak_iv_count: number of weak WEP IVs received from this station
  * @last_rx: time (in jiffies) when last frame was received from this STA
+ * @last_auth: jiffies of last auth packet with seq = 1
  * @last_connected: time (in seconds) when a station got connected
  * @num_duplicates: number of duplicate frames received from this STA
  * @rx_fragments: number of received MPDUs
@@ -324,6 +325,7 @@ struct sta_info {
 	unsigned long rx_packets, rx_bytes;
 	unsigned long wep_weak_iv_count;
 	unsigned long last_rx;
+	unsigned long last_auth;
 	long last_connected;
 	unsigned long num_duplicates;
 	unsigned long rx_fragments;
-- 
1.8.0

