Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62263 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1DKLJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 07:09:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 04:09:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: Register id table for platform device
Date: Mon, 11 Apr 2011 16:39:41 +0530
Message-ID: <1302520181-11949-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302520181-11949-1-git-send-email-vasanth@atheros.com>
References: <1302520181-11949-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take devid from driver_data of platform_device_id instead of using a hardcoded
value.

Cc: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 9cb0efa..92da321 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -21,6 +21,13 @@
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
+const struct platform_device_id ath9k_platform_id_table[] = {
+	{
+		.name = "ar913x_wmac",
+		.driver_data = AR5416_AR9100_DEVID,
+	},
+};
+
 /* return bus cachesize in 4B word units */
 static void ath_ahb_read_cachesize(struct ath_common *common, int *csz)
 {
@@ -57,6 +64,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	struct resource *res;
+	const struct platform_device_id *id = platform_get_device_id(pdev);
 	int irq;
 	int ret = 0;
 	struct ath_hw *ah;
@@ -116,7 +124,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_free_hw;
 	}
 
-	ret = ath9k_init_device(AR5416_AR9100_DEVID, sc, 0x0, &ath_ahb_bus_ops);
+	ret = ath9k_init_device(id->driver_data, sc, 0x0, &ath_ahb_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_irq;
@@ -165,6 +173,7 @@ static struct platform_driver ath_ahb_driver = {
 		.name	= "ath9k",
 		.owner	= THIS_MODULE,
 	},
+	.id_table    = ath9k_platform_id_table,
 };
 
 int ath_ahb_init(void)
-- 
1.7.0.4

