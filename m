Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52505 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbcALHgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:36:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/26] staging: wilc1000: use unified firmware
Date: Tue, 12 Jan 2016 16:39:38 +0900
Message-ID: <1452584395-24910-10-git-send-email-glen.lee@atmel.com> (sfid-20160112_083638_313151_5A933BE0)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a unified firmware for all mode of operations which are station, ap and
p2p. Two firmware are introduced for 1002 and 1003 chipset.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile     |  5 ++---
 drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++---------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 20a5cb9..90c3760 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,8 +1,7 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
-ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
-		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
-		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
+ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
+		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
 ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 58837d7..9dccfd8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -416,21 +416,21 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 {
 	struct wilc_vif *vif;
 	struct wilc *wilc;
-	int ret = 0;
+	int chip_id, ret = 0;
 	const struct firmware *wilc_firmware;
 	char *firmware;
 
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	if (vif->iftype == AP_MODE) {
-		firmware = AP_FIRMWARE;
-	} else if (vif->iftype == STATION_MODE) {
-		firmware = STA_FIRMWARE;
-	} else {
-		PRINT_D(INIT_DBG, "Get P2P_CONCURRENCY_FIRMWARE\n");
-		firmware = P2P_CONCURRENCY_FIRMWARE;
-	}
+	chip_id = wilc_get_chipid(wilc, 0);
+
+	if(chip_id < 0x1003a0)
+		firmware = FIRMWARE_1002;
+	else
+		firmware = FIRMWARE_1003;
+
+	netdev_info(dev, "loading firmware %s\n", firmware);
 
 	if (!vif) {
 		PRINT_ER("vif is NULL\n");
-- 
1.9.1

