Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49929 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700Ab3GaASl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 20:18:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix adapter pointer dereference issue
Date: Tue, 30 Jul 2013 17:18:15 -0700
Message-ID: <1375229895-31856-1-git-send-email-bzhao@marvell.com> (sfid-20130731_021846_911248_7D5AC6F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It has introduced by recent commit 6b41f941d7cd: "mwifiex:
handle driver initialization error paths" which adds error
path handling for mwifiex_fw_dpc().

release_firmware(adapter->*) is called for success as well
as failure paths. In failure paths, adapter is already freed
at this point.

The issue is fixed by moving mwifiex_free_adapter() call.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 5644c7f..3402bff 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -414,6 +414,8 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	struct mwifiex_private *priv;
 	struct mwifiex_adapter *adapter = context;
 	struct mwifiex_fw_image fw;
+	struct semaphore *sem = adapter->card_sem;
+	bool init_failed = false;
 
 	if (!firmware) {
 		dev_err(adapter->dev,
@@ -528,15 +530,20 @@ err_dnld_fw:
 	}
 	adapter->surprise_removed = true;
 	mwifiex_terminate_workqueue(adapter);
-	mwifiex_free_adapter(adapter);
+	init_failed = true;
 done:
 	if (adapter->cal_data) {
 		release_firmware(adapter->cal_data);
 		adapter->cal_data = NULL;
 	}
-	release_firmware(adapter->firmware);
+	if (adapter->firmware) {
+		release_firmware(adapter->firmware);
+		adapter->firmware = NULL;
+	}
 	complete(&adapter->fw_load);
-	up(adapter->card_sem);
+	if (init_failed)
+		mwifiex_free_adapter(adapter);
+	up(sem);
 	return;
 }
 
-- 
1.8.2.3

