Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14301 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcA0C5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/13] staging: wilc1000: rename Firmware_ver variable
Date: Wed, 27 Jan 2016 11:50:29 +0900
Message-ID: <1453863037-31073-5-git-send-email-glen.lee@atmel.com> (sfid-20160127_035738_016387_0BCCD1B3)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Firmware_ver variable to firmware_ver to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 06c79dd..fd405b0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -929,13 +929,14 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 
 		if (wilc_wlan_cfg_get(vif, 1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
-			char Firmware_ver[20];
-
-			size = wilc_wlan_cfg_get_val(
-					WID_FIRMWARE_VERSION,
-					Firmware_ver, sizeof(Firmware_ver));
-			Firmware_ver[size] = '\0';
-			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
+			char firmware_ver[20];
+
+			size = wilc_wlan_cfg_get_val(WID_FIRMWARE_VERSION,
+						     firmware_ver,
+						     sizeof(firmware_ver));
+			firmware_ver[size] = '\0';
+			PRINT_D(INIT_DBG, "**** Firmware Ver = %s ****\n",
+				firmware_ver);
 		}
 		ret = linux_wlan_init_test_config(dev, vif);
 
-- 
1.9.1

