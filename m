Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:41435 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab3ENBPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:15:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/17] mwifiex: scan delay timer cleanup in unload path
Date: Mon, 13 May 2013 18:14:46 -0700
Message-ID: <1368494101-23651-3-git-send-email-bzhao@marvell.com> (sfid-20130514_031518_342356_1CDB670A)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
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

