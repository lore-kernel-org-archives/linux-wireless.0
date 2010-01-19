Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33926 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab0ASWP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 17:15:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas/assoc.c: rearrange some strange line breaks
Date: Tue, 19 Jan 2010 17:09:16 -0500
Message-Id: <1263938956-19160-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/assoc.c |   62 ++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index fb3dff0..0979b07 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1160,11 +1160,11 @@ int lbs_adhoc_stop(struct lbs_private *priv)
 static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
 					struct bss_descriptor *match_bss)
 {
-	if (!secinfo->wep_enabled  && !secinfo->WPAenabled
-	    && !secinfo->WPA2enabled
-	    && match_bss->wpa_ie[0] != WLAN_EID_GENERIC
-	    && match_bss->rsn_ie[0] != WLAN_EID_RSN
-	    && !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
+	if (!secinfo->wep_enabled &&
+	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
+	    match_bss->wpa_ie[0] != WLAN_EID_GENERIC &&
+	    match_bss->rsn_ie[0] != WLAN_EID_RSN &&
+	    !(match_bss->capability & WLAN_CAPABILITY_PRIVACY))
 		return 1;
 	else
 		return 0;
@@ -1173,9 +1173,9 @@ static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
 static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
 				       struct bss_descriptor *match_bss)
 {
-	if (secinfo->wep_enabled && !secinfo->WPAenabled
-	    && !secinfo->WPA2enabled
-	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
+	if (secinfo->wep_enabled &&
+	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
+	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
 		return 1;
 	else
 		return 0;
@@ -1184,8 +1184,8 @@ static inline int match_bss_static_wep(struct lbs_802_11_security *secinfo,
 static inline int match_bss_wpa(struct lbs_802_11_security *secinfo,
 				struct bss_descriptor *match_bss)
 {
-	if (!secinfo->wep_enabled && secinfo->WPAenabled
-	    && (match_bss->wpa_ie[0] == WLAN_EID_GENERIC)
+	if (!secinfo->wep_enabled && secinfo->WPAenabled &&
+	    (match_bss->wpa_ie[0] == WLAN_EID_GENERIC)
 	    /* privacy bit may NOT be set in some APs like LinkSys WRT54G
 	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY) */
 	   )
@@ -1210,11 +1210,11 @@ static inline int match_bss_wpa2(struct lbs_802_11_security *secinfo,
 static inline int match_bss_dynamic_wep(struct lbs_802_11_security *secinfo,
 					struct bss_descriptor *match_bss)
 {
-	if (!secinfo->wep_enabled && !secinfo->WPAenabled
-	    && !secinfo->WPA2enabled
-	    && (match_bss->wpa_ie[0] != WLAN_EID_GENERIC)
-	    && (match_bss->rsn_ie[0] != WLAN_EID_RSN)
-	    && (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
+	if (!secinfo->wep_enabled &&
+	    !secinfo->WPAenabled && !secinfo->WPA2enabled &&
+	    (match_bss->wpa_ie[0] != WLAN_EID_GENERIC) &&
+	    (match_bss->rsn_ie[0] != WLAN_EID_RSN) &&
+	    (match_bss->capability & WLAN_CAPABILITY_PRIVACY))
 		return 1;
 	else
 		return 0;
@@ -1525,8 +1525,8 @@ static int assoc_helper_associate(struct lbs_private *priv,
 	/* If we're given and 'any' BSSID, try associating based on SSID */
 
 	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		if (compare_ether_addr(bssid_any, assoc_req->bssid)
-		    && compare_ether_addr(bssid_off, assoc_req->bssid)) {
+		if (compare_ether_addr(bssid_any, assoc_req->bssid) &&
+		    compare_ether_addr(bssid_off, assoc_req->bssid)) {
 			ret = assoc_helper_bssid(priv, assoc_req);
 			done = 1;
 		}
@@ -1612,11 +1612,9 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		goto restore_mesh;
 	}
 
-	if (   assoc_req->secinfo.wep_enabled
-	    &&   (assoc_req->wep_keys[0].len
-	       || assoc_req->wep_keys[1].len
-	       || assoc_req->wep_keys[2].len
-	       || assoc_req->wep_keys[3].len)) {
+	if (assoc_req->secinfo.wep_enabled &&
+	    (assoc_req->wep_keys[0].len || assoc_req->wep_keys[1].len ||
+	     assoc_req->wep_keys[2].len || assoc_req->wep_keys[3].len)) {
 		/* Make sure WEP keys are re-sent to firmware */
 		set_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags);
 	}
@@ -1983,14 +1981,14 @@ void lbs_association_worker(struct work_struct *work)
 		assoc_req->secinfo.auth_mode);
 
 	/* If 'any' SSID was specified, find an SSID to associate with */
-	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)
-	    && !assoc_req->ssid_len)
+	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags) &&
+	    !assoc_req->ssid_len)
 		find_any_ssid = 1;
 
 	/* But don't use 'any' SSID if there's a valid locked BSSID to use */
 	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		if (compare_ether_addr(assoc_req->bssid, bssid_any)
-		    && compare_ether_addr(assoc_req->bssid, bssid_off))
+		if (compare_ether_addr(assoc_req->bssid, bssid_any) &&
+		    compare_ether_addr(assoc_req->bssid, bssid_off))
 			find_any_ssid = 0;
 	}
 
@@ -2064,15 +2062,15 @@ void lbs_association_worker(struct work_struct *work)
 			goto out;
 	}
 
-	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)
-	    || test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
+	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags) ||
+	    test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
 		ret = assoc_helper_wpa_keys(priv, assoc_req);
 		if (ret)
 			goto out;
 	}
 
-	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
-	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
+	if (test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags) ||
+	    test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
 		ret = assoc_helper_wep_keys(priv, assoc_req);
 		if (ret)
 			goto out;
@@ -2082,8 +2080,8 @@ void lbs_association_worker(struct work_struct *work)
 	/* SSID/BSSID should be the _last_ config option set, because they
 	 * trigger the association attempt.
 	 */
-	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)
-	    || test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
+	if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags) ||
+	    test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
 		int success = 1;
 
 		ret = assoc_helper_associate(priv, assoc_req);
-- 
1.6.2.5

