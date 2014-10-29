Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35111 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2R6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:11 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so5323630wiv.9
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:10 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 38/48] staging: vt6655: dead code remove iowpa.h
Date: Wed, 29 Oct 2014 17:55:56 +0000
Message-Id: <1414605366-9335-39-git-send-email-tvboxspy@gmail.com> (sfid-20141029_191320_701305_E04CD7B1)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/iowpa.h       | 130 -----------------------------------
 2 files changed, 131 deletions(-)
 delete mode 100644 drivers/staging/vt6655/iowpa.h

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 2327369..d5ab7c4 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -64,7 +64,6 @@
 #include "rxtx.h"
 #include "dpc.h"
 #include "rf.h"
-#include "iowpa.h"
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/vt6655/iowpa.h b/drivers/staging/vt6655/iowpa.h
deleted file mode 100644
index 7f79eae..0000000
--- a/drivers/staging/vt6655/iowpa.h
+++ /dev/null
@@ -1,130 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * File: iowpa.h
- *
- * Purpose: Handles wpa supplicant ioctl interface
- *
- * Author: Lyndon Chen
- *
- * Date: May 8, 2002
- *
- */
-
-#ifndef __IOWPA_H__
-#define __IOWPA_H__
-
-#define WPA_IE_LEN 64
-
-/* WPA related */
-
-enum {
-	VIAWGET_SET_WPA = 1,
-	VIAWGET_SET_KEY = 2,
-	VIAWGET_SET_SCAN = 3,
-	VIAWGET_GET_SCAN = 4,
-	VIAWGET_GET_SSID = 5,
-	VIAWGET_GET_BSSID = 6,
-	VIAWGET_SET_DROP_UNENCRYPT = 7,
-	VIAWGET_SET_DEAUTHENTICATE = 8,
-	VIAWGET_SET_ASSOCIATE = 9,
-	VIAWGET_SET_DISASSOCIATE = 10
-};
-
-enum {
-	VIAWGET_ASSOC_MSG = 1,
-	VIAWGET_DISASSOC_MSG = 2,
-	VIAWGET_PTK_MIC_MSG = 3,
-	VIAWGET_GTK_MIC_MSG = 4,
-	VIAWGET_CCKM_ROAM_MSG = 5,
-	VIAWGET_DEVICECLOSE_MSG = 6
-};
-
-#pragma pack(1)
-typedef struct viawget_wpa_header {
-	u8 type;
-	u16 req_ie_len;
-	u16 resp_ie_len;
-} viawget_wpa_header;
-
-struct viawget_wpa_param {
-	u32 cmd;
-	u8 addr[6];
-	union {
-		struct {
-			u8 len;
-			u8 data[0];
-		} generic_elem;
-
-		struct {
-			u8 bssid[6];
-			u8 ssid[32];
-			u8 ssid_len;
-			u8 __user *wpa_ie;
-			u16 wpa_ie_len;
-			int pairwise_suite;
-			int group_suite;
-			int key_mgmt_suite;
-			int auth_alg;
-			int mode;
-
-		} wpa_associate;
-
-		struct {
-			int alg_name;
-			u16 key_index;
-			u16 set_tx;
-			u8 *seq;
-			u16 seq_len;
-			u8 *key;
-			u16 key_len;
-		} wpa_key;
-
-		struct {
-			u8 ssid_len;
-			u8 ssid[32];
-		} scan_req;
-
-		struct {
-			u16 scan_count;
-			u8 __user *buf;
-		} scan_results;
-
-	} u;
-};
-
-#pragma pack(1)
-struct viawget_scan_result {
-	u8 bssid[6];
-	u8 ssid[32];
-	u16 ssid_len;
-	u8 wpa_ie[WPA_IE_LEN];
-	u16 wpa_ie_len;
-	u8 rsn_ie[WPA_IE_LEN];
-	u16 rsn_ie_len;
-	int freq; /* MHz */
-	int caps; /* e.g. privacy */
-	int qual; /* signal quality */
-	int noise;
-	int level;
-	int maxrate;
-};
-
-#pragma pack()
-
-#endif /* __IOWPA_H__ */
-- 
2.1.0

