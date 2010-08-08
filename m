Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0HHCO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:14:29 -0400
Subject: [PATCH 4/5] libertas: [sdio] use common firmware request helper
 and new firmware locations
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1281233470.6235.12.camel@dcbw.foobar.com>
References: <1281233470.6235.12.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:15:52 -0500
Message-ID: <1281233752.6235.17.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-firmware puts libertas firmware in /libertas.  Fix the driver to
look there first, but fall back to the old firmware names if the new
ones don't exist.  Add preference for newer firmware versions too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/if_sdio.c |  143 +++++++++++++------------------
 drivers/net/wireless/libertas/if_sdio.h |    4 -
 2 files changed, 60 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 6e71346..024e5ca 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -76,36 +76,32 @@ static const struct sdio_device_id if_sdio_ids[] = {
 
 MODULE_DEVICE_TABLE(sdio, if_sdio_ids);
 
-struct if_sdio_model {
-	int model;
-	const char *helper;
-	const char *firmware;
-};
-
-static struct if_sdio_model if_sdio_models[] = {
-	{
-		/* 8385 */
-		.model = IF_SDIO_MODEL_8385,
-		.helper = "sd8385_helper.bin",
-		.firmware = "sd8385.bin",
-	},
-	{
-		/* 8686 */
-		.model = IF_SDIO_MODEL_8686,
-		.helper = "sd8686_helper.bin",
-		.firmware = "sd8686.bin",
-	},
-	{
-		/* 8688 */
-		.model = IF_SDIO_MODEL_8688,
-		.helper = "sd8688_helper.bin",
-		.firmware = "sd8688.bin",
-	},
+#define MODEL_8385	0x04
+#define MODEL_8686	0x0b
+#define MODEL_8688	0x10
+
+static const struct lbs_fw_table fw_table[] = {
+	{ MODEL_8385, "libertas/sd8385_helper.bin", "libertas/sd8385.bin" },
+	{ MODEL_8385, "sd8385_helper.bin", "sd8385.bin" },
+	{ MODEL_8686, "libertas/sd8686_v9_helper.bin", "libertas/sd8686_v9.bin" },
+	{ MODEL_8686, "libertas/sd8686_v8_helper.bin", "libertas/sd8686_v8.bin" },
+	{ MODEL_8686, "sd8686_helper.bin", "sd8686.bin" },
+	{ MODEL_8688, "libertas/sd8688_helper.bin", "libertas/sd8688.bin" },
+	{ MODEL_8688, "sd8688_helper.bin", "sd8688.bin" },
+	{ 0, NULL, NULL }
 };
+MODULE_FIRMWARE("libertas/sd8385_helper.bin");
+MODULE_FIRMWARE("libertas/sd8385.bin");
 MODULE_FIRMWARE("sd8385_helper.bin");
 MODULE_FIRMWARE("sd8385.bin");
+MODULE_FIRMWARE("libertas/sd8686_v9_helper.bin");
+MODULE_FIRMWARE("libertas/sd8686_v9.bin");
+MODULE_FIRMWARE("libertas/sd8686_v8_helper.bin");
+MODULE_FIRMWARE("libertas/sd8686_v8.bin");
 MODULE_FIRMWARE("sd8686_helper.bin");
 MODULE_FIRMWARE("sd8686.bin");
+MODULE_FIRMWARE("libertas/sd8688_helper.bin");
+MODULE_FIRMWARE("libertas/sd8688.bin");
 MODULE_FIRMWARE("sd8688_helper.bin");
 MODULE_FIRMWARE("sd8688.bin");
 
@@ -185,11 +181,11 @@ static u16 if_sdio_read_rx_len(struct if_sdio_card *card, int *err)
 	u16 rx_len;
 
 	switch (card->model) {
-	case IF_SDIO_MODEL_8385:
-	case IF_SDIO_MODEL_8686:
+	case MODEL_8385:
+	case MODEL_8686:
 		rx_len = if_sdio_read_scratch(card, &ret);
 		break;
-	case IF_SDIO_MODEL_8688:
+	case MODEL_8688:
 	default: /* for newer chipsets */
 		rx_len = sdio_readb(card->func, IF_SDIO_RX_LEN, &ret);
 		if (!ret)
@@ -286,7 +282,7 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	if (card->model == IF_SDIO_MODEL_8385) {
+	if (card->model == MODEL_8385) {
 		event = sdio_readb(card->func, IF_SDIO_EVENT, &ret);
 		if (ret)
 			goto out;
@@ -464,10 +460,10 @@ static void if_sdio_host_to_card_worker(struct work_struct *work)
 
 #define FW_DL_READY_STATUS (IF_SDIO_IO_RDY | IF_SDIO_DL_RDY)
 
-static int if_sdio_prog_helper(struct if_sdio_card *card)
+static int if_sdio_prog_helper(struct if_sdio_card *card,
+				const struct firmware *fw)
 {
 	int ret;
-	const struct firmware *fw;
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
@@ -476,16 +472,10 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	ret = request_firmware(&fw, card->helper, &card->func->dev);
-	if (ret) {
-		lbs_pr_err("can't load helper firmware\n");
-		goto out;
-	}
-
 	chunk_buffer = kzalloc(64, GFP_KERNEL);
 	if (!chunk_buffer) {
 		ret = -ENOMEM;
-		goto release_fw;
+		goto out;
 	}
 
 	sdio_claim_host(card->func);
@@ -560,22 +550,19 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 release:
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
-release_fw:
-	release_firmware(fw);
 
 out:
 	if (ret)
 		lbs_pr_err("failed to load helper firmware\n");
 
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
-
 	return ret;
 }
 
-static int if_sdio_prog_real(struct if_sdio_card *card)
+static int if_sdio_prog_real(struct if_sdio_card *card,
+				const struct firmware *fw)
 {
 	int ret;
-	const struct firmware *fw;
 	unsigned long timeout;
 	u8 *chunk_buffer;
 	u32 chunk_size;
@@ -584,16 +571,10 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	ret = request_firmware(&fw, card->firmware, &card->func->dev);
-	if (ret) {
-		lbs_pr_err("can't load firmware\n");
-		goto out;
-	}
-
 	chunk_buffer = kzalloc(512, GFP_KERNEL);
 	if (!chunk_buffer) {
 		ret = -ENOMEM;
-		goto release_fw;
+		goto out;
 	}
 
 	sdio_claim_host(card->func);
@@ -683,15 +664,12 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 release:
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
-release_fw:
-	release_firmware(fw);
 
 out:
 	if (ret)
 		lbs_pr_err("failed to load firmware\n");
 
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
-
 	return ret;
 }
 
@@ -699,6 +677,8 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 {
 	int ret;
 	u16 scratch;
+	const struct firmware *helper = NULL;
+	const struct firmware *mainfw = NULL;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
@@ -716,11 +696,18 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 		goto success;
 	}
 
-	ret = if_sdio_prog_helper(card);
+	ret = lbs_get_firmware(&card->func->dev, lbs_helper_name, lbs_fw_name,
+				card->model, &fw_table[0], &helper, &mainfw);
+	if (ret) {
+		lbs_pr_err("failed to find firmware (%d)\n", ret);
+		goto out;
+	}
+
+	ret = if_sdio_prog_helper(card, helper);
 	if (ret)
 		goto out;
 
-	ret = if_sdio_prog_real(card);
+	ret = if_sdio_prog_real(card, mainfw);
 	if (ret)
 		goto out;
 
@@ -731,8 +718,12 @@ success:
 	ret = 0;
 
 out:
-	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
+	if (helper)
+		release_firmware(helper);
+	if (mainfw)
+		release_firmware(mainfw);
 
+	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
 	return ret;
 }
 
@@ -936,7 +927,7 @@ static int if_sdio_probe(struct sdio_func *func,
 				"ID: %x", &model) == 1)
 			break;
 		if (!strcmp(func->card->info[i], "IBIS Wireless SDIO Card")) {
-			model = IF_SDIO_MODEL_8385;
+			model = MODEL_8385;
 			break;
 		}
 	}
@@ -954,13 +945,13 @@ static int if_sdio_probe(struct sdio_func *func,
 	card->model = model;
 
 	switch (card->model) {
-	case IF_SDIO_MODEL_8385:
+	case MODEL_8385:
 		card->scratch_reg = IF_SDIO_SCRATCH_OLD;
 		break;
-	case IF_SDIO_MODEL_8686:
+	case MODEL_8686:
 		card->scratch_reg = IF_SDIO_SCRATCH;
 		break;
-	case IF_SDIO_MODEL_8688:
+	case MODEL_8688:
 	default: /* for newer chipsets */
 		card->scratch_reg = IF_SDIO_FW_STATUS;
 		break;
@@ -970,31 +961,17 @@ static int if_sdio_probe(struct sdio_func *func,
 	card->workqueue = create_workqueue("libertas_sdio");
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 
-	for (i = 0;i < ARRAY_SIZE(if_sdio_models);i++) {
-		if (card->model == if_sdio_models[i].model)
+	/* Check if we support this card */
+	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
+		if (card->model == fw_table[i].model)
 			break;
 	}
-
-	if (i == ARRAY_SIZE(if_sdio_models)) {
+	if (i == ARRAY_SIZE(fw_table)) {
 		lbs_pr_err("unknown card model 0x%x\n", card->model);
 		ret = -ENODEV;
 		goto free;
 	}
 
-	card->helper = if_sdio_models[i].helper;
-	card->firmware = if_sdio_models[i].firmware;
-
-	if (lbs_helper_name) {
-		lbs_deb_sdio("overriding helper firmware: %s\n",
-			lbs_helper_name);
-		card->helper = lbs_helper_name;
-	}
-
-	if (lbs_fw_name) {
-		lbs_deb_sdio("overriding firmware: %s\n", lbs_fw_name);
-		card->firmware = lbs_fw_name;
-	}
-
 	sdio_claim_host(func);
 
 	ret = sdio_enable_func(func);
@@ -1008,7 +985,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	/* For 1-bit transfers to the 8686 model, we need to enable the
 	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
 	 * bit to allow access to non-vendor registers. */
-	if ((card->model == IF_SDIO_MODEL_8686) &&
+	if ((card->model == MODEL_8686) &&
 	    (host->caps & MMC_CAP_SDIO_IRQ) &&
 	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
 		u8 reg;
@@ -1071,8 +1048,8 @@ static int if_sdio_probe(struct sdio_func *func,
 	 * Get rx_unit if the chip is SD8688 or newer.
 	 * SD8385 & SD8686 do not have rx_unit.
 	 */
-	if ((card->model != IF_SDIO_MODEL_8385)
-			&& (card->model != IF_SDIO_MODEL_8686))
+	if ((card->model != MODEL_8385)
+			&& (card->model != MODEL_8686))
 		card->rx_unit = if_sdio_read_rx_unit(card);
 	else
 		card->rx_unit = 0;
@@ -1088,7 +1065,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	/*
 	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
 	 */
-	if (card->model == IF_SDIO_MODEL_8688) {
+	if (card->model == MODEL_8688) {
 		struct cmd_header cmd;
 
 		memset(&cmd, 0, sizeof(cmd));
@@ -1141,7 +1118,7 @@ static void if_sdio_remove(struct sdio_func *func)
 
 	card = sdio_get_drvdata(func);
 
-	if (user_rmmod && (card->model == IF_SDIO_MODEL_8688)) {
+	if (user_rmmod && (card->model == MODEL_8688)) {
 		/*
 		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
 		 * multiple functions
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index 12179c1..62fda35 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -12,10 +12,6 @@
 #ifndef _LBS_IF_SDIO_H
 #define _LBS_IF_SDIO_H
 
-#define IF_SDIO_MODEL_8385	0x04
-#define IF_SDIO_MODEL_8686	0x0b
-#define IF_SDIO_MODEL_8688	0x10
-
 #define IF_SDIO_IOPORT		0x00
 
 #define IF_SDIO_H_INT_MASK	0x04
-- 
1.7.2.1


