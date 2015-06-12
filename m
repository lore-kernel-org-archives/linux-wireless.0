Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37482 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbbFLJwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 05:52:43 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH] staging: wilc1000: remove warnings reported by checkpatch.pl.
Date: Fri, 12 Jun 2015 18:51:56 +0900
Message-ID: <1434102716-3476-1-git-send-email-dean.lee@atmel.com> (sfid-20150612_115504_198030_39C352DC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the following warnings in the wilc_log.h:
- unnecessary whitespace before a quoted newline
- line over 80 characters
- single statement macros should not use a do {} while (0) loop.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_log.h | 53 +++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_log.h b/drivers/staging/wilc1000/wilc_log.h
index 2269ebd..93f467a 100644
--- a/drivers/staging/wilc1000/wilc_log.h
+++ b/drivers/staging/wilc1000/wilc_log.h
@@ -2,46 +2,53 @@
 #define __WILC_LOG_H__
 
 /* Errors will always get printed */
-#define WILC_ERROR(...) do {  WILC_PRINTF("(ERR)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			      WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_ERROR(...)							\
+do {									\
+	WILC_PRINTF("(ERR)(%s:%d)", __WILC_FUNCTION__, __WILC_LINE__);	\
+	WILC_PRINTF(__VA_ARGS__);					\
+} while (0)
 
 /* Wraning only printed if verbosity is 1 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 0)
-#define WILC_WARN(...) do { WILC_PRINTF("(WRN)"); \
-			    WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_WARN(...)				\
+do {						\
+	WILC_PRINTF("(WRN)");			\
+	WILC_PRINTF(__VA_ARGS__);		\
+} while (0)
 #else
-#define WILC_WARN(...) (0)
+#define WILC_WARN(...)	(0)
 #endif
 
 /* Info only printed if verbosity is 2 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 1)
-#define WILC_INFO(...) do {  WILC_PRINTF("(INF)"); \
-			     WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_INFO(...)				\
+do {						\
+	WILC_PRINTF("(INF)");			\
+	WILC_PRINTF(__VA_ARGS__);		\
+} while (0)
 #else
-#define WILC_INFO(...) (0)
+#define WILC_INFO(...)	(0)
 #endif
 
 /* Debug is only printed if verbosity is 3 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 2)
-#define WILC_DBG(...) do { WILC_PRINTF("(DBG)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			   WILC_PRINTF(__VA_ARGS__); \
-			} while (0)
-
+#define WILC_DBG(...)							\
+do {									\
+	WILC_PRINTF("(DBG)(%s:%d)", __WILC_FUNCTION__, __WILC_LINE__);	\
+	WILC_PRINTF(__VA_ARGS__);					\
+} while (0)
 #else
-#define WILC_DBG(...) (0)
+#define WILC_DBG(...)	(0)
 #endif
 
 /* Function In/Out is only printed if verbosity is 4 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 3)
-#define WILC_FN_IN do { WILC_PRINTF("(FIN) (%s:%d) \n", __WILC_FUNCTION__, __WILC_LINE__);  } while (0)
-#define WILC_FN_OUT(ret) do { WILC_PRINTF("(FOUT) (%s:%d) %d.\n", __WILC_FUNCTION__, __WILC_LINE__, (ret));  } while (0)
+#define WILC_FN_IN		\
+	WILC_PRINTF("(FIN)(%s:%d)\n", __WILC_FUNCTION__, __WILC_LINE__)
+#define WILC_FN_OUT(ret)	\
+	WILC_PRINTF("(FOUT)(%s:%d)%d\n", __WILC_FUNCTION__, __WILC_LINE__, ret)
 #else
-#define WILC_FN_IN (0)
-#define WILC_FN_OUT(ret) (0)
+#define WILC_FN_IN		(0)
+#define WILC_FN_OUT(ret)	(0)
+#endif
 #endif
-
-
-#endif
\ No newline at end of file
-- 
2.4.3

