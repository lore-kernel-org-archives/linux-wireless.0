Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:56676 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab2ALUjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 15:39:02 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 2/2] mac80211: in IBSS use the Auth frame to trigger STA reinsertion
Date: Thu, 12 Jan 2012 21:36:56 +0100
Message-Id: <1326400616-1109-2-git-send-email-ordex@autistici.org> (sfid-20120112_213918_623589_679D1247)
In-Reply-To: <1326400616-1109-1-git-send-email-ordex@autistici.org>
References: <1326400616-1109-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of re-authentication of a node, in IBSS mode, the sta_info structure
corresponding to it is first destroyed and then reinserted. In this way its
internal state is reset.

This operation is helpful in case of a node being rebooted which is joining the
ad-hoc cell again before its purge timeout on the other nodes expires.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/ibss.c |   94 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a7564e3..d80de75 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -35,32 +35,6 @@
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
-
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
@@ -275,7 +249,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  cbss->tsf);
 }
 
-static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
+static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
+						  bool auth)
 	__acquires(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -289,13 +264,15 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
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
@@ -312,7 +289,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 static struct sta_info *
 ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 		       const u8 *bssid, const u8 *addr,
-		       u32 supp_rates)
+		       u32 supp_rates, bool auth)
 	__acquires(RCU)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -354,7 +331,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	return ieee80211_ibss_finish_sta(sta);
+	return ieee80211_ibss_finish_sta(sta, auth);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -419,7 +396,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else {
 				rcu_read_unlock();
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates);
+						mgmt->sa, supp_rates, true);
 			}
 		}
 
@@ -547,7 +524,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates);
+				       supp_rates, true);
 		rcu_read_unlock();
 	}
 
@@ -784,6 +761,49 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_mgmt *mgmt,
+					size_t len)
+{
+	u16 auth_alg, auth_transaction;
+	size_t baselen;
+
+	lockdep_assert_held(&sdata->u.ibss.mtx);
+
+	if (len < 24 + 6)
+		return;
+
+	baselen = (u8 *) mgmt->u.auth.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
+	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
+
+	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "%s: RX Auth SA=%pM DA=%pM BSSID=%pM."
+		       "(auth_transaction=%d)\n",
+		       sdata->name, mgmt->sa, mgmt->da, mgmt->bssid,
+		       auth_transaction);
+#endif
+		if (sta_info_destroy_addr(sdata, mgmt->sa) != -ENOENT) {
+			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0,
+					       false);
+			rcu_read_unlock();
+		}
+
+		/*
+		 * IEEE 802.11 standard does not require authentication in IBSS
+		 * networks and most implementations do not seem to use it.
+		 * However, try to reply to authentication attempts if someone
+		 * has actually implemented this.
+		 */
+		ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0,
+				    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0);
+	}
+}
+
 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 					struct sk_buff *req)
 {
@@ -952,7 +972,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta);
+		ieee80211_ibss_finish_sta(sta, true);
 		rcu_read_unlock();
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
-- 
1.7.3.4

