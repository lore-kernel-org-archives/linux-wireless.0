Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:38214 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964786Ab2JEU6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 16:58:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joe Perches <joe@perches.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 1/2] mwifiex: use sizeof(array) to print_hex_dump_bytes
Date: Fri,  5 Oct 2012 13:57:48 -0700
Message-Id: <1349470669-363-1-git-send-email-bzhao@marvell.com> (sfid-20121005_225809_233254_4ED23588)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DBG_CMD_NUM is the number of commands, not the actual bytes of
data for printing.

Also remove the duplicated DBG_CMD_NUM definition.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: fix existing code first before applying Andrei's patch
    (Andy Shevchenko)

 drivers/net/wireless/mwifiex/cmdevt.c |   11 +++++++----
 drivers/net/wireless/mwifiex/main.h   |    2 --
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 8d46510..6627f9c 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -918,20 +918,23 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		dev_err(adapter->dev, "last_cmd_index = %d\n",
 			adapter->dbg.last_cmd_index);
 		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_id, DBG_CMD_NUM);
+				     adapter->dbg.last_cmd_id,
+				     sizeof(adapter->dbg.last_cmd_id));
 		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_act, DBG_CMD_NUM);
+				     adapter->dbg.last_cmd_act,
+				     sizeof(adapter->dbg.last_cmd_act));
 
 		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
 			adapter->dbg.last_cmd_resp_index);
 		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
 				     adapter->dbg.last_cmd_resp_id,
-				     DBG_CMD_NUM);
+				     sizeof(adapter->dbg.last_cmd_resp_id));
 
 		dev_err(adapter->dev, "last_event_index = %d\n",
 			adapter->dbg.last_event_index);
 		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_event, DBG_CMD_NUM);
+				     adapter->dbg.last_event,
+				     sizeof(adapter->dbg.last_event));
 
 		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
 			adapter->data_sent, adapter->cmd_sent);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c2d0ab1..0b747ec 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -115,8 +115,6 @@ enum {
 #define MWIFIEX_TYPE_DATA				0
 #define MWIFIEX_TYPE_EVENT				3
 
-#define DBG_CMD_NUM						5
-
 #define MAX_BITMAP_RATES_SIZE			10
 
 #define MAX_CHANNEL_BAND_BG     14
-- 
1.7.0.2

