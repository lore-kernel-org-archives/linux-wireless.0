Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965230Ab3E2KEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 06:04:25 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] mwifiex: dump small buffers with help of %*ph
Date: Wed, 29 May 2013 13:04:20 +0300
Message-Id: <1369821860-3004-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20130529_120428_649109_8199AFC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/mwifiex/join.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 6bcb66e..122175a 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -919,9 +919,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	memcpy(&priv->curr_bss_params.data_rates,
 	       &adhoc_start->data_rate, priv->curr_bss_params.num_of_rates);
 
-	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
-		adhoc_start->data_rate[0], adhoc_start->data_rate[1],
-		adhoc_start->data_rate[2], adhoc_start->data_rate[3]);
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%4ph\n",
+		adhoc_start->data_rate);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
 
-- 
1.8.2.rc0.22.gb3600c3

