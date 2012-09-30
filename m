Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47113 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215Ab2I3Qa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:30:57 -0400
Message-Id: <20120930163050.031259011@w1.fi> (sfid-20120930_183129_569108_79A6DA1D)
Date: Sun, 30 Sep 2012 19:29:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 4/4] mac80211: Allow station mode SAE to be implemented in user space
References: <20120930162936.046757966@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SAE uses two rounds of Authentication frames and both rounds require
considerable calculation to be done. This commit extends the existing
station mode authentication request to allow more control for user
space programs to build the SAE fields and to run the authentication
step ones. Only the second round with authentication transaction
sequence 2 will result in moving to authenticated state.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/ieee80211_i.h |    5 +++--
 net/mac80211/main.c        |    1 +
 net/mac80211/mlme.c        |   43 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 42 insertions(+), 7 deletions(-)

Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2012-09-30 19:16:52.591842581 +0300
+++ wireless-testing/net/mac80211/ieee80211_i.h	2012-09-30 19:16:59.375842452 +0300
@@ -378,8 +378,9 @@ struct ieee80211_mgd_auth_data {
 	u8 key_len, key_idx;
 	bool done;
 
-	size_t ie_len;
-	u8 ie[];
+	u16 sae_trans, sae_status;
+	size_t data_len;
+	u8 data[];
 };
 
 struct ieee80211_mgd_assoc_data {
Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c	2012-09-30 19:16:51.227842607 +0300
+++ wireless-testing/net/mac80211/main.c	2012-09-30 19:16:59.375842452 +0300
@@ -585,6 +585,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
+			  NL80211_FEATURE_SAE |
 			  NL80211_FEATURE_HT_IBSS;
 
 	if (!ops->set_key)
Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c	2012-09-30 19:16:55.831842519 +0300
+++ wireless-testing/net/mac80211/mlme.c	2012-09-30 19:16:59.375842452 +0300
@@ -1877,6 +1877,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
 	case WLAN_AUTH_FT:
+	case WLAN_AUTH_SAE:
 		break;
 	case WLAN_AUTH_SHARED_KEY:
 		if (ifmgd->auth_data->expected_transaction != 4) {
@@ -1896,6 +1897,15 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	run_again(ifmgd, ifmgd->auth_data->timeout);
 
+	if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
+	    ifmgd->auth_data->expected_transaction != 2) {
+		/*
+		 * Report auth frame to user space for processing since another
+		 * round of Authentication frames is still needed.
+		 */
+		return RX_MGMT_CFG80211_RX_AUTH;
+	}
+
 	/* move station state to auth */
 	mutex_lock(&sdata->local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
@@ -2708,13 +2718,23 @@ static int ieee80211_probe_auth(struct i
 	drv_mgd_prepare_tx(local, sdata);
 
 	if (auth_data->bss->proberesp_ies) {
+		u16 trans = 1;
+		u16 status = 0;
+
 		sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
 			   auth_data->bss->bssid, auth_data->tries,
 			   IEEE80211_AUTH_MAX_TRIES);
 
 		auth_data->expected_transaction = 2;
-		ieee80211_send_auth(sdata, 1, auth_data->algorithm, 0,
-				    auth_data->ie, auth_data->ie_len,
+
+		if (auth_data->algorithm == WLAN_AUTH_SAE) {
+			trans = auth_data->sae_trans;
+			status = auth_data->sae_status;
+			auth_data->expected_transaction = trans;
+		}
+
+		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
+				    auth_data->data, auth_data->data_len,
 				    auth_data->bss->bssid,
 				    auth_data->bss->bssid, NULL, 0, 0);
 	} else {
@@ -3268,19 +3288,32 @@ int ieee80211_mgd_auth(struct ieee80211_
 	case NL80211_AUTHTYPE_NETWORK_EAP:
 		auth_alg = WLAN_AUTH_LEAP;
 		break;
+	case NL80211_AUTHTYPE_SAE:
+		auth_alg = WLAN_AUTH_SAE;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	auth_data = kzalloc(sizeof(*auth_data) + req->ie_len, GFP_KERNEL);
+	auth_data = kzalloc(sizeof(*auth_data) + req->sae_data_len +
+			    req->ie_len, GFP_KERNEL);
 	if (!auth_data)
 		return -ENOMEM;
 
 	auth_data->bss = req->bss;
 
+	if (req->sae_data_len >= 4) {
+		__le16 *pos = (__le16 *) req->sae_data;
+		auth_data->sae_trans = le16_to_cpu(pos[0]);
+		auth_data->sae_status = le16_to_cpu(pos[1]);
+		memcpy(auth_data->data, req->sae_data + 4,
+		       req->sae_data_len - 4);
+		auth_data->data_len += req->sae_data_len - 4;
+	}
 	if (req->ie && req->ie_len) {
-		memcpy(auth_data->ie, req->ie, req->ie_len);
-		auth_data->ie_len = req->ie_len;
+		memcpy(&auth_data->data[auth_data->data_len],
+		       req->ie, req->ie_len);
+		auth_data->data_len += req->ie_len;
 	}
 
 	if (req->key && req->key_len) {

