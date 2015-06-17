Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0139.outbound.protection.outlook.com ([157.55.234.139]:16096
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063AbbFQEs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 00:48:26 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Staging: wilc1000: Remove casting the values returned by
 kmalloc()
Date: Wed, 17 Jun 2015 04:48:23 +0000
Message-ID: <1434516421-26313-1-git-send-email-habdul@visteon.com> (sfid-20150617_064845_724837_40579B8F)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch removes casting the values returned by memory allocation functions.

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/linux_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index bc7feb4..8cba13c 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -247,7 +247,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	nic = netdev_priv(dev);
 
 	netif_stop_queue(dev);
-	mgmt_tx = (struct tx_complete_mon_data *)kmalloc(sizeof(struct tx_complete_mon_data), GFP_ATOMIC);
+	mgmt_tx = kmalloc(sizeof(struct tx_complete_mon_data), GFP_ATOMIC);
 	if (mgmt_tx == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 		return WILC_FAIL;
-- 
1.9.1
