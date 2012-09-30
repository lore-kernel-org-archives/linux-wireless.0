Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47107 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2I3Qap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:30:45 -0400
Message-Id: <20120930163038.460058465@w1.fi> (sfid-20120930_183127_293779_8168D587)
Date: Sun, 30 Sep 2012 19:29:37 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 1/4] mac80211: Take status code as parameter to ieee80211_send_auth
References: <20120930162936.046757966@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Non-zero status code may be needed for Authentication frames, e.g.,
when using SAE.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/ibss.c        |    4 ++--
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |    4 ++--
 net/mac80211/util.c        |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

Index: wireless-testing/net/mac80211/ibss.c
===================================================================
--- wireless-testing.orig/net/mac80211/ibss.c	2012-09-30 19:16:51.487842602 +0300
+++ wireless-testing/net/mac80211/ibss.c	2012-09-30 19:16:52.587842581 +0300
@@ -279,7 +279,7 @@ static struct sta_info *ieee80211_ibss_f
 		ibss_dbg(sdata,
 			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
-		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
+		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, 0, NULL, 0,
 				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
 	}
 	return sta;
@@ -389,7 +389,7 @@ static void ieee80211_rx_mgmt_auth_ibss(
 	 * However, try to reply to authentication attempts if someone
 	 * has actually implemented this.
 	 */
-	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0,
+	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, 0, NULL, 0,
 			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0);
 }
 
Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2012-09-30 19:16:51.467842603 +0300
+++ wireless-testing/net/mac80211/ieee80211_i.h	2012-09-30 19:16:52.591842581 +0300
@@ -1444,7 +1444,7 @@ static inline void ieee80211_add_pending
 }
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
-			 u16 transaction, u16 auth_alg,
+			 u16 transaction, u16 auth_alg, u16 status,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx);
 void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c	2012-09-30 19:16:51.499842602 +0300
+++ wireless-testing/net/mac80211/mlme.c	2012-09-30 19:16:52.591842581 +0300
@@ -1824,7 +1824,7 @@ static void ieee80211_auth_challenge(str
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata);
-	ieee80211_send_auth(sdata, 3, auth_data->algorithm,
+	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
 			    elems.challenge - 2, elems.challenge_len + 2,
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
@@ -2708,7 +2708,7 @@ static int ieee80211_probe_auth(struct i
 			   IEEE80211_AUTH_MAX_TRIES);
 
 		auth_data->expected_transaction = 2;
-		ieee80211_send_auth(sdata, 1, auth_data->algorithm,
+		ieee80211_send_auth(sdata, 1, auth_data->algorithm, 0,
 				    auth_data->ie, auth_data->ie_len,
 				    auth_data->bss->bssid,
 				    auth_data->bss->bssid, NULL, 0, 0);
Index: wireless-testing/net/mac80211/util.c
===================================================================
--- wireless-testing.orig/net/mac80211/util.c	2012-09-30 19:16:51.479842602 +0300
+++ wireless-testing/net/mac80211/util.c	2012-09-30 19:16:52.591842581 +0300
@@ -968,7 +968,7 @@ u32 ieee80211_mandatory_rates(struct iee
 }
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
-			 u16 transaction, u16 auth_alg,
+			 u16 transaction, u16 auth_alg, u16 status,
 			 u8 *extra, size_t extra_len, const u8 *da,
 			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx)
 {
@@ -993,7 +993,7 @@ void ieee80211_send_auth(struct ieee8021
 	memcpy(mgmt->bssid, bssid, ETH_ALEN);
 	mgmt->u.auth.auth_alg = cpu_to_le16(auth_alg);
 	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
-	mgmt->u.auth.status_code = cpu_to_le16(0);
+	mgmt->u.auth.status_code = cpu_to_le16(status);
 	if (extra)
 		memcpy(skb_put(skb, extra_len), extra, extra_len);
 

