Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbXEKCvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:51:51 -0400
Subject: [PATCH 07/19] libertas: remove setencryptionmode private ioctl and  Encryptionmode variable
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:55:20 -0400
Message-Id: <1178852120.8607.25.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly unused, and its functionality is provided by other internal members
like WEPstatus, WPAenabled, WPA2enabled, and SIOCSIWGENIE.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmdresp.c |    2 --
 drivers/net/wireless/libertas/defs.h    |    9 ---------
 drivers/net/wireless/libertas/dev.h     |    1 -
 drivers/net/wireless/libertas/fw.c      |    1 -
 drivers/net/wireless/libertas/ioctl.c   |   28 ----------------------------
 drivers/net/wireless/libertas/scan.c    |   17 +++++------------
 6 files changed, 5 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index cdb012c..001cdef 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -72,8 +72,6 @@ void libertas_mac_event_disconnected(wlan_private * priv)
 	adapter->secinfo.WPAenabled = 0;
 	adapter->secinfo.WPA2enabled = 0;
 	adapter->wpa_ie_len = 0;
-	adapter->secinfo.auth1xalg = WLAN_1X_AUTH_ALG_NONE;
-	adapter->secinfo.Encryptionmode = CIPHER_NONE;
 
 	adapter->connect_status = libertas_disconnected;
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 15fcb2c..a6dee5e 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -223,15 +223,6 @@ enum SNRNF_DATA {
 	MAX_TYPE_AVG
 };
 
-/** WLAN_802_11_ENCRYPTION_MODE */
-enum WLAN_802_11_ENCRYPTION_MODE {
-	CIPHER_NONE,
-	CIPHER_WEP40,
-	CIPHER_TKIP,
-	CIPHER_CCMP,
-	CIPHER_WEP104,
-};
-
 /** WLAN_802_11_POWER_MODE */
 enum WLAN_802_11_POWER_MODE {
 	wlan802_11powermodecam,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 5b88449..440b96d 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -59,7 +59,6 @@ struct wlan_802_11_security {
 	u8 WPA2enabled;
 	enum WLAN_802_11_WEP_STATUS WEPstatus;
 	enum WLAN_802_11_AUTHENTICATION_MODE authmode;
-	enum WLAN_802_11_ENCRYPTION_MODE Encryptionmode;
 };
 
 /** Current Basic Service Set State Structure */
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index b167a85..6911113 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -201,7 +201,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->wep_tx_keyidx = 0;
 	adapter->secinfo.WEPstatus = wlan802_11WEPdisabled;
 	adapter->secinfo.authmode = wlan802_11authmodeopen;
-	adapter->secinfo.Encryptionmode = CIPHER_NONE;
 	adapter->inframode = wlan802_11infrastructure;
 
 	adapter->assoc_req = NULL;
diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index f70930a..e2a18ab 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -577,30 +577,6 @@ static int wlan_set_multiple_dtim_ioctl(wlan_private * priv, struct ifreq *req)
 	return ret;
 }
 
-static int wlan_setencryptionmode_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	int mode;
-	struct iwreq *wrq = (struct iwreq *)req;
-
-	ENTER();
-
-	if (wrq->u.data.flags == 0) {
-		//from iwpriv subcmd
-		mode = SUBCMD_DATA(wrq);
-	} else {
-		//from wpa_supplicant subcmd
-		if (copy_from_user(&mode, wrq->u.data.pointer, sizeof(int))) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-	}
-	lbs_pr_debug(1, "encryption mode is %#x\n", mode);
-	priv->adapter->secinfo.Encryptionmode = mode;
-
-	LEAVE();
-	return 0;
-}
-
 static void adjust_mtu(wlan_private * priv)
 {
 	int mtu_increment = 0;
@@ -2002,10 +1978,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 			ret = wlan_set_multiple_dtim_ioctl(priv, req);
 			break;
 
-		case WLANSETENCRYPTIONMODE:
-			ret = wlan_setencryptionmode_ioctl(priv, req);
-			break;
-
 		case WLAN_SET_LINKMODE:
 			ret = wlan_set_linkmode_ioctl(priv, req);
 			break;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 29b1192..e4a58bc 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -94,7 +94,6 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		    && !adapter->secinfo.WPA2enabled
 		    && adapter->scantable[index].wpa_ie[0] != WPA_IE
 		    && adapter->scantable[index].rsn_ie[0] != WPA2_IE
-		    && adapter->secinfo.Encryptionmode == CIPHER_NONE
 		    && !adapter->scantable[index].privacy) {
 			/* no security */
 			LEAVE();
@@ -116,7 +115,7 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			/* WPA enabled */
 			lbs_pr_debug(1,
 			       "is_network_compatible() WPA: index=%d wpa_ie=%#x "
-			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x "
+			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
 			       "privacy=%#x\n", index,
 			       adapter->scantable[index].wpa_ie[0],
 			       adapter->scantable[index].rsn_ie[0],
@@ -124,7 +123,6 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 				wlan802_11WEPenabled) ? "e" : "d",
 			       (adapter->secinfo.WPAenabled) ? "e" : "d",
 			       (adapter->secinfo.WPA2enabled) ? "e" : "d",
-			       adapter->secinfo.Encryptionmode,
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
@@ -138,7 +136,7 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			/* WPA2 enabled */
 			lbs_pr_debug(1,
 			       "is_network_compatible() WPA2: index=%d wpa_ie=%#x "
-			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x "
+			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
 			       "privacy=%#x\n", index,
 			       adapter->scantable[index].wpa_ie[0],
 			       adapter->scantable[index].rsn_ie[0],
@@ -146,7 +144,6 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 				wlan802_11WEPenabled) ? "e" : "d",
 			       (adapter->secinfo.WPAenabled) ? "e" : "d",
 			       (adapter->secinfo.WPA2enabled) ? "e" : "d",
-			       adapter->secinfo.Encryptionmode,
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
@@ -155,16 +152,14 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 			   && !adapter->secinfo.WPA2enabled
 			   && (adapter->scantable[index].wpa_ie[0] != WPA_IE)
 			   && (adapter->scantable[index].rsn_ie[0] != WPA2_IE)
-			   && adapter->secinfo.Encryptionmode != CIPHER_NONE
 			   && adapter->scantable[index].privacy) {
 			/* dynamic WEP enabled */
 			lbs_pr_debug(1,
 			       "is_network_compatible() dynamic WEP: index=%d "
-			       "wpa_ie=%#x wpa2_ie=%#x Encmode=%#x privacy=%#x\n",
+			       "wpa_ie=%#x wpa2_ie=%#x privacy=%#x\n",
 			       index,
 			       adapter->scantable[index].wpa_ie[0],
 			       adapter->scantable[index].rsn_ie[0],
-			       adapter->secinfo.Encryptionmode,
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
@@ -173,15 +168,13 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		/* security doesn't match */
 		lbs_pr_debug(1,
 		       "is_network_compatible() FAILED: index=%d wpa_ie=%#x "
-		       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x privacy=%#x\n",
+		       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s privacy=%#x\n",
 		       index,
 		       adapter->scantable[index].wpa_ie[0],
 		       adapter->scantable[index].rsn_ie[0],
-		       (adapter->secinfo.WEPstatus ==
-			wlan802_11WEPenabled) ? "e" : "d",
+		       (adapter->secinfo.WEPstatus == wlan802_11WEPenabled) ? "e" : "d",
 		       (adapter->secinfo.WPAenabled) ? "e" : "d",
 		       (adapter->secinfo.WPA2enabled) ? "e" : "d",
-		       adapter->secinfo.Encryptionmode,
 		       adapter->scantable[index].privacy);
 		LEAVE();
 		return -ECONNREFUSED;
-- 
1.5.0.6



