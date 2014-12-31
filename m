Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59263 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbaLaKiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:23 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/9] mwifiex: Adjust calling place of mwifiex_terminate_workqueue
Date: Wed, 31 Dec 2014 02:36:39 -0800
Message-ID: <1420022206-11435-3-git-send-email-akarwar@marvell.com> (sfid-20141231_113825_772525_DEFF5E5E)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

Workqueue needs to be flushed early when removing card, otherwise
soft lockup issue may happen because main_process is triggered by
interrupt while card is being removed.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2568395..2d4047f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -1166,6 +1166,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 
 	adapter->surprise_removed = true;
 
+	mwifiex_terminate_workqueue(adapter);
+
 	/* Stop data */
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
@@ -1208,8 +1210,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 
-	mwifiex_terminate_workqueue(adapter);
-
 	/* Unregister device */
 	dev_dbg(adapter->dev, "info: unregister device\n");
 	if (adapter->if_ops.unregister_dev)
-- 
1.8.1.4

