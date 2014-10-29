Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51617 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2R6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:19 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so5334331wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 42/48] staging: vt6655: device.h remove dead strutures and macros
Date: Wed, 29 Oct 2014 17:56:00 +0000
Message-Id: <1414605366-9335-43-git-send-email-tvboxspy@gmail.com> (sfid-20141029_191320_828283_55F900A5)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 76 -----------------------------------------
 1 file changed, 76 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index bc33b2d..79c4ae0 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -147,16 +147,6 @@
 
 #define	NUM				64
 
-#define PRIVATE_Message                 0
-
-/*---------------------  Export Types  ------------------------------*/
-
-#define PRINT_K(p, args...)		\
-do {					\
-	if (PRIVATE_Message)		\
-		printk(p, ##args);	\
-} while (0)
-
 /* 0:11A 1:11B 2:11G */
 typedef enum _VIA_BB_TYPE
 {
@@ -174,57 +164,6 @@ typedef enum _VIA_PKT_TYPE
 	PK_TYPE_11GA
 } VIA_PKT_TYPE, *PVIA_PKT_TYPE;
 
-typedef enum __device_msg_level {
-	MSG_LEVEL_ERR = 0,	/* Errors that will cause abnormal operation. */
-	MSG_LEVEL_NOTICE = 1,	/* Some errors need users to be notified. */
-	MSG_LEVEL_INFO = 2,	/* Normal message. */
-	MSG_LEVEL_VERBOSE = 3,	/* Will report all trival errors. */
-	MSG_LEVEL_DEBUG = 4	/* Only for debug purpose. */
-} DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
-
-/* NDIS related */
-#define MAX_BSSIDINFO_4_PMKID   16
-#define MAX_PMKIDLIST           5
-/* Flags for PMKID Candidate list structure */
-#define NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED	0x01
-
-/* PMKID Structures */
-typedef unsigned char NDIS_802_11_PMKID_VALUE[16];
-
-typedef enum _NDIS_802_11_WEP_STATUS {
-	Ndis802_11WEPEnabled,
-	Ndis802_11Encryption1Enabled = Ndis802_11WEPEnabled,
-	Ndis802_11WEPDisabled,
-	Ndis802_11EncryptionDisabled = Ndis802_11WEPDisabled,
-	Ndis802_11WEPKeyAbsent,
-	Ndis802_11Encryption1KeyAbsent = Ndis802_11WEPKeyAbsent,
-	Ndis802_11WEPNotSupported,
-	Ndis802_11EncryptionNotSupported = Ndis802_11WEPNotSupported,
-	Ndis802_11Encryption2Enabled,
-	Ndis802_11Encryption2KeyAbsent,
-	Ndis802_11Encryption3Enabled,
-	Ndis802_11Encryption3KeyAbsent
-} NDIS_802_11_WEP_STATUS, *PNDIS_802_11_WEP_STATUS,
-	NDIS_802_11_ENCRYPTION_STATUS, *PNDIS_802_11_ENCRYPTION_STATUS;
-
-typedef enum _NDIS_802_11_STATUS_TYPE {
-	Ndis802_11StatusType_Authentication,
-	Ndis802_11StatusType_MediaStreamMode,
-	Ndis802_11StatusType_PMKID_CandidateList,
-	Ndis802_11StatusTypeMax    /* defined as an upper bound */
-} NDIS_802_11_STATUS_TYPE, *PNDIS_802_11_STATUS_TYPE;
-
-
-/* 802.11h related */
-#define MAX_QUIET_COUNT     8
-
-typedef struct tagSQuietControl {
-	bool bEnable;
-	unsigned long dwStartTime;
-	unsigned char byPeriod;
-	unsigned short wDuration;
-} SQuietControl, *PSQuietControl;
-
 typedef struct __chip_info_tbl {
 	CHIP_TYPE   chip_id;
 	char *name;
@@ -238,20 +177,6 @@ typedef enum {
 	OWNED_BY_NIC = 1
 } DEVICE_OWNER_TYPE, *PDEVICE_OWNER_TYPE;
 
-/* The receive duplicate detection cache entry */
-typedef struct tagSCacheEntry {
-	unsigned short wFmSequence;
-	unsigned char abyAddr2[ETH_ALEN];
-} SCacheEntry, *PSCacheEntry;
-
-typedef struct tagSCache {
-/* The receive cache is updated circularly. The next entry to be written is
- * indexed by the "InPtr".
- */
-	unsigned int uInPtr;         /* Place to use next */
-	SCacheEntry     asCacheEntry[DUPLICATE_RX_CACHE_LENGTH];
-} SCache, *PSCache;
-
 #define CB_MAX_RX_FRAG                 64
 /* DeFragment Control Block, used for collecting fragments prior to reassembly */
 typedef struct tagSDeFragControlBlock {
@@ -361,7 +286,6 @@ struct vnt_private {
 	volatile PSRxDesc           aRD0Ring;
 	volatile PSRxDesc           aRD1Ring;
 	volatile PSRxDesc           pCurrRD[TYPE_MAXRD];
-	SCache                      sDupRxCache;
 
 	SDeFragControlBlock         sRxDFCB[CB_MAX_RX_FRAG];
 	unsigned int	cbDFCB;
-- 
2.1.0

