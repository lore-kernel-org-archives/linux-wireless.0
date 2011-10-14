Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50263 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab1JNMxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:53:06 -0400
Received: by gyb13 with SMTP id 13so1066116gyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:53:05 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 1/5] ath6kl: Add SDIO polling function definitions
Date: Fri, 14 Oct 2011 13:50:42 +0100
Message-Id: <1318596646-19495-2-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145316_990652_CB3EB868)
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add SDIO polling function definition into debug.h

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/debug.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 9288a3c..bbe4a39 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -133,6 +133,31 @@ static inline int ath6kl_debug_init(struct ath6kl *ar)
 static inline void ath6kl_debug_cleanup(struct ath6kl *ar)
 {
 }
+#endif
+
+#ifdef CONFIG_ATH6KL_SDIO_POLL
+void ath6kl_wd_init(struct ath6kl *ar);
+
+void ath6kl_wd_cleanup(struct ath6kl *ar);
+
+static inline int ath6kl_wd_poll_is_ture(void)
+{
+	return true;
+}
+
+#else
+static inline void ath6kl_wd_init(struct ath6kl *ar)
+{
+}
+
+static inline void ath6kl_wd_cleanup(struct ath6kl *ar)
+{
+}
+
+static inline int ath6kl_wd_poll_is_ture(void)
+{
+	return false;
+}
 
 #endif
 #endif
-- 
1.7.4.1

