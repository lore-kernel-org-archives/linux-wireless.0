Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:34255 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3GWCS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 15/21] mwifiex: reduce firmware poll retries
Date: Mon, 22 Jul 2013 19:17:52 -0700
Message-ID: <1374545878-15683-16-git-send-email-bzhao@marvell.com> (sfid-20130723_041918_937360_47E8385C)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

After downloading the firmware, firmware status is checked by
reading a register. Polling interval is 100 msecs. Therefore 100
retries means the status is checked for 10 secs which is more than
sufficient for firmware to get ready.

This patch removes 1000 retries macro usage, because 100secs
time is not practical.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   | 3 ---
 drivers/net/wireless/mwifiex/init.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1b45aa5..99c2729 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -85,9 +85,6 @@ enum KEY_TYPE_ID {
 #define WAPI_KEY_LEN			50
 
 #define MAX_POLL_TRIES			100
-
-#define MAX_MULTI_INTERFACE_POLL_TRIES  1000
-
 #define MAX_FIRMWARE_POLL_TRIES			100
 
 #define FIRMWARE_READY_SDIO				0xfedc
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2cda7ee..e021a58 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -691,7 +691,6 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		if (!adapter->winner) {
 			dev_notice(adapter->dev,
 				   "FW already running! Skip FW dnld\n");
-			poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
 			goto poll_fw;
 		}
 	}
-- 
1.8.2.3

