Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:63113 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2APSN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 13:13:58 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: " \"John W. Linville\"" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv3 2/2] mac80211: in IBSS use the Auth frame to trigger STA reinsertion
Date: Mon, 16 Jan 2012 19:12:06 +0100
Message-Id: <1326737526-29750-1-git-send-email-ordex@autistici.org> (sfid-20120116_191401_981142_914AF279)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of a node re-joining the cell the sta_info structure belonging to it is
first destroyed and then reinserted. In this way its internal state is reset.

The joining operation is recognised thank the Auth frame being received.

This operation is helpful in case of a node being rebooted that is joining the
ad-hoc cell again, before its purge timeout on other nodes expires.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

- moved ieee80211_rx_mgmt_auth_ibss() after ieee80211_ibss_add_sta() definition


 net/mac80211/ibss.c |   85 +++++++++++++++++++++++++++++---------------------
 1 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a7564e3..f6f5009 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -36,31 +36,6 @@
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
 
-static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_mgmt *mgmt,
-					size_t len)
-{
-	u16 auth_alg, auth_transaction;
-
-	lockdep_assert_held(&sdata->u.ibss.mtx);
-
-	if (len < 24 + 6)
-		return;
-
-	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
-	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
-
-	/*
-	 * IEEE 802.11 standard does not require authentication in IBSS
-	 * networks and most implementations do not seem to use it.
-	 * However, try to reply to authentication attempts if someone
-	 * has actually implemented this.
-	 */
-	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1)
-		ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0, mgmt->sa,
-				    sdata->u.ibss.bssid, NULL, 0, 0);
-}
-
 static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
@@ -275,7 +250,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  cbss->tsf);
 }
 
-static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
+static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
+						  bool auth)
 	__acquires(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -289,13 +265,15 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 		    addr, sdata->name);
 #endif
 
+	if (auth) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
-	       "(auth_transaction=1)\n", sdata->vif.addr,
-	       sdata->u.ibss.bssid, addr);
+		printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
+		       "(auth_transaction=1)\n", sdata->vif.addr,
+		       sdata->u.ibss.bssid, addr);
 #endif
-	ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
-			    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
+				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+	}
 
 	sta_info_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
@@ -312,7 +290,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 static struct sta_info *
 ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 		       const u8 *bssid, const u8 *addr,
-		       u32 supp_rates)
+		       u32 supp_rates, bool auth)
 	__acquires(RCU)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -354,7 +332,42 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	return ieee80211_ibss_finish_sta(sta);
+	return ieee80211_ibss_finish_sta(sta, auth);
+}
+
+static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_mgmt *mgmt,
+					size_t len)
+{
+	u16 auth_alg, auth_transaction;
+
+	lockdep_assert_held(&sdata->u.ibss.mtx);
+
+	if (len < 24 + 6)
+		return;
+
+	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
+	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
+
+	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
+		return;
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "%s: RX Auth SA=%pM DA=%pM BSSID=%pM."
+	       "(auth_transaction=%d)\n",
+	       sdata->name, mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
+#endif
+	sta_info_destroy_addr(sdata, mgmt->sa);
+	ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
+	rcu_read_unlock();
+
+	/*
+	 * IEEE 802.11 standard does not require authentication in IBSS
+	 * networks and most implementations do not seem to use it.
+	 * However, try to reply to authentication attempts if someone
+	 * has actually implemented this.
+	 */
+	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0,
+			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -419,7 +432,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else {
 				rcu_read_unlock();
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates);
+						mgmt->sa, supp_rates, true);
 			}
 		}
 
@@ -547,7 +560,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates);
+				       supp_rates, true);
 		rcu_read_unlock();
 	}
 
@@ -952,7 +965,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta);
+		ieee80211_ibss_finish_sta(sta, true);
 		rcu_read_unlock();
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
-- 
1.7.3.4

