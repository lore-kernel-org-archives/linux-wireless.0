Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbXEKCyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:54:44 -0400
Subject: [PATCH 11/19] libertas: remove WLAN_802_11_NETWORK_INFRASTRUCTURE  enum
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:58:02 -0400
Message-Id: <1178852282.8607.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use standard IW_MODE_* constants instead.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/assoc.c   |   34 ++++++++--------
 drivers/net/wireless/libertas/cmd.c     |   13 +++---
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 drivers/net/wireless/libertas/defs.h    |    9 ----
 drivers/net/wireless/libertas/dev.h     |    5 +-
 drivers/net/wireless/libertas/fw.c      |    2 +-
 drivers/net/wireless/libertas/ioctl.c   |    6 +-
 drivers/net/wireless/libertas/join.c    |   30 ++++++--------
 drivers/net/wireless/libertas/scan.c    |   42 +++++++++----------
 drivers/net/wireless/libertas/scan.h    |   11 ++---
 drivers/net/wireless/libertas/wext.c    |   65 ++++++++-----------------------
 11 files changed, 86 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index cc6352e..c260bd1 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -23,13 +23,13 @@ static int assoc_helper_essid(wlan_private *priv,
 	ENTER();
 
 	lbs_pr_debug(1, "New SSID requested: %s\n", assoc_req->ssid.ssid);
-	if (assoc_req->mode == wlan802_11infrastructure) {
+	if (assoc_req->mode == IW_MODE_INFRA) {
 		if (adapter->prescan) {
 			libertas_send_specific_SSID_scan(priv, &assoc_req->ssid, 1);
 		}
 
 		i = libertas_find_SSID_in_list(adapter, &assoc_req->ssid,
-				NULL, wlan802_11infrastructure);
+				NULL, IW_MODE_INFRA);
 		if (i >= 0) {
 			lbs_pr_debug(1,
 			       "SSID found in scan list ... associating...\n");
@@ -44,7 +44,7 @@ static int assoc_helper_essid(wlan_private *priv,
 			lbs_pr_debug(1, "SSID '%s' not found; cannot associate\n",
 				assoc_req->ssid.ssid);
 		}
-	} else if (assoc_req->mode == wlan802_11ibss) {
+	} else if (assoc_req->mode == IW_MODE_ADHOC) {
 		/* Scan for the network, do not save previous results.  Stale
 		 *   scan data will cause us to join a non-existant adhoc network
 		 */
@@ -52,7 +52,7 @@ static int assoc_helper_essid(wlan_private *priv,
 
 		/* Search for the requested SSID in the scan table */
 		i = libertas_find_SSID_in_list(adapter, &assoc_req->ssid, NULL,
-				wlan802_11ibss);
+				IW_MODE_ADHOC);
 		if (i >= 0) {
 			lbs_pr_debug(1, "SSID found at %d in List, so join\n", ret);
 			libertas_join_adhoc_network(priv, &adapter->scantable[i]);
@@ -90,10 +90,10 @@ static int assoc_helper_bssid(wlan_private *priv,
 		goto out;
 	}
 
-	if (assoc_req->mode == wlan802_11infrastructure) {
+	if (assoc_req->mode == IW_MODE_INFRA) {
 		ret = wlan_associate(priv, &adapter->scantable[i]);
 		lbs_pr_debug(1, "ASSOC: return from wlan_associate(bssd) was %d\n", ret);
-	} else if (assoc_req->mode == wlan802_11ibss) {
+	} else if (assoc_req->mode == IW_MODE_ADHOC) {
 		libertas_join_adhoc_network(priv, &adapter->scantable[i]);
 	}
 	memcpy(&assoc_req->ssid, &adapter->scantable[i].ssid,
@@ -142,23 +142,23 @@ static int assoc_helper_mode(wlan_private *priv,
 
 	ENTER();
 
-	if (assoc_req->mode == adapter->inframode) {
+	if (assoc_req->mode == adapter->mode) {
 		LEAVE();
 		return 0;
 	}
 
-	if (assoc_req->mode == wlan802_11infrastructure) {
+	if (assoc_req->mode == IW_MODE_INFRA) {
 		if (adapter->psstate != PS_STATE_FULL_POWER)
 			libertas_ps_wakeup(priv, cmd_option_waitforrsp);
 		adapter->psmode = wlan802_11powermodecam;
 	}
 
-	adapter->inframode = assoc_req->mode;
+	adapter->mode = assoc_req->mode;
 	ret = libertas_prepare_and_send_command(priv,
 				    cmd_802_11_snmp_mib,
 				    0, cmd_option_waitforrsp,
 				    OID_802_11_INFRASTRUCTURE_MODE,
-				    (void *) assoc_req->mode);
+				    (void *) (size_t) assoc_req->mode);
 
 	LEAVE();
 	return ret;
@@ -315,7 +315,7 @@ static int should_deauth_infrastructure(wlan_adapter *adapter,
 
 	/* FIXME: deal with 'auto' mode somehow */
 	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
-		if (assoc_req->mode != wlan802_11infrastructure)
+		if (assoc_req->mode != IW_MODE_INFRA)
 			return 1;
 	}
 
@@ -337,7 +337,7 @@ static int should_stop_adhoc(wlan_adapter *adapter,
 
 	/* FIXME: deal with 'auto' mode somehow */
 	if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
-		if (assoc_req->mode != wlan802_11ibss)
+		if (assoc_req->mode != IW_MODE_ADHOC)
 			return 1;
 	}
 
@@ -381,7 +381,7 @@ void wlan_association_worker(struct work_struct *work)
 	}
 
 	if (find_any_ssid) {
-		enum WLAN_802_11_NETWORK_INFRASTRUCTURE new_mode;
+		u8 new_mode;
 
 		ret = libertas_find_best_network_SSID(priv, &assoc_req->ssid,
 				assoc_req->mode, &new_mode);
@@ -392,7 +392,7 @@ void wlan_association_worker(struct work_struct *work)
 		}
 
 		/* Ensure we switch to the mode of the AP */
-		if (assoc_req->mode == wlan802_11autounknown) {
+		if (assoc_req->mode == IW_MODE_AUTO) {
 			set_bit(ASSOC_FLAG_MODE, &assoc_req->flags);
 			assoc_req->mode = new_mode;
 		}
@@ -402,7 +402,7 @@ void wlan_association_worker(struct work_struct *work)
 	 * Check if the attributes being changing require deauthentication
 	 * from the currently associated infrastructure access point.
 	 */
-	if (adapter->inframode == wlan802_11infrastructure) {
+	if (adapter->mode == IW_MODE_INFRA) {
 		if (should_deauth_infrastructure(adapter, assoc_req)) {
 			ret = libertas_send_deauthentication(priv);
 			if (ret) {
@@ -411,7 +411,7 @@ void wlan_association_worker(struct work_struct *work)
 					ret);
 			}
 		}
-	} else if (adapter->inframode == wlan802_11ibss) {
+	} else if (adapter->mode == IW_MODE_ADHOC) {
 		if (should_stop_adhoc(adapter, assoc_req)) {
 			ret = libertas_stop_adhoc_network(priv);
 			if (ret) {
@@ -542,7 +542,7 @@ struct assoc_request * wlan_get_association_request(wlan_adapter *adapter)
 		assoc_req->channel = adapter->curbssparams.channel;
 
 	if (!test_bit(ASSOC_FLAG_MODE, &assoc_req->flags))
-		assoc_req->mode = adapter->inframode;
+		assoc_req->mode = adapter->mode;
 
 	if (!test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
 		memcpy(&assoc_req->bssid, adapter->curbssparams.bssid,
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index bfdac58..96df746 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -381,15 +381,16 @@ static int wlan_cmd_802_11_snmp_mib(wlan_private * priv,
 	switch (cmd_oid) {
 	case OID_802_11_INFRASTRUCTURE_MODE:
 	{
-		enum WLAN_802_11_NETWORK_INFRASTRUCTURE mode =
-			(enum WLAN_802_11_NETWORK_INFRASTRUCTURE) pdata_buf;
+ 		u8 mode = (u8) (size_t) pdata_buf;
 		pSNMPMIB->querytype = cpu_to_le16(cmd_act_set);
 		pSNMPMIB->oid = cpu_to_le16((u16) desired_bsstype_i);
 		pSNMPMIB->bufsize = sizeof(u8);
-		if (mode == wlan802_11infrastructure)
-			ucTemp = SNMP_MIB_VALUE_INFRA;
-		else
-			ucTemp = SNMP_MIB_VALUE_ADHOC;
+ 		if (mode == IW_MODE_ADHOC) {
+ 			ucTemp = SNMP_MIB_VALUE_ADHOC;
+ 		} else {
+ 			/* Infra and Auto modes */
+ 			ucTemp = SNMP_MIB_VALUE_INFRA;
+ 		}
 
 		memmove(pSNMPMIB->value, &ucTemp, sizeof(u8));
 
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 001cdef..c864540 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -809,7 +809,7 @@ int libertas_process_rx_command(wlan_private * priv)
 		if (result) {
 			lbs_pr_debug(1, "CMD_RESP: PS command failed- %#x \n",
 			       resp->result);
-			if (adapter->inframode == wlan802_11ibss) {
+			if (adapter->mode == IW_MODE_ADHOC) {
 				/*
 				 * We should not re-try enter-ps command in
 				 * ad-hoc mode. It takes place in
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 1168903..9156bbc 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -267,15 +267,6 @@ enum mv_ms_type {
 	MVMS_EVENT
 };
 
-/** WLAN_802_11_NETWORK_INFRASTRUCTURE */
-enum WLAN_802_11_NETWORK_INFRASTRUCTURE {
-	wlan802_11ibss,
-	wlan802_11infrastructure,
-	wlan802_11autounknown,
-	/*defined as upper bound */
-	wlan802_11infrastructuremax
-};
-
 /** SNMP_MIB_INDEX_e */
 enum SNMP_MIB_INDEX_e {
 	desired_bsstype_i = 0,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 014bc1e..70ad16d 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -183,7 +183,7 @@ struct assoc_request {
 
 	struct WLAN_802_11_SSID ssid;
 	u8 channel;
-	enum WLAN_802_11_NETWORK_INFRASTRUCTURE mode;
+ 	u8 mode;
 	u8 bssid[ETH_ALEN];
 
 	/** WEP keys */
@@ -252,7 +252,8 @@ struct _wlan_adapter {
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
 
-	enum WLAN_802_11_NETWORK_INFRASTRUCTURE inframode;
+	/* IW_MODE_* */
+	u8 mode;
 
 	struct bss_descriptor *pattemptedbssdesc;
 
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index 565506a..441123c 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -200,7 +200,7 @@ static void wlan_init_adapter(wlan_private * priv)
 		memset(&adapter->wep_keys[i], 0, sizeof(struct WLAN_802_11_KEY));
 	adapter->wep_tx_keyidx = 0;
 	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	adapter->inframode = wlan802_11infrastructure;
+	adapter->mode = IW_MODE_INFRA;
 
 	adapter->assoc_req = NULL;
 
diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index 054c657..636a089 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -445,8 +445,8 @@ static int wlan_get_adhoc_status_ioctl(wlan_private * priv, struct iwreq *wrq)
 
 	memset(status, 0, sizeof(status));
 
-	switch (adapter->inframode) {
-	case wlan802_11ibss:
+	switch (adapter->mode) {
+	case IW_MODE_ADHOC:
 		if (adapter->connect_status == libertas_connected) {
 			if (adapter->adhoccreate)
 				memcpy(&status, "AdhocStarted", sizeof(status));
@@ -456,7 +456,7 @@ static int wlan_get_adhoc_status_ioctl(wlan_private * priv, struct iwreq *wrq)
 			memcpy(&status, "AdhocIdle", sizeof(status));
 		}
 		break;
-	case wlan802_11infrastructure:
+	case IW_MODE_INFRA:
 		memcpy(&status, "Inframode", sizeof(status));
 		break;
 	default:
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index b33e5f5..ef2440a 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -87,7 +87,7 @@ int libertas_send_deauth(wlan_private * priv)
 	wlan_adapter *adapter = priv->adapter;
 	int ret = 0;
 
-	if (adapter->inframode == wlan802_11infrastructure &&
+	if (adapter->mode == IW_MODE_INFRA &&
 	    adapter->connect_status == libertas_connected)
 		ret = libertas_send_deauthentication(priv);
 	else
@@ -101,7 +101,7 @@ int libertas_do_adhocstop_ioctl(wlan_private * priv)
 	wlan_adapter *adapter = priv->adapter;
 	int ret = 0;
 
-	if (adapter->inframode == wlan802_11ibss &&
+	if (adapter->mode == IW_MODE_ADHOC &&
 	    adapter->connect_status == libertas_connected)
 		ret = libertas_stop_adhoc_network(priv);
 	else
@@ -209,8 +209,7 @@ int libertas_join_adhoc_network(wlan_private * priv, struct bss_descriptor * pbs
 	/* check if the requested SSID is already joined */
 	if (adapter->curbssparams.ssid.ssidlength
 	    && !libertas_SSID_cmp(&pbssdesc->ssid, &adapter->curbssparams.ssid)
-	    && (adapter->curbssparams.bssdescriptor.inframode ==
-		wlan802_11ibss)) {
+	    && (adapter->mode == IW_MODE_ADHOC)) {
 
         lbs_pr_debug(1,
 		       "ADHOC_J_CMD: New ad-hoc SSID is the same as current, "
@@ -278,7 +277,7 @@ int libertas_idle_off(wlan_private * priv)
 	ENTER();
 
 	if (adapter->connect_status == libertas_disconnected) {
-		if (adapter->inframode == wlan802_11infrastructure) {
+		if (adapter->mode == IW_MODE_INFRA) {
 			if (memcmp(adapter->previousbssid, zeromac,
 				   sizeof(zeromac)) != 0) {
 
@@ -296,7 +295,7 @@ int libertas_idle_off(wlan_private * priv)
 				i = libertas_find_SSID_in_list(adapter,
 						   &adapter->previousssid,
 						   adapter->previousbssid,
-						   adapter->inframode);
+						   adapter->mode);
 
 				if (i < 0) {
 					libertas_send_specific_BSSID_scan(priv,
@@ -308,8 +307,7 @@ int libertas_idle_off(wlan_private * priv)
 							   previousssid,
 							   adapter->
 							   previousbssid,
-							   adapter->
-							   inframode);
+							   adapter->mode);
 				}
 
 				if (i < 0) {
@@ -317,8 +315,7 @@ int libertas_idle_off(wlan_private * priv)
 					i = libertas_find_SSID_in_list(adapter,
 							   &adapter->
 							   previousssid, NULL,
-							   adapter->
-							   inframode);
+							   adapter->mode);
 				}
 
 				if (i < 0) {
@@ -329,8 +326,7 @@ int libertas_idle_off(wlan_private * priv)
 					i = libertas_find_SSID_in_list(adapter,
 							   &adapter->
 							   previousssid, NULL,
-							   adapter->
-							   inframode);
+							   adapter->mode);
 				}
 
 				if (i >= 0) {
@@ -340,7 +336,7 @@ int libertas_idle_off(wlan_private * priv)
 							   scantable[i]);
 				}
 			}
-		} else if (adapter->inframode == wlan802_11ibss) {
+		} else if (adapter->mode == IW_MODE_ADHOC) {
 			ret = libertas_prepare_and_send_command(priv,
 						    cmd_802_11_ad_hoc_start,
 						    0,
@@ -367,7 +363,7 @@ int libertas_idle_on(wlan_private * priv)
 	int ret = 0;
 
 	if (adapter->connect_status == libertas_connected) {
-		if (adapter->inframode == wlan802_11infrastructure) {
+		if (adapter->mode == IW_MODE_INFRA) {
 			lbs_pr_debug(1, "Previous SSID = %s\n",
 			       adapter->previousssid.ssid);
 			memmove(&adapter->previousssid,
@@ -375,7 +371,7 @@ int libertas_idle_on(wlan_private * priv)
 				sizeof(struct WLAN_802_11_SSID));
 			libertas_send_deauth(priv);
 
-		} else if (adapter->inframode == wlan802_11ibss) {
+		} else if (adapter->mode == IW_MODE_ADHOC) {
 			ret = libertas_stop_adhoc_network(priv);
 		}
 
@@ -569,7 +565,7 @@ int libertas_cmd_80211_associate(wlan_private * priv,
 	lbs_pr_debug(1, "ASSOC_CMD: rates->header.len = %d\n", rates->header.len);
 
 	/* set IBSS field */
-	if (pbssdesc->inframode == wlan802_11infrastructure) {
+	if (pbssdesc->mode == IW_MODE_INFRA) {
 #define CAPINFO_ESS_MODE 1
 		passo->capinfo.ess = CAPINFO_ESS_MODE;
 	}
@@ -643,7 +639,7 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * priv,
 
 	/* set the BSS type */
 	adhs->bsstype = cmd_bss_type_ibss;
-	pbssdesc->inframode = wlan802_11ibss;
+	pbssdesc->mode = IW_MODE_ADHOC;
 	adhs->beaconperiod = adapter->beaconperiod;
 
 	/* set Physical param set */
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 37ae195..6c0cbb5 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -84,11 +84,11 @@
  *
  *  @return        Index in scantable, or error code if negative
  */
-static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
+static int is_network_compatible(wlan_adapter * adapter, int index, u8 mode)
 {
 	ENTER();
 
-	if (adapter->scantable[index].inframode == mode) {
+	if (adapter->scantable[index].mode == mode) {
 		if (   !adapter->secinfo.wep_enabled
 		    && !adapter->secinfo.WPAenabled
 		    && !adapter->secinfo.WPA2enabled
@@ -996,9 +996,9 @@ static int InterpretBSSDescriptionWithIE(struct bss_descriptor * pBSSEntry,
 	}
 
 	if (pcap->ibss == 1) {
-		pBSSEntry->inframode = wlan802_11ibss;
+		pBSSEntry->mode = IW_MODE_ADHOC;
 	} else {
-		pBSSEntry->inframode = wlan802_11infrastructure;
+		pBSSEntry->mode = IW_MODE_INFRA;
 	}
 
 	/* process variable IE */
@@ -1196,7 +1196,7 @@ int libertas_SSID_cmp(struct WLAN_802_11_SSID *ssid1, struct WLAN_802_11_SSID *s
  *
  *  @return         index in BSSID list, or error return code (< 0)
  */
-int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, int mode)
+int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, u8 mode)
 {
 	int ret = -ENETUNREACH;
 	int i;
@@ -1216,8 +1216,8 @@ int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, int mode)
 	for (i = 0; ret < 0 && i < adapter->numinscantable; i++) {
 		if (!memcmp(adapter->scantable[i].macaddress, bssid, ETH_ALEN)) {
 			switch (mode) {
-			case wlan802_11infrastructure:
-			case wlan802_11ibss:
+			case IW_MODE_INFRA:
+			case IW_MODE_ADHOC:
 				ret = is_network_compatible(adapter, i, mode);
 				break;
 			default:
@@ -1241,7 +1241,7 @@ int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, int mode)
  *  @return         index in BSSID list
  */
 int libertas_find_SSID_in_list(wlan_adapter * adapter,
-		   struct WLAN_802_11_SSID *ssid, u8 * bssid, int mode)
+		   struct WLAN_802_11_SSID *ssid, u8 * bssid, u8 mode)
 {
 	int net = -ENETUNREACH;
 	u8 bestrssi = 0;
@@ -1256,8 +1256,8 @@ int libertas_find_SSID_in_list(wlan_adapter * adapter,
 		     !memcmp(adapter->scantable[i].
 			     macaddress, bssid, ETH_ALEN))) {
 			switch (mode) {
-			case wlan802_11infrastructure:
-			case wlan802_11ibss:
+			case IW_MODE_INFRA:
+			case IW_MODE_ADHOC:
 				j = is_network_compatible(adapter, i, mode);
 
 				if (j >= 0) {
@@ -1280,7 +1280,7 @@ int libertas_find_SSID_in_list(wlan_adapter * adapter,
 					}
 				}
 				break;
-			case wlan802_11autounknown:
+			case IW_MODE_AUTO:
 			default:
 				if (SCAN_RSSI(adapter->scantable[i].rssi)
 				    > bestrssi) {
@@ -1307,8 +1307,7 @@ int libertas_find_SSID_in_list(wlan_adapter * adapter,
  *
  *  @return         index in BSSID list
  */
-int libertas_find_best_SSID_in_list(wlan_adapter * adapter,
-                                    enum WLAN_802_11_NETWORK_INFRASTRUCTURE mode)
+int libertas_find_best_SSID_in_list(wlan_adapter * adapter, u8 mode)
 {
 	int bestnet = -ENETUNREACH;
 	u8 bestrssi = 0;
@@ -1320,8 +1319,8 @@ int libertas_find_best_SSID_in_list(wlan_adapter * adapter,
 
 	for (i = 0; i < adapter->numinscantable; i++) {
 		switch (mode) {
-		case wlan802_11infrastructure:
-		case wlan802_11ibss:
+		case IW_MODE_INFRA:
+		case IW_MODE_ADHOC:
 			if (is_network_compatible(adapter, i, mode) >= 0) {
 				if (SCAN_RSSI(adapter->scantable[i].rssi) >
 				    bestrssi) {
@@ -1332,7 +1331,7 @@ int libertas_find_best_SSID_in_list(wlan_adapter * adapter,
 				}
 			}
 			break;
-		case wlan802_11autounknown:
+		case IW_MODE_AUTO:
 		default:
 			if (SCAN_RSSI(adapter->scantable[i].rssi) > bestrssi) {
 				bestrssi =
@@ -1357,8 +1356,7 @@ int libertas_find_best_SSID_in_list(wlan_adapter * adapter,
  */
 int libertas_find_best_network_SSID(wlan_private * priv,
                                     struct WLAN_802_11_SSID *pSSID,
-                                    enum WLAN_802_11_NETWORK_INFRASTRUCTURE preferred_mode,
-                                    enum WLAN_802_11_NETWORK_INFRASTRUCTURE *out_mode)
+                                    u8 preferred_mode, u8 *out_mode)
 {
 	wlan_adapter *adapter = priv->adapter;
 	int ret = 0;
@@ -1383,7 +1381,7 @@ int libertas_find_best_network_SSID(wlan_private * priv,
 	preqbssid = &adapter->scantable[i];
 	memcpy(pSSID, &preqbssid->ssid,
 	       sizeof(struct WLAN_802_11_SSID));
-	*out_mode = preqbssid->inframode;
+	*out_mode = preqbssid->mode;
 
 	if (!pSSID->ssidlength) {
 		ret = -1;
@@ -1601,7 +1599,7 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
 
 		//Add mode
 		iwe.cmd = SIOCGIWMODE;
-		iwe.u.mode = adapter->scantable[i].inframode + 1;
+		iwe.u.mode = adapter->scantable[i].mode;
 		iwe.len = IW_EV_UINT_LEN;
 		current_ev =
 		    iwe_stream_add_event(current_ev, end_buf, &iwe, iwe.len);
@@ -1635,7 +1633,7 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.noise =
 			    CAL_NF(adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
 		}
-		if ((adapter->inframode == wlan802_11ibss) &&
+		if ((adapter->mode == IW_MODE_ADHOC) &&
 		    !libertas_SSID_cmp(&adapter->curbssparams.ssid,
 			     &adapter->scantable[i].ssid)
 		    && adapter->adhoccreate) {
@@ -1700,7 +1698,7 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
 						 end_buf, &iwe, iwe.len);
 
 		}
-		if ((adapter->scantable[i].inframode == wlan802_11ibss)
+		if ((adapter->scantable[i].mode == IW_MODE_ADHOC)
 		    && !libertas_SSID_cmp(&adapter->curbssparams.ssid,
 				&adapter->scantable[i].ssid)
 		    && adapter->adhoccreate) {
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index 486bdc4..405f4f0 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -153,7 +153,7 @@ struct bss_descriptor {
 
 	u32 atimwindow;
 
-	enum WLAN_802_11_NETWORK_INFRASTRUCTURE inframode;
+	u8 mode;
 	u8 libertas_supported_rates[WLAN_SUPPORTED_RATES];
 
 	int extra_ie;
@@ -177,14 +177,13 @@ struct bss_descriptor {
 extern int libertas_SSID_cmp(struct WLAN_802_11_SSID *ssid1,
 		   struct WLAN_802_11_SSID *ssid2);
 extern int libertas_find_SSID_in_list(wlan_adapter * adapter, struct WLAN_802_11_SSID *ssid,
-			  u8 * bssid, int mode);
-int libertas_find_best_SSID_in_list(wlan_adapter * adapter, enum WLAN_802_11_NETWORK_INFRASTRUCTURE mode);
-extern int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, int mode);
+			  u8 * bssid, u8 mode);
+int libertas_find_best_SSID_in_list(wlan_adapter * adapter, u8 mode);
+extern int libertas_find_BSSID_in_list(wlan_adapter * adapter, u8 * bssid, u8 mode);
 
 int libertas_find_best_network_SSID(wlan_private * priv,
 			struct WLAN_802_11_SSID *pSSID,
-			enum WLAN_802_11_NETWORK_INFRASTRUCTURE preferred_mode,
-			enum WLAN_802_11_NETWORK_INFRASTRUCTURE *out_mode);
+			u8 preferred_mode, u8 *out_mode);
 
 extern int libertas_send_specific_SSID_scan(wlan_private * priv,
 				struct WLAN_802_11_SSID *prequestedssid,
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 62d92ff..18629af 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -233,7 +233,7 @@ static int changeadhocchannel(wlan_private * priv, int channel)
 
 		// find out the BSSID that matches the current SSID
 		i = libertas_find_SSID_in_list(adapter, &curadhocssid, NULL,
-				   wlan802_11ibss);
+				   IW_MODE_ADHOC);
 
 		if (i >= 0) {
 			lbs_pr_debug(1, "SSID found at %d in List,"
@@ -316,13 +316,11 @@ static int get_active_data_rates(wlan_adapter * adapter,
 	ENTER();
 
 	if (adapter->connect_status != libertas_connected) {
-		if (adapter->inframode == wlan802_11infrastructure) {
-			//Infra. mode
+		if (adapter->mode == IW_MODE_INFRA) {
 			lbs_pr_debug(1, "Infra\n");
 			k = copyrates(rates, k, libertas_supported_rates,
 				      sizeof(libertas_supported_rates));
 		} else {
-			//ad-hoc mode
 			lbs_pr_debug(1, "Adhoc G\n");
 			k = copyrates(rates, k, libertas_adhoc_rates_g,
 				      sizeof(libertas_adhoc_rates_g));
@@ -586,20 +584,7 @@ static int wlan_get_mode(struct net_device *dev,
 
 	ENTER();
 
-	switch (adapter->inframode) {
-	case wlan802_11ibss:
-		*uwrq = IW_MODE_ADHOC;
-		break;
-
-	case wlan802_11infrastructure:
-		*uwrq = IW_MODE_INFRA;
-		break;
-
-	default:
-	case wlan802_11autounknown:
-		*uwrq = IW_MODE_AUTO;
-		break;
-	}
+	*uwrq = adapter->mode;
 
 	LEAVE();
 	return 0;
@@ -1417,7 +1402,7 @@ static struct iw_statistics *wlan_get_wireless_stats(struct net_device *dev)
 
 	ENTER();
 
-	priv->wstats.status = adapter->inframode;
+	priv->wstats.status = adapter->mode;
 
 	/* If we're not associated, all quality values are meaningless */
 	if (adapter->connect_status != libertas_connected)
@@ -1551,7 +1536,7 @@ static int wlan_set_freq(struct net_device *dev, struct iw_request_info *info,
 		if (!cfp) {
 			rc = -EINVAL;
 		} else {
-			if (adapter->inframode == wlan802_11ibss) {
+			if (adapter->mode == IW_MODE_ADHOC) {
 				rc = changeadhocchannel(priv, channel);
 				/*  If station is WEP enabled, send the
 				 *  command to set WEP in firmware
@@ -1698,49 +1683,31 @@ static int wlan_set_mode(struct net_device *dev,
 	wlan_private *priv = dev->priv;
 	wlan_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
-	enum WLAN_802_11_NETWORK_INFRASTRUCTURE new_mode;
 
 	ENTER();
 
-	switch (*uwrq) {
-	case IW_MODE_ADHOC:
-		lbs_pr_debug(1, "Wanted mode is ad-hoc: current datarate=%#x\n",
-		       adapter->datarate);
-		new_mode = wlan802_11ibss;
-		adapter->adhocchannel = DEFAULT_AD_HOC_CHANNEL;
-		break;
-
-	case IW_MODE_INFRA:
-		lbs_pr_debug(1, "Wanted mode is Infrastructure\n");
-		new_mode = wlan802_11infrastructure;
-		break;
-
-	case IW_MODE_AUTO:
-		lbs_pr_debug(1, "Wanted mode is Auto\n");
-		new_mode = wlan802_11autounknown;
-		break;
-
-	default:
-		lbs_pr_debug(1, "Wanted mode is Unknown: 0x%x\n", *uwrq);
-		return -EINVAL;
+	if (   (*uwrq != IW_MODE_ADHOC)
+	    && (*uwrq != IW_MODE_INFRA)
+	    && (*uwrq != IW_MODE_AUTO)) {
+		lbs_pr_debug(1, "Invalid mode: 0x%x\n", *uwrq);
+		ret = -EINVAL;
+		goto out;
 	}
 
 	mutex_lock(&adapter->lock);
 	assoc_req = wlan_get_association_request(adapter);
 	if (!assoc_req) {
 		ret = -ENOMEM;
+		wlan_cancel_association_work(priv);
 	} else {
-		assoc_req->mode = new_mode;
-	}
-
-	if (ret == 0) {
+		assoc_req->mode = *uwrq;
 		set_bit(ASSOC_FLAG_MODE, &assoc_req->flags);
 		wlan_postpone_association_work(priv);
-	} else {
-		wlan_cancel_association_work(priv);
+		lbs_pr_debug(1, "Switching to mode: 0x%x\n", *uwrq);
 	}
 	mutex_unlock(&adapter->lock);
 
+out:
 	LEAVE();
 	return ret;
 }
@@ -2037,7 +2004,7 @@ static int wlan_get_encodeext(struct net_device *dev,
 
 	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
 	    ext->alg != IW_ENCODE_ALG_WEP) {
-		if (index != 0 || adapter->inframode != wlan802_11infrastructure)
+		if (index != 0 || adapter->mode != IW_MODE_INFRA)
 			goto out;
 	}
 
-- 
1.5.0.6



