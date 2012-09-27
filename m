Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2I0MvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:51:20 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 6/6] ath6kl: Add a hardware flag for SDIO CRC error workaround
Date: Thu, 27 Sep 2012 18:19:53 +0530
Message-ID: <1348750193-2665-6-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145123_278426_2CA0C741)
In-Reply-To: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Make use of SDIO CRC error workaround hardware flag and avoid
target revision checks.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1778bd3..189d8fa 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -152,6 +152,7 @@ enum ath6kl_hw_flags {
 	ATH6KL_HW_64BIT_RATES		= BIT(0),
 	ATH6KL_HW_AP_INACTIVITY_MINS	= BIT(1),
 	ATH6KL_HW_MAP_LP_ENDPOINT	= BIT(2),
+	ATH6KL_HW_SDIO_CRC_ERROR_WAR	= BIT(3),
 };
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bb6aeea..f21fa32 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -42,7 +42,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 6912,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
-		.flags				= 0,
+		.flags				= ATH6KL_HW_SDIO_CRC_ERROR_WAR,
 
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
@@ -68,7 +68,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
 		.testscript_addr		= 0x57ef74,
-		.flags				= 0,
+		.flags				= ATH6KL_HW_SDIO_CRC_ERROR_WAR,
 
 		.fw = {
 			.dir		= AR6003_HW_2_1_1_FW_DIR,
@@ -1431,8 +1431,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 		return status;
 
 	/* WAR to avoid SDIO CRC err */
-	if (ar->version.target_ver == AR6003_HW_2_0_VERSION ||
-	    ar->version.target_ver == AR6003_HW_2_1_1_VERSION) {
+	if (ar->hw.flags & ATH6KL_HW_SDIO_CRC_ERROR_WAR) {
 		ath6kl_err("temporary war to avoid sdio crc error\n");
 
 		param = 0x28;
-- 
1.7.0.4

