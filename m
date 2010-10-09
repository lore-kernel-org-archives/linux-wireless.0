Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0JIDqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 23:46:19 -0400
Received: by pwj4 with SMTP id 4so353562pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 20:46:19 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Steve deRosier <steve@cozybit.com>
Subject: [PATCH] mac80211: Update mesh constants to approved IEEE ANA values
Date: Fri,  8 Oct 2010 20:46:01 -0700
Message-Id: <1286595961-5593-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates IEEE802.11 mesh constants to be consistent with newly
approved values. It modifies some values, as well as adds many new constants
in preparation for updating mesh code to the current 802.11s drafts. ANA
numbers were taken from:
https://mentor.ieee.org/802.11/dcn/09/11-09-0031-12-0000-ana-database-assigned-number-authority.xls

A few notes are in order:
1. This will break backwards compatibility with existing Linux kernels as
over-the-air constants have changed.
2. Some old and obsolete constants have been retained for now as the mesh code
itself hasn't been updated yet to the new 802.11s draft. This was desired to
keep the existing mesh scheme working until it can be updated. Adding the
approved values is the first step in updating the mesh code.
3. Obsolete constants have been clearly marked.
4. All ANA approved 802.11s constants have been added.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 include/linux/ieee80211.h |   71 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 97b2eae..6fd405d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -986,6 +986,7 @@ struct ieee80211_ht_info {
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
 #define WLAN_AUTH_FT 2
+#define WLAN_AUTH_SAE 3
 #define WLAN_AUTH_LEAP 128
 
 #define WLAN_AUTH_CHALLENGE_LEN 128
@@ -1072,6 +1073,10 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_NO_DIRECT_LINK = 48,
 	WLAN_STATUS_STA_NOT_PRESENT = 49,
 	WLAN_STATUS_STA_NOT_QSTA = 50,
+	/* 802.11s */
+	WLAN_STATUS_ANTI_CLOG_REQUIRED = 76,
+	WLAN_STATUS_FCG_NOT_SUPP = 78,
+	WLAN_STATUS_STA_NO_TBTT = 78,
 };
 
 
@@ -1112,6 +1117,22 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_QSTA_REQUIRE_SETUP = 38,
 	WLAN_REASON_QSTA_TIMEOUT = 39,
 	WLAN_REASON_QSTA_CIPHER_NOT_SUPP = 45,
+	/* 802.11s */
+	WLAN_REASON_MESH_PEER_CANCLED = 52,
+	WLAN_REASON_MESH_MAX_PEERS = 53,
+	WLAN_REASON_MESH_CONFIG = 54,
+	WLAN_REASON_MESH_CLOSE = 55,
+	WLAN_REASON_MESH_MAX_RETRIES = 56,
+	WLAN_REASON_MESH_CONFIRM_TIMEOUT = 57,
+	WLAN_REASON_MESH_INVALID_GTK = 58,
+	WLAN_REASON_MESH_INCONSISTANT_PARAM = 59,
+	WLAN_REASON_MESH_INVALID_SECURITY = 60,
+	WLAN_REASON_MESH_PATH_ERROR = 61,
+	WLAN_REASON_MESH_PATH_NOFORWARD = 62,
+	WLAN_REASON_MESH_PATH_DEST_UNREACHABLE = 63,
+	WLAN_REASON_MAC_EXISTS_MBBS = 64,
+	WLAN_REASON_MESH_CHAN_REGULATORY = 65,
+	WLAN_REASON_MESH_CHAN = 66,
 };
 
 
@@ -1139,20 +1160,33 @@ enum ieee80211_eid {
 	WLAN_EID_TS_DELAY = 43,
 	WLAN_EID_TCLAS_PROCESSING = 44,
 	WLAN_EID_QOS_CAPA = 46,
-	/* 802.11s
-	 *
-	 * All mesh EID numbers are pending IEEE 802.11 ANA approval.
-	 * The numbers have been incremented from those suggested in
-	 * 802.11s/D2.0 so that MESH_CONFIG does not conflict with
-	 * EXT_SUPP_RATES.
+	/* 802.11s */
+	WLAN_EID_MESH_CONFIG = 113,
+	WLAN_EID_MESH_ID = 114,
+	WLAN_EID_LINK_METRIC_REPORT = 115,
+	WLAN_EID_CONGESTION_NOTIFICATION = 116,
+	/* Note that the Peer Link IE has been replaced with the similar
+	 * Peer Management IE.  We will keep the former definition until mesh
+	 * code is changed to comply with latest 802.11s drafts.
 	 */
-	WLAN_EID_MESH_CONFIG = 51,
-	WLAN_EID_MESH_ID = 52,
-	WLAN_EID_PEER_LINK = 55,
-	WLAN_EID_PREQ = 68,
-	WLAN_EID_PREP = 69,
-	WLAN_EID_PERR = 70,
-	WLAN_EID_RANN = 49,	/* compatible with FreeBSD */
+	WLAN_EID_PEER_LINK = 55,  /* no longer in 802.11s drafts */
+	WLAN_EID_PEER_MGMT = 117,
+	WLAN_EID_CHAN_SWITCH_PARAM = 118,
+	WLAN_EID_MESH_AWAKE_WINDOW = 119,
+	WLAN_EID_BEACON_TIMING = 120,
+	WLAN_EID_MCCAOP_SETUP_REQ = 121,
+	WLAN_EID_MCCAOP_SETUP_RESP = 122,
+	WLAN_EID_MCCAOP_ADVERT = 123,
+	WLAN_EID_MCCAOP_TEARDOWN = 124,
+	WLAN_EID_GANN = 125,
+	WLAN_EID_RANN = 126,
+	WLAN_EID_PREQ = 130,
+	WLAN_EID_PREP = 131,
+	WLAN_EID_PERR = 132,
+	WLAN_EID_PXU = 137,
+	WLAN_EID_PXUC = 138,
+	WLAN_EID_AUTH_MESH_PEER_EXCH = 139,
+	WLAN_EID_MIC = 140,
 
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
@@ -1211,9 +1245,14 @@ enum ieee80211_category {
 	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
+	WLAN_CATEGORY_MESH_ACTION = 13,
+	WLAN_CATEGORY_MULTIHOP_ACTION = 14,
+	WLAN_CATEGORY_SELF_PROTECTED = 15,
 	WLAN_CATEGORY_WMM = 17,
-	WLAN_CATEGORY_MESH_PLINK = 30,		/* Pending ANA approval */
-	WLAN_CATEGORY_MESH_PATH_SEL = 32,	/* Pending ANA approval */
+	/* TODO: remove MESH_PLINK and MESH_PATH_SEL after */
+	/*       mesh is updated to current 802.11s draft  */
+	WLAN_CATEGORY_MESH_PLINK = 30,
+	WLAN_CATEGORY_MESH_PATH_SEL = 32,
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
@@ -1351,6 +1390,8 @@ enum ieee80211_sa_query_action {
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X		0x000FAC01
 #define WLAN_AKM_SUITE_PSK		0x000FAC02
+#define WLAN_AKM_SUITE_SAE			0x000FAC08
+#define WLAN_AKM_SUITE_FT_OVER_SAE	0x000FAC09
 
 #define WLAN_MAX_KEY_LEN		32
 
-- 
1.7.0

