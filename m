Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbXEKCxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:53:11 -0400
Subject: [PATCH 09/19] libertas: Use standard values instead of  WLAN_802_11_AUTHENTICATION_MODE
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:56:42 -0400
Message-Id: <1178852202.8607.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WLAN_802_11_AUTHENTICATION_MODE enum and use IW_AUTH_ALG_* instead.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/assoc.c |    3 +-
 drivers/net/wireless/libertas/defs.h  |    7 ----
 drivers/net/wireless/libertas/dev.h   |    2 +-
 drivers/net/wireless/libertas/fw.c    |    2 +-
 drivers/net/wireless/libertas/join.c  |   31 +++++++++++++++----
 drivers/net/wireless/libertas/wext.c  |   52 ++++++++++----------------------
 6 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index dfffabc..7ebd836 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -300,8 +300,7 @@ static int should_deauth_infrastructure(wlan_adapter *adapter,
 	}
 
 	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		if (adapter->secinfo.authmode !=
-		    assoc_req->secinfo.authmode) {
+		if (adapter->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
 			lbs_pr_debug(1, "Deauthenticating due to updated security "
 				"info in configuration request.\n");
 			return 1;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index a6dee5e..9f54593 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -276,13 +276,6 @@ enum WLAN_802_11_NETWORK_INFRASTRUCTURE {
 	wlan802_11infrastructuremax
 };
 
-/** WLAN_802_11_AUTHENTICATION_MODE */
-enum WLAN_802_11_AUTHENTICATION_MODE {
-	wlan802_11authmodeopen = 0x00,
-	wlan802_11authmodeshared = 0x01,
-	wlan802_11authmodenetworkEAP = 0x80,
-};
-
 /** WLAN_802_11_WEP_STATUS */
 enum WLAN_802_11_WEP_STATUS {
 	wlan802_11WEPenabled,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 440b96d..eb490a6 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -58,7 +58,7 @@ struct wlan_802_11_security {
 	u8 WPAenabled;
 	u8 WPA2enabled;
 	enum WLAN_802_11_WEP_STATUS WEPstatus;
-	enum WLAN_802_11_AUTHENTICATION_MODE authmode;
+	u8 auth_mode;
 };
 
 /** Current Basic Service Set State Structure */
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index 6911113..f2d626d 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -200,7 +200,7 @@ static void wlan_init_adapter(wlan_private * priv)
 		memset(&adapter->wep_keys[i], 0, sizeof(struct WLAN_802_11_KEY));
 	adapter->wep_tx_keyidx = 0;
 	adapter->secinfo.WEPstatus = wlan802_11WEPdisabled;
-	adapter->secinfo.authmode = wlan802_11authmodeopen;
+	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	adapter->inframode = wlan802_11infrastructure;
 
 	adapter->assoc_req = NULL;
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 11682cb..a52bbc6 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -398,22 +398,39 @@ int libertas_cmd_80211_authenticate(wlan_private * priv,
 				 void *pdata_buf)
 {
 	wlan_adapter *adapter = priv->adapter;
-	struct cmd_ds_802_11_authenticate *pauthenticate =
-	    &cmd->params.auth;
+ 	struct cmd_ds_802_11_authenticate *pauthenticate = &cmd->params.auth;
+ 	int ret = -1;
 	u8 *bssid = pdata_buf;
 
 	cmd->command = cpu_to_le16(cmd_802_11_authenticate);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_authenticate)
-			     + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_authenticate)
+	                        + S_DS_GEN);
+
+	/* translate auth mode to 802.11 defined wire value */
+	switch (adapter->secinfo.auth_mode) {
+	case IW_AUTH_ALG_OPEN_SYSTEM:
+		pauthenticate->authtype = 0x00;
+		break;
+	case IW_AUTH_ALG_SHARED_KEY:
+		pauthenticate->authtype = 0x01;
+		break;
+	case IW_AUTH_ALG_LEAP:
+		pauthenticate->authtype = 0x80;
+		break;
+	default:
+		lbs_pr_debug(1, "AUTH_CMD: invalid auth alg 0x%X\n",
+		             adapter->secinfo.auth_mode);
+		goto out;
+	}
 
-	pauthenticate->authtype = adapter->secinfo.authmode;
 	memcpy(pauthenticate->macaddr, bssid, ETH_ALEN);
 
 	lbs_pr_debug(1, "AUTH_CMD: Bssid is : %x:%x:%x:%x:%x:%x\n",
 	       bssid[0], bssid[1], bssid[2], bssid[3], bssid[4], bssid[5]);
+	ret = 0;
 
-	return 0;
+out:
+	return ret;
 }
 
 int libertas_cmd_80211_deauthenticate(wlan_private * priv,
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index cfce23d..22eacd2 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1772,13 +1772,13 @@ static int wlan_get_encode(struct net_device *dev,
 	dwrq->flags = 0;
 
 	/* Authentication method */
-	switch (adapter->secinfo.authmode) {
-	case wlan802_11authmodeopen:
+	switch (adapter->secinfo.auth_mode) {
+	case IW_AUTH_ALG_OPEN_SYSTEM:
 		dwrq->flags = IW_ENCODE_OPEN;
 		break;
 
-	case wlan802_11authmodeshared:
-	case wlan802_11authmodenetworkEAP:
+	case IW_AUTH_ALG_SHARED_KEY:
+	case IW_AUTH_ALG_LEAP:
 		dwrq->flags = IW_ENCODE_RESTRICTED;
 		break;
 	default:
@@ -1915,7 +1915,7 @@ static void disable_wep(struct assoc_request *assoc_req)
 	int i;
 
 	/* Set Open System auth mode */
-	assoc_req->secinfo.authmode = wlan802_11authmodeopen;
+	assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 
 	/* Clear WEP keys and mark WEP as disabled */
 	assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
@@ -1984,9 +1984,9 @@ static int wlan_set_encode(struct net_device *dev,
 		set_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags);
 
 	if (dwrq->flags & IW_ENCODE_RESTRICTED) {
-		assoc_req->secinfo.authmode = wlan802_11authmodeshared;
+		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
 	} else if (dwrq->flags & IW_ENCODE_OPEN) {
-		assoc_req->secinfo.authmode = wlan802_11authmodeopen;
+		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	}
 
 out:
@@ -2144,11 +2144,9 @@ static int wlan_set_encodeext(struct net_device *dev,
 			goto out;
 
 		if (dwrq->flags & IW_ENCODE_RESTRICTED) {
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeshared;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
 		} else if (dwrq->flags & IW_ENCODE_OPEN) {
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeopen;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 
 		/* Mark the various WEP bits as modified */
@@ -2334,14 +2332,12 @@ static int wlan_set_auth(struct net_device *dev,
 		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA) {
 			assoc_req->secinfo.WPAenabled = 1;
 			assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeopen;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA2) {
 			assoc_req->secinfo.WPA2enabled = 1;
 			assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeopen;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 		updated = 1;
 		break;
@@ -2359,14 +2355,11 @@ static int wlan_set_auth(struct net_device *dev,
 
 	case IW_AUTH_80211_AUTH_ALG:
 		if (dwrq->value & IW_AUTH_ALG_SHARED_KEY) {
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeshared;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
 		} else if (dwrq->value & IW_AUTH_ALG_OPEN_SYSTEM) {
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodeopen;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		} else if (dwrq->value & IW_AUTH_ALG_LEAP) {
-			assoc_req->secinfo.authmode =
-			    wlan802_11authmodenetworkEAP;
+			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_LEAP;
 		} else {
 			ret = -EINVAL;
 		}
@@ -2380,8 +2373,7 @@ static int wlan_set_auth(struct net_device *dev,
 				assoc_req->secinfo.WPAenabled = 1;
 				assoc_req->secinfo.WPA2enabled = 1;
 				assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
-				assoc_req->secinfo.authmode =
-				    wlan802_11authmodeopen;
+				assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 			}
 		} else {
 			assoc_req->secinfo.WPAenabled = 0;
@@ -2438,19 +2430,7 @@ static int wlan_get_auth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
-		switch (adapter->secinfo.authmode) {
-		case wlan802_11authmodeshared:
-			dwrq->value = IW_AUTH_ALG_SHARED_KEY;
-			break;
-		case wlan802_11authmodeopen:
-			dwrq->value = IW_AUTH_ALG_OPEN_SYSTEM;
-			break;
-		case wlan802_11authmodenetworkEAP:
-			dwrq->value = IW_AUTH_ALG_LEAP;
-			break;
-		default:
-			break;
-		}
+		dwrq->value = adapter->secinfo.auth_mode;
 		break;
 
 	case IW_AUTH_WPA_ENABLED:
-- 
1.5.0.6



