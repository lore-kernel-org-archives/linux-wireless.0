Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4158 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2I0Mu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:50:26 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 3/6] ath6kl: Rename ATH6KL_HW_FLAG_64BIT_RATES
Date: Thu, 27 Sep 2012 18:19:50 +0530
Message-ID: <1348750193-2665-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145029_156936_EEF570FC)
In-Reply-To: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Rename ATH6KL_HW_FLAG_64BIT_RATES to ATH6KL_HW_64BIT_RATES.
This seemed to be necessary to add/use new hardware flags
without exceeding 80 lines. We shall be adding new hw flags
dropping the FLAG term.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    8 ++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6e6c2d..8cbca8f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3708,7 +3708,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_5ghz.ht_cap.ht_supported = false;
 	}
 
-	if (ar->hw.flags & ATH6KL_HW_FLAG_64BIT_RATES) {
+	if (ar->hw.flags & ATH6KL_HW_64BIT_RATES) {
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3b2dfc1..fc5e4b2 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -149,7 +149,7 @@ struct ath6kl_fw_ie {
 };
 
 enum ath6kl_hw_flags {
-	ATH6KL_HW_FLAG_64BIT_RATES	= BIT(0),
+	ATH6KL_HW_64BIT_RATES	= BIT(0),
 };
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 424676e..18550c5 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -93,7 +93,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x433900,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_FLAG_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_0_FW_DIR,
@@ -113,7 +113,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x43d400,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_FLAG_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_1_FW_DIR,
@@ -133,7 +133,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x435c00,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_FLAG_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES,
 
 		.fw = {
 			.dir		= AR6004_HW_1_2_FW_DIR,
@@ -152,7 +152,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x436400,
 		.refclk_hz                      = 40000000,
 		.uarttx_pin                     = 11,
-		.flags                          = ATH6KL_HW_FLAG_64BIT_RATES,
+		.flags                          = ATH6KL_HW_64BIT_RATES,
 
 		.fw = {
 			.dir            = AR6004_HW_1_3_FW_DIR,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f3aeebb..55ccf97 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2828,7 +2828,7 @@ int ath6kl_wmi_set_bitrate_mask(struct wmi *wmi, u8 if_idx,
 {
 	struct ath6kl *ar = wmi->parent_dev;
 
-	if (ar->hw.flags & ATH6KL_HW_FLAG_64BIT_RATES)
+	if (ar->hw.flags & ATH6KL_HW_64BIT_RATES)
 		return ath6kl_set_bitrate_mask64(wmi, if_idx, mask);
 	else
 		return ath6kl_set_bitrate_mask32(wmi, if_idx, mask);
-- 
1.7.0.4

