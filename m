Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:56399 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3GWCSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/21] mwifiex: move del_timer_sync(scan_delay_timer) call to fix memleak
Date: Mon, 22 Jul 2013 19:17:48 -0700
Message-ID: <1374545878-15683-12-git-send-email-bzhao@marvell.com> (sfid-20130723_041916_550244_BA29B9BA)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently it is in mwifiex_adapter_cleanup() which doesn't get
called if driver initialization is failed causing memory leak.

scan_delay_timer is initialized in mwifiex_register(), so it
should be deleted in mwifiex_unregister(). Hence it has been
moved to appropriate place.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 7 -------
 drivers/net/wireless/mwifiex/main.c | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 09c4b76..787cff8 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -378,18 +378,11 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
-	int i;
-
 	if (!adapter) {
 		pr_err("%s: adapter is NULL\n", __func__);
 		return;
 	}
 
-	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i])
-			del_timer_sync(&adapter->priv[i]->scan_delay_timer);
-	}
-
 	mwifiex_cancel_all_pending_cmd(adapter);
 
 	/* Free lock variables */
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 1753431..8217368 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -197,6 +197,7 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			mwifiex_free_curr_bcn(adapter->priv[i]);
+			del_timer_sync(&adapter->priv[i]->scan_delay_timer);
 			kfree(adapter->priv[i]);
 		}
 	}
-- 
1.8.2.3

