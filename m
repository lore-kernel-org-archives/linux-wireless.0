Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2JDJO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 05:14:59 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com
Subject: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
Date: Thu,  4 Oct 2012 12:16:01 +0300
Message-Id: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20121004_111504_334272_7ACCC1F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Make output more readable and remove unneeded function call.

...
mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
last_cmd_id: 00000000: 28 00 28 00 28                            (.(.(
...

would be changed to:

...
mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 28 00 28
...

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 225c1a4..e6a0600 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -917,21 +917,20 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 		dev_err(adapter->dev, "last_cmd_index = %d\n",
 			adapter->dbg.last_cmd_index);
-		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_id, DBG_CMD_NUM);
-		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_act, DBG_CMD_NUM);
+		dev_err(adapter->dev, "last_cmd_id: %*ph\n", DBG_CMD_NUM,
+			adapter->dbg.last_cmd_id);
+		dev_err(adapter->dev, "last_cmd_act: %*ph\n", DBG_CMD_NUM,
+			adapter->dbg.last_cmd_act);
 
 		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
 			adapter->dbg.last_cmd_resp_index);
-		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_resp_id,
-				     DBG_CMD_NUM);
+		dev_err(adapter->dev, "last_cmd_resp_id: %*ph\n", DBG_CMD_NUM,
+			adapter->dbg.last_cmd_resp_id);
 
 		dev_err(adapter->dev, "last_event_index = %d\n",
 			adapter->dbg.last_event_index);
-		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_event, DBG_CMD_NUM);
+		dev_err(adapter->dev, "last_event: %*ph\n", DBG_CMD_NUM,
+				     adapter->dbg.last_event);
 
 		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
 			adapter->data_sent, adapter->cmd_sent);
-- 
1.7.9.5

