Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbZGATkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:40:46 -0400
Subject: [PATCH 21/20 v4] mac80211: remove auth algorithm retry
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090701192641.072258140@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 21:40:45 +0200
Message-Id: <1246477245.8154.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The automatic auth algorithm issue is now solved in
cfg80211, so mac80211 no longer needs code to try
different algorithms -- just using whatever cfg80211
asked for is good.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c            |    8 +++----
 net/mac80211/debugfs_netdev.c |    3 --
 net/mac80211/ieee80211_i.h    |    8 -------
 net/mac80211/mlme.c           |   47 ------------------------------------------
 4 files changed, 4 insertions(+), 62 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-01 13:27:46.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-01 20:29:51.000000000 +0200
@@ -251,12 +251,6 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_REQ_AUTH 1
 #define IEEE80211_STA_REQ_RUN  2
 
-/* bitfield of allowed auth algs */
-#define IEEE80211_AUTH_ALG_OPEN BIT(0)
-#define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
-#define IEEE80211_AUTH_ALG_LEAP BIT(2)
-#define IEEE80211_AUTH_ALG_FT BIT(3)
-
 struct ieee80211_if_managed {
 	struct timer_list timer;
 	struct timer_list chswitch_timer;
@@ -303,7 +297,6 @@ struct ieee80211_if_managed {
 
 	unsigned int flags;
 
-	unsigned int auth_algs; /* bitfield of allowed auth algs */
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
 
@@ -488,7 +481,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *extra_ie_len;
 			struct dentry *auth_tries;
 			struct dentry *assoc_tries;
-			struct dentry *auth_algs;
 			struct dentry *auth_alg;
 			struct dentry *auth_transaction;
 			struct dentry *flags;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-01 20:29:35.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-01 20:29:51.000000000 +0200
@@ -1414,39 +1414,6 @@ static void ieee80211_rx_mgmt_auth(struc
 		return;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
-		if (status_code == WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) {
-			u8 algs[3];
-			const int num_algs = ARRAY_SIZE(algs);
-			int i, pos;
-			algs[0] = algs[1] = algs[2] = 0xff;
-			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_OPEN)
-				algs[0] = WLAN_AUTH_OPEN;
-			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
-				algs[1] = WLAN_AUTH_SHARED_KEY;
-			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_LEAP)
-				algs[2] = WLAN_AUTH_LEAP;
-			if (ifmgd->auth_alg == WLAN_AUTH_OPEN)
-				pos = 0;
-			else if (ifmgd->auth_alg == WLAN_AUTH_SHARED_KEY)
-				pos = 1;
-			else
-				pos = 2;
-			for (i = 0; i < num_algs; i++) {
-				pos++;
-				if (pos >= num_algs)
-					pos = 0;
-				if (algs[pos] == ifmgd->auth_alg ||
-				    algs[pos] == 0xff)
-					continue;
-				if (algs[pos] == WLAN_AUTH_SHARED_KEY &&
-				    !ieee80211_sta_wep_configured(sdata))
-					continue;
-				ifmgd->auth_alg = algs[pos];
-				ifmgd->auth_tries = 0;
-				return;
-			}
-		}
-		/* nothing else to try -- give up */
 		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len,
 				      GFP_KERNEL);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
@@ -2102,18 +2069,6 @@ static void ieee80211_sta_reset_auth(str
 	drv_reset_tsf(local);
 
 	ifmgd->wmm_last_param_set = -1; /* allow any WMM update */
-
-
-	if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_OPEN)
-		ifmgd->auth_alg = WLAN_AUTH_OPEN;
-	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
-		ifmgd->auth_alg = WLAN_AUTH_SHARED_KEY;
-	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_LEAP)
-		ifmgd->auth_alg = WLAN_AUTH_LEAP;
-	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_FT)
-		ifmgd->auth_alg = WLAN_AUTH_FT;
-	else
-		ifmgd->auth_alg = WLAN_AUTH_OPEN;
 	ifmgd->auth_transaction = -1;
 	ifmgd->flags &= ~IEEE80211_STA_ASSOCIATED;
 	ifmgd->assoc_scan_tries = 0;
@@ -2351,8 +2306,6 @@ void ieee80211_sta_setup_sdata(struct ie
 	skb_queue_head_init(&ifmgd->skb_queue);
 
 	ifmgd->capab = WLAN_CAPABILITY_ESS;
-	ifmgd->auth_algs = IEEE80211_AUTH_ALG_OPEN |
-		IEEE80211_AUTH_ALG_SHARED_KEY;
 	ifmgd->flags |= IEEE80211_STA_CREATE_IBSS |
 		IEEE80211_STA_AUTO_BSSID_SEL |
 		IEEE80211_STA_AUTO_CHANNEL_SEL;
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 20:29:47.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 20:29:51.000000000 +0200
@@ -1178,16 +1178,16 @@ static int ieee80211_auth(struct wiphy *
 
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
-		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_OPEN;
+		sdata->u.mgd.auth_alg = WLAN_AUTH_OPEN;
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_SHARED_KEY;
+		sdata->u.mgd.auth_alg = WLAN_AUTH_SHARED_KEY;
 		break;
 	case NL80211_AUTHTYPE_FT:
-		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_FT;
+		sdata->u.mgd.auth_alg = WLAN_AUTH_FT;
 		break;
 	case NL80211_AUTHTYPE_NETWORK_EAP:
-		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_LEAP;
+		sdata->u.mgd.auth_alg = WLAN_AUTH_LEAP;
 		break;
 	default:
 		return -EOPNOTSUPP;
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-07-01 13:27:46.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-07-01 20:29:52.000000000 +0200
@@ -105,7 +105,6 @@ IEEE80211_IF_FILE(capab, u.mgd.capab, HE
 IEEE80211_IF_FILE(extra_ie_len, u.mgd.extra_ie_len, SIZE);
 IEEE80211_IF_FILE(auth_tries, u.mgd.auth_tries, DEC);
 IEEE80211_IF_FILE(assoc_tries, u.mgd.assoc_tries, DEC);
-IEEE80211_IF_FILE(auth_algs, u.mgd.auth_algs, HEX);
 IEEE80211_IF_FILE(auth_alg, u.mgd.auth_alg, DEC);
 IEEE80211_IF_FILE(auth_transaction, u.mgd.auth_transaction, DEC);
 
@@ -194,7 +193,6 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(extra_ie_len, sta);
 	DEBUGFS_ADD(auth_tries, sta);
 	DEBUGFS_ADD(assoc_tries, sta);
-	DEBUGFS_ADD(auth_algs, sta);
 	DEBUGFS_ADD(auth_alg, sta);
 	DEBUGFS_ADD(auth_transaction, sta);
 	DEBUGFS_ADD(flags, sta);
@@ -327,7 +325,6 @@ static void del_sta_files(struct ieee802
 	DEBUGFS_DEL(extra_ie_len, sta);
 	DEBUGFS_DEL(auth_tries, sta);
 	DEBUGFS_DEL(assoc_tries, sta);
-	DEBUGFS_DEL(auth_algs, sta);
 	DEBUGFS_DEL(auth_alg, sta);
 	DEBUGFS_DEL(auth_transaction, sta);
 	DEBUGFS_DEL(flags, sta);


