Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:39368 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964786Ab2JEU6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 16:58:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joe Perches <joe@perches.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 2/2] mwifiex: Using %*phD instead of print_hex_dump_bytes
Date: Fri,  5 Oct 2012 13:57:49 -0700
Message-Id: <1349470669-363-2-git-send-email-bzhao@marvell.com> (sfid-20121005_225824_362657_588A0351)
In-Reply-To: <1349470669-363-1-git-send-email-bzhao@marvell.com>
References: <1349470669-363-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Make output more readable and remove unneeded function call.

...
mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
last_cmd_id: 00000000: 16 00 cd 00 83 00 df 00 28 00 ........(.
...

would be changed to:

...
mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
mwifiex_sdio mmc1:0001:1: last_cmd_id: 16 00 cd 00 83 00 df 00 28 00
...

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: use (int)sizeof(cool_var) as the buffer length
    (Andy Shevchenko)

 drivers/net/wireless/mwifiex/cmdevt.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6627f9c..da6c491 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -917,24 +917,24 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 		dev_err(adapter->dev, "last_cmd_index = %d\n",
 			adapter->dbg.last_cmd_index);
-		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_id,
-				     sizeof(adapter->dbg.last_cmd_id));
-		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_act,
-				     sizeof(adapter->dbg.last_cmd_act));
+		dev_err(adapter->dev, "last_cmd_id: %*ph\n",
+			(int)sizeof(adapter->dbg.last_cmd_id),
+			adapter->dbg.last_cmd_id);
+		dev_err(adapter->dev, "last_cmd_act: %*ph\n",
+			(int)sizeof(adapter->dbg.last_cmd_act),
+			adapter->dbg.last_cmd_act);
 
 		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
 			adapter->dbg.last_cmd_resp_index);
-		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_cmd_resp_id,
-				     sizeof(adapter->dbg.last_cmd_resp_id));
+		dev_err(adapter->dev, "last_cmd_resp_id: %*ph\n",
+			(int)sizeof(adapter->dbg.last_cmd_resp_id),
+			adapter->dbg.last_cmd_resp_id);
 
 		dev_err(adapter->dev, "last_event_index = %d\n",
 			adapter->dbg.last_event_index);
-		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
-				     adapter->dbg.last_event,
-				     sizeof(adapter->dbg.last_event));
+		dev_err(adapter->dev, "last_event: %*ph\n",
+			(int)sizeof(adapter->dbg.last_event),
+			adapter->dbg.last_event);
 
 		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
 			adapter->data_sent, adapter->cmd_sent);
-- 
1.7.0.2

