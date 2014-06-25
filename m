Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:55128 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaFYUU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:20:57 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so2660670wev.6
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:20:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/34] staging: vt6656: move life time macros to rxtx.h
Date: Wed, 25 Jun 2014 21:19:39 +0100
Message-Id: <1403727611-6825-3-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222106_296727_C4E083D6)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DEFAULT_MGN_LIFETIME_RES_64us
DEFAULT_MSDU_LIFETIME_RES_64us

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.h | 3 +++
 drivers/staging/vt6656/wmgr.h | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 65f7e26..00a5c22 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -33,6 +33,9 @@
 #include "wcmd.h"
 #include "baseband.h"
 
+#define DEFAULT_MGN_LIFETIME_RES_64us	125  /* 64us */
+#define DEFAULT_MSDU_LIFETIME_RES_64us  8000
+
 /* MIC HDR data header */
 struct vnt_mic_hdr {
 	u8 id;
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 26ba47d..b6610a1 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -53,10 +53,8 @@
 #define WCMD_PASSIVE_SCAN_TIME  100 //(ms)
 
 #define DEFAULT_MSDU_LIFETIME           512  // ms
-#define DEFAULT_MSDU_LIFETIME_RES_64us  8000 // 64us
 
 #define DEFAULT_MGN_LIFETIME            8    // ms
-#define DEFAULT_MGN_LIFETIME_RES_64us   125  // 64us
 
 #define MAKE_BEACON_RESERVED            10  //(us)
 
-- 
1.9.1

