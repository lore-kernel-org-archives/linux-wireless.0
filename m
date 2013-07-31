Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:36202 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab3GaBGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 21:06:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] Bluetooth: btmrvl: add calibration data download support
Date: Tue, 30 Jul 2013 18:05:59 -0700
Message-ID: <1375232759-32114-1-git-send-email-bzhao@marvell.com> (sfid-20130731_030623_224034_B3E5CD82)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

A text file containing calibration data in hex format can
be provided at following path:

/lib/firmware/mrvl/sd8797_caldata.conf

The data will be downloaded to firmware during initialization.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: Remove module parameter. The calibration data will be downloaded
    only when the device speicific data file is provided.
    (Marcel Holtmann)

 drivers/bluetooth/btmrvl_drv.h  |  10 ++-
 drivers/bluetooth/btmrvl_main.c | 140 +++++++++++++++++++++++++++++++++++++++-
 drivers/bluetooth/btmrvl_sdio.c |   9 ++-
 drivers/bluetooth/btmrvl_sdio.h |   2 +
 4 files changed, 157 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index 27068d1..5ef5e84 100644
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
 
@@ -91,6 +95,7 @@ struct btmrvl_private {
 #define BT_CMD_HOST_SLEEP_CONFIG	0x59
 #define BT_CMD_HOST_SLEEP_ENABLE	0x5A
 #define BT_CMD_MODULE_CFG_REQ		0x5B
+#define BT_CMD_LOAD_CONFIG_DATA		0x61
 
 /* Sub-commands: Module Bringup/Shutdown Request/Response */
 #define MODULE_BRINGUP_REQ		0xF1
@@ -116,10 +121,13 @@ struct btmrvl_private {
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
index 9a9f518..9487684 100644
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
@@ -552,6 +553,132 @@ static int btmrvl_service_main_thread(void *data)
 	return 0;
 }
 
+static int btmrvl_parse_cal_cfg(const u8 *src, u32 len, u8 *dst, u32 dst_size)
+{
+	const u8 *s = src;
+	u8 *d = dst;
+	int ret;
+	u8 tmp[3];
+
+	while ((s - src) < len) {
+		if (*s && (isspace(*s) || *s == '\t')) {
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
+			tmp[2] = '\0';
+
+			ret = kstrtol(tmp, 16, (long *)d++);
+			if (ret < 0)
+				return ret;
+
+			s += 2;
+		} else {
+			s++;
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
+	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
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
+	/* swap cal-data bytes */
+	for (i = 4; i < BT_CMD_DATA_SIZE; i++)
+		cmd->data[i] = config_data[(i/4)*8 - 1 - i];
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
 int btmrvl_register_hdev(struct btmrvl_private *priv)
 {
 	struct hci_dev *hdev = NULL;
@@ -583,12 +710,21 @@ int btmrvl_register_hdev(struct btmrvl_private *priv)
 		goto err_hci_register_dev;
 	}
 
+	ret = btmrvl_cal_data_config(priv);
+	if (ret) {
+		BT_ERR("Set cal data failed");
+		goto err_cal_data_config;
+	}
+
 #ifdef CONFIG_DEBUG_FS
 	btmrvl_debugfs_init(hdev);
 #endif
 
 	return 0;
 
+err_cal_data_config:
+	hci_unregister_dev(hdev);
+
 err_hci_register_dev:
 	hci_free_dev(hdev);
 
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 75c2626..292fd92 100644
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
@@ -1222,4 +1228,5 @@ MODULE_FIRMWARE("mrvl/sd8688_helper.bin");
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
1.8.0

