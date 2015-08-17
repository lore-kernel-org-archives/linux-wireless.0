Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33903 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbbHQNok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:44:40 -0400
Received: by paccq16 with SMTP id cq16so65420959pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2015 06:44:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: delete wilc_log.h
Date: Mon, 17 Aug 2015 22:44:28 +0900
Message-Id: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_154443_806034_8CDDBACF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macros in wilc_log.h are not referenced anywhere, so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_log.h       | 47 -------------------------------
 drivers/staging/wilc1000/wilc_oswrapper.h |  2 --
 2 files changed, 49 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_log.h

diff --git a/drivers/staging/wilc1000/wilc_log.h b/drivers/staging/wilc1000/wilc_log.h
deleted file mode 100644
index 2269ebd..0000000
--- a/drivers/staging/wilc1000/wilc_log.h
+++ /dev/null
@@ -1,47 +0,0 @@
-#ifndef __WILC_LOG_H__
-#define __WILC_LOG_H__
-
-/* Errors will always get printed */
-#define WILC_ERROR(...) do {  WILC_PRINTF("(ERR)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			      WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
-
-/* Wraning only printed if verbosity is 1 or more */
-#if (WILC_LOG_VERBOSITY_LEVEL > 0)
-#define WILC_WARN(...) do { WILC_PRINTF("(WRN)"); \
-			    WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
-#else
-#define WILC_WARN(...) (0)
-#endif
-
-/* Info only printed if verbosity is 2 or more */
-#if (WILC_LOG_VERBOSITY_LEVEL > 1)
-#define WILC_INFO(...) do {  WILC_PRINTF("(INF)"); \
-			     WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
-#else
-#define WILC_INFO(...) (0)
-#endif
-
-/* Debug is only printed if verbosity is 3 or more */
-#if (WILC_LOG_VERBOSITY_LEVEL > 2)
-#define WILC_DBG(...) do { WILC_PRINTF("(DBG)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			   WILC_PRINTF(__VA_ARGS__); \
-			} while (0)
-
-#else
-#define WILC_DBG(...) (0)
-#endif
-
-/* Function In/Out is only printed if verbosity is 4 or more */
-#if (WILC_LOG_VERBOSITY_LEVEL > 3)
-#define WILC_FN_IN do { WILC_PRINTF("(FIN) (%s:%d) \n", __WILC_FUNCTION__, __WILC_LINE__);  } while (0)
-#define WILC_FN_OUT(ret) do { WILC_PRINTF("(FOUT) (%s:%d) %d.\n", __WILC_FUNCTION__, __WILC_LINE__, (ret));  } while (0)
-#else
-#define WILC_FN_IN (0)
-#define WILC_FN_OUT(ret) (0)
-#endif
-
-
-#endif
\ No newline at end of file
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 374e33b..68e091f 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -17,8 +17,6 @@
 #include "wilc_osconfig.h"
 #include "wilc_platform.h"
 
-/* Logging Functions */
-#include "wilc_log.h"
 
 /* Error reporting and handling support */
 #include "wilc_errorsupport.h"
-- 
1.9.1

