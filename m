Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0HHCPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:15:08 -0400
Subject: [PATCH 5/5] libertas: [spi] use common firmware request helper and
 new firmware locations
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1281233470.6235.12.camel@dcbw.foobar.com>
References: <1281233470.6235.12.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:16:30 -0500
Message-ID: <1281233790.6235.18.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-firmware puts libertas firmware in /libertas.  Fix the driver to
look there first, but fall back to the old firmware names if the new
ones don't exist.  Add preference for newer firmware versions too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/if_spi.c |  144 +++++++++++++++-----------------
 drivers/net/wireless/libertas/if_spi.h |    5 -
 2 files changed, 69 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index fe3f080..012e7fd 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -39,9 +39,6 @@ struct if_spi_card {
 	struct lbs_private		*priv;
 	struct libertas_spi_platform_data *pdata;
 
-	char				helper_fw_name[IF_SPI_FW_NAME_MAX];
-	char				main_fw_name[IF_SPI_FW_NAME_MAX];
-
 	/* The card ID and card revision, as reported by the hardware. */
 	u16				card_id;
 	u8				card_rev;
@@ -70,10 +67,28 @@ static void free_if_spi_card(struct if_spi_card *card)
 	kfree(card);
 }
 
-static struct chip_ident chip_id_to_device_name[] = {
-	{ .chip_id = 0x04, .name = 8385 },
-	{ .chip_id = 0x0b, .name = 8686 },
+#define MODEL_8385	0x04
+#define MODEL_8686	0x0b
+#define MODEL_8688	0x10
+
+static const struct lbs_fw_table fw_table[] = {
+	{ MODEL_8385, "libertas/gspi8385_helper.bin", "libertas/gspi8385.bin" },
+	{ MODEL_8385, "libertas/gspi8385_hlp.bin", "libertas/gspi8385.bin" },
+	{ MODEL_8686, "libertas/gspi8686_v9_helper.bin", "libertas/gspi8686_v9.bin" },
+	{ MODEL_8686, "libertas/gspi8686_hlp.bin", "libertas/gspi8686.bin" },
+	{ MODEL_8688, "libertas/gspi8688_helper.bin", "libertas/gspi8688.bin" },
+	{ 0, NULL, NULL }
 };
+MODULE_FIRMWARE("libertas/gspi8385_helper.bin");
+MODULE_FIRMWARE("libertas/gspi8385_hlp.bin");
+MODULE_FIRMWARE("libertas/gspi8385.bin");
+MODULE_FIRMWARE("libertas/gspi8686_v9_helper.bin");
+MODULE_FIRMWARE("libertas/gspi8686_v9.bin");
+MODULE_FIRMWARE("libertas/gspi8686_hlp.bin");
+MODULE_FIRMWARE("libertas/gspi8686.bin");
+MODULE_FIRMWARE("libertas/gspi8688_helper.bin");
+MODULE_FIRMWARE("libertas/gspi8688.bin");
+
 
 /*
  * SPI Interface Unit Routines
@@ -399,26 +414,20 @@ static int spu_init(struct if_spi_card *card, int use_dummy_writes)
  * Firmware Loading
  */
 
-static int if_spi_prog_helper_firmware(struct if_spi_card *card)
+static int if_spi_prog_helper_firmware(struct if_spi_card *card,
+					const struct firmware *firmware)
 {
 	int err = 0;
-	const struct firmware *firmware = NULL;
 	int bytes_remaining;
 	const u8 *fw;
 	u8 temp[HELPER_FW_LOAD_CHUNK_SZ];
-	struct spi_device *spi = card->spi;
 
 	lbs_deb_enter(LBS_DEB_SPI);
 
 	err = spu_set_interrupt_mode(card, 1, 0);
 	if (err)
 		goto out;
-	/* Get helper firmware image */
-	err = request_firmware(&firmware, card->helper_fw_name, &spi->dev);
-	if (err) {
-		lbs_pr_err("request_firmware failed with err = %d\n", err);
-		goto out;
-	}
+
 	bytes_remaining = firmware->size;
 	fw = firmware->data;
 
@@ -429,13 +438,13 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card)
 		err = spu_write_u16(card, IF_SPI_SCRATCH_1_REG,
 					HELPER_FW_LOAD_CHUNK_SZ);
 		if (err)
-			goto release_firmware;
+			goto out;
 
 		err = spu_wait_for_u16(card, IF_SPI_HOST_INT_STATUS_REG,
 					IF_SPI_HIST_CMD_DOWNLOAD_RDY,
 					IF_SPI_HIST_CMD_DOWNLOAD_RDY);
 		if (err)
-			goto release_firmware;
+			goto out;
 
 		/* Feed the data into the command read/write port reg
 		 * in chunks of 64 bytes */
@@ -446,16 +455,16 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card)
 		err = spu_write(card, IF_SPI_CMD_RDWRPORT_REG,
 					temp, HELPER_FW_LOAD_CHUNK_SZ);
 		if (err)
-			goto release_firmware;
+			goto out;
 
 		/* Interrupt the boot code */
 		err = spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG, 0);
 		if (err)
-			goto release_firmware;
+			goto out;
 		err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
 				       IF_SPI_CIC_CMD_DOWNLOAD_OVER);
 		if (err)
-			goto release_firmware;
+			goto out;
 		bytes_remaining -= HELPER_FW_LOAD_CHUNK_SZ;
 		fw += HELPER_FW_LOAD_CHUNK_SZ;
 	}
@@ -465,18 +474,16 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card)
 	 * bootloader. This completes the helper download. */
 	err = spu_write_u16(card, IF_SPI_SCRATCH_1_REG, FIRMWARE_DNLD_OK);
 	if (err)
-		goto release_firmware;
+		goto out;
 	err = spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG, 0);
 	if (err)
-		goto release_firmware;
+		goto out;
 	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
 				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
-		goto release_firmware;
+		goto out;
 
 	lbs_deb_spi("waiting for helper to boot...\n");
 
-release_firmware:
-	release_firmware(firmware);
 out:
 	if (err)
 		lbs_pr_err("failed to load helper firmware (err=%d)\n", err);
@@ -523,13 +530,12 @@ static int if_spi_prog_main_firmware_check_len(struct if_spi_card *card,
 	return len;
 }
 
-static int if_spi_prog_main_firmware(struct if_spi_card *card)
+static int if_spi_prog_main_firmware(struct if_spi_card *card,
+					const struct firmware *firmware)
 {
 	int len, prev_len;
 	int bytes, crc_err = 0, err = 0;
-	const struct firmware *firmware = NULL;
 	const u8 *fw;
-	struct spi_device *spi = card->spi;
 	u16 num_crc_errs;
 
 	lbs_deb_enter(LBS_DEB_SPI);
@@ -538,19 +544,11 @@ static int if_spi_prog_main_firmware(struct if_spi_card *card)
 	if (err)
 		goto out;
 
-	/* Get firmware image */
-	err = request_firmware(&firmware, card->main_fw_name, &spi->dev);
-	if (err) {
-		lbs_pr_err("%s: can't get firmware '%s' from kernel. "
-			"err = %d\n", __func__, card->main_fw_name, err);
-		goto out;
-	}
-
 	err = spu_wait_for_u16(card, IF_SPI_SCRATCH_1_REG, 0, 0);
 	if (err) {
 		lbs_pr_err("%s: timed out waiting for initial "
 			   "scratch reg = 0\n", __func__);
-		goto release_firmware;
+		goto out;
 	}
 
 	num_crc_errs = 0;
@@ -560,7 +558,7 @@ static int if_spi_prog_main_firmware(struct if_spi_card *card)
 	while ((len = if_spi_prog_main_firmware_check_len(card, &crc_err))) {
 		if (len < 0) {
 			err = len;
-			goto release_firmware;
+			goto out;
 		}
 		if (bytes < 0) {
 			/* If there are no more bytes left, we would normally
@@ -575,7 +573,7 @@ static int if_spi_prog_main_firmware(struct if_spi_card *card)
 				lbs_pr_err("Too many CRC errors encountered "
 					   "in firmware load.\n");
 				err = -EIO;
-				goto release_firmware;
+				goto out;
 			}
 		} else {
 			/* Previous transfer succeeded. Advance counters. */
@@ -590,15 +588,15 @@ static int if_spi_prog_main_firmware(struct if_spi_card *card)
 
 		err = spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG, 0);
 		if (err)
-			goto release_firmware;
+			goto out;
 		err = spu_write(card, IF_SPI_CMD_RDWRPORT_REG,
 				card->cmd_buffer, len);
 		if (err)
-			goto release_firmware;
+			goto out;
 		err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG ,
 					IF_SPI_CIC_CMD_DOWNLOAD_OVER);
 		if (err)
-			goto release_firmware;
+			goto out;
 		prev_len = len;
 	}
 	if (bytes > prev_len) {
@@ -611,12 +609,9 @@ static int if_spi_prog_main_firmware(struct if_spi_card *card)
 					SUCCESSFUL_FW_DOWNLOAD_MAGIC);
 	if (err) {
 		lbs_pr_err("failed to confirm the firmware download\n");
-		goto release_firmware;
+		goto out;
 	}
 
-release_firmware:
-	release_firmware(firmware);
-
 out:
 	if (err)
 		lbs_pr_err("failed to load firmware (err=%d)\n", err);
@@ -886,37 +881,16 @@ static irqreturn_t if_spi_host_interrupt(int irq, void *dev_id)
  * SPI callbacks
  */
 
-static int if_spi_calculate_fw_names(u16 card_id,
-			      char *helper_fw, char *main_fw)
-{
-	int i;
-	for (i = 0; i < ARRAY_SIZE(chip_id_to_device_name); ++i) {
-		if (card_id == chip_id_to_device_name[i].chip_id)
-			break;
-	}
-	if (i == ARRAY_SIZE(chip_id_to_device_name)) {
-		lbs_pr_err("Unsupported chip_id: 0x%02x\n", card_id);
-		return -EAFNOSUPPORT;
-	}
-	snprintf(helper_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d_hlp.bin",
-		 chip_id_to_device_name[i].name);
-	snprintf(main_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d.bin",
-		 chip_id_to_device_name[i].name);
-	return 0;
-}
-MODULE_FIRMWARE("libertas/gspi8385_hlp.bin");
-MODULE_FIRMWARE("libertas/gspi8385.bin");
-MODULE_FIRMWARE("libertas/gspi8686_hlp.bin");
-MODULE_FIRMWARE("libertas/gspi8686.bin");
-
 static int __devinit if_spi_probe(struct spi_device *spi)
 {
 	struct if_spi_card *card;
 	struct lbs_private *priv = NULL;
 	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
-	int err = 0;
+	int err = 0, i;
 	u32 scratch;
 	struct sched_param param = { .sched_priority = 1 };
+	const struct firmware *helper = NULL;
+	const struct firmware *mainfw = NULL;
 
 	lbs_deb_enter(LBS_DEB_SPI);
 
@@ -961,10 +935,25 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		lbs_deb_spi("Firmware is already loaded for "
 			    "Marvell WLAN 802.11 adapter\n");
 	else {
-		err = if_spi_calculate_fw_names(card->card_id,
-				card->helper_fw_name, card->main_fw_name);
-		if (err)
+		/* Check if we support this card */
+		for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
+			if (card->card_id == fw_table[i].model)
+				break;
+		}
+		if (i == ARRAY_SIZE(fw_table)) {
+			lbs_pr_err("Unsupported chip_id: 0x%02x\n",
+					card->card_id);
+			err = -ENODEV;
 			goto free_card;
+		}
+
+		err = lbs_get_firmware(&card->spi->dev, NULL, NULL,
+					card->card_id, &fw_table[0], &helper,
+					&mainfw);
+		if (err) {
+			lbs_pr_err("failed to find firmware (%d)\n", err);
+			goto free_card;
+		}
 
 		lbs_deb_spi("Initializing FW for Marvell WLAN 802.11 adapter "
 				"(chip_id = 0x%04x, chip_rev = 0x%02x) "
@@ -973,10 +962,10 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 				card->card_id, card->card_rev,
 				spi->master->bus_num, spi->chip_select,
 				spi->max_speed_hz);
-		err = if_spi_prog_helper_firmware(card);
+		err = if_spi_prog_helper_firmware(card, helper);
 		if (err)
 			goto free_card;
-		err = if_spi_prog_main_firmware(card);
+		err = if_spi_prog_main_firmware(card, mainfw);
 		if (err)
 			goto free_card;
 		lbs_deb_spi("loaded FW for Marvell WLAN 802.11 adapter\n");
@@ -1044,6 +1033,11 @@ remove_card:
 free_card:
 	free_if_spi_card(card);
 out:
+	if (helper)
+		release_firmware(helper);
+	if (mainfw)
+		release_firmware(mainfw);
+
 	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
 	return err;
 }
diff --git a/drivers/net/wireless/libertas/if_spi.h b/drivers/net/wireless/libertas/if_spi.h
index f87eec4..8b1417d 100644
--- a/drivers/net/wireless/libertas/if_spi.h
+++ b/drivers/net/wireless/libertas/if_spi.h
@@ -25,11 +25,6 @@
 
 #define IF_SPI_FW_NAME_MAX 30
 
-struct chip_ident {
-	u16 chip_id;
-	u16 name;
-};
-
 #define MAX_MAIN_FW_LOAD_CRC_ERR 10
 
 /* Chunk size when loading the helper firmware */
-- 
1.7.2.1


