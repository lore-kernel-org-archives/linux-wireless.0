Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0HHCN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 22:13:59 -0400
Subject: [PATCH 3/5] libertas: [cs] use common firmware request helper and
 new firmware locations
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1281233470.6235.12.camel@dcbw.foobar.com>
References: <1281233470.6235.12.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 21:15:19 -0500
Message-ID: <1281233719.6235.16.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-firmware puts libertas firmware in /libertas.  Fix the driver to
look there first, but fall back to the old firmware names if the new
ones don't exist.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/if_cs.c |  130 +++++++++++++++++++--------------
 1 files changed, 74 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 08e4e39..a6fd704 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -49,7 +49,6 @@
 MODULE_AUTHOR("Holger Schurig <hs4233@mail.mn-solutions.de>");
 MODULE_DESCRIPTION("Driver for Marvell 83xx compact flash WLAN cards");
 MODULE_LICENSE("GPL");
-MODULE_FIRMWARE("libertas_cs_helper.fw");
 
 
 
@@ -62,9 +61,34 @@ struct if_cs_card {
 	struct lbs_private *priv;
 	void __iomem *iobase;
 	bool align_regs;
+	u32 model;
 };
 
 
+enum {
+	MODEL_UNKNOWN = 0x00,
+	MODEL_8305 = 0x01,
+	MODEL_8381 = 0x02,
+	MODEL_8385 = 0x03
+};
+
+static const struct lbs_fw_table fw_table[] = {
+	{ MODEL_8305, "libertas/cf8305.bin", NULL },
+	{ MODEL_8305, "libertas_cs_helper.fw", NULL },
+	{ MODEL_8381, "libertas/cf8381_helper.bin", "libertas/cf8381.bin" },
+	{ MODEL_8381, "libertas_cs_helper.fw", "libertas_cs.fw" },
+	{ MODEL_8385, "libertas/cf8385_helper.bin", "libertas/cf8385.bin" },
+	{ MODEL_8385, "libertas_cs_helper.fw", "libertas_cs.fw" },
+	{ 0, NULL, NULL }
+};
+MODULE_FIRMWARE("libertas/cf8305.bin");
+MODULE_FIRMWARE("libertas/cf8381_helper.bin");
+MODULE_FIRMWARE("libertas/cf8381.bin");
+MODULE_FIRMWARE("libertas/cf8385_helper.bin");
+MODULE_FIRMWARE("libertas/cf8385.bin");
+MODULE_FIRMWARE("libertas_cs_helper.fw");
+MODULE_FIRMWARE("libertas_cs.fw");
+
 
 /********************************************************************/
 /* Hardware access                                                  */
@@ -290,22 +314,19 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
 #define CF8385_MANFID		0x02df
 #define CF8385_CARDID		0x8103
 
-static inline int if_cs_hw_is_cf8305(struct pcmcia_device *p_dev)
-{
-	return (p_dev->manf_id == CF8305_MANFID &&
-		p_dev->card_id == CF8305_CARDID);
-}
-
-static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
-{
-	return (p_dev->manf_id == CF8381_MANFID &&
-		p_dev->card_id == CF8381_CARDID);
-}
-
-static inline int if_cs_hw_is_cf8385(struct pcmcia_device *p_dev)
+/* FIXME: just use the 'driver_info' field of 'struct pcmcia_device_id' when
+ * that gets fixed.  Currently there's no way to access it from the probe hook.
+ */
+static inline u32 get_model(u16 manf_id, u16 card_id)
 {
-	return (p_dev->manf_id == CF8385_MANFID &&
-		p_dev->card_id == CF8385_CARDID);
+	/* NOTE: keep in sync with if_cs_ids */
+	if (manf_id == CF8305_MANFID && card_id == CF8305_CARDID)
+		return MODEL_8305;
+	else if (manf_id == CF8381_MANFID && card_id == CF8381_CARDID)
+		return MODEL_8381;
+	else if (manf_id == CF8385_MANFID && card_id == CF8385_CARDID)
+		return MODEL_8385;
+	return MODEL_UNKNOWN;
 }
 
 /********************************************************************/
@@ -559,12 +580,11 @@ static irqreturn_t if_cs_interrupt(int irq, void *data)
  *
  * Return 0 on success
  */
-static int if_cs_prog_helper(struct if_cs_card *card)
+static int if_cs_prog_helper(struct if_cs_card *card, const struct firmware *fw)
 {
 	int ret = 0;
 	int sent = 0;
 	u8  scratch;
-	const struct firmware *fw;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
@@ -590,14 +610,6 @@ static int if_cs_prog_helper(struct if_cs_card *card)
 		goto done;
 	}
 
-	/* TODO: make firmware file configurable */
-	ret = request_firmware(&fw, "libertas_cs_helper.fw",
-		&card->p_dev->dev);
-	if (ret) {
-		lbs_pr_err("can't load helper firmware\n");
-		ret = -ENODEV;
-		goto done;
-	}
 	lbs_deb_cs("helper size %td\n", fw->size);
 
 	/* "Set the 5 bytes of the helper image to 0" */
@@ -636,7 +648,7 @@ static int if_cs_prog_helper(struct if_cs_card *card)
 		if (ret < 0) {
 			lbs_pr_err("can't download helper at 0x%x, ret %d\n",
 				sent, ret);
-			goto err_release;
+			goto done;
 		}
 
 		if (count == 0)
@@ -645,17 +657,14 @@ static int if_cs_prog_helper(struct if_cs_card *card)
 		sent += count;
 	}
 
-err_release:
-	release_firmware(fw);
 done:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
 
 
-static int if_cs_prog_real(struct if_cs_card *card)
+static int if_cs_prog_real(struct if_cs_card *card, const struct firmware *fw)
 {
-	const struct firmware *fw;
 	int ret = 0;
 	int retry = 0;
 	int len = 0;
@@ -663,21 +672,13 @@ static int if_cs_prog_real(struct if_cs_card *card)
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	/* TODO: make firmware file configurable */
-	ret = request_firmware(&fw, "libertas_cs.fw",
-		&card->p_dev->dev);
-	if (ret) {
-		lbs_pr_err("can't load firmware\n");
-		ret = -ENODEV;
-		goto done;
-	}
 	lbs_deb_cs("fw size %td\n", fw->size);
 
 	ret = if_cs_poll_while_fw_download(card, IF_CS_SQ_READ_LOW,
 		IF_CS_SQ_HELPER_OK);
 	if (ret < 0) {
 		lbs_pr_err("helper firmware doesn't answer\n");
-		goto err_release;
+		goto done;
 	}
 
 	for (sent = 0; sent < fw->size; sent += len) {
@@ -692,7 +693,7 @@ static int if_cs_prog_real(struct if_cs_card *card)
 		if (retry > 20) {
 			lbs_pr_err("could not download firmware\n");
 			ret = -ENODEV;
-			goto err_release;
+			goto done;
 		}
 		if (retry) {
 			sent -= len;
@@ -711,7 +712,7 @@ static int if_cs_prog_real(struct if_cs_card *card)
 			IF_CS_BIT_COMMAND);
 		if (ret < 0) {
 			lbs_pr_err("can't download firmware at 0x%x\n", sent);
-			goto err_release;
+			goto done;
 		}
 	}
 
@@ -719,9 +720,6 @@ static int if_cs_prog_real(struct if_cs_card *card)
 	if (ret < 0)
 		lbs_pr_err("firmware download failed\n");
 
-err_release:
-	release_firmware(fw);
-
 done:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
@@ -825,6 +823,8 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	unsigned int prod_id;
 	struct lbs_private *priv;
 	struct if_cs_card *card;
+	const struct firmware *helper = NULL;
+	const struct firmware *mainfw = NULL;
 
 	lbs_deb_enter(LBS_DEB_CS);
 
@@ -844,7 +844,6 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 		goto out1;
 	}
 
-
 	/*
 	 * Allocate an interrupt line.  Note that this does not assign
 	 * a handler to the interrupt, unless the 'Handler' member of
@@ -883,34 +882,47 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	 */
 	card->align_regs = 0;
 
+	card->model = get_model(p_dev->manf_id, p_dev->card_id);
+	if (card->model == MODEL_UNKNOWN) {
+		lbs_pr_err("unsupported manf_id 0x%04x / card_id 0x%04x\n",
+			   p_dev->manf_id, p_dev->card_id);
+		goto out2;
+	}
+
 	/* Check if we have a current silicon */
 	prod_id = if_cs_read8(card, IF_CS_PRODUCT_ID);
-	if (if_cs_hw_is_cf8305(p_dev)) {
+	if (card->model == MODEL_8305) {
 		card->align_regs = 1;
 		if (prod_id < IF_CS_CF8305_B1_REV) {
-			lbs_pr_err("old chips like 8305 rev B3 "
-				"aren't supported\n");
+			lbs_pr_err("8305 rev B0 and older are not supported\n");
 			ret = -ENODEV;
 			goto out2;
 		}
 	}
 
-	if (if_cs_hw_is_cf8381(p_dev) && prod_id < IF_CS_CF8381_B3_REV) {
-		lbs_pr_err("old chips like 8381 rev B3 aren't supported\n");
+	if ((card->model == MODEL_8381) && prod_id < IF_CS_CF8381_B3_REV) {
+		lbs_pr_err("8381 rev B2 and older are not supported\n");
 		ret = -ENODEV;
 		goto out2;
 	}
 
-	if (if_cs_hw_is_cf8385(p_dev) && prod_id < IF_CS_CF8385_B1_REV) {
-		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
+	if ((card->model == MODEL_8385) && prod_id < IF_CS_CF8385_B1_REV) {
+		lbs_pr_err("8385 rev B0 and older are not supported\n");
 		ret = -ENODEV;
 		goto out2;
 	}
 
+	ret = lbs_get_firmware(&p_dev->dev, NULL, NULL, card->model,
+				&fw_table[0], &helper, &mainfw);
+	if (ret) {
+		lbs_pr_err("failed to find firmware (%d)\n", ret);
+		goto out2;
+	}
+
 	/* Load the firmware early, before calling into libertas.ko */
-	ret = if_cs_prog_helper(card);
-	if (ret == 0 && !if_cs_hw_is_cf8305(p_dev))
-		ret = if_cs_prog_real(card);
+	ret = if_cs_prog_helper(card, helper);
+	if (ret == 0 && (card->model != MODEL_8305))
+		ret = if_cs_prog_real(card, mainfw);
 	if (ret)
 		goto out2;
 
@@ -959,6 +971,11 @@ out2:
 out1:
 	pcmcia_disable_device(p_dev);
 out:
+	if (helper)
+		release_firmware(helper);
+	if (mainfw)
+		release_firmware(mainfw);
+
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
 	return ret;
 }
@@ -995,6 +1012,7 @@ static struct pcmcia_device_id if_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
 	PCMCIA_DEVICE_MANF_CARD(CF8385_MANFID, CF8385_CARDID),
+	/* NOTE: keep in sync with get_model() */
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
-- 
1.7.2.1


