Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37919 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdIUM4W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 08:56:22 -0400
Received: by mail-pg0-f67.google.com with SMTP id m30so3385597pgn.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 05:56:22 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: [v2] rsi: add version information
Date: Thu, 21 Sep 2017 18:20:34 +0530
Message-Id: <1505998234-1992-1-git-send-email-amitkarwar@gmail.com> (sfid-20170921_145627_154377_8BC1C5D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>

We will dump information about firmware version, firmware file
name and operating mode during initialization.

Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
v2: Removed driver version information.(Kalle Valo)
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 19 ++++++-------------
 drivers/net/wireless/rsi/rsi_91x_hal.c     | 13 +++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c    | 25 +++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_hal.h         |  3 +++
 drivers/net/wireless/rsi/rsi_main.h        | 14 ++++++++++----
 5 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index e98eb55..8c6ca8e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -83,19 +83,12 @@ static int rsi_version_read(struct seq_file *seq, void *data)
 {
 	struct rsi_common *common = seq->private;
 
-	common->driver_ver.major = 0;
-	common->driver_ver.minor = 1;
-	common->driver_ver.release_num = 0;
-	common->driver_ver.patch_num = 0;
-	seq_printf(seq, "Driver : %x.%d.%d.%d\nLMAC   : %d.%d.%d.%d\n",
-		   common->driver_ver.major,
-		   common->driver_ver.minor,
-		   common->driver_ver.release_num,
-		   common->driver_ver.patch_num,
-		   common->fw_ver.major,
-		   common->fw_ver.minor,
-		   common->fw_ver.release_num,
-		   common->fw_ver.patch_num);
+	seq_printf(seq, "LMAC   : %d.%d.%d.%d\n",
+		   common->lmac_ver.major,
+		   common->lmac_ver.minor,
+		   common->lmac_ver.release_num,
+		   common->lmac_ver.patch_num);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 7e8e5d4..71b02ad 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -769,6 +769,7 @@ static int auto_fw_upgrade(struct rsi_hw *adapter, u8 *flash_content,
 
 static int rsi_load_firmware(struct rsi_hw *adapter)
 {
+	struct rsi_common *common = adapter->priv;
 	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
 	const struct firmware *fw_entry = NULL;
 	u32 regout_val = 0, content_size;
@@ -844,6 +845,18 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 	content_size = fw_entry->size;
 	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", content_size);
 
+	/* Get the firmware version */
+	common->lmac_ver.ver.info.fw_ver[0] =
+		flash_content[LMAC_VER_OFFSET] & 0xFF;
+	common->lmac_ver.ver.info.fw_ver[1] =
+		flash_content[LMAC_VER_OFFSET + 1] & 0xFF;
+	common->lmac_ver.major = flash_content[LMAC_VER_OFFSET + 2] & 0xFF;
+	common->lmac_ver.release_num =
+		flash_content[LMAC_VER_OFFSET + 3] & 0xFF;
+	common->lmac_ver.minor = flash_content[LMAC_VER_OFFSET + 4] & 0xFF;
+	common->lmac_ver.patch_num = 0;
+	rsi_print_version(common);
+
 	status = bl_write_header(adapter, flash_content, content_size);
 	if (status) {
 		rsi_dbg(ERR_ZONE,
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index b57bfdc..71b8cfb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -20,6 +20,7 @@
 #include <linux/firmware.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 u32 rsi_zone_enabled = /* INFO_ZONE |
 			INIT_ZONE |
@@ -56,6 +57,30 @@ void rsi_dbg(u32 zone, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(rsi_dbg);
 
+static char *opmode_str(int oper_mode)
+{
+	switch (oper_mode) {
+	case RSI_DEV_OPMODE_WIFI_ALONE:
+		return "Wi-Fi alone";
+	}
+
+	return "Unknown";
+}
+
+void rsi_print_version(struct rsi_common *common)
+{
+	rsi_dbg(ERR_ZONE, "================================================\n");
+	rsi_dbg(ERR_ZONE, "================ RSI Version Info ==============\n");
+	rsi_dbg(ERR_ZONE, "================================================\n");
+	rsi_dbg(ERR_ZONE, "FW Version\t: %d.%d.%d\n",
+		common->lmac_ver.major, common->lmac_ver.minor,
+		common->lmac_ver.release_num);
+	rsi_dbg(ERR_ZONE, "Operating mode\t: %d [%s]",
+		common->oper_mode, opmode_str(common->oper_mode));
+	rsi_dbg(ERR_ZONE, "Firmware file\t: %s", common->priv->fw_file_name);
+	rsi_dbg(ERR_ZONE, "================================================\n");
+}
+
 /**
  * rsi_prepare_skb() - This function prepares the skb.
  * @common: Pointer to the driver private structure.
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index ad0d653..a09d36b 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -101,6 +101,9 @@
 
 #define BBP_INFO_40MHZ 0x6
 
+#define FW_FLASH_OFFSET			0x820
+#define LMAC_VER_OFFSET			(FW_FLASH_OFFSET + 0x200)
+
 struct bl_header {
 	__le32 flags;
 	__le32 image_no;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 34089ab..a118b7a 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -113,8 +113,13 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 struct version_info {
 	u16 major;
 	u16 minor;
-	u16 release_num;
-	u16 patch_num;
+	u8 release_num;
+	u8 patch_num;
+	union {
+		struct {
+			u8 fw_ver[8];
+		} info;
+	} ver;
 } __packed;
 
 struct skb_info {
@@ -199,8 +204,7 @@ struct rsi_common {
 	struct vif_priv vif_info[RSI_MAX_VIFS];
 
 	bool mgmt_q_block;
-	struct version_info driver_ver;
-	struct version_info fw_ver;
+	struct version_info lmac_ver;
 
 	struct rsi_thread tx_thread;
 	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 2];
@@ -334,6 +338,8 @@ struct rsi_hw {
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
 
+void rsi_print_version(struct rsi_common *common);
+
 struct rsi_host_intf_ops {
 	int (*read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
 	int (*write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
-- 
2.7.4
