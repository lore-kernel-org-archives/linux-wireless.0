Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59749 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1DACqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 22:46:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove unused macros in decl.h and main.h
Date: Thu, 31 Mar 2011 19:50:14 -0700
Message-Id: <1301626214-13581-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These macros are leftover of previous cleanup patches.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |   24 ------------------------
 drivers/net/wireless/mwifiex/main.h |    7 -------
 2 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 4e1f115..c3c15f9 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -51,7 +51,6 @@
 #define MWIFIEX_RATE_BITMAP_MCS127 159
 
 #define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
-#define MWIFIEX_RX_CMD_BUF_SIZE      (2 * 1024)
 
 #define MWIFIEX_RTS_MIN_VALUE              (0)
 #define MWIFIEX_RTS_MAX_VALUE              (2347)
@@ -141,13 +140,6 @@ struct mwifiex_bss_attr {
 	u32 bss_num;
 };
 
-enum mwifiex_cmd_result_e {
-	MWIFIEX_CMD_RESULT_SUCCESS = 0,
-	MWIFIEX_CMD_RESULT_FAILURE = 1,
-	MWIFIEX_CMD_RESULT_TIMEOUT = 2,
-	MWIFIEX_CMD_RESULT_INVALID_DATA = 3
-} __packed;
-
 enum mwifiex_wmm_ac_e {
 	WMM_AC_BK,
 	WMM_AC_BE,
@@ -155,22 +147,6 @@ enum mwifiex_wmm_ac_e {
 	WMM_AC_VO
 } __packed;
 
-enum mwifiex_wmm_queue_config_action_e {
-	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_GET = 0,
-	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_SET = 1,
-	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_DEFAULT = 2,
-	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_MAX
-} __packed;
-
-enum mwifiex_wmm_queue_stats_action_e {
-	MWIFIEX_WMM_STATS_ACTION_START = 0,
-	MWIFIEX_WMM_STATS_ACTION_STOP = 1,
-	MWIFIEX_WMM_STATS_ACTION_GET_CLR = 2,
-	MWIFIEX_WMM_STATS_ACTION_SET_CFG = 3,	/* Not currently used */
-	MWIFIEX_WMM_STATS_ACTION_GET_CFG = 4,	/* Not currently used */
-	MWIFIEX_WMM_STATS_ACTION_MAX
-} __packed;
-
 struct mwifiex_device {
 	struct mwifiex_bss_attr bss_attr[MWIFIEX_MAX_BSS_NUM];
 };
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c26f704..43ff149 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -50,8 +50,6 @@ enum {
 };
 
 #define DRV_MODE_STA       0x1
-#define DRV_MODE_UAP       0x2
-#define DRV_MODE_UAP_STA   0x3
 
 #define SD8787_W0   0x30
 #define SD8787_W1   0x31
@@ -74,13 +72,8 @@ struct mwifiex_drv_mode {
 #define MWIFIEX_TIMER_10S			10000
 #define MWIFIEX_TIMER_1S			1000
 
-#define NL_MAX_PAYLOAD      1024
-#define NL_MULTICAST_GROUP  1
-
 #define MAX_TX_PENDING      60
 
-#define HEADER_ALIGNMENT                8
-
 #define MWIFIEX_UPLD_SIZE               (2312)
 
 #define MAX_EVENT_SIZE                  1024
-- 
1.7.0.2

