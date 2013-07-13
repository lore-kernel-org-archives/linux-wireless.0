Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.laptop.org ([18.85.2.166]:37945 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab3GMOzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 10:55:54 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com, akarwar@marvell.com, bzhao@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: fix IRQ enable/disable
Message-Id: <20130713145710.BC47D12647A@dev.laptop.org> (sfid-20130713_165557_778468_C312BC85)
Date: Sat, 13 Jul 2013 10:57:10 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During tear down (e.g. mwifiex_sdio_remove during system suspend),
mwifiex left IRQs enabled for a significant period of time when it was
unable to handle them correctly. This caused interrupt storms and
interfered with the bluetooth interface on the same SDIO card.

Solve this by disabling interrupts at the point when they can no longer
be handled correctly, which is at the start of mwifiex_remove_card().

For cleanliness, we now enable interrupts in the mwifiex_add_card() path,
to be symmetrical with the disabling of interrupts. We also couple the
registration of the sdio IRQ handler with the actual enable/disable of
interrupts at the hardware level.

I also removed a write to this register in mwifiex_init_sdio which seemed
pointless and won't cause any ill effects now that we only register
the SDIO IRQ handler when we are ready to accept interrupts.

Includes some corrections from Amitkumar Karwar.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/mwifiex/init.c | 10 +---
 drivers/net/wireless/mwifiex/main.c | 13 +++++-
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/sdio.c | 91 +++++++++++++++++--------------------
 drivers/net/wireless/mwifiex/sdio.h |  3 --
 5 files changed, 57 insertions(+), 61 deletions(-)

Replaces the previous patch:
	mwifiex: don't ignore SDIO interrupts during shutdown

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index caaf4bd..2cf8b96 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -693,7 +693,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		if (!ret) {
 			dev_notice(adapter->dev,
 				   "WLAN FW already running! Skip FW dnld\n");
-			goto done;
+			return 0;
 		}
 
 		poll_num = MAX_FIRMWARE_POLL_TRIES;
@@ -719,14 +719,8 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 poll_fw:
 	/* Check if the firmware is downloaded successfully or not */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
-	if (ret) {
+	if (ret)
 		dev_err(adapter->dev, "FW failed to be active in time\n");
-		return -1;
-	}
-done:
-	/* re-enable host interrupt for mwifiex after fw dnld is successful */
-	if (adapter->if_ops.enable_int)
-		adapter->if_ops.enable_int(adapter);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index e15ab72..1753431 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -427,6 +427,10 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 				"Cal data request_firmware() failed\n");
 	}
 
+	/* enable host interrupt after fw dnld is successful */
+	if (adapter->if_ops.enable_int)
+		adapter->if_ops.enable_int(adapter);
+
 	adapter->init_wait_q_woken = false;
 	ret = mwifiex_init_fw(adapter);
 	if (ret == -1) {
@@ -478,6 +482,8 @@ err_add_intf:
 	mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
 	rtnl_unlock();
 err_init_fw:
+	if (adapter->if_ops.disable_int)
+		adapter->if_ops.disable_int(adapter);
 	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
 done:
@@ -855,7 +861,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
 
 	/* Register the device. Fill up the private data structure with relevant
-	   information from the card and request for the required IRQ. */
+	   information from the card. */
 	if (adapter->if_ops.register_dev(adapter)) {
 		pr_err("%s: failed to register mwifiex device\n", __func__);
 		goto err_registerdev;
@@ -919,6 +925,11 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	if (!adapter)
 		goto exit_remove;
 
+	/* We can no longer handle interrupts once we start doing the teardown
+	 * below. */
+	if (adapter->if_ops.disable_int)
+		adapter->if_ops.disable_int(adapter);
+
 	adapter->surprise_removed = true;
 
 	/* Stop data */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3da73d3..253e0bd 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -601,6 +601,7 @@ struct mwifiex_if_ops {
 	int (*register_dev) (struct mwifiex_adapter *);
 	void (*unregister_dev) (struct mwifiex_adapter *);
 	int (*enable_int) (struct mwifiex_adapter *);
+	void (*disable_int) (struct mwifiex_adapter *);
 	int (*process_int_status) (struct mwifiex_adapter *);
 	int (*host_to_card) (struct mwifiex_adapter *, u8, struct sk_buff *,
 			     struct mwifiex_tx_param *);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5ee5ed0..5ef49f2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -51,6 +51,7 @@ static struct mwifiex_if_ops sdio_ops;
 static struct semaphore add_remove_card_sem;
 
 static int mwifiex_sdio_resume(struct device *dev);
+static void mwifiex_sdio_interrupt(struct sdio_func *func);
 
 /*
  * SDIO probe.
@@ -296,6 +297,15 @@ static struct sdio_driver mwifiex_sdio = {
 	}
 };
 
+/* Write data into SDIO card register. Caller claims SDIO device. */
+static int
+mwifiex_write_reg_locked(struct sdio_func *func, u32 reg, u8 data)
+{
+	int ret = -1;
+	sdio_writeb(func, data, reg, &ret);
+	return ret;
+}
+
 /*
  * This function writes data into SDIO card register.
  */
@@ -303,10 +313,10 @@ static int
 mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u8 data)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = -1;
+	int ret;
 
 	sdio_claim_host(card->func);
-	sdio_writeb(card->func, data, reg, &ret);
+	ret = mwifiex_write_reg_locked(card->func, reg, data);
 	sdio_release_host(card->func);
 
 	return ret;
@@ -685,23 +695,15 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
  * The host interrupt mask is read, the disable bit is reset and
  * written back to the card host interrupt mask register.
  */
-static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
+static void mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 {
-	u8 host_int_mask, host_int_disable = HOST_INT_DISABLE;
-
-	/* Read back the host_int_mask register */
-	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask))
-		return -1;
-
-	/* Update with the mask and write back to the register */
-	host_int_mask &= ~host_int_disable;
-
-	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
-		dev_err(adapter->dev, "disable host interrupt failed\n");
-		return -1;
-	}
+	struct sdio_mmc_card *card = adapter->card;
+	struct sdio_func *func = card->func;
 
-	return 0;
+	sdio_claim_host(func);
+	mwifiex_write_reg_locked(func, HOST_INT_MASK_REG, 0);
+	sdio_release_irq(func);
+	sdio_release_host(func);
 }
 
 /*
@@ -713,14 +715,29 @@ static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	struct sdio_func *func = card->func;
+	int ret;
+
+	sdio_claim_host(func);
+
+	/* Request the SDIO IRQ */
+	ret = sdio_claim_irq(func, mwifiex_sdio_interrupt);
+	if (ret) {
+		dev_err(adapter->dev, "claim irq failed: ret=%d\n", ret);
+		goto out;
+	}
 
 	/* Simply write the mask to the register */
-	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG,
-			      card->reg->host_int_enable)) {
+	ret = mwifiex_write_reg_locked(func, HOST_INT_MASK_REG,
+				       card->reg->host_int_enable);
+	if (ret) {
 		dev_err(adapter->dev, "enable host interrupt failed\n");
-		return -1;
+		sdio_release_irq(func);
 	}
-	return 0;
+
+out:
+	sdio_release_host(func);
+	return ret;
 }
 
 /*
@@ -997,9 +1014,6 @@ mwifiex_sdio_interrupt(struct sdio_func *func)
 	}
 	adapter = card->adapter;
 
-	if (adapter->surprise_removed)
-		return;
-
 	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
 		adapter->ps_state = PS_STATE_AWAKE;
 
@@ -1728,9 +1742,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 
 	if (adapter->card) {
-		/* Release the SDIO IRQ */
 		sdio_claim_host(card->func);
-		sdio_release_irq(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
 		sdio_set_drvdata(card->func, NULL);
@@ -1744,7 +1756,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
+	int ret;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
 
@@ -1753,22 +1765,14 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	sdio_claim_host(func);
 
-	/* Request the SDIO IRQ */
-	ret = sdio_claim_irq(func, mwifiex_sdio_interrupt);
-	if (ret) {
-		pr_err("claim irq failed: ret=%d\n", ret);
-		goto disable_func;
-	}
-
 	/* Set block size */
 	ret = sdio_set_block_size(card->func, MWIFIEX_SDIO_BLOCK_SIZE);
+	sdio_release_host(func);
 	if (ret) {
 		pr_err("cannot set SDIO block size\n");
-		ret = -1;
-		goto release_irq;
+		return ret;
 	}
 
-	sdio_release_host(func);
 	sdio_set_drvdata(func, card);
 
 	adapter->dev = &func->dev;
@@ -1776,15 +1780,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	strcpy(adapter->fw_name, card->firmware);
 
 	return 0;
-
-release_irq:
-	sdio_release_irq(func);
-disable_func:
-	sdio_disable_func(func);
-	sdio_release_host(func);
-	adapter->card = NULL;
-
-	return -1;
 }
 
 /*
@@ -1813,9 +1808,6 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	 */
 	mwifiex_read_reg(adapter, HOST_INTSTATUS_REG, &sdio_ireg);
 
-	/* Disable host interrupt mask register for SDIO */
-	mwifiex_sdio_disable_host_int(adapter);
-
 	/* Get SDIO ioport */
 	mwifiex_init_sdio_ioport(adapter);
 
@@ -1957,6 +1949,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.register_dev = mwifiex_register_dev,
 	.unregister_dev = mwifiex_unregister_dev,
 	.enable_int = mwifiex_sdio_enable_host_int,
+	.disable_int = mwifiex_sdio_disable_host_int,
 	.process_int_status = mwifiex_process_int_status,
 	.host_to_card = mwifiex_sdio_host_to_card,
 	.wakeup = mwifiex_pm_wakeup_card,
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 6d51dfd..532ae0a 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -92,9 +92,6 @@
 /* Host Control Registers : Download host interrupt mask */
 #define DN_LD_HOST_INT_MASK		(0x2U)
 
-/* Disable Host interrupt mask */
-#define	HOST_INT_DISABLE		0xff
-
 /* Host Control Registers : Host interrupt status */
 #define HOST_INTSTATUS_REG		0x03
 /* Host Control Registers : Upload host interrupt status */
-- 
1.8.1.4

