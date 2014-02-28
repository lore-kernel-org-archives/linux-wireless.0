Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55375 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 7/9] mwifiex: get rid of extra num_cmd_timeout variable
Date: Thu, 27 Feb 2014 19:35:16 -0800
Message-ID: <1393558518-921-2-git-send-email-bzhao@marvell.com> (sfid-20140228_043539_311862_0E8A0B84)
In-Reply-To: <1393558518-921-1-git-send-email-bzhao@marvell.com>
References: <1393558518-921-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We already have one in mwifiex_adapter structure.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 3 +--
 drivers/net/wireless/mwifiex/main.h   | 1 -
 drivers/net/wireless/mwifiex/util.c   | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 83195d9..686943c 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -892,7 +892,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct timeval tstamp;
 
 	adapter->num_cmd_timeout++;
-	adapter->dbg.num_cmd_timeout++;
 	if (!adapter->curr_cmd) {
 		dev_dbg(adapter->dev, "cmd: empty curr_cmd\n");
 		return;
@@ -916,7 +915,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			adapter->dbg.num_cmd_host_to_card_failure);
 
 		dev_err(adapter->dev, "num_cmd_timeout = %d\n",
-			adapter->dbg.num_cmd_timeout);
+			adapter->num_cmd_timeout);
 		dev_err(adapter->dev, "num_tx_timeout = %d\n",
 			adapter->dbg.num_tx_timeout);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 85ce29c..a5f6160 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -145,7 +145,6 @@ struct mwifiex_dbg {
 	u32 num_cmd_assoc_success;
 	u32 num_cmd_assoc_failure;
 	u32 num_tx_timeout;
-	u32 num_cmd_timeout;
 	u16 timeout_cmd_id;
 	u16 timeout_cmd_act;
 	u16 last_cmd_id[DBG_CMD_NUM];
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 098de88..7022c69 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -104,6 +104,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->pm_wakeup_fw_try = adapter->pm_wakeup_fw_try;
 		info->is_hs_configured = adapter->is_hs_configured;
 		info->hs_activated = adapter->hs_activated;
+		info->num_cmd_timeout = adapter->num_cmd_timeout;
 		info->num_cmd_host_to_card_failure
 				= adapter->dbg.num_cmd_host_to_card_failure;
 		info->num_cmd_sleep_cfm_host_to_card_failure
@@ -119,7 +120,6 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->num_cmd_assoc_failure =
 					adapter->dbg.num_cmd_assoc_failure;
 		info->num_tx_timeout = adapter->dbg.num_tx_timeout;
-		info->num_cmd_timeout = adapter->dbg.num_cmd_timeout;
 		info->timeout_cmd_id = adapter->dbg.timeout_cmd_id;
 		info->timeout_cmd_act = adapter->dbg.timeout_cmd_act;
 		memcpy(info->last_cmd_id, adapter->dbg.last_cmd_id,
-- 
1.8.2.3

