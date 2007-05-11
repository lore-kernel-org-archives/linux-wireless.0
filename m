Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXEKCr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:47:59 -0400
Subject: [PATCH 01/19] libertas: remove WPA_SUPPLICANT structure
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:51:28 -0400
Message-Id: <1178851888.8607.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start to normalize bss_descriptor with ieee80211_network so we can
eventually replace bss_descriptor more easily.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/scan.c |  115 +++++++++++++--------------------
 drivers/net/wireless/libertas/scan.h |    8 ++-
 2 files changed, 50 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index e187062..400558a 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -95,10 +95,9 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
 		    && !adapter->secinfo.WPAenabled
 		    && !adapter->secinfo.WPA2enabled
-		    && adapter->scantable[index].wpa_supplicant.wpa_ie[0] !=
-		    WPA_IE
-		    && adapter->scantable[index].wpa2_supplicant.wpa_ie[0] !=
-		    WPA2_IE && adapter->secinfo.Encryptionmode == CIPHER_NONE
+		    && adapter->scantable[index].wpa_ie[0] != WPA_IE
+		    && adapter->scantable[index].rsn_ie[0] != WPA2_IE
+		    && adapter->secinfo.Encryptionmode == CIPHER_NONE
 		    && !adapter->scantable[index].privacy) {
 			/* no security */
 			LEAVE();
@@ -113,21 +112,17 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
 			   && adapter->secinfo.WPAenabled
 			   && !adapter->secinfo.WPA2enabled
-			   && (adapter->scantable[index].wpa_supplicant.
-			       wpa_ie[0]
-			       == WPA_IE)
+			   && (adapter->scantable[index].wpa_ie[0] == WPA_IE)
 			   /* privacy bit may NOT be set in some APs like LinkSys WRT54G
 			      && adapter->scantable[index].privacy */
 		    ) {
 			/* WPA enabled */
-            lbs_pr_debug(1,
+			lbs_pr_debug(1,
 			       "is_network_compatible() WPA: index=%d wpa_ie=%#x "
 			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x "
 			       "privacy=%#x\n", index,
-			       adapter->scantable[index].wpa_supplicant.
-			       wpa_ie[0],
-			       adapter->scantable[index].wpa2_supplicant.
-			       wpa_ie[0],
+			       adapter->scantable[index].wpa_ie[0],
+			       adapter->scantable[index].rsn_ie[0],
 			       (adapter->secinfo.WEPstatus ==
 				wlan802_11WEPenabled) ? "e" : "d",
 			       (adapter->secinfo.WPAenabled) ? "e" : "d",
@@ -139,21 +134,17 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
 			   && !adapter->secinfo.WPAenabled
 			   && adapter->secinfo.WPA2enabled
-			   && (adapter->scantable[index].wpa2_supplicant.
-			       wpa_ie[0]
-			       == WPA2_IE)
+			   && (adapter->scantable[index].rsn_ie[0] == WPA2_IE)
 			   /* privacy bit may NOT be set in some APs like LinkSys WRT54G
 			      && adapter->scantable[index].privacy */
 		    ) {
 			/* WPA2 enabled */
-            lbs_pr_debug(1,
+			lbs_pr_debug(1,
 			       "is_network_compatible() WPA2: index=%d wpa_ie=%#x "
 			       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x "
 			       "privacy=%#x\n", index,
-			       adapter->scantable[index].wpa_supplicant.
-			       wpa_ie[0],
-			       adapter->scantable[index].wpa2_supplicant.
-			       wpa_ie[0],
+			       adapter->scantable[index].wpa_ie[0],
+			       adapter->scantable[index].rsn_ie[0],
 			       (adapter->secinfo.WEPstatus ==
 				wlan802_11WEPenabled) ? "e" : "d",
 			       (adapter->secinfo.WPAenabled) ? "e" : "d",
@@ -165,35 +156,30 @@ static int is_network_compatible(wlan_adapter * adapter, int index, int mode)
 		} else if (adapter->secinfo.WEPstatus == wlan802_11WEPdisabled
 			   && !adapter->secinfo.WPAenabled
 			   && !adapter->secinfo.WPA2enabled
-			   && (adapter->scantable[index].wpa_supplicant.
-			       wpa_ie[0]
-			       != WPA_IE)
-			   && (adapter->scantable[index].wpa2_supplicant.
-			       wpa_ie[0]
-			       != WPA2_IE)
+			   && (adapter->scantable[index].wpa_ie[0] != WPA_IE)
+			   && (adapter->scantable[index].rsn_ie[0] != WPA2_IE)
 			   && adapter->secinfo.Encryptionmode != CIPHER_NONE
 			   && adapter->scantable[index].privacy) {
 			/* dynamic WEP enabled */
-            lbs_pr_debug(1,
+			lbs_pr_debug(1,
 			       "is_network_compatible() dynamic WEP: index=%d "
 			       "wpa_ie=%#x wpa2_ie=%#x Encmode=%#x privacy=%#x\n",
 			       index,
-			       adapter->scantable[index].wpa_supplicant.
-			       wpa_ie[0],
-			       adapter->scantable[index].wpa2_supplicant.
-			       wpa_ie[0], adapter->secinfo.Encryptionmode,
+			       adapter->scantable[index].wpa_ie[0],
+			       adapter->scantable[index].rsn_ie[0],
+			       adapter->secinfo.Encryptionmode,
 			       adapter->scantable[index].privacy);
 			LEAVE();
 			return index;
 		}
 
 		/* security doesn't match */
-        lbs_pr_debug(1,
+		lbs_pr_debug(1,
 		       "is_network_compatible() FAILED: index=%d wpa_ie=%#x "
 		       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s Encmode=%#x privacy=%#x\n",
 		       index,
-		       adapter->scantable[index].wpa_supplicant.wpa_ie[0],
-		       adapter->scantable[index].wpa2_supplicant.wpa_ie[0],
+		       adapter->scantable[index].wpa_ie[0],
+		       adapter->scantable[index].rsn_ie[0],
 		       (adapter->secinfo.WEPstatus ==
 			wlan802_11WEPenabled) ? "e" : "d",
 		       (adapter->secinfo.WPAenabled) ? "e" : "d",
@@ -924,8 +910,6 @@ static int InterpretBSSDescriptionWithIE(struct bss_descriptor * pBSSEntry,
 	u8 founddatarateie;
 	int bytesleftforcurrentbeacon;
 
-	struct WPA_SUPPLICANT *pwpa_supplicant;
-	struct WPA_SUPPLICANT *pwpa2_supplicant;
 	struct IE_WPA *pIe;
 	const u8 oui01[4] = { 0x00, 0x50, 0xf2, 0x01 };
 
@@ -962,9 +946,6 @@ static int InterpretBSSDescriptionWithIE(struct bss_descriptor * pBSSEntry,
 
 	bytesleftforcurrentbeacon = beaconsize;
 
-	pwpa_supplicant = &pBSSEntry->wpa_supplicant;
-	pwpa2_supplicant = &pBSSEntry->wpa2_supplicant;
-
 	memcpy(pBSSEntry->macaddress, pcurrentptr, ETH_ALEN);
 	lbs_pr_debug(1, "InterpretIE: AP MAC Addr-%x:%x:%x:%x:%x:%x\n",
 	       pBSSEntry->macaddress[0], pBSSEntry->macaddress[1],
@@ -1160,27 +1141,27 @@ static int InterpretBSSDescriptionWithIE(struct bss_descriptor * pBSSEntry,
 #define IE_ID_LEN_FIELDS_BYTES 2
 			pIe = (struct IE_WPA *)pcurrentptr;
 
-			if (!memcmp(pIe->oui, oui01, sizeof(oui01))) {
-				pwpa_supplicant->wpa_ie_len
-				    = min_t(size_t, elemlen + IE_ID_LEN_FIELDS_BYTES,
-					  sizeof(pwpa_supplicant->wpa_ie));
-				memcpy(pwpa_supplicant->wpa_ie,
-				       pcurrentptr,
-				       pwpa_supplicant->wpa_ie_len);
-				lbs_dbg_hex("InterpretIE: Resp WPA_IE",
-					pwpa_supplicant->wpa_ie, elemlen);
-			}
+			if (memcmp(pIe->oui, oui01, sizeof(oui01)))
+				break;
+
+			pBSSEntry->wpa_ie_len = min_t(size_t,
+				elemlen + IE_ID_LEN_FIELDS_BYTES,
+				sizeof(pBSSEntry->wpa_ie));
+			memcpy(pBSSEntry->wpa_ie, pcurrentptr,
+				pBSSEntry->wpa_ie_len);
+			lbs_dbg_hex("InterpretIE: Resp WPA_IE",
+				pBSSEntry->wpa_ie, elemlen);
 			break;
 		case WPA2_IE:
 			pIe = (struct IE_WPA *)pcurrentptr;
-			pwpa2_supplicant->wpa_ie_len
-			    = min_t(size_t, elemlen + IE_ID_LEN_FIELDS_BYTES,
-				  sizeof(pwpa2_supplicant->wpa_ie));
-			memcpy(pwpa2_supplicant->wpa_ie,
-			       pcurrentptr, pwpa2_supplicant->wpa_ie_len);
-
+			
+			pBSSEntry->rsn_ie_len = min_t(size_t,
+				elemlen + IE_ID_LEN_FIELDS_BYTES,
+				sizeof(pBSSEntry->rsn_ie));
+			memcpy(pBSSEntry->rsn_ie, pcurrentptr,
+				pBSSEntry->rsn_ie_len);
 			lbs_dbg_hex("InterpretIE: Resp WPA2_IE",
-				pwpa2_supplicant->wpa_ie, elemlen);
+				pBSSEntry->rsn_ie, elemlen);
 			break;
 		case TIM:
 			break;
@@ -1745,30 +1726,24 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
 		/* Add new value to event */
 		current_val = current_ev + IW_EV_LCP_LEN;
 
-		if (adapter->scantable[i].wpa2_supplicant.wpa_ie[0] == WPA2_IE) {
+		if (adapter->scantable[i].rsn_ie[0] == WPA2_IE) {
 			memset(&iwe, 0, sizeof(iwe));
 			memset(buf, 0, sizeof(buf));
-			memcpy(buf, adapter->scantable[i].
-						wpa2_supplicant.wpa_ie,
-					adapter->scantable[i].wpa2_supplicant.
-						wpa_ie_len);
+			memcpy(buf, adapter->scantable[i].rsn_ie,
+					adapter->scantable[i].rsn_ie_len);
 			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = adapter->scantable[i].
-					wpa2_supplicant.wpa_ie_len;
+			iwe.u.data.length = adapter->scantable[i].rsn_ie_len;
 			iwe.len = IW_EV_POINT_LEN + iwe.u.data.length;
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 					&iwe, buf);
 		}
-		if (adapter->scantable[i].wpa_supplicant.wpa_ie[0] == WPA_IE) {
+		if (adapter->scantable[i].wpa_ie[0] == WPA_IE) {
 			memset(&iwe, 0, sizeof(iwe));
 			memset(buf, 0, sizeof(buf));
-			memcpy(buf, adapter->scantable[i].
-						wpa_supplicant.wpa_ie,
-					adapter->scantable[i].wpa_supplicant.
-						wpa_ie_len);
+			memcpy(buf, adapter->scantable[i].wpa_ie,
+					adapter->scantable[i].wpa_ie_len);
 			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = adapter->scantable[i].
-					wpa_supplicant.wpa_ie_len;
+			iwe.u.data.length = adapter->scantable[i].wpa_ie_len;
 			iwe.len = IW_EV_POINT_LEN + iwe.u.data.length;
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 					&iwe, buf);
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index d93aa7f..1a8756e 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -10,6 +10,7 @@
 #ifndef _WLAN_SCAN_H
 #define _WLAN_SCAN_H
 
+#include <net/ieee80211.h>
 #include "hostcmd.h"
 
 /**
@@ -170,9 +171,10 @@ struct bss_descriptor {
 
 	struct ieeetypes_countryinfofullset countryinfo;
 
-	struct WPA_SUPPLICANT wpa_supplicant;
-	struct WPA_SUPPLICANT wpa2_supplicant;
-
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	size_t wpa_ie_len;
+	u8 rsn_ie[MAX_WPA_IE_LEN];
+	size_t rsn_ie_len;
 };
 
 extern int libertas_SSID_cmp(struct WLAN_802_11_SSID *ssid1,
-- 
1.5.0.6



