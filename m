Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:46535 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab3G2TaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 15:30:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] Bluetooth: btmrvl: add calibration data download support
Date: Mon, 29 Jul 2013 12:29:07 -0700
Message-ID: <1375126147-28642-1-git-send-email-bzhao@marvell.com> (sfid-20130729_213009_949640_0FAA59F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

A text file containing calibration data in hex format can
be provided while loading btmrvl module. The data will be
downloaded to firmware.
eg. insmod btmrvl.ko cal_data_cfg=mrvl/bt_cal_data.conf

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/bluetooth/btmrvl_drv.h  |   9 ++-
 drivers/bluetooth/btmrvl_main.c | 140 +++++++++++++++++++++++++++++++++++++++-
 drivers/bluetooth/btmrvl_sdio.c |   2 +-
 3 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index 27068d1..f9a6e1b 100644
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
@@ -41,6 +43,7 @@ struct btmrvl_thread {
 struct btmrvl_device {
 	void *card;
 	struct hci_dev *hcidev;
+	struct device *dev;
 
 	u8 dev_type;
 
@@ -91,6 +94,7 @@ struct btmrvl_private {
 #define BT_CMD_HOST_SLEEP_CONFIG	0x59
 #define BT_CMD_HOST_SLEEP_ENABLE	0x5A
 #define BT_CMD_MODULE_CFG_REQ		0x5B
+#define BT_CMD_LOAD_CONFIG_DATA		0x61
 
 /* Sub-commands: Module Bringup/Shutdown Request/Response */
 #define MODULE_BRINGUP_REQ		0xF1
@@ -116,10 +120,13 @@ struct btmrvl_private {
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
index 9a9f518..e16c65c 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -27,6 +27,9 @@
 
 #define VERSION "1.0"
 
+static char *cal_data_cfg;
+module_param(cal_data_cfg, charp, 0);
+
 /*
  * This function is called by interface specific interrupt handler.
  * It updates Power Save & Host Sleep states, and wakes up the main
@@ -57,8 +60,9 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
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
@@ -552,6 +556,129 @@ static int btmrvl_service_main_thread(void *data)
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
+				BT_ERR("cal_file size too big!!!");
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
+static int btmrvl_cal_data_config(struct btmrvl_private *priv, char *cal_file)
+{
+	const struct firmware *cfg;
+	int ret;
+
+	if (!cal_file)
+		return 0;
+
+	ret = request_firmware(&cfg, cal_file, priv->btmrvl_dev.dev);
+	if (ret < 0) {
+		BT_ERR("request_firmware() %s failed", cal_file);
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
 
+	ret = btmrvl_cal_data_config(priv, cal_data_cfg);
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
index 75c2626..bb9912c 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -18,7 +18,6 @@
  * this warranty disclaimer.
  **/
 
-#include <linux/firmware.h>
 #include <linux/slab.h>
 
 #include <linux/mmc/sdio_ids.h>
@@ -1034,6 +1033,7 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 	}
 
 	card->priv = priv;
+	priv->btmrvl_dev.dev = &card->func->dev;
 
 	/* Initialize the interface specific function pointers */
 	priv->hw_host_to_card = btmrvl_sdio_host_to_card;
-- 
1.8.0

