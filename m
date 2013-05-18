Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59524 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963Ab3ERAy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:54:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 02/17] mwifiex: scan delay timer cleanup in unload path
Date: Fri, 17 May 2013 17:50:19 -0700
Message-ID: <1368838234-32585-3-git-send-email-bzhao@marvell.com> (sfid-20130518_025500_379109_919FFA6D)
In-Reply-To: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
References: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Return from scan delay timer routine if surprise_removed flag
is true. Also, cancel the timer in unload path.

This fixes a crash when scan delay timer accesses structures
that have been freed already.

Tested with "iwlist mlan0 scan & sleep 1; rmmod mwifiex_sdio"

Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 58e151e..71bbf12 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -59,6 +59,9 @@ static void scan_delay_timer_fn(unsigned long data)
 	struct cmd_ctrl_node *cmd_node, *tmp_node;
 	unsigned long flags;
 
+	if (adapter->surprise_removed)
+		return;
+
 	if (adapter->scan_delay_cnt == MWIFIEX_MAX_SCAN_DELAY_CNT) {
 		/*
 		 * Abort scan operation by cancelling all pending scan
@@ -458,11 +461,18 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
+	int i;
+
 	if (!adapter) {
 		pr_err("%s: adapter is NULL\n", __func__);
 		return;
 	}
 
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i])
+			del_timer_sync(&adapter->priv[i]->scan_delay_timer);
+	}
+
 	mwifiex_cancel_all_pending_cmd(adapter);
 
 	/* Free lock variables */
-- 
1.8.2.3

