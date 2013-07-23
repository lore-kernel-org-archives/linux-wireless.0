Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:41143 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab3GWCTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 13/21] mwifiex: move if_ops.cleanup_if() call
Date: Mon, 22 Jul 2013 19:17:50 -0700
Message-ID: <1374545878-15683-14-git-send-email-bzhao@marvell.com> (sfid-20130723_041929_163674_EAFDBB8C)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As if_ops.init_if() is called in mwifiex_register(),
corresponding cleanup routine should be called in
mwifiex_unregister().

Currently it's there in mwifiex_adapter_cleanup(), hence
interface specific cleanup is not performed if driver
initialization is failed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 3 ---
 drivers/net/wireless/mwifiex/main.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 8ff5d7b..2cda7ee 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -394,9 +394,6 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 
 	dev_dbg(adapter->dev, "info: free scan table\n");
 
-	if (adapter->if_ops.cleanup_if)
-		adapter->if_ops.cleanup_if(adapter);
-
 	if (adapter->sleep_cfm)
 		dev_kfree_skb_any(adapter->sleep_cfm);
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 8217368..e64c369 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -191,6 +191,9 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 {
 	s32 i;
 
+	if (adapter->if_ops.cleanup_if)
+		adapter->if_ops.cleanup_if(adapter);
+
 	del_timer(&adapter->cmd_timer);
 
 	/* Free private structures */
-- 
1.8.2.3

