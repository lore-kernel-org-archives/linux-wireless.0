Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:35970 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754295AbeDJPBr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:47 -0400
Received: by mail-pl0-f65.google.com with SMTP id 91-v6so7707436pld.3
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:47 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 2/7] rsi: device bootup parameter configuration
Date: Tue, 10 Apr 2018 20:34:12 +0530
Message-Id: <1523372657-6067-3-git-send-email-siva8118@gmail.com> (sfid-20180410_170153_006319_670F7720)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Some device configuration flags need to be enabled while sending 'bootup
params' internal frame to firmware. This patch takes care of it.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_boot_params.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index 238ee96..ad903b22 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -46,7 +46,8 @@
 	(((TA_PLL_M_VAL_20 + 1) * 40) / \
 	 ((TA_PLL_N_VAL_20 + 1) * (TA_PLL_P_VAL_20 + 1)))
 #define VALID_20 \
-	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS)
+	(WIFI_TAPLL_CONFIGS | WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | \
+	 WIFI_SWITCH_CLK_CONFIGS | BOOTUP_MODE_INFO | CRYSTAL_GOOD_TIME)
 #define UMAC_CLK_40BW   \
 	(((TA_PLL_M_VAL_40 + 1) * 40) / \
 	 ((TA_PLL_N_VAL_40 + 1) * (TA_PLL_P_VAL_40 + 1)))
-- 
2.7.4
