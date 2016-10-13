Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34105 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932869AbcJMQlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:49 -0400
Received: by mail-lf0-f65.google.com with SMTP id x23so7785747lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:41:05 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 2/5] ath6kl: Updated TARG_VTOP macro with default value
Date: Thu, 13 Oct 2016 18:39:26 +0200
Message-Id: <1476376769-4708-3-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184156_554914_8190ACF3)
In-Reply-To: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A minor modification of the TARG_VTOP macro.
The AR6004 VTOP macro is used as default (for all
chip's except AR6003)

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/target.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index d5eeeae..c6c49b0 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -331,11 +331,11 @@ struct host_interest {
 
 /* Convert a Target virtual address into a Target physical address */
 #define AR6003_VTOP(vaddr) ((vaddr) & 0x001fffff)
-#define AR6004_VTOP(vaddr) (vaddr)
+#define DEFAULT_VTOP(vaddr) (vaddr)
 
 #define TARG_VTOP(target_type, vaddr) \
 	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
-	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
+	DEFAULT_VTOP(vaddr))
 
 #define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
 
-- 
2.1.4
