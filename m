Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36234 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1DLHM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 03:12:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 00:12:01 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2 V2] ath9k: Register id table for platform device
Date: Tue, 12 Apr 2011 12:42:22 +0530
Message-ID: <1302592342-25154-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the device id in the platform driver is hardcoded to an id
which is specific to AR9130/AR9132 SOCs as it supports only wmac (wireless mac)
of these SOCs. But this needs to be dynamic when we want to support different
wmac of SOCs. So add id_table to driver to make it extendable to more SOCs.

Cc: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
V2 

- Verbose to commit log
- Rename platform name to ath9k to avoid breaking existing board support

 
 drivers/net/wireless/ath/ath9k/ahb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 9cb0efa..5193ed5 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -21,6 +21,14 @@
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
+const struct platform_device_id ath9k_platform_id_table[] = {
+	{
+		.name = "ath9k",
+		.driver_data = AR5416_AR9100_DEVID,
+	},
+	{},
+};
+
 /* return bus cachesize in 4B word units */
 static void ath_ahb_read_cachesize(struct ath_common *common, int *csz)
 {
@@ -57,6 +65,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	struct resource *res;
+	const struct platform_device_id *id = platform_get_device_id(pdev);
 	int irq;
 	int ret = 0;
 	struct ath_hw *ah;
@@ -116,7 +125,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_free_hw;
 	}
 
-	ret = ath9k_init_device(AR5416_AR9100_DEVID, sc, 0x0, &ath_ahb_bus_ops);
+	ret = ath9k_init_device(id->driver_data, sc, 0x0, &ath_ahb_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_irq;
@@ -165,8 +174,11 @@ static struct platform_driver ath_ahb_driver = {
 		.name	= "ath9k",
 		.owner	= THIS_MODULE,
 	},
+	.id_table    = ath9k_platform_id_table,
 };
 
+MODULE_DEVICE_TABLE(platform, ath9k_platform_id_table);
+
 int ath_ahb_init(void)
 {
 	return platform_driver_register(&ath_ahb_driver);
-- 
1.7.0.4

