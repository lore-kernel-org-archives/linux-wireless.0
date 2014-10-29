Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59830 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2R6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:02 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2436264wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 33/48] staging: vt6655: dead code remove ndis and pmkid strutures.
Date: Wed, 29 Oct 2014 17:55:51 +0000
Message-Id: <1414605366-9335-34-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185814_043319_33B50AA9)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct pmkid_candidate
typedef struct _BSSID_INFO
typedef struct tagSPMKID
typedef struct tagSPMKIDCandidateEvent
NDIS_802_11_MAC_ADDRESS
typedef struct _NDIS_802_11_AI_REQFI
typedef struct _NDIS_802_11_AI_RESFI
typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION
typedef struct tagSAssocInfo

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 26 --------------------------
 drivers/staging/vt6655/wmgr.h   | 35 -----------------------------------
 2 files changed, 61 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index d2779a3..0725d78 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -216,29 +216,6 @@ typedef enum _NDIS_802_11_STATUS_TYPE {
 	Ndis802_11StatusTypeMax    /* defined as an upper bound */
 } NDIS_802_11_STATUS_TYPE, *PNDIS_802_11_STATUS_TYPE;
 
-/* Added new types for PMKID Candidate lists. */
-struct pmkid_candidate {
-	NDIS_802_11_MAC_ADDRESS BSSID;
-	unsigned long Flags;
-};
-
-typedef struct _BSSID_INFO {
-	NDIS_802_11_MAC_ADDRESS BSSID;
-	NDIS_802_11_PMKID_VALUE PMKID;
-} BSSID_INFO, *PBSSID_INFO;
-
-typedef struct tagSPMKID {
-	unsigned long Length;
-	unsigned long BSSIDInfoCount;
-	BSSID_INFO BSSIDInfo[MAX_BSSIDINFO_4_PMKID];
-} SPMKID, *PSPMKID;
-
-typedef struct tagSPMKIDCandidateEvent {
-	NDIS_802_11_STATUS_TYPE     StatusType;
-	unsigned long Version;       /* Version of the structure */
-	unsigned long NumCandidates; /* No. of pmkid candidates */
-	struct pmkid_candidate CandidateList[MAX_PMKIDLIST];
-} SPMKIDCandidateEvent, *PSPMKIDCandidateEvent;
 
 /* 802.11h related */
 #define MAX_QUIET_COUNT     8
@@ -667,9 +644,6 @@ struct vnt_private {
 	unsigned char abySNAP_RFC1042[ETH_ALEN];
 	unsigned char abySNAP_Bridgetunnel[ETH_ALEN];
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
-	/* Pre-Authentication & PMK cache */
-	SPMKID                  gsPMKID;
-	SPMKIDCandidateEvent    gsPMKIDCandidate;
 
 	/* for 802.11h */
 	bool b11hEnable;
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 1deedd8..cc8662e 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -78,39 +78,4 @@
 #define timer_expire(timer, next_tick)   mod_timer(&timer, RUN_AT(next_tick))
 typedef void (*TimerFunction)(unsigned long);
 
-//+++ NDIS related
-
-typedef unsigned char NDIS_802_11_MAC_ADDRESS[6];
-typedef struct _NDIS_802_11_AI_REQFI {
-	unsigned short Capabilities;
-	unsigned short ListenInterval;
-	NDIS_802_11_MAC_ADDRESS  CurrentAPAddress;
-} NDIS_802_11_AI_REQFI, *PNDIS_802_11_AI_REQFI;
-
-typedef struct _NDIS_802_11_AI_RESFI {
-	unsigned short Capabilities;
-	unsigned short StatusCode;
-	unsigned short AssociationId;
-} NDIS_802_11_AI_RESFI, *PNDIS_802_11_AI_RESFI;
-
-typedef struct _NDIS_802_11_ASSOCIATION_INFORMATION {
-	unsigned long Length;
-	unsigned short          AvailableRequestFixedIEs;
-	NDIS_802_11_AI_REQFI    RequestFixedIEs;
-	unsigned long RequestIELength;
-	unsigned long OffsetRequestIEs;
-	unsigned short          AvailableResponseFixedIEs;
-	NDIS_802_11_AI_RESFI    ResponseFixedIEs;
-	unsigned long ResponseIELength;
-	unsigned long OffsetResponseIEs;
-} NDIS_802_11_ASSOCIATION_INFORMATION, *PNDIS_802_11_ASSOCIATION_INFORMATION;
-
-typedef struct tagSAssocInfo {
-	NDIS_802_11_ASSOCIATION_INFORMATION     AssocInfo;
-	unsigned char abyIEs[WLAN_BEACON_FR_MAXLEN+WLAN_BEACON_FR_MAXLEN];
-	// store ReqIEs set by OID_802_11_ASSOCIATION_INFORMATION
-	unsigned long RequestIELength;
-	unsigned char abyReqIEs[WLAN_BEACON_FR_MAXLEN];
-} SAssocInfo, *PSAssocInfo;
-
 #endif // __WMGR_H__
-- 
2.1.0

