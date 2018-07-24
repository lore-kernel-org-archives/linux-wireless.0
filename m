Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25495 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388424AbeGXIuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:01 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 09/19] wil6210: fix min() compilation errors
Date: Tue, 24 Jul 2018 10:44:30 +0300
Message-Id: <1532418280-5849-10-git-send-email-merez@codeaurora.org> (sfid-20180724_094513_547865_CC1F254E)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

With some tool chains compilation fails due to type
mismatch of the arguments passed to min().
Use min_t() to solve these compilation errors.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/fw_inc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 718161b..388b3d4 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -145,7 +145,7 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 				    capabilities);
 	bitmap_zero(wil->fw_capabilities, WMI_FW_CAPABILITY_MAX);
 	memcpy(wil->fw_capabilities, rec->capabilities,
-	       min(sizeof(wil->fw_capabilities), capa_size));
+	       min_t(size_t, sizeof(wil->fw_capabilities), capa_size));
 	wil_hex_dump_fw("CAPA", DUMP_PREFIX_OFFSET, 16, 1,
 			rec->capabilities, capa_size, false);
 	return 0;
-- 
1.9.1
