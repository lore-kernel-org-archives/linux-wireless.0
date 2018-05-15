Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58118 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752922AbeEOJPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:08 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/8] btmrvl: support sysfs initiated firmware coredump
Date: Tue, 15 May 2018 11:14:48 +0200
Message-Id: <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111551_543416_43779E3A)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
it is possible to initiate a device coredump from user-space. This
patch adds support for it in btmrvl_sdio adding the .coredump()
driver callback. This makes dump through debugfs obsolete so removing
it.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
 drivers/bluetooth/btmrvl_drv.h     |  2 --
 drivers/bluetooth/btmrvl_main.c    |  6 ------
 drivers/bluetooth/btmrvl_sdio.c    | 11 ++++++++---
 4 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index 1828ed8..023d35e 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -167,35 +167,6 @@ static ssize_t btmrvl_hscmd_read(struct file *file, char __user *userbuf,
 	.llseek = default_llseek,
 };
 
-static ssize_t btmrvl_fwdump_write(struct file *file, const char __user *ubuf,
-				   size_t count, loff_t *ppos)
-{
-	struct btmrvl_private *priv = file->private_data;
-	char buf[16];
-	bool result;
-
-	memset(buf, 0, sizeof(buf));
-
-	if (copy_from_user(&buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
-		return -EFAULT;
-
-	if (strtobool(buf, &result))
-		return -EINVAL;
-
-	if (!result)
-		return -EINVAL;
-
-	btmrvl_firmware_dump(priv);
-
-	return count;
-}
-
-static const struct file_operations btmrvl_fwdump_fops = {
-	.write	= btmrvl_fwdump_write,
-	.open	= simple_open,
-	.llseek = default_llseek,
-};
-
 void btmrvl_debugfs_init(struct hci_dev *hdev)
 {
 	struct btmrvl_private *priv = hci_get_drvdata(hdev);
@@ -226,8 +197,6 @@ void btmrvl_debugfs_init(struct hci_dev *hdev)
 			    priv, &btmrvl_hscmd_fops);
 	debugfs_create_file("hscfgcmd", 0644, dbg->config_dir,
 			    priv, &btmrvl_hscfgcmd_fops);
-	debugfs_create_file("fw_dump", 0200, dbg->config_dir,
-			    priv, &btmrvl_fwdump_fops);
 
 	dbg->status_dir = debugfs_create_dir("status", hdev->debugfs);
 	debugfs_create_u8("curpsmode", 0444, dbg->status_dir,
diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index fc3caf4..f045454 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -110,7 +110,6 @@ struct btmrvl_private {
 				u8 *payload, u16 nb);
 	int (*hw_wakeup_firmware)(struct btmrvl_private *priv);
 	int (*hw_process_int_status)(struct btmrvl_private *priv);
-	void (*firmware_dump)(struct btmrvl_private *priv);
 	spinlock_t driver_lock;		/* spinlock used by driver */
 #ifdef CONFIG_DEBUG_FS
 	void *debugfs_data;
@@ -183,7 +182,6 @@ struct btmrvl_event {
 int btmrvl_enable_ps(struct btmrvl_private *priv);
 int btmrvl_prepare_command(struct btmrvl_private *priv);
 int btmrvl_enable_hs(struct btmrvl_private *priv);
-void btmrvl_firmware_dump(struct btmrvl_private *priv);
 
 #ifdef CONFIG_DEBUG_FS
 void btmrvl_debugfs_init(struct hci_dev *hdev);
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index f6c694a..708ad216 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -358,12 +358,6 @@ int btmrvl_prepare_command(struct btmrvl_private *priv)
 	return ret;
 }
 
-void btmrvl_firmware_dump(struct btmrvl_private *priv)
-{
-	if (priv->firmware_dump)
-		priv->firmware_dump(priv);
-}
-
 static int btmrvl_tx_pkt(struct btmrvl_private *priv, struct sk_buff *skb)
 {
 	int ret = 0;
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 6f99b9f..888bac4 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1311,9 +1311,11 @@ rdwr_status btmrvl_sdio_rdwr_firmware(struct btmrvl_private *priv,
 }
 
 /* This function dump sdio register and memory data */
-static void btmrvl_sdio_dump_firmware(struct btmrvl_private *priv)
+static void btmrvl_sdio_coredump(struct device *dev)
 {
-	struct btmrvl_sdio_card *card = priv->btmrvl_dev.card;
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct btmrvl_sdio_card *card;
+	struct btmrvl_private *priv;
 	int ret = 0;
 	unsigned int reg, reg_start, reg_end;
 	enum rdwr_status stat;
@@ -1321,6 +1323,9 @@ static void btmrvl_sdio_dump_firmware(struct btmrvl_private *priv)
 	u8 dump_num = 0, idx, i, read_reg, doneflag = 0;
 	u32 memory_size, fw_dump_len = 0;
 
+	card = sdio_get_drvdata(func);
+	priv = card->priv;
+
 	/* dump sdio register first */
 	btmrvl_sdio_dump_regs(priv);
 
@@ -1547,7 +1552,6 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 	priv->hw_host_to_card = btmrvl_sdio_host_to_card;
 	priv->hw_wakeup_firmware = btmrvl_sdio_wakeup_fw;
 	priv->hw_process_int_status = btmrvl_sdio_process_int_status;
-	priv->firmware_dump = btmrvl_sdio_dump_firmware;
 
 	if (btmrvl_register_hdev(priv)) {
 		BT_ERR("Register hdev failed!");
@@ -1717,6 +1721,7 @@ static int btmrvl_sdio_resume(struct device *dev)
 	.remove		= btmrvl_sdio_remove,
 	.drv = {
 		.owner = THIS_MODULE,
+		.coredump = btmrvl_sdio_coredump,
 		.pm = &btmrvl_sdio_pm_ops,
 	}
 };
-- 
1.9.1
