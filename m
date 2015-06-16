Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0133.outbound.protection.outlook.com ([157.55.234.133]:63381
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751556AbbFPHYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:24:23 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] Staging: wilc1000: Remove casting the values returned by
 kmalloc()
Date: Tue, 16 Jun 2015 07:09:56 +0000
Message-ID: <1434438514-5247-1-git-send-email-habdul@visteon.com> (sfid-20150616_092426_650750_8885E53A)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch removes casting the values returned by memory allocation functions.

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d5860ce..8cba13c 100644
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
@@ -258,7 +258,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	len += sizeof(struct tx_complete_mon_data *);
 	#endif
 
-	mgmt_tx->buff = (char *)kmalloc(len, GFP_ATOMIC);
+	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (mgmt_tx->buff == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		return WILC_FAIL;
-- 
1.9.1
