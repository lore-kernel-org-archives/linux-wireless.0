Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40400 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbaKSSxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:53:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1XrANL-0007Ep-FW
	for linux-wireless@vger.kernel.org; Wed, 19 Nov 2014 19:53:11 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: don't rebuild all the time
Date: Wed, 19 Nov 2014 19:53:08 +0100
Message-Id: <1416423188-8394-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_195316_191754_8C421581)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are better ways to get the kernel information, use the
utsname and omit the version code entirely since it's duplicate.
The version magic is rather useless anyway

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath10k/debug.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a8f5a72ba259..f10721da4980 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -17,9 +17,8 @@
 
 #include <linux/module.h>
 #include <linux/debugfs.h>
-#include <linux/version.h>
-#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
+#include <linux/utsname.h>
 
 #include "core.h"
 #include "debug.h"
@@ -866,8 +865,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
 
-	dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
-	strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
+	dump_data->kernel_ver_code = 0;
+	strlcpy(dump_data->kernel_ver, init_utsname()->release,
 		sizeof(dump_data->kernel_ver));
 
 	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
-- 
2.1.1

