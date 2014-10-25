Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64859 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaJYT1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:27:52 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so3508040wiv.9
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:27:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 42/48] staging: vt6655: device.h remove dead strutures and macros
Date: Sat, 25 Oct 2014 09:40:20 +0100
Message-Id: <1414226426-5811-43-git-send-email-tvboxspy@gmail.com> (sfid-20141025_212755_733660_B08DA2CE)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 77 -----------------------------------------
 1 file changed, 77 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a26e904..c8f1a3e 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -151,16 +151,6 @@
 
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
 //0:11A 1:11B 2:11G
 typedef enum _VIA_BB_TYPE
 {
@@ -178,58 +168,6 @@ typedef enum _VIA_PKT_TYPE
 	PK_TYPE_11GA
 } VIA_PKT_TYPE, *PVIA_PKT_TYPE;
 
-typedef enum __device_msg_level {
-	MSG_LEVEL_ERR = 0,            //Errors that will cause abnormal operation.
-	MSG_LEVEL_NOTICE = 1,         //Some errors need users to be notified.
-	MSG_LEVEL_INFO = 2,           //Normal message.
-	MSG_LEVEL_VERBOSE = 3,        //Will report all trival errors.
-	MSG_LEVEL_DEBUG = 4           //Only for debug purpose.
-} DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
-
-//++ NDIS related
-
-#define MAX_BSSIDINFO_4_PMKID   16
-#define MAX_PMKIDLIST           5
-//Flags for PMKID Candidate list structure
-#define NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED	0x01
-
-// PMKID Structures
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
-	Ndis802_11StatusTypeMax    // not a real type, defined as an upper bound
-} NDIS_802_11_STATUS_TYPE, *PNDIS_802_11_STATUS_TYPE;
-
-//++ 802.11h related
-#define MAX_QUIET_COUNT     8
-
-typedef struct tagSQuietControl {
-	bool bEnable;
-	unsigned long dwStartTime;
-	unsigned char byPeriod;
-	unsigned short wDuration;
-} SQuietControl, *PSQuietControl;
-
-//--
 typedef struct __chip_info_tbl {
 	CHIP_TYPE   chip_id;
 	char *name;
@@ -243,20 +181,6 @@ typedef enum {
 	OWNED_BY_NIC = 1
 } DEVICE_OWNER_TYPE, *PDEVICE_OWNER_TYPE;
 
-// The receive duplicate detection cache entry
-typedef struct tagSCacheEntry {
-	unsigned short wFmSequence;
-	unsigned char abyAddr2[ETH_ALEN];
-} SCacheEntry, *PSCacheEntry;
-
-typedef struct tagSCache {
-/* The receive cache is updated circularly.  The next entry to be written is
- * indexed by the "InPtr".
- */
-	unsigned int uInPtr;         // Place to use next
-	SCacheEntry     asCacheEntry[DUPLICATE_RX_CACHE_LENGTH];
-} SCache, *PSCache;
-
 #define CB_MAX_RX_FRAG                 64
 // DeFragment Control Block, used for collecting fragments prior to reassembly
 typedef struct tagSDeFragControlBlock {
@@ -366,7 +290,6 @@ struct vnt_private {
 	volatile PSRxDesc           aRD0Ring;
 	volatile PSRxDesc           aRD1Ring;
 	volatile PSRxDesc           pCurrRD[TYPE_MAXRD];
-	SCache                      sDupRxCache;
 
 	SDeFragControlBlock         sRxDFCB[CB_MAX_RX_FRAG];
 	unsigned int	cbDFCB;
-- 
1.9.1

