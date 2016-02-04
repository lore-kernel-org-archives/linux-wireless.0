Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10549 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966103AbcBDJ1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:27:31 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 37/70] staging: wilc1000: Optimize code of wilc_get_chipid function
Date: Thu, 4 Feb 2016 18:15:54 +0900
Message-ID: <1454577387-509-38-git-send-email-glen.lee@atmel.com> (sfid-20160204_102738_285257_B1FA07E6)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch optimize code of wilc_get_chipid function.
u8 type changed to boolean type and removed unnecessary if statement.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  4 ++--
 drivers/staging/wilc1000/wilc_wlan.c    | 19 +++++++------------
 drivers/staging/wilc1000/wilc_wlan_if.h |  2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 22a2f98..9e5dea4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -388,7 +388,7 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	chip_id = wilc_get_chipid(wilc, 0);
+	chip_id = wilc_get_chipid(wilc, false);
 
 	if (chip_id < 0x1003a0)
 		firmware = FIRMWARE_1002;
@@ -475,7 +475,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	wilc_get_mac_address(vif, mac_add);
 
 	netdev_dbg(dev, "MAC address is : %pM\n", mac_add);
-	wilc_get_chipid(wilc, 0);
+	wilc_get_chipid(wilc, false);
 
 	*(int *)c_val = 1;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index dc26322..46087e2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1441,36 +1441,31 @@ static u32 init_chip(struct net_device *dev)
 	return ret;
 }
 
-u32 wilc_get_chipid(struct wilc *wilc, u8 update)
+u32 wilc_get_chipid(struct wilc *wilc, bool update)
 {
 	static u32 chipid;
 	u32 tempchipid = 0;
-	u32 rfrevid;
+	u32 rfrevid = 0;
 
-	if (chipid == 0 || update != 0) {
+	if (chipid == 0 || update) {
 		wilc->hif_func->hif_read_reg(wilc, 0x1000, &tempchipid);
 		wilc->hif_func->hif_read_reg(wilc, 0x13f4, &rfrevid);
 		if (!ISWILC1000(tempchipid)) {
 			chipid = 0;
-			goto _fail_;
+			return chipid;
 		}
 		if (tempchipid == 0x1002a0) {
-			if (rfrevid == 0x1) {
-			} else {
+			if (rfrevid != 0x1)
 				tempchipid = 0x1002a1;
-			}
 		} else if (tempchipid == 0x1002b0) {
-			if (rfrevid == 3) {
-			} else if (rfrevid == 4) {
+			if (rfrevid == 0x4)
 				tempchipid = 0x1002b1;
-			} else {
+			else if (rfrevid != 0x3)
 				tempchipid = 0x1002b2;
-			}
 		}
 
 		chipid = tempchipid;
 	}
-_fail_:
 	return chipid;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 294552d..269c56e 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -921,6 +921,6 @@ struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-u32 wilc_get_chipid(struct wilc *wilc, u8 update);
+u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
 #endif
-- 
1.9.1

