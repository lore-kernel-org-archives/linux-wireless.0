Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:39374 "HELO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751948Ab2DCCyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 22:54:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <padovan@profusion.mobi>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] Bluetooth: btmrvl: add support for SDIO suspend/resume callbacks
Date: Mon,  2 Apr 2012 19:53:39 -0700
Message-Id: <1333421619-8182-2-git-send-email-bzhao@marvell.com> (sfid-20120403_045517_930693_D289C299)
In-Reply-To: <1333421619-8182-1-git-send-email-bzhao@marvell.com>
References: <1333421619-8182-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Host sleep is activated using already configured host sleep
parameters in suspend handler and it is cancelled in resume
handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/bluetooth/btmrvl_drv.h  |    2 +
 drivers/bluetooth/btmrvl_main.c |    3 +-
 drivers/bluetooth/btmrvl_sdio.c |  100 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index 2c79e76..94f2d65 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -67,6 +67,7 @@ struct btmrvl_adapter {
 	u8 wakeup_tries;
 	wait_queue_head_t cmd_wait_q;
 	u8 cmd_complete;
+	bool is_suspended;
 };
 
 struct btmrvl_private {
@@ -142,6 +143,7 @@ int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd);
 int btmrvl_send_hscfg_cmd(struct btmrvl_private *priv);
 int btmrvl_enable_ps(struct btmrvl_private *priv);
 int btmrvl_prepare_command(struct btmrvl_private *priv);
+int btmrvl_enable_hs(struct btmrvl_private *priv);
 
 #ifdef CONFIG_DEBUG_FS
 void btmrvl_debugfs_init(struct hci_dev *hdev);
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index a880537..681ca9d 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -262,7 +262,7 @@ int btmrvl_enable_ps(struct btmrvl_private *priv)
 }
 EXPORT_SYMBOL_GPL(btmrvl_enable_ps);
 
-static int btmrvl_enable_hs(struct btmrvl_private *priv)
+int btmrvl_enable_hs(struct btmrvl_private *priv)
 {
 	struct sk_buff *skb;
 	struct btmrvl_cmd *cmd;
@@ -298,6 +298,7 @@ static int btmrvl_enable_hs(struct btmrvl_private *priv)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(btmrvl_enable_hs);
 
 int btmrvl_prepare_command(struct btmrvl_private *priv)
 {
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index f93a7a2..35a3e7c 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1051,11 +1051,111 @@ static void btmrvl_sdio_remove(struct sdio_func *func)
 	}
 }
 
+static int btmrvl_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct btmrvl_sdio_card *card;
+	struct btmrvl_private *priv;
+	mmc_pm_flag_t pm_flags;
+	struct hci_dev *hcidev;
+
+	if (func) {
+		pm_flags = sdio_get_host_pm_caps(func);
+		BT_DBG("%s: suspend: PM flags = 0x%x\n", sdio_func_id(func),
+		       pm_flags);
+		if (!(pm_flags & MMC_PM_KEEP_POWER)) {
+			BT_ERR("%s: cannot remain alive while host is "
+			       "suspended\n", sdio_func_id(func));
+			return -ENOSYS;
+		}
+		card = sdio_get_drvdata(func);
+		if (!card || !card->priv) {
+			BT_ERR("Card or priv structure is not valid\n");
+			return 0;
+		}
+	} else {
+		BT_ERR("sdio_func is not specified\n");
+		return 0;
+	}
+
+	priv = card->priv;
+
+	if (priv->adapter->hs_state != HS_ACTIVATED) {
+		if (btmrvl_enable_hs(priv)) {
+			BT_ERR("HS not actived, suspend fail!\n");
+			return -EBUSY;
+		}
+	}
+	hcidev = priv->btmrvl_dev.hcidev;
+	BT_DBG("%s: SDIO suspend\n", hcidev->name);
+	hci_suspend_dev(hcidev);
+	skb_queue_purge(&priv->adapter->tx_queue);
+
+	priv->adapter->is_suspended = true;
+
+	/* We will keep the power when hs enabled successfully */
+	if (priv->adapter->hs_state == HS_ACTIVATED) {
+		BT_DBG("suspend with MMC_PM_KEEP_POWER\n");
+		return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	} else {
+		BT_DBG("suspend without MMC_PM_KEEP_POWER\n");
+		return 0;
+	}
+}
+
+static int btmrvl_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct btmrvl_sdio_card *card;
+	struct btmrvl_private *priv;
+	mmc_pm_flag_t pm_flags;
+	struct hci_dev *hcidev;
+
+	if (func) {
+		pm_flags = sdio_get_host_pm_caps(func);
+		BT_DBG("%s: resume: PM flags = 0x%x\n", sdio_func_id(func),
+		       pm_flags);
+		card = sdio_get_drvdata(func);
+		if (!card || !card->priv) {
+			BT_ERR("Card or priv structure is not valid\n");
+			return 0;
+		}
+	} else {
+		BT_ERR("sdio_func is not specified\n");
+		return 0;
+	}
+	priv = card->priv;
+
+	if (!priv->adapter->is_suspended) {
+		BT_DBG("device already resumed\n");
+		return 0;
+	}
+
+	priv->adapter->is_suspended = false;
+	hcidev = priv->btmrvl_dev.hcidev;
+	BT_DBG("%s: SDIO resume\n", hcidev->name);
+	hci_resume_dev(hcidev);
+	priv->hw_wakeup_firmware(priv);
+	priv->adapter->hs_state = HS_DEACTIVATED;
+	BT_DBG("%s: HS DEACTIVATED in resume!\n", hcidev->name);
+
+	return 0;
+}
+
+static const struct dev_pm_ops btmrvl_sdio_pm_ops = {
+	.suspend	= btmrvl_sdio_suspend,
+	.resume		= btmrvl_sdio_resume,
+};
+
 static struct sdio_driver bt_mrvl_sdio = {
 	.name		= "btmrvl_sdio",
 	.id_table	= btmrvl_sdio_ids,
 	.probe		= btmrvl_sdio_probe,
 	.remove		= btmrvl_sdio_remove,
+	.drv = {
+		.owner = THIS_MODULE,
+		.pm = &btmrvl_sdio_pm_ops,
+	}
 };
 
 static int __init btmrvl_sdio_init_module(void)
-- 
1.7.4.1

