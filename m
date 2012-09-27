Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4206 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0Mug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:50:36 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Manikandan Radhakrishnan <mradhakr@qca.qualcomm.com>
Subject: [PATCH 4/6] ath6kl: Fix inactivity timeout for AR6004
Date: Thu, 27 Sep 2012 18:19:51 +0530
Message-ID: <1348750193-2665-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145038_786874_F188959D)
In-Reply-To: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Currently AR6004 handles the inactivity timeout resolution
in minutes rather than seconds. So parse the inactivity timeout
to the firmware in minutes. For now we will cleanup the
inactive station entries to the nearest converted minutes
(ex:  an inactive time of 70 seconds would take atleast 2 - 3 minutes)
Tested with surprise removal of client cards/host shutdown.

Cc: Manikandan Radhakrishnan <mradhakr@qca.qualcomm.com>
Reported-by: Leela Kella <leela@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 +++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    3 ++-
 drivers/net/wireless/ath/ath6kl/init.c     |   13 ++++++++-----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8cbca8f..88553cf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2760,6 +2760,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	int res;
 	int i, ret;
 	u16 rsn_capab = 0;
+	int inactivity_timeout = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s:\n", __func__);
 
@@ -2896,8 +2897,15 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (info->inactivity_timeout) {
+
+		inactivity_timeout = info->inactivity_timeout;
+
+		if (ar->hw.flags & ATH6KL_HW_AP_INACTIVITY_MINS)
+			inactivity_timeout = DIV_ROUND_UP(inactivity_timeout,
+							  60);
+
 		res = ath6kl_wmi_set_inact_period(ar->wmi, vif->fw_vif_idx,
-						  info->inactivity_timeout);
+						  inactivity_timeout);
 		if (res < 0)
 			return res;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index fc5e4b2..95fc9b3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -149,7 +149,8 @@ struct ath6kl_fw_ie {
 };
 
 enum ath6kl_hw_flags {
-	ATH6KL_HW_64BIT_RATES	= BIT(0),
+	ATH6KL_HW_64BIT_RATES		= BIT(0),
+	ATH6KL_HW_AP_INACTIVITY_MINS	= BIT(1),
 };
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 18550c5..7ffb853 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -93,7 +93,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x433900,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES |
+						  ATH6KL_HW_AP_INACTIVITY_MINS,
 
 		.fw = {
 			.dir		= AR6004_HW_1_0_FW_DIR,
@@ -113,8 +114,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x43d400,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_64BIT_RATES,
-
+		.flags				= ATH6KL_HW_64BIT_RATES |
+						  ATH6KL_HW_AP_INACTIVITY_MINS,
 		.fw = {
 			.dir		= AR6004_HW_1_1_FW_DIR,
 			.fw		= AR6004_HW_1_1_FIRMWARE_FILE,
@@ -133,7 +134,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x435c00,
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
-		.flags				= ATH6KL_HW_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES |
+						  ATH6KL_HW_AP_INACTIVITY_MINS,
 
 		.fw = {
 			.dir		= AR6004_HW_1_2_FW_DIR,
@@ -152,7 +154,8 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x436400,
 		.refclk_hz                      = 40000000,
 		.uarttx_pin                     = 11,
-		.flags                          = ATH6KL_HW_64BIT_RATES,
+		.flags				= ATH6KL_HW_64BIT_RATES |
+						  ATH6KL_HW_AP_INACTIVITY_MINS,
 
 		.fw = {
 			.dir            = AR6004_HW_1_3_FW_DIR,
-- 
1.7.0.4

