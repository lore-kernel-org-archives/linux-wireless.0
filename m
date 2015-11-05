Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26792 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbbKEFfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:35:32 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 21/38] staging: wilc1000: fixes add spaces required around that '&&'
Date: Thu, 5 Nov 2015 14:36:22 +0900
Message-ID: <1446701799-24870-21-git-send-email-glen.lee@atmel.com> (sfid-20151105_063755_451394_FCBA97FF)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes add to spaces around that '&&' or '||'.
Reported by checkpatch.pl for spaces required around that '&&' or '||' (ctx:VxE).

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4b2afa0..aecb89d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1093,7 +1093,7 @@ int mac_open(struct net_device *ndev)
 	wl = nic->wilc;
 
 #ifdef WILC_SPI
-	if (!wl|| !wl->wilc_spidev) {
+	if (!wl || !wl->wilc_spidev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
@@ -1495,8 +1495,7 @@ void wl_wlan_cleanup(struct wilc *wilc)
 	if (wilc && wilc->firmware)
 		release_firmware(wilc->firmware);
 
-	if (wilc&&
-	   (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
+	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
 		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-- 
1.9.1

