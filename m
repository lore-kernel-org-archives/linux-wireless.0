Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:32907 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaEUUKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:10:40 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so2533120wes.36
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:10:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6656: iocmd.h remove dead code.
Date: Wed, 21 May 2014 21:09:39 +0100
Message-Id: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com> (sfid-20140521_221044_314259_9ACF94BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead strutures and macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iocmd.h | 86 ------------------------------------------
 1 file changed, 86 deletions(-)

diff --git a/drivers/staging/vt6656/iocmd.h b/drivers/staging/vt6656/iocmd.h
index abf1f86..b957e6d 100644
--- a/drivers/staging/vt6656/iocmd.h
+++ b/drivers/staging/vt6656/iocmd.h
@@ -35,90 +35,4 @@ typedef enum tagWZONETYPE {
   ZoneType_Europe = 2
 } WZONETYPE;
 
-#define SSID_MAXLEN            32
-#define BSSID_LEN              6
-#define WEP_NKEYS              4
-#define WEP_KEYMAXLEN          29
-#define WEP_40BIT_LEN          5
-#define WEP_104BIT_LEN         13
-#define WEP_232BIT_LEN         16
-
-typedef struct tagSBSSIDItem {
-
-	u32	    uChannel;
-    u8      abyBSSID[BSSID_LEN];
-    u8      abySSID[SSID_MAXLEN + 1];
-    u16	    wBeaconInterval;
-    u16	    wCapInfo;
-    u8      byNetType;
-    bool    bWEPOn;
-    u32     uRSSI;
-
-} __packed SBSSIDItem;
-
-typedef struct tagSNodeItem {
-    // STA info
-    u16            wAID;
-    u8             abyMACAddr[6];
-    u16            wTxDataRate;
-    u16            wInActiveCount;
-    u16            wEnQueueCnt;
-    u16            wFlags;
-    bool           bPWBitOn;
-    u8             byKeyIndex;
-    u16            wWepKeyLength;
-    u8            abyWepKey[WEP_KEYMAXLEN];
-    // Auto rate fallback vars
-    bool           bIsInFallback;
-    u32            uTxFailures;
-    u32            uTxAttempts;
-    u16            wFailureRatio;
-
-} __packed SNodeItem;
-
-struct viawget_hostapd_param {
-	u32 cmd;
-	u8 sta_addr[6];
-	union {
-		struct {
-			u16 aid;
-			u16 capability;
-			u8 tx_supp_rates;
-		} add_sta;
-		struct {
-			u32 inactive_sec;
-		} get_info_sta;
-		struct {
-			u8 alg;
-			u32 flags;
-			u32 err;
-			u8 idx;
-			u8 seq[8];
-			u16 key_len;
-			u8 key[0];
-		} crypt;
-		struct {
-			u32 flags_and;
-			u32 flags_or;
-		} set_flags_sta;
-		struct {
-			u16 rid;
-			u16 len;
-			u8 data[0];
-		} rid;
-		struct {
-			u8 len;
-			u8 data[0];
-		} generic_elem;
-		struct {
-			u16 cmd;
-			u16 reason_code;
-		} mlme;
-		struct {
-			u8 ssid_len;
-			u8 ssid[32];
-		} scan_req;
-	} u;
-} __packed;
-
 #endif /* __IOCMD_H__ */
-- 
1.9.1

