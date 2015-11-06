Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37036 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 34/73] staging: wilc1000: rename Dropped variable
Date: Fri, 6 Nov 2015 11:12:55 +0900
Message-ID: <1446776014-28094-34-git-send-email-glen.lee@atmel.com> (sfid-20151106_033755_090041_69391978)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Dropped variable to dropped
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 66d7f1e..283ab52 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -345,7 +345,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
 	u32 i = 0;
-	u32 Dropped = 0;
+	u32 dropped = 0;
 	wilc_wlan_dev_t *p = &g_wlan;
 
 	nic = netdev_priv(dev);
@@ -366,7 +366,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				kfree(tqe);
-				Dropped++;
+				dropped++;
 			}
 		}
 	}
@@ -380,9 +380,9 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
 
-	while (Dropped > 0) {
+	while (dropped > 0) {
 		linux_wlan_lock_timeout(&wilc->txq_event, 1);
-		Dropped--;
+		dropped--;
 	}
 
 	return 1;
-- 
1.9.1

