Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40339 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbbASEzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 23:55:18 -0500
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Stable <stable@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2] mwifiex: set netif carrier off in ndo_open
Date: Mon, 19 Jan 2015 15:54:36 +0530
Message-ID: <1421663076-32291-1-git-send-email-patila@marvell.com> (sfid-20150119_055528_595709_277438D0)
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
index 6125d1c..a16c293 100644
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

