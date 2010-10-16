Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JPR0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 13:26:37 -0400
Received: by bwz15 with SMTP id 15so1856587bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Oct 2010 10:26:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: fix memory leak issue in async cmd macro wrappers
Date: Sat, 16 Oct 2010 20:47:50 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010162047.50476.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch continues where the previous commit:
	"carl9170: fix async command buffer leak"
left off.

Similar to carl9170_reboot/carl9170_powersave, the
carl9170_async_regwrite* macros would leak the
temporary command buffer, if __carl9170_exec_cmd
fails to upload the command to the device.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/cmd.h b/drivers/net/wireless/ath/carl9170/cmd.h
index f78728c..568174c 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.h
+++ b/drivers/net/wireless/ath/carl9170/cmd.h
@@ -116,8 +116,9 @@ __regwrite_out :							\
 } while (0);
 
 
-#define carl9170_async_get_buf()					\
+#define carl9170_async_regwrite_get_buf()				\
 do {									\
+	__nreg = 0;							\
 	__cmd = carl9170_cmd_buf(__carl, CARL9170_CMD_WREG_ASYNC,	\
 				 CARL9170_MAX_CMD_PAYLOAD_LEN);		\
 	if (__cmd == NULL) {						\
@@ -128,38 +129,42 @@ do {									\
 
 #define carl9170_async_regwrite_begin(carl)				\
 do {									\
-	int __nreg = 0, __err = 0;					\
 	struct ar9170 *__carl = carl;					\
 	struct carl9170_cmd *__cmd;					\
-	carl9170_async_get_buf();					\
+	unsigned int __nreg;						\
+	int  __err = 0;							\
+	carl9170_async_regwrite_get_buf();				\
+
+#define carl9170_async_regwrite_flush()					\
+do {									\
+	if (__cmd == NULL || __nreg == 0)				\
+		break;							\
+									\
+	if (IS_ACCEPTING_CMD(__carl) && __nreg) {			\
+		__cmd->hdr.len = 8 * __nreg;				\
+		__err = __carl9170_exec_cmd(__carl, __cmd, true);	\
+		__cmd = NULL;						\
+		break;							\
+	}								\
+	goto __async_regwrite_out;					\
+} while (0)
 
 #define carl9170_async_regwrite(r, v) do {				\
+	if (__cmd == NULL)						\
+		carl9170_async_regwrite_get_buf();			\
 	__cmd->wreg.regs[__nreg].addr = cpu_to_le32(r);			\
 	__cmd->wreg.regs[__nreg].val = cpu_to_le32(v);			\
 	__nreg++;							\
-	if ((__nreg >= PAYLOAD_MAX/2)) {				\
-		if (IS_ACCEPTING_CMD(__carl)) {				\
-			__cmd->hdr.len = 8 * __nreg;			\
-			__err = __carl9170_exec_cmd(__carl, __cmd, true);\
-			__cmd = NULL;					\
-			carl9170_async_get_buf();			\
-		} else {						\
-			goto __async_regwrite_out;			\
-		}							\
-		__nreg = 0;						\
-		if (__err)						\
-			goto __async_regwrite_out;			\
-	}								\
+	if ((__nreg >= PAYLOAD_MAX / 2))				\
+		carl9170_async_regwrite_flush();			\
 } while (0)
 
-#define carl9170_async_regwrite_finish()				\
+#define carl9170_async_regwrite_finish() do {				\
 __async_regwrite_out :							\
-	if (__err == 0 && __nreg) {					\
-		__cmd->hdr.len = 8 * __nreg;				\
-		if (IS_ACCEPTING_CMD(__carl))				\
-			__err = __carl9170_exec_cmd(__carl, __cmd, true);\
-		__nreg = 0;						\
-	}
+	if (__cmd != NULL && __err == 0)				\
+		carl9170_async_regwrite_flush();			\
+	kfree(__cmd);							\
+} while (0)								\
 
 #define carl9170_async_regwrite_result()				\
 	__err;								\
