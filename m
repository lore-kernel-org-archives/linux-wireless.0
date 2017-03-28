Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34420 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932668AbdC1X7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 19:59:40 -0400
Received: by mail-pg0-f51.google.com with SMTP id 21so367247pgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 16:59:39 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 2/2] mwifiex: catch mwifiex_fw_dpc() errors properly in reset
Date: Tue, 28 Mar 2017 16:59:33 -0700
Message-Id: <20170328235933.950-2-briannorris@chromium.org> (sfid-20170329_020122_812851_F0C2CF4C)
In-Reply-To: <20170328235933.950-1-briannorris@chromium.org>
References: <20170328235933.950-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When resetting the device, we take a synchronous firmware-loading code
path, which borrows a lot from the asynchronous path used at probe time.
We don't catch errors correctly though, which means that in the PCIe
driver, we may try to dereference the 'adapter' struct after
mwifiex_fw_dpc() has freed it. See this (erronous) print in
mwifiex_pcie_reset_notify():

	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);

Let's instead refactor the synchronous (or "!req_fw_nowait") path so
that we propagate errors and handle them properly.

This fixes a use-after-free issue in the PCIe driver, as well as a
misleading debug message ("successful"). It looks like the SDIO driver
doesn't have these problems, since it doesn't do anything after
mwifiex_reinit_sw().

Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 33 +++++++++++++++++++----------
 drivers/net/wireless/marvell/mwifiex/pcie.c |  7 +++++-
 drivers/net/wireless/marvell/mwifiex/sdio.c |  5 ++++-
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 98c83453ba5b..0dfbac850689 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -512,7 +512,7 @@ static void mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
  *      - Download the correct firmware to card
  *      - Issue the init commands to firmware
  */
-static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
+static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 {
 	int ret;
 	char fmt[64];
@@ -665,11 +665,18 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		mwifiex_free_adapter(adapter);
 	/* Tell all current and future waiters we're finished */
 	complete_all(fw_done);
-	return;
+
+	return init_failed ? -EIO : 0;
+}
+
+static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
+{
+	_mwifiex_fw_dpc(firmware, context);
 }
 
 /*
- * This function initializes the hardware and gets firmware.
+ * This function gets the firmware and (if called asynchronously) kicks off the
+ * HW init when done.
  */
 static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter,
 			      bool req_fw_nowait)
@@ -692,20 +699,15 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter,
 		ret = request_firmware_nowait(THIS_MODULE, 1, adapter->fw_name,
 					      adapter->dev, GFP_KERNEL, adapter,
 					      mwifiex_fw_dpc);
-		if (ret < 0)
-			mwifiex_dbg(adapter, ERROR,
-				    "request_firmware_nowait error %d\n", ret);
 	} else {
 		ret = request_firmware(&adapter->firmware,
 				       adapter->fw_name,
 				       adapter->dev);
-		if (ret < 0)
-			mwifiex_dbg(adapter, ERROR,
-				    "request_firmware error %d\n", ret);
-		else
-			mwifiex_fw_dpc(adapter->firmware, (void *)adapter);
 	}
 
+	if (ret < 0)
+		mwifiex_dbg(adapter, ERROR, "request_firmware%s error %d\n",
+			    req_fw_nowait ? "_nowait" : "", ret);
 	return ret;
 }
 
@@ -1427,6 +1429,8 @@ EXPORT_SYMBOL_GPL(mwifiex_shutdown_sw);
 int
 mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 {
+	int ret;
+
 	mwifiex_init_lock_list(adapter);
 	if (adapter->if_ops.up_dev)
 		adapter->if_ops.up_dev(adapter);
@@ -1473,6 +1477,13 @@ mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 			    "%s: firmware init failed\n", __func__);
 		goto err_init_fw;
 	}
+
+	/* _mwifiex_fw_dpc() does its own cleanup */
+	ret = _mwifiex_fw_dpc(adapter->firmware, adapter);
+	if (ret) {
+		pr_err("Failed to bring up adapter: %d\n", ret);
+		return ret;
+	}
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index e381deff37f3..f45ab125cd0d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -350,6 +350,7 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 {
 	struct pcie_service_card *card = pci_get_drvdata(pdev);
 	struct mwifiex_adapter *adapter = card->adapter;
+	int ret;
 
 	if (!adapter) {
 		dev_err(&pdev->dev, "%s: adapter structure is not valid\n",
@@ -376,7 +377,11 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 * and firmware including firmware redownload
 		 */
 		adapter->surprise_removed = false;
-		mwifiex_reinit_sw(adapter);
+		ret = mwifiex_reinit_sw(adapter);
+		if (ret) {
+			dev_err(&pdev->dev, "reinit failed: %d\n", ret);
+			return;
+		}
 	}
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 58d3da09cfbd..424532b81c2d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2196,6 +2196,7 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
+	int ret;
 
 	mwifiex_shutdown_sw(adapter);
 
@@ -2210,7 +2211,9 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 
-	mwifiex_reinit_sw(adapter);
+	ret = mwifiex_reinit_sw(adapter);
+	if (ret)
+		dev_err(&func->dev, "reinit failed: %d\n", ret);
 }
 
 /* This function read/write firmware */
-- 
2.12.2.564.g063fe858b8-goog
