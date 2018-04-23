Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:50243 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932306AbeDWUM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 16:12:27 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 9/9] ath10k: re-enable the firmware fallback mechanism for testmode
Date: Mon, 23 Apr 2018 16:12:05 -0400
Message-Id: <20180423201205.20533-10-andresx7@gmail.com> (sfid-20180423_221333_771300_98B83FA0)
In-Reply-To: <20180423201205.20533-1-andresx7@gmail.com>
References: <20180423201205.20533-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath10k testmode uses request_firmware_direct() in order to avoid
producing firmware load warnings. Disabling the fallback mechanism was a
side effect of disabling warnings.

We now have a new API that allows us to avoid warnings while keeping the
fallback mechanism enabled. So use that instead.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---
 drivers/net/wireless/ath/ath10k/testmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 568810b41657..0beb91be1b1c 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -157,7 +157,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
 
 	/* load utf firmware image */
-	ret = request_firmware_direct(&fw_file->firmware, filename, ar->dev);
+	ret = request_firmware_nowarn(&fw_file->firmware, filename, ar->dev);
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode fw request '%s': %d\n",
 		   filename, ret);
 
-- 
2.14.1
