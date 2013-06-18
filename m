Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:54999 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3FRMWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:22:47 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv2] Revert "mac80211: in IBSS use the Auth frame to trigger STA reinsertion"
Date: Tue, 18 Jun 2013 14:20:40 +0200
Message-Id: <1371558040-2821-1-git-send-email-ordex@autistici.org> (sfid-20130618_142255_621646_2C907C0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

This reverts commit 6d810f10325522cfcf498dc6d64b9f96e1f5153f

In this way an IBSS station will not use the AUTH messages
to trigger a state reinitialisation anymore.

The behaviour was racy and was not working properly.
It has been introduced to help wpa_supplicant to support
IBSS/RSN, however all the logic is now getting moved into
wpa_s itself which will also be in charge of handling the
AUTH messages thanks to the mgmt frame registration.

If userspace does not register for receiving AUTH frames
then mac80211 will still reply by itself.

At the same time, the auth frame registration counter can be
removed since it is not needed anymore.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

v2:
- remove auth_frame_registrations member in ieee80211_if_ibss

Cheers,

 net/mac80211/cfg.c         | 10 ----------
 net/mac80211/ibss.c        | 41 +++++++----------------------------------
 net/mac80211/ieee80211_i.h |  1 -
 3 files changed, 7 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 64cf294..98c323d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2927,16 +2927,6 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 	switch (frame_type) {
-	case IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH:
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-			struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-			if (reg)
-				ifibss->auth_frame_registrations++;
-			else
-				ifibss->auth_frame_registrations--;
-		}
-		break;
 	case IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ:
 		if (reg)
 			local->probe_req_reg++;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index caa4b4f..6c9d21a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -298,8 +298,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  tsf, false);
 }
 
-static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
-						  bool auth)
+static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 	__acquires(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -321,20 +320,12 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
-	if (auth && !sdata->u.ibss.auth_frame_registrations) {
-		ibss_dbg(sdata,
-			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
-			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
-		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, 0, NULL, 0,
-				    addr, sdata->u.ibss.bssid, NULL, 0, 0, 0);
-	}
 	return sta;
 }
 
 static struct sta_info *
-ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-		       const u8 *bssid, const u8 *addr,
-		       u32 supp_rates, bool auth)
+ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
+		       const u8 *addr, u32 supp_rates)
 	__acquires(RCU)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
@@ -385,7 +376,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(sband);
 
-	return ieee80211_ibss_finish_sta(sta, auth);
+	return ieee80211_ibss_finish_sta(sta);
 }
 
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
@@ -407,8 +398,6 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					size_t len)
 {
 	u16 auth_alg, auth_transaction;
-	struct sta_info *sta;
-	u8 deauth_frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	sdata_assert_lock(sdata);
 
@@ -425,22 +414,6 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 		return;
 
-	sta_info_destroy_addr(sdata, mgmt->sa);
-	sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
-	rcu_read_unlock();
-
-	/*
-	 * if we have any problem in allocating the new station, we reply with a
-	 * DEAUTH frame to tell the other end that we had a problem
-	 */
-	if (!sta) {
-		ieee80211_send_deauth_disassoc(sdata, sdata->u.ibss.bssid,
-					       IEEE80211_STYPE_DEAUTH,
-					       WLAN_REASON_UNSPECIFIED, true,
-					       deauth_frame_buf);
-		return;
-	}
-
 	/*
 	 * IEEE 802.11 standard does not require authentication in IBSS
 	 * networks and most implementations do not seem to use it.
@@ -506,7 +479,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else {
 				rcu_read_unlock();
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates, true);
+						mgmt->sa, supp_rates);
 			}
 		}
 
@@ -610,7 +583,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band, NULL);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, true);
+				       supp_rates);
 		rcu_read_unlock();
 	}
 
@@ -982,7 +955,7 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 		list_del(&sta->list);
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
-		ieee80211_ibss_finish_sta(sta, true);
+		ieee80211_ibss_finish_sta(sta);
 		rcu_read_unlock();
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a6f1a0..1d1aac6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -497,7 +497,6 @@ struct ieee80211_if_ibss {
 	bool privacy;
 
 	bool control_port;
-	unsigned int auth_frame_registrations;
 
 	u8 bssid[ETH_ALEN] __aligned(2);
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-- 
1.8.1.5

