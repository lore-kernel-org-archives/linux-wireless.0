Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53956 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcEKRCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:44 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 10/21] ath10k: support logging ath10k_info as KERN_DEBUG
Date: Wed, 11 May 2016 10:02:22 -0700
Message-Id: <1462986153-16318-11-git-send-email-greearb@candelatech.com> (sfid-20160511_192231_187826_2C09DA29)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps keep messages off of (serial) console when
that is desired.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 5 ++++-
 drivers/net/wireless/ath/ath10k/debug.h | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 97de9f37..76b5163 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -139,7 +139,10 @@ void ath10k_info(struct ath10k *ar, const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	dev_info(ar->dev, "%pV", &vaf);
+	if (ath10k_debug_mask & ATH10K_DBG_INFO_AS_DBG)
+		dev_printk(KERN_DEBUG, ar->dev, "%pV", &vaf);
+	else
+		dev_info(ar->dev, "%pV", &vaf);
 	trace_ath10k_log_info(ar, &vaf);
 	va_end(args);
 }
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 641fce1..070f1c6 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -21,6 +21,10 @@
 #include <linux/types.h>
 #include "trace.h"
 
+/**
+ * ATH10K_DBG_INFO_AS_DBG: use dev_dbg instead of dev_info
+ *       for ath10k_info messages
+ */
 enum ath10k_debug_mask {
 	ATH10K_DBG_PCI		= 0x00000001,
 	ATH10K_DBG_WMI		= 0x00000002,
@@ -38,6 +42,8 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_WMI_PRINT	= 0x00002000,
 	ATH10K_DBG_PCI_PS	= 0x00004000,
 	ATH10K_DBG_AHB		= 0x00008000,
+
+	ATH10K_DBG_INFO_AS_DBG	= 0x40000000,
 	ATH10K_DBG_FW		= 0x80000000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
-- 
2.4.3

