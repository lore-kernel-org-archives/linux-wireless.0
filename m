Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20844 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbbJ3DI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:08:58 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/17] staging: wilc1000: wilc_wlan_start: add argument struct net_device
Date: Fri, 30 Oct 2015 12:10:38 +0900
Message-ID: <1446174642-28570-13-git-send-email-glen.lee@atmel.com> (sfid-20151030_040910_681715_B92C5CE5)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and pass dev to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c  | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bb37f5b..2226ddb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -584,7 +584,7 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 
 	/* start firmware */
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
-	ret = wilc_wlan_start();
+	ret = wilc_wlan_start(dev);
 	if (ret < 0) {
 		PRINT_ER("Failed to start Firmware\n");
 		goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 93fae34..894466f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1489,7 +1489,7 @@ _fail_1:
  *      Common
  *
  ********************************************/
-int wilc_wlan_start(void)
+int wilc_wlan_start(struct net_device *dev)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index c948c25..73e01a7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -297,7 +297,7 @@ typedef struct {
 
 int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
 				u32 buffer_size);
-int wilc_wlan_start(void);
+int wilc_wlan_start(struct net_device *dev);
 int wilc_wlan_stop(struct net_device *dev);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func);
-- 
1.9.1

