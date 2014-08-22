Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:63337 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaHVVfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 17:35:52 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so11104402wes.35
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 14:35:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/3] staging: vt6655: 80211mgr.h add ieee80211.h header and fix conflicts
Date: Fri, 22 Aug 2014 22:35:09 +0100
Message-Id: <1408743311-13177-1-git-send-email-tvboxspy@gmail.com> (sfid-20140822_233555_769902_0BFD4164)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix conflict with WLAN_EID macros, by removing them.

This allows the adding other definitions from the ieee80211 header.

Eventually the 80211mgr.h header will be removed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/80211mgr.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/80211mgr.h b/drivers/staging/vt6655/80211mgr.h
index 94fb93d..d462a8a 100644
--- a/drivers/staging/vt6655/80211mgr.h
+++ b/drivers/staging/vt6655/80211mgr.h
@@ -32,6 +32,7 @@
 #define __80211MGR_H__
 
 #include <linux/types.h>
+#include "linux/ieee80211.h"
 
 #include "ttype.h"
 #include "80211hdr.h"
@@ -39,17 +40,10 @@
 #define WLAN_MIN_ARRAY          1
 
 /* Information Element ID value */
-#define WLAN_EID_SSID           0
-#define WLAN_EID_SUPP_RATES     1
 #define WLAN_EID_FH_PARMS       2
 #define WLAN_EID_DS_PARMS       3
 #define WLAN_EID_CF_PARMS       4
-#define WLAN_EID_TIM            5
 #define WLAN_EID_IBSS_PARMS     6
-#define WLAN_EID_COUNTRY        7
-#define WLAN_EID_CHALLENGE      16
-#define WLAN_EID_PWR_CONSTRAINT 32
-#define WLAN_EID_PWR_CAPABILITY 33
 #define WLAN_EID_TPC_REQ        34
 #define WLAN_EID_TPC_REP        35
 #define WLAN_EID_SUPP_CH        36
@@ -60,7 +54,6 @@
 #define WLAN_EID_IBSS_DFS       41
 #define WLAN_EID_ERP            42
 /* reference 802.11i 7.3.2 table 20 */
-#define WLAN_EID_RSN            48
 #define WLAN_EID_EXTSUPP_RATES  50
 /* reference WiFi WPA spec. */
 #define WLAN_EID_RSN_WPA        221
-- 
1.9.1

