Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53967 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab3LCHSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/12] mwifiex: remove redundant goto exit_remove statement
Date: Mon, 2 Dec 2013 23:17:57 -0800
Message-ID: <1386055079-6623-11-git-send-email-bzhao@marvell.com> (sfid-20131203_081853_433175_97E33B20)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The check for 'priv' pointer is redundant. 'priv' won't
be used later in this routine.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 36c79cf..6bf58ab 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -992,12 +992,8 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		rtnl_unlock();
 	}
 
-	priv = adapter->priv[0];
-	if (!priv || !priv->wdev)
-		goto exit_remove;
-
-	wiphy_unregister(priv->wdev->wiphy);
-	wiphy_free(priv->wdev->wiphy);
+	wiphy_unregister(adapter->wiphy);
+	wiphy_free(adapter->wiphy);
 
 	mwifiex_terminate_workqueue(adapter);
 
-- 
1.8.2.3

