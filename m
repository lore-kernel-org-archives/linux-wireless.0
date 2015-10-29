Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28211 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbbJ2DQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:16:23 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 06/12] staging: wilc1000: linux_wlan_start_firmware: change argument with dev
Date: Thu, 29 Oct 2015 12:18:46 +0900
Message-ID: <1446088732-12301-6-git-send-email-glen.lee@atmel.com> (sfid-20151029_041626_108303_D6411BC7)
In-Reply-To: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes argument nic with dev and use netdev private data member
wilc instead of g_linux_wlan, and pass dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 69d2839..6b5f1c5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -570,10 +570,15 @@ _fail_:
 
 }
 
-static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
+static int linux_wlan_start_firmware(struct net_device *dev)
 {
-
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 	int ret = 0;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
 	/* start firmware */
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
 	ret = wilc_wlan_start();
@@ -584,7 +589,7 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 
 	/* wait for mac ready */
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
-	ret = linux_wlan_lock_timeout(&g_linux_wlan->sync_event, 5000);
+	ret = linux_wlan_lock_timeout(&wilc->sync_event, 5000);
 	if (ret) {
 		PRINT_D(INIT_DBG, "Firmware start timed out");
 		goto _fail_;
@@ -1136,7 +1141,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/* Start firmware*/
-		ret = linux_wlan_start_firmware(nic);
+		ret = linux_wlan_start_firmware(dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to start firmware\n");
 			ret = -EIO;
-- 
1.9.1

