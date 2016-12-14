Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36681 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755002AbcLNONH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 09:13:07 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/5] mwifiex: sdio card reset enhancement
Date: Wed, 14 Dec 2016 19:40:49 +0530
Message-ID: <1481724651-30397-3-git-send-email-akarwar@marvell.com> (sfid-20161214_151312_364096_BCDB26AD)
In-Reply-To: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
References: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Commit b4336a282db8 ("mwifiex: sdio: reset adapter using mmc_hw_reset")
introduces a simple sdio card reset solution based on card remove and
re-probe. This solution has proved to be vulnerable, as card and
adapter structures are not protected, concurrent access will result in
kernel panic issues.

Let's reuse PCIe FLR's functions for SDIO reset to avoid freeing and
reallocating adapter and card structures.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 73 +++++++++++++----------------
 drivers/net/wireless/marvell/mwifiex/sdio.h |  3 --
 2 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 44eb65a..b3aca10 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -104,7 +104,6 @@ static int mwifiex_sdio_probe_of(struct device *dev)
 	init_completion(&card->fw_done);
 
 	card->func = func;
-	card->device_id = id;
 
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
@@ -2196,33 +2195,13 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 		    port, card->mp_data_port_mask);
 }
 
-static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
+static struct mwifiex_adapter *save_adapter;
+static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
+	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
-	const struct sdio_device_id *device_id = card->device_id;
-
-	/* TODO mmc_hw_reset does not require destroying and re-probing the
-	 * whole adapter. Hence there was no need to for this rube-goldberg
-	 * design to reload the fw from an external workqueue. If we don't
-	 * destroy the adapter we could reload the fw from
-	 * mwifiex_main_work_queue directly.
-	 * The real difficulty with fw reset is to restore all the user
-	 * settings applied through ioctl. By destroying and recreating the
-	 * adapter, we take the easy way out, since we rely on user space to
-	 * restore them. We assume that user space will treat the new
-	 * incarnation of the adapter(interfaces) as if they had been just
-	 * discovered and initializes them from scratch.
-	 */
 
-	__mwifiex_sdio_remove(func);
-
-	/*
-	 * Normally, we would let the driver core take care of releasing these.
-	 * But we're not letting the driver core handle this one. See above
-	 * TODO.
-	 */
-	sdio_set_drvdata(func, NULL);
-	devm_kfree(&func->dev, card);
+	mwifiex_shutdown_sw(adapter);
 
 	/* power cycle the adapter */
 	sdio_claim_host(func);
@@ -2235,21 +2214,7 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
 	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
 	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
 
-	mwifiex_sdio_probe(func, device_id);
-}
-
-static struct mwifiex_adapter *save_adapter;
-static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
-{
-	struct sdio_mmc_card *card = adapter->card;
-
-	/* TODO card pointer is unprotected. If the adapter is removed
-	 * physically, sdio core might trigger mwifiex_sdio_remove, before this
-	 * workqueue is run, which will destroy the adapter struct. When this
-	 * workqueue eventually exceutes it will dereference an invalid adapter
-	 * pointer
-	 */
-	mwifiex_recreate_adapter(card);
+	mwifiex_reinit_sw(adapter);
 }
 
 /* This function read/write firmware */
@@ -2677,6 +2642,33 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 	return p - drv_buf;
 }
 
+/* sdio device/function initialization, code is extracted
+ * from init_if handler and register_dev handler.
+ */
+static void mwifiex_sdio_up_dev(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	u8 sdio_ireg;
+
+	sdio_claim_host(card->func);
+	sdio_enable_func(card->func);
+	sdio_set_block_size(card->func, MWIFIEX_SDIO_BLOCK_SIZE);
+	sdio_release_host(card->func);
+
+	/* tx_buf_size might be changed to 3584 by firmware during
+	 * data transfer, we will reset to default size.
+	 */
+	adapter->tx_buf_size = card->tx_buf_size;
+
+	/* Read the host_int_status_reg for ACK the first interrupt got
+	 * from the bootloader. If we don't do this we get a interrupt
+	 * as soon as we register the irq.
+	 */
+	mwifiex_read_reg(adapter, card->reg->host_int_status_reg, &sdio_ireg);
+
+	mwifiex_init_sdio_ioport(adapter);
+}
+
 static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
@@ -2702,6 +2694,7 @@ static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 	.reg_dump = mwifiex_sdio_reg_dump,
 	.device_dump = mwifiex_sdio_device_dump,
 	.deaggr_pkt = mwifiex_deaggr_sdio_pkt,
+	.up_dev = mwifiex_sdio_up_dev,
 };
 
 module_driver(mwifiex_sdio, sdio_register_driver, sdio_unregister_driver);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index cdbf3a3a..afa10d5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -267,9 +267,6 @@ struct sdio_mmc_card {
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
-
-	/* needed for card reset */
-	const struct sdio_device_id *device_id;
 };
 
 struct mwifiex_sdio_device {
-- 
1.9.1
