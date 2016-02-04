Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58435 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbcBDJax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:30:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 40/70] staging: wilc1000: wilc_wlan.c: replaces PRINT_ER with netdev_err
Date: Thu, 4 Feb 2016 18:24:01 +0900
Message-ID: <1454577871-667-1-git-send-email-glen.lee@atmel.com> (sfid-20160204_103101_753671_928BBF95)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patches replaces PRINT_ER with netdev_err.
Removes unnecessary debug logs as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 46087e2..ec111d8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1496,7 +1496,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
@@ -1505,7 +1504,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
 	}
 
-- 
1.9.1

