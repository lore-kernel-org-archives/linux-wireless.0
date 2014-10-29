Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58384 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaJ2R6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:24 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so3919387wgh.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 45/48] staging: vt6655: Move LIFETIME RES 64us macros to rxtx.h
Date: Wed, 29 Oct 2014 17:56:03 +0000
Message-Id: <1414605366-9335-46-git-send-email-tvboxspy@gmail.com> (sfid-20141029_191321_072827_0F9732A8)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
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
2.1.0

