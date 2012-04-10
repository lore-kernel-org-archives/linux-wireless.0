Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:34616 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758467Ab2DJDHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/5] mwifiex: use asynchronous firmware loading
Date: Mon,  9 Apr 2012 20:06:57 -0700
Message-Id: <1334027217-23724-6-git-send-email-bzhao@marvell.com> (sfid-20120410_050741_611606_7267924A)
In-Reply-To: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
References: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Make use of request_firmware_nowait instead of request_firmware
to load FW asynchronously. This fixes timeouts introduced with
recent udev changes.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch depends on "[PATCH 14/26] wireless, mwifiex: drop redundant
NULL test before call to release_firmware()" (Jesper Juhl).

 drivers/net/wireless/mwifiex/main.c |  103 +++++++++++++++++++----------------
 drivers/net/wireless/mwifiex/main.h |    1 +
 drivers/net/wireless/mwifiex/pcie.c |    3 +
 drivers/net/wireless/mwifiex/sdio.c |    3 +
 4 files changed, 62 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2ee6162..245b732 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -292,29 +292,28 @@ static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function initializes the hardware and firmware.
+ * This function gets firmware and initializes it.
  *
  * The main initialization steps followed are -
  *      - Download the correct firmware to card
- *      - Allocate and initialize the adapter structure
- *      - Initialize the private structures
  *      - Issue the init commands to firmware
  */
-static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
+static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 {
-	int ret, err;
+	int ret;
+	char fmt[64];
+	struct mwifiex_private *priv;
+	struct mwifiex_adapter *adapter = context;
 	struct mwifiex_fw_image fw;
 
-	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
-
-	err = request_firmware(&adapter->firmware, adapter->fw_name,
-			       adapter->dev);
-	if (err < 0) {
-		dev_err(adapter->dev, "request_firmware() returned"
-				" error code %#x\n", err);
-		ret = -1;
+	if (!firmware) {
+		dev_err(adapter->dev,
+			"Failed to get firmware %s\n", adapter->fw_name);
 		goto done;
 	}
+
+	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
+	adapter->firmware = firmware;
 	fw.fw_buf = (u8 *) adapter->firmware->data;
 	fw.fw_len = adapter->firmware->size;
 
@@ -335,16 +334,54 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	/* Wait for mwifiex_init to complete */
 	wait_event_interruptible(adapter->init_wait_q,
 				 adapter->init_wait_q_woken);
-	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
-		ret = -1;
+	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
 		goto done;
+
+	priv = adapter->priv[0];
+	if (mwifiex_register_cfg80211(priv) != 0) {
+		dev_err(adapter->dev, "cannot register with cfg80211\n");
+		goto err_init_fw;
+	}
+
+	rtnl_lock();
+	/* Create station interface by default */
+	if (!mwifiex_add_virtual_intf(priv->wdev->wiphy, "mlan%d",
+				      NL80211_IFTYPE_STATION, NULL, NULL)) {
+		dev_err(adapter->dev, "cannot create default STA interface\n");
+		goto err_add_intf;
 	}
-	ret = 0;
+	rtnl_unlock();
+
+	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
+	dev_notice(adapter->dev, "driver_version = %s\n", fmt);
+	goto done;
 
+err_add_intf:
+	mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+	rtnl_unlock();
+err_init_fw:
+	pr_debug("info: %s: unregister device\n", __func__);
+	adapter->if_ops.unregister_dev(adapter);
 done:
 	release_firmware(adapter->firmware);
-	if (ret)
-		ret = -1;
+	complete(&adapter->fw_load);
+	return;
+}
+
+/*
+ * This function initializes the hardware and gets firmware.
+ */
+static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
+{
+	int ret;
+
+	init_completion(&adapter->fw_load);
+	ret = request_firmware_nowait(THIS_MODULE, 1, adapter->fw_name,
+				      adapter->dev, GFP_KERNEL, adapter,
+				      mwifiex_fw_dpc);
+	if (ret < 0)
+		dev_err(adapter->dev,
+			"request_firmware_nowait() returned error %d\n", ret);
 	return ret;
 }
 
@@ -649,8 +686,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops, u8 iface_type)
 {
 	struct mwifiex_adapter *adapter;
-	char fmt[64];
-	struct mwifiex_private *priv;
 
 	if (down_interruptible(sem))
 		goto exit_sem_err;
@@ -691,37 +726,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_init_fw;
 	}
 
-	priv = adapter->priv[0];
-
-	if (mwifiex_register_cfg80211(priv) != 0) {
-		dev_err(adapter->dev, "cannot register netdevice"
-			       " with cfg80211\n");
-			goto err_init_fw;
-	}
-
-	rtnl_lock();
-	/* Create station interface by default */
-	if (!mwifiex_add_virtual_intf(priv->wdev->wiphy, "mlan%d",
-				      NL80211_IFTYPE_STATION, NULL, NULL)) {
-		rtnl_unlock();
-		dev_err(adapter->dev, "cannot create default station"
-				" interface\n");
-		goto err_add_intf;
-	}
-
-	rtnl_unlock();
-
 	up(sem);
-
-	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
-	dev_notice(adapter->dev, "driver_version = %s\n", fmt);
-
 	return 0;
 
-err_add_intf:
-	rtnl_lock();
-	mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
-	rtnl_unlock();
 err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5081da3..46c298e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -655,6 +655,7 @@ struct mwifiex_adapter {
 	u8 scan_wait_q_woken;
 	struct cmd_ctrl_node *cmd_queued;
 	spinlock_t queue_lock;		/* lock for tx queues */
+	struct completion fw_load;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 5867fac..13fbc4e 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -119,6 +119,9 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	/* In case driver is removed when asynchronous FW load is in progress */
+	wait_for_completion(&adapter->fw_load);
+
 	if (user_rmmod) {
 #ifdef CONFIG_PM
 		if (adapter->is_suspended)
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index f8012e2..1aa45c4 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -123,6 +123,9 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	/* In case driver is removed when asynchronous FW load is in progress */
+	wait_for_completion(&adapter->fw_load);
+
 	if (user_rmmod) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
-- 
1.7.0.2

