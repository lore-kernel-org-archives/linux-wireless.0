Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16935 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707Ab3ITWVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 18:21:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 2/2] Bluetooth: btmrvl: add calibration data download support
Date: Fri, 20 Sep 2013 15:21:07 -0700
Message-ID: <1379715667-22424-2-git-send-email-bzhao@marvell.com> (sfid-20130921_002146_740679_75530C31)
In-Reply-To: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
References: <1379715667-22424-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

A text file containing calibration data in hex format can
be provided at following path:

/lib/firmware/mrvl/sd8797_caldata.conf

The data will be downloaded to firmware during initialization.

Reviewed-by: Mike Frysinger <vapier@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Hyuckjoo Lee <hyuckjoo.lee@samsung.com>
---
v2: Remove module parameter. The calibration data will be downloaded
    only when the device speicific data file is provided.
    (Marcel Holtmann)
v3: Fix crash (misaligned memory access) on ARM
v4: Simplify white space parsing and save some CPU cycles (Mike Frysinger)
v5: Improvements in cal data parsing logic. Add explanatory comments.
    Replace GFP_ATOMIC flag with GFP_KERNEL (Mike Frysinger)

 drivers/bluetooth/btmrvl_drv.h  |   10 +++-
 drivers/bluetooth/btmrvl_main.c |  144 ++++++++++++++++++++++++++++++++++++++-
 drivers/bluetooth/btmrvl_sdio.c |    9 ++-
 drivers/bluetooth/btmrvl_sdio.h |    2 +
 4 files changed, 161 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index e776b8b..dcd3468 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -23,6 +23,8 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <net/bluetooth/bluetooth.h>
+#include <linux/ctype.h>
+#include <linux/firmware.h>
 
 #define BTM_HEADER_LEN			4
 #define BTM_UPLD_SIZE			2312
@@ -41,6 +43,8 @@ struct btmrvl_thread {
 struct btmrvl_device {
 	void *card;
 	struct hci_dev *hcidev;
+	struct device *dev;
+	const char *cal_data;
 
 	u8 dev_type;
 
@@ -92,6 +96,7 @@ struct btmrvl_private {
 #define BT_CMD_HOST_SLEEP_CONFIG	0x59
 #define BT_CMD_HOST_SLEEP_ENABLE	0x5A
 #define BT_CMD_MODULE_CFG_REQ		0x5B
+#define BT_CMD_LOAD_CONFIG_DATA		0x61
 
 /* Sub-commands: Module Bringup/Shutdown Request/Response */
 #define MODULE_BRINGUP_REQ		0xF1
@@ -117,10 +122,13 @@ struct btmrvl_private {
 #define PS_SLEEP			0x01
 #define PS_AWAKE			0x00
 
+#define BT_CMD_DATA_SIZE		32
+#define BT_CAL_DATA_SIZE		28
+
 struct btmrvl_cmd {
 	__le16 ocf_ogf;
 	u8 length;
-	u8 data[4];
+	u8 data[BT_CMD_DATA_SIZE];
 } __packed;
 
 struct btmrvl_event {
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index e352f8e..6eea188 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -57,8 +57,9 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
 		ocf = hci_opcode_ocf(opcode);
 		ogf = hci_opcode_ogf(opcode);
 
-		if (ocf == BT_CMD_MODULE_CFG_REQ &&
-					priv->btmrvl_dev.sendcmdflag) {
+		if ((ocf == BT_CMD_MODULE_CFG_REQ ||
+		     ocf == BT_CMD_LOAD_CONFIG_DATA) &&
+		    priv->btmrvl_dev.sendcmdflag) {
 			priv->btmrvl_dev.sendcmdflag = false;
 			priv->adapter->cmd_complete = true;
 			wake_up_interruptible(&priv->adapter->cmd_wait_q);
@@ -479,6 +480,142 @@ static int btmrvl_open(struct hci_dev *hdev)
 	return 0;
 }
 
+/*
+ * This function parses provided calibration data input. It should contain
+ * hex bytes separated by space or new line character. Here is an example.
+ * 00 1C 01 37 FF FF FF FF 02 04 7F 01
+ * CE BA 00 00 00 2D C6 C0 00 00 00 00
+ * 00 F0 00 00
+ */
+static int btmrvl_parse_cal_cfg(const u8 *src, u32 len, u8 *dst, u32 dst_size)
+{
+	const u8 *s = src;
+	u8 *d = dst;
+	int ret;
+	u8 tmp[3];
+
+	tmp[2] = '\0';
+	while ((s - src) <= len - 2) {
+		if (isspace(*s) || *s == '\n') {
+			s++;
+			continue;
+		}
+
+		if (isxdigit(*s)) {
+			if ((d - dst) >= dst_size) {
+				BT_ERR("calibration data file too big!!!");
+				return -EINVAL;
+			}
+
+			memcpy(tmp, s, 2);
+
+			ret = kstrtou8(tmp, 16, d++);
+			if (ret < 0)
+				return ret;
+
+			s += 2;
+		} else {
+			return -EINVAL;
+		}
+	}
+	if (d == dst)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int btmrvl_load_cal_data(struct btmrvl_private *priv,
+				u8 *config_data)
+{
+	struct sk_buff *skb;
+	struct btmrvl_cmd *cmd;
+	int i;
+
+	skb = bt_skb_alloc(sizeof(*cmd), GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct btmrvl_cmd *)skb->data;
+	cmd->ocf_ogf =
+		cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_LOAD_CONFIG_DATA));
+	cmd->length = BT_CMD_DATA_SIZE;
+	cmd->data[0] = 0x00;
+	cmd->data[1] = 0x00;
+	cmd->data[2] = 0x00;
+	cmd->data[3] = BT_CMD_DATA_SIZE - 4;
+
+	/* Swap cal-data bytes. Each four bytes are swapped. Considering 4
+	 * byte SDIO header offset, mapping of input and output bytes will be
+	 * {3, 2, 1, 0} -> {0+4, 1+4, 2+4, 3+4},
+	 * {7, 6, 5, 4} -> {4+4, 5+4, 6+4, 7+4} */
+	for (i = 4; i < BT_CMD_DATA_SIZE; i++)
+		cmd->data[i] = config_data[(i / 4) * 8 - 1 - i];
+
+	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
+	skb_put(skb, sizeof(*cmd));
+	skb->dev = (void *)priv->btmrvl_dev.hcidev;
+	skb_queue_head(&priv->adapter->tx_queue, skb);
+	priv->btmrvl_dev.sendcmdflag = true;
+	priv->adapter->cmd_complete = false;
+
+	print_hex_dump_bytes("Calibration data: ",
+			     DUMP_PREFIX_OFFSET, cmd->data, BT_CMD_DATA_SIZE);
+
+	wake_up_interruptible(&priv->main_thread.wait_q);
+	if (!wait_event_interruptible_timeout(priv->adapter->cmd_wait_q,
+					      priv->adapter->cmd_complete,
+				       msecs_to_jiffies(WAIT_UNTIL_CMD_RESP))) {
+		BT_ERR("Timeout while loading calibration data");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int
+btmrvl_process_cal_cfg(struct btmrvl_private *priv, u8 *data, u32 size)
+{
+	u8 cal_data[BT_CAL_DATA_SIZE];
+	int ret;
+
+	ret = btmrvl_parse_cal_cfg(data, size, cal_data, sizeof(cal_data));
+	if (ret)
+		return ret;
+
+	ret = btmrvl_load_cal_data(priv, cal_data);
+	if (ret) {
+		BT_ERR("Fail to load calibrate data");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int btmrvl_cal_data_config(struct btmrvl_private *priv)
+{
+	const struct firmware *cfg;
+	int ret;
+	const char *cal_data = priv->btmrvl_dev.cal_data;
+
+	if (!cal_data)
+		return 0;
+
+	ret = request_firmware(&cfg, cal_data, priv->btmrvl_dev.dev);
+	if (ret < 0) {
+		BT_DBG("Failed to get %s file, skipping cal data download",
+		       cal_data);
+		ret = 0;
+		goto done;
+	}
+
+	ret = btmrvl_process_cal_cfg(priv, (u8 *)cfg->data, cfg->size);
+done:
+	if (cfg)
+		release_firmware(cfg);
+
+	return ret;
+}
+
 static int btmrvl_setup(struct hci_dev *hdev)
 {
 	struct btmrvl_private *priv = hci_get_drvdata(hdev);
@@ -489,6 +626,9 @@ static int btmrvl_setup(struct hci_dev *hdev)
 
 	btmrvl_send_module_cfg_cmd(priv, MODULE_BRINGUP_REQ);
 
+	if (btmrvl_cal_data_config(priv))
+		BT_ERR("Set cal data failed");
+
 	priv->btmrvl_dev.psmode = 1;
 	btmrvl_enable_ps(priv);
 
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index c526915..51e95ed 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -18,7 +18,6 @@
  * this warranty disclaimer.
  **/
 
-#include <linux/firmware.h>
 #include <linux/slab.h>
 
 #include <linux/mmc/sdio_ids.h>
@@ -102,6 +101,7 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_88xx = {
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
 	.helper		= "mrvl/sd8688_helper.bin",
 	.firmware	= "mrvl/sd8688.bin",
+	.cal_data	= NULL,
 	.reg		= &btmrvl_reg_8688,
 	.sd_blksz_fw_dl	= 64,
 };
@@ -109,6 +109,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8787 = {
 	.helper		= NULL,
 	.firmware	= "mrvl/sd8787_uapsta.bin",
+	.cal_data	= NULL,
 	.reg		= &btmrvl_reg_87xx,
 	.sd_blksz_fw_dl	= 256,
 };
@@ -116,6 +117,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8787 = {
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8797 = {
 	.helper		= NULL,
 	.firmware	= "mrvl/sd8797_uapsta.bin",
+	.cal_data	= "mrvl/sd8797_caldata.conf",
 	.reg		= &btmrvl_reg_87xx,
 	.sd_blksz_fw_dl	= 256,
 };
@@ -123,6 +125,7 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8797 = {
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8897 = {
 	.helper		= NULL,
 	.firmware	= "mrvl/sd8897_uapsta.bin",
+	.cal_data	= NULL,
 	.reg		= &btmrvl_reg_88xx,
 	.sd_blksz_fw_dl	= 256,
 };
@@ -1006,6 +1009,7 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 		struct btmrvl_sdio_device *data = (void *) id->driver_data;
 		card->helper = data->helper;
 		card->firmware = data->firmware;
+		card->cal_data = data->cal_data;
 		card->reg = data->reg;
 		card->sd_blksz_fw_dl = data->sd_blksz_fw_dl;
 	}
@@ -1034,6 +1038,8 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 	}
 
 	card->priv = priv;
+	priv->btmrvl_dev.dev = &card->func->dev;
+	priv->btmrvl_dev.cal_data = card->cal_data;
 
 	/* Initialize the interface specific function pointers */
 	priv->hw_host_to_card = btmrvl_sdio_host_to_card;
@@ -1216,4 +1222,5 @@ MODULE_FIRMWARE("mrvl/sd8688_helper.bin");
 MODULE_FIRMWARE("mrvl/sd8688.bin");
 MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
+MODULE_FIRMWARE("mrvl/sd8797_caldata.conf");
 MODULE_FIRMWARE("mrvl/sd8897_uapsta.bin");
diff --git a/drivers/bluetooth/btmrvl_sdio.h b/drivers/bluetooth/btmrvl_sdio.h
index 43d35a6..6872d9e 100644
--- a/drivers/bluetooth/btmrvl_sdio.h
+++ b/drivers/bluetooth/btmrvl_sdio.h
@@ -85,6 +85,7 @@ struct btmrvl_sdio_card {
 	u32 ioport;
 	const char *helper;
 	const char *firmware;
+	const char *cal_data;
 	const struct btmrvl_sdio_card_reg *reg;
 	u16 sd_blksz_fw_dl;
 	u8 rx_unit;
@@ -94,6 +95,7 @@ struct btmrvl_sdio_card {
 struct btmrvl_sdio_device {
 	const char *helper;
 	const char *firmware;
+	const char *cal_data;
 	const struct btmrvl_sdio_card_reg *reg;
 	u16 sd_blksz_fw_dl;
 };
-- 
1.7.3.4

