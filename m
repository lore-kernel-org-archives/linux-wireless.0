Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51313 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab2C1Nve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:51:34 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	PingYang Zhang <pingzhan@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Use vmalloc instead of kmalloc for fw
Date: Wed, 28 Mar 2012 19:21:25 +0530
Message-ID: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120328_155138_016897_55772F2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes it has been observed that allocating a contiguous memory
of more than 100K fails with kmalloc. This has been modified to
use vmalloc instead.

Signed-off-by: PingYang Zhang <pingzhan@qca.qualcomm.com>
Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    3 ++-
 drivers/net/wireless/ath/ath6kl/init.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 5c20a04..fdb3b1d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/export.h>
+#include <linux/vmalloc.h>
 
 #include "debug.h"
 #include "hif-ops.h"
@@ -305,7 +306,7 @@ void ath6kl_core_cleanup(struct ath6kl *ar)
 
 	kfree(ar->fw_board);
 	kfree(ar->fw_otp);
-	kfree(ar->fw);
+	vfree(ar->fw);
 	kfree(ar->fw_patch);
 	kfree(ar->fw_testscript);
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 092e4cd..5949ab5 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/mmc/sdio_func.h>
+#include <linux/vmalloc.h>
 
 #include "core.h"
 #include "cfg80211.h"
@@ -928,13 +929,14 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			if (ar->fw != NULL)
 				break;
 
-			ar->fw = kmemdup(data, ie_len, GFP_KERNEL);
+			ar->fw = vmalloc(ie_len);
 
 			if (ar->fw == NULL) {
 				ret = -ENOMEM;
 				goto out;
 			}
 
+			memcpy(ar->fw, data, ie_len);
 			ar->fw_len = ie_len;
 			break;
 		case ATH6KL_FW_IE_PATCH_IMAGE:
-- 
1.7.4.1

