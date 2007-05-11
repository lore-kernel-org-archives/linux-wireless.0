Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996AbXEKCx7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:53:59 -0400
Subject: [PATCH 10/19] libertas: remove WLAN_802_11_WEP_STATUS enum
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:57:23 -0400
Message-Id: <1178852243.8607.31.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also change WEPstatus to "wep_enabled"; it's clearer and consistent with the
WPAenabled and WPA2enabled members.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/assoc.c |    2 +-
 drivers/net/wireless/libertas/defs.h  |    6 -----
 drivers/net/wireless/libertas/dev.h   |    2 +-
 drivers/net/wireless/libertas/fw.c    |    3 +-
 drivers/net/wireless/libertas/join.c  |   13 +++++------
 drivers/net/wireless/libertas/scan.c  |   30 +++++++++++-------------
 drivers/net/wireless/libertas/wext.c  |   39 ++++++++++++++++-----------------
 7 files changed, 42 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 7ebd836..cc6352e 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -196,7 +196,7 @@ static int assoc_helper_wep_keys(wlan_private *priv,
 		goto out;
 
 	/* enable/disable the MAC's WEP packet filter */
-	if (assoc_req->secinfo.WEPstatus == wlan802_11WEPenabled)
+	if (assoc_req->secinfo.wep_enabled)
 		adapter->currentpacketfilter |= cmd_act_mac_wep_enable;
 	else
 		adapter->currentpacketfilter &= ~cmd_act_mac_wep_enable;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 9f54593..1168903 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -276,12 +276,6 @@ enum WLAN_802_11_NETWORK_INFRASTRUCTURE {
 	wlan802_11infrastructuremax
 };
 
-/** WLAN_802_11_WEP_STATUS */
-enum WLAN_802_11_WEP_STATUS {
-	wlan802_11WEPenabled,
-	wlan802_11WEPdisabled,
-};
-
 /** SNMP_MIB_INDEX_e */
 enum SNMP_MIB_INDEX_e {
 	desired_bsstype_i = 0,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index eb490a6..014bc1e 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -57,7 +57,7 @@ struct region_channel {
 struct wlan_802_11_security {
 	u8 WPAenabled;
 	u8 WPA2enabled;
-	enum WLAN_802_11_WEP_STATUS WEPstatus;
+	u8 wep_enabled;
 	u8 auth_mode;
 };
 
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index f2d626d..565506a 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -194,12 +194,11 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->scanmode = cmd_bss_type_any;
 
 	/* 802.11 specific */
-	adapter->secinfo.WEPstatus = wlan802_11WEPdisabled;
+	adapter->secinfo.wep_enabled = 0;
 	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
 	     i++)
 		memset(&adapter->wep_keys[i], 0, sizeof(struct WLAN_802_11_KEY));
 	adapter->wep_tx_keyidx = 0;
-	adapter->secinfo.WEPstatus = wlan802_11WEPdisabled;
 	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	adapter->inframode = wlan802_11infrastructure;
 
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index a52bbc6..b33e5f5 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -15,6 +15,8 @@
 #include "join.h"
 #include "dev.h"
 
+#define AD_HOC_CAP_PRIVACY_ON 1
+
 /**
  *  @brief This function finds out the common rates between rate1 and rate2.
  *
@@ -683,15 +685,12 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * priv,
 	adhs->probedelay = cpu_to_le16(cmd_scan_probe_delay_time);
 
 	/* set up privacy in adapter->scantable[i] */
-	if (adapter->secinfo.WEPstatus == wlan802_11WEPenabled) {
-
-#define AD_HOC_CAP_PRIVACY_ON 1
-		lbs_pr_debug(1, "ADHOC_S_CMD: WEPstatus set, privacy to WEP\n");
+	if (adapter->secinfo.wep_enabled) {
+		lbs_pr_debug(1, "ADHOC_S_CMD: WEP enabled, setting privacy on\n");
 		pbssdesc->privacy = wlan802_11privfilter8021xWEP;
 		adhs->cap.privacy = AD_HOC_CAP_PRIVACY_ON;
 	} else {
-		lbs_pr_debug(1, "ADHOC_S_CMD: WEPstatus NOT set, Setting "
-		       "privacy to ACCEPT ALL\n");
+		lbs_pr_debug(1, "ADHOC_S_CMD: WEP disabled, setting privacy off\n");
 		pbssdesc->privacy = wlan802_11privfilteracceptall;
 	}
 
@@ -849,7 +848,7 @@ int libertas_cmd_80211_ad_hoc_join(wlan_private * priv,
 	padhocjoin->bssdescriptor.ssparamset.ibssparamset.atimwindow =
 	    cpu_to_le16(pbssdesc->atimwindow);
 
-	if (adapter->secinfo.WEPstatus == wlan802_11WEPenabled) {
+	if (adapter->secinfo.wep_enabled) {
 		padhocjoin->bssdescriptor.cap.privacy = AD_HOC_CAP_PRIVACY_ON;
 	}
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index e4a58bc..37ae195 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -89,7 +89,7 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 	ENTER();
 
 	if (adapter->scantable[index].inframode == mode) {
-		if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
+		if (   !adapter->secinfo.wep_enabled
 		    && !adapter->secinfo.WPAenabled
 		    && !adapter->secinfo.WPA2enabled
 		    && adapter->scantable[index].wpa_ie[0] != WPA_IE
@@ -98,14 +98,14 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			/* no security */
 			LEAVE();
 			return index;
-		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPenabled
+		} else if (   adapter->secinfo.wep_enabled
 			   && !adapter->secinfo.WPAenabled
 			   && !adapter->secinfo.WPA2enabled
 			   && adapter->scantable[index].privacy) {
 			/* static WEP enabled */
 			LEAVE();
 			return index;
-		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
+		} else if (   !adapter->secinfo.wep_enabled
 			   && adapter->secinfo.WPAenabled
 			   && !adapter->secinfo.WPA2enabled
 			   && (adapter->scantable[index].wpa_ie[0] == WPA_IE)
@@ -119,14 +119,13 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			       "privacy=%#x\n", index,
 			       adapter->scantable[index].wpa_ie[0],
 			       adapter->scantable[index].rsn_ie[0],
-			       (adapter->secinfo.WEPstatus ==
-				wlan802_11WEPenabled) ? "e" : "d",
-			       (adapter->secinfo.WPAenabled) ? "e" : "d",
-			       (adapter->secinfo.WPA2enabled) ? "e" : "d",
+			       adapter->secinfo.wep_enabled ? "e" : "d",
+			       adapter->secinfo.WPAenabled ? "e" : "d",
+			       adapter->secinfo.WPA2enabled ? "e" : "d",
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
-		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
+		} else if (   !adapter->secinfo.wep_enabled
 			   && !adapter->secinfo.WPAenabled
 			   && adapter->secinfo.WPA2enabled
 			   && (adapter->scantable[index].rsn_ie[0] == WPA2_IE)
@@ -140,14 +139,13 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			       "privacy=%#x\n", index,
 			       adapter->scantable[index].wpa_ie[0],
 			       adapter->scantable[index].rsn_ie[0],
-			       (adapter->secinfo.WEPstatus ==
-				wlan802_11WEPenabled) ? "e" : "d",
-			       (adapter->secinfo.WPAenabled) ? "e" : "d",
-			       (adapter->secinfo.WPA2enabled) ? "e" : "d",
+			       adapter->secinfo.wep_enabled ? "e" : "d",
+			       adapter->secinfo.WPAenabled ? "e" : "d",
+			       adapter->secinfo.WPA2enabled ? "e" : "d",
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
-		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
+		} else if (   !adapter->secinfo.wep_enabled
 			   && !adapter->secinfo.WPAenabled
 			   && !adapter->secinfo.WPA2enabled
 			   && (adapter->scantable[index].wpa_ie[0] != WPA_IE)
@@ -172,9 +170,9 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		       index,
 		       adapter->scantable[index].wpa_ie[0],
 		       adapter->scantable[index].rsn_ie[0],
-		       (adapter->secinfo.WEPstatus == wlan802_11WEPenabled) ? "e" : "d",
-		       (adapter->secinfo.WPAenabled) ? "e" : "d",
-		       (adapter->secinfo.WPA2enabled) ? "e" : "d",
+		       adapter->secinfo.wep_enabled ? "e" : "d",
+		       adapter->secinfo.WPAenabled ? "e" : "d",
+		       adapter->secinfo.WPA2enabled ? "e" : "d",
 		       adapter->scantable[index].privacy);
 		LEAVE();
 		return -ECONNREFUSED;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 22eacd2..62d92ff 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1556,8 +1556,7 @@ static int wlan_set_freq(struct net_device *dev, struct iw_request_info *info,
 				/*  If station is WEP enabled, send the
 				 *  command to set WEP in firmware
 				 */
-				if (adapter->secinfo.WEPstatus ==
-				    wlan802_11WEPenabled) {
+				if (adapter->secinfo.wep_enabled) {
 					lbs_pr_debug(1, "set_freq: WEP enabled\n");
 					ret = libertas_prepare_and_send_command(priv,
 								    cmd_802_11_set_wep,
@@ -1786,8 +1785,9 @@ static int wlan_get_encode(struct net_device *dev,
 		break;
 	}
 
-	if ((adapter->secinfo.WEPstatus == wlan802_11WEPenabled)
-	    || adapter->secinfo.WPAenabled || adapter->secinfo.WPA2enabled) {
+	if (   adapter->secinfo.wep_enabled
+	    || adapter->secinfo.WPAenabled
+	    || adapter->secinfo.WPA2enabled) {
 		dwrq->flags &= ~IW_ENCODE_DISABLED;
 	} else {
 		dwrq->flags |= IW_ENCODE_DISABLED;
@@ -1801,8 +1801,7 @@ static int wlan_get_encode(struct net_device *dev,
 	if (index < 0)
 		index = adapter->wep_tx_keyidx;
 
-	if ((adapter->wep_keys[index].len) &&
-	    (adapter->secinfo.WEPstatus == wlan802_11WEPenabled)) {
+	if ((adapter->wep_keys[index].len) && adapter->secinfo.wep_enabled) {
 		memcpy(extra, adapter->wep_keys[index].key,
 		       adapter->wep_keys[index].len);
 		dwrq->length = adapter->wep_keys[index].len;
@@ -1886,7 +1885,7 @@ static int wlan_set_wep_key(struct assoc_request *assoc_req,
 		assoc_req->wep_tx_keyidx = index;
 	}
 
-	assoc_req->secinfo.WEPstatus = wlan802_11WEPenabled;
+	assoc_req->secinfo.wep_enabled = 1;
 
 	LEAVE();
 	return 0;
@@ -1918,7 +1917,7 @@ static void disable_wep(struct assoc_request *assoc_req)
 	assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 
 	/* Clear WEP keys and mark WEP as disabled */
-	assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
+	assoc_req->secinfo.wep_enabled = 0;
 	for (i = 0; i < 4; i++)
 		assoc_req->wep_keys[i].len = 0;
 
@@ -1970,8 +1969,7 @@ static int wlan_set_encode(struct net_device *dev,
 	/* If WEP isn't enabled, or if there is no key data but a valid
 	 * index, set the TX key.
 	 */
-	if ((assoc_req->secinfo.WEPstatus != wlan802_11WEPenabled)
-	    || (dwrq->length == 0 && !is_default))
+	if (!assoc_req->secinfo.wep_enabled || (dwrq->length == 0 && !is_default))
 		set_tx_key = 1;
 
 	ret = wlan_set_wep_key(assoc_req, extra, dwrq->length, index, set_tx_key);
@@ -2046,23 +2044,24 @@ static int wlan_get_encodeext(struct net_device *dev,
 	dwrq->flags = index + 1;
 	memset(ext, 0, sizeof(*ext));
 
-	if ((adapter->secinfo.WEPstatus == wlan802_11WEPdisabled)
-	    && !adapter->secinfo.WPAenabled && !adapter->secinfo.WPA2enabled) {
+	if (   !adapter->secinfo.wep_enabled
+	    && !adapter->secinfo.WPAenabled
+	    && !adapter->secinfo.WPA2enabled) {
 		ext->alg = IW_ENCODE_ALG_NONE;
 		ext->key_len = 0;
 		dwrq->flags |= IW_ENCODE_DISABLED;
 	} else {
 		u8 *key = NULL;
 
-		if ((adapter->secinfo.WEPstatus == wlan802_11WEPenabled)
+		if (   adapter->secinfo.wep_enabled
 		    && !adapter->secinfo.WPAenabled
 		    && !adapter->secinfo.WPA2enabled) {
 			ext->alg = IW_ENCODE_ALG_WEP;
 			ext->key_len = adapter->wep_keys[index].len;
 			key = &adapter->wep_keys[index].key[0];
-		} else if ((adapter->secinfo.WEPstatus == wlan802_11WEPdisabled) &&
-		           (adapter->secinfo.WPAenabled ||
-		            adapter->secinfo.WPA2enabled)) {
+		} else if (   !adapter->secinfo.wep_enabled
+		           && (adapter->secinfo.WPAenabled ||
+		               adapter->secinfo.WPA2enabled)) {
 			/* WPA */
 			ext->alg = IW_ENCODE_ALG_TKIP;
 			ext->key_len = 0;
@@ -2132,7 +2131,7 @@ static int wlan_set_encodeext(struct net_device *dev,
 		/* If WEP isn't enabled, or if there is no key data but a valid
 		 * index, or if the set-TX-key flag was passed, set the TX key.
 		 */
-		if ((assoc_req->secinfo.WEPstatus != wlan802_11WEPenabled)
+		if (   !assoc_req->secinfo.wep_enabled
 		    || (dwrq->length == 0 && !is_default)
 		    || (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY))
 			set_tx_key = 1;
@@ -2331,12 +2330,12 @@ static int wlan_set_auth(struct net_device *dev,
 		}
 		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA) {
 			assoc_req->secinfo.WPAenabled = 1;
-			assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
+			assoc_req->secinfo.wep_enabled = 0;
 			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 		if (dwrq->value & IW_AUTH_WPA_VERSION_WPA2) {
 			assoc_req->secinfo.WPA2enabled = 1;
-			assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
+			assoc_req->secinfo.wep_enabled = 0;
 			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 		updated = 1;
@@ -2372,7 +2371,7 @@ static int wlan_set_auth(struct net_device *dev,
 			    !assoc_req->secinfo.WPA2enabled) {
 				assoc_req->secinfo.WPAenabled = 1;
 				assoc_req->secinfo.WPA2enabled = 1;
-				assoc_req->secinfo.WEPstatus = wlan802_11WEPdisabled;
+				assoc_req->secinfo.wep_enabled = 0;
 				assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 			}
 		} else {
-- 
1.5.0.6



