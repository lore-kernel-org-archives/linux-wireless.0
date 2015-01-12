Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50703 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbbALGzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 01:55:17 -0500
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: set netif carrier off in ndo_open
Date: Mon, 12 Jan 2015 17:54:56 +0530
Message-ID: <1421065496-1968-1-git-send-email-patila@marvell.com> (sfid-20150112_075523_686139_C5D813D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch adds fix to set carrier state off during ndo_open.
Carrier should be set to ON when device is ready to send data.
In case of station/adhoc interface device is able to transfer
data after successful association/join operation.
For AP this would be after bss_active event.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index effea6e..48e7c63 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -562,7 +562,8 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 static int
 mwifiex_open(struct net_device *dev)
 {
-	netif_tx_start_all_queues(dev);
+	netif_carrier_off(dev);
+
 	return 0;
 }
 
-- 
1.8.1.4

