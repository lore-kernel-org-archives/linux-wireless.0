Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44360 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906Ab1DARxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 13:53:24 -0400
Received: by mail-ew0-f42.google.com with SMTP id 2so1134620ewy.29
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 10:53:23 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: move hardcoded hci_io_ds value into the conf struct
Date: Fri,  1 Apr 2011 20:52:29 +0300
Message-Id: <1301680349-7186-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcoding the hci_io_ds configuration that we write to the
SDIO_IO_DS top registed, read it from the default configuration so
that it's easier to change for different platforms.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |    2 +-
 drivers/net/wireless/wl12xx/boot.h |   11 +++++++----
 drivers/net/wireless/wl12xx/conf.h |    1 +
 drivers/net/wireless/wl12xx/main.c |    1 +
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b5ec2c2..2b0cf85 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -779,7 +779,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	 * to upload_fw) */
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
-		wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
+		wl1271_top_reg_write(wl, SDIO_IO_DS, wl->conf.hci_io_ds);
 
 	ret = wl1271_boot_upload_firmware(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index d9de64a..e8f8255 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -117,10 +117,13 @@ struct wl1271_static_data {
 #define SDIO_IO_DS                   0xd14
 
 /* SDIO/wSPI DS configuration values */
-#define HCI_IO_DS_8MA                0
-#define HCI_IO_DS_4MA                1 /* default */
-#define HCI_IO_DS_6MA                2
-#define HCI_IO_DS_2MA                3
+enum {
+	HCI_IO_DS_8MA = 0,
+	HCI_IO_DS_4MA = 1, /* default */
+	HCI_IO_DS_6MA = 2,
+	HCI_IO_DS_2MA = 3,
+};
+
 /* end PLL configuration algorithm for wl128x */
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..52269d4 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1206,6 +1206,7 @@ struct conf_drv_settings {
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
+	u8 hci_io_ds;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a5a5d01..732fd21 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -319,6 +319,7 @@ static struct conf_drv_settings default_conf = {
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
 	},
+	.hci_io_ds = HCI_IO_DS_6MA,
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
-- 
1.7.1

