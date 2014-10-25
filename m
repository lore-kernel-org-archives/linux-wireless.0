Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:32775 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaJYTh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:37:27 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so3152224wgh.29
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:37:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 45/48] staging: vt6655: Move LIFETIME RES 64us macros to rxtx.h
Date: Sat, 25 Oct 2014 09:40:23 +0100
Message-Id: <1414226426-5811-46-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213734_119907_E02F9086)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used only by vnt_generate_fifo_header move these macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.h | 4 ++++
 drivers/staging/vt6655/wmgr.h | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 50d77a0..cf0dfa6 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -32,6 +32,10 @@
 #include "ttype.h"
 #include "device.h"
 
+#define DEFAULT_MSDU_LIFETIME_RES_64us	8000 /* 64us */
+#define DEFAULT_MGN_LIFETIME_RES_64us	125  /* 64us */
+
+
 /*---------------------  Export Definitions -------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 74f1f16..daf996c 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -51,10 +51,8 @@
 #define WCMD_PASSIVE_SCAN_TIME  100 //(ms)
 
 #define DEFAULT_MSDU_LIFETIME           512  // ms
-#define DEFAULT_MSDU_LIFETIME_RES_64us  8000 // 64us
 
 #define DEFAULT_MGN_LIFETIME            8    // ms
-#define DEFAULT_MGN_LIFETIME_RES_64us   125  // 64us
 
 #define MAKE_BEACON_RESERVED            10  //(us)
 
-- 
1.9.1

