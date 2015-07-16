Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36415 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbbGPQuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 12:50:05 -0400
Received: by widjy10 with SMTP id jy10so20970814wid.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 09:50:04 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH] mwifiex: sdio: reset adapter using mmc_hw_reset
Date: Thu, 16 Jul 2015 18:50:01 +0200
Message-Id: <1437065401-20245-1-git-send-email-afenkart@gmail.com> (sfid-20150716_185010_461782_F9FDE0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 1fb654fd97ff("mmc: sdio: add reset callback to bus operations"),
sdio cards can be power cycled using mmc_hw_reset.
The use mmc_remove_host/mmc_add_host is discouraged, because these are
internal functions to the mmc core and should only be used by mmc hosts

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 51 ++++++++++++++++++++++++++-----------
 drivers/net/wireless/mwifiex/sdio.h |  3 +++
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a0b121f..e4c35ee 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -91,6 +91,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		return -ENOMEM;
 
 	card->func = func;
+	card->device_id = id;
 
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
@@ -2107,26 +2108,46 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 		    port, card->mp_data_port_mask);
 }
 
+static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
+{
+	struct sdio_func *func = card->func;
+	const struct sdio_device_id *device_id = card->device_id;
+
+	/* TODO mmc_hw_reset does not require destroying and re-probing the
+	 * whole adapter. Hence there was no need to for this rube-goldberg
+	 * design to reload the fw from an external workqueue. If we don't
+	 * destroy the adapter we could reload the fw from
+	 * mwifiex_main_work_queue directly.
+	 * The real difficulty with fw reset is to restore all the user
+	 * settings applied through ioctl. By destroying and recreating the
+	 * adapter, we take the easy way out, since we rely on user space to
+	 * restore them. We assume that user space will treat the new
+	 * incarnation of the adapter(interfaces) as if they had been just
+	 * discovered and initializes them from scratch.
+	 */
+
+	mwifiex_sdio_remove(func);
+
+	/* power cycle the adapter */
+	sdio_claim_host(func);
+	mmc_hw_reset(func->card->host);
+	sdio_release_host(func);
+
+	mwifiex_sdio_probe(func, device_id);
+}
+
 static struct mwifiex_adapter *save_adapter;
 static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	struct mmc_host *target = card->func->card->host;
-
-	/* The actual reset operation must be run outside of driver thread.
-	 * This is because mmc_remove_host() will cause the device to be
-	 * instantly destroyed, and the driver then needs to end its thread,
-	 * leading to a deadlock.
-	 *
-	 * We run it in a totally independent workqueue.
-	 */
 
-	mwifiex_dbg(adapter, WARN, "Resetting card...\n");
-	mmc_remove_host(target);
-	/* 200ms delay is based on experiment with sdhci controller */
-	mdelay(200);
-	target->rescan_entered = 0; /* rescan non-removable cards */
-	mmc_add_host(target);
+	/* TODO card pointer is unprotected. If the adapter is removed
+	 * physically, sdio core might trigger mwifiex_sdio_remove, before this
+	 * workqueue is run, which will destroy the adapter struct. When this
+	 * workqueue eventually exceutes it will dereference an invalid adapter
+	 * pointer
+	 */
+	mwifiex_recreate_adapter(card);
 }
 
 /* This function read/write firmware */
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 6f645cf..c44da61 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -262,6 +262,9 @@ struct sdio_mmc_card {
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
+
+	/* needed for card reset */
+	const struct sdio_device_id *device_id;
 };
 
 struct mwifiex_sdio_device {
-- 
2.1.4

