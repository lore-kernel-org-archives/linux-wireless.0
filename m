Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56275 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0EANGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 09:06:16 -0400
Received: by mail-ww0-f46.google.com with SMTP id 34so763709wwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 06:06:15 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 6/6] orinoco_usb: implement fw download
Date: Sat,  1 May 2010 14:05:43 +0100
Message-Id: <1272719143-26171-7-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1272719143-26171-1-git-send-email-kilroyd@googlemail.com>
References: <1272719143-26171-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This involves some refactorring of the common fw download code to
substitute ezusb versions of various functions.

Note that WPA-enabled firmwares (9.xx series) will not work fully with
orinoco_usb yet.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/fw.c          |    8 +-
 drivers/net/wireless/orinoco/hermes.c      |  208 ++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hermes.h      |    7 +
 drivers/net/wireless/orinoco/hermes_dld.c  |  243 +--------------------------
 drivers/net/wireless/orinoco/orinoco_usb.c |  120 ++++++++++++++
 drivers/net/wireless/orinoco/spectrum_cs.c |    1 +
 6 files changed, 349 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 4c99240..3e1947d 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -122,7 +122,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	dev_dbg(dev, "Attempting to download firmware %s\n", firmware);
 
 	/* Read current plug data */
-	err = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 0);
+	err = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
 	dev_dbg(dev, "Read PDA returned %d\n", err);
 	if (err)
 		goto free;
@@ -149,7 +149,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	}
 
 	/* Enable aux port to allow programming */
-	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
+	err = hw->ops->program_init(hw, le32_to_cpu(hdr->entry_point));
 	dev_dbg(dev, "Program init returned %d\n", err);
 	if (err != 0)
 		goto abort;
@@ -177,7 +177,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		goto abort;
 
 	/* Tell card we've finished */
-	err = hermesi_program_end(hw);
+	err = hw->ops->program_end(hw);
 	dev_dbg(dev, "Program end returned %d\n", err);
 	if (err != 0)
 		goto abort;
@@ -224,7 +224,7 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 		if (!pda)
 			return -ENOMEM;
 
-		ret = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 1);
+		ret = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
 		if (ret)
 			goto free;
 	}
diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index 845693f..6c6a23e 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -52,6 +52,26 @@
 #define ALLOC_COMPL_TIMEOUT (1000) /* in iterations of ~10us */
 
 /*
+ * AUX port access.  To unlock the AUX port write the access keys to the
+ * PARAM0-2 registers, then write HERMES_AUX_ENABLE to the HERMES_CONTROL
+ * register.  Then read it and make sure it's HERMES_AUX_ENABLED.
+ */
+#define HERMES_AUX_ENABLE	0x8000	/* Enable auxiliary port access */
+#define HERMES_AUX_DISABLE	0x4000	/* Disable to auxiliary port access */
+#define HERMES_AUX_ENABLED	0xC000	/* Auxiliary port is open */
+#define HERMES_AUX_DISABLED	0x0000	/* Auxiliary port is closed */
+
+#define HERMES_AUX_PW0	0xFE01
+#define HERMES_AUX_PW1	0xDC23
+#define HERMES_AUX_PW2	0xBA45
+
+/* HERMES_CMD_DOWNLD */
+#define HERMES_PROGRAM_DISABLE             (0x0000 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_ENABLE_VOLATILE     (0x0100 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_ENABLE_NON_VOLATILE (0x0200 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_NON_VOLATILE        (0x0300 | HERMES_CMD_DOWNLD)
+
+/*
  * Debugging helpers
  */
 
@@ -170,6 +190,7 @@ void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 	hw->iobase = address;
 	hw->reg_spacing = reg_spacing;
 	hw->inten = 0x0;
+	hw->eeprom_pda = false;
 	hw->ops = &hermes_ops_local;
 }
 EXPORT_SYMBOL(hermes_struct_init);
@@ -529,6 +550,189 @@ static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 	return err;
 }
 
+/*** Hermes AUX control ***/
+
+static inline void
+hermes_aux_setaddr(hermes_t *hw, u32 addr)
+{
+	hermes_write_reg(hw, HERMES_AUXPAGE, (u16) (addr >> 7));
+	hermes_write_reg(hw, HERMES_AUXOFFSET, (u16) (addr & 0x7F));
+}
+
+static inline int
+hermes_aux_control(hermes_t *hw, int enabled)
+{
+	int desired_state = enabled ? HERMES_AUX_ENABLED : HERMES_AUX_DISABLED;
+	int action = enabled ? HERMES_AUX_ENABLE : HERMES_AUX_DISABLE;
+	int i;
+
+	/* Already open? */
+	if (hermes_read_reg(hw, HERMES_CONTROL) == desired_state)
+		return 0;
+
+	hermes_write_reg(hw, HERMES_PARAM0, HERMES_AUX_PW0);
+	hermes_write_reg(hw, HERMES_PARAM1, HERMES_AUX_PW1);
+	hermes_write_reg(hw, HERMES_PARAM2, HERMES_AUX_PW2);
+	hermes_write_reg(hw, HERMES_CONTROL, action);
+
+	for (i = 0; i < 20; i++) {
+		udelay(10);
+		if (hermes_read_reg(hw, HERMES_CONTROL) ==
+		    desired_state)
+			return 0;
+	}
+
+	return -EBUSY;
+}
+
+/*** Hermes programming ***/
+
+/* About to start programming data (Hermes I)
+ * offset is the entry point
+ *
+ * Spectrum_cs' Symbol fw does not require this
+ * wl_lkm Agere fw does
+ * Don't know about intersil
+ */
+static int hermesi_program_init(hermes_t *hw, u32 offset)
+{
+	int err;
+
+	/* Disable interrupts?*/
+	/*hw->inten = 0x0;*/
+	/*hermes_write_regn(hw, INTEN, 0);*/
+	/*hermes_set_irqmask(hw, 0);*/
+
+	/* Acknowledge any outstanding command */
+	hermes_write_regn(hw, EVACK, 0xFFFF);
+
+	/* Using init_cmd_wait rather than cmd_wait */
+	err = hw->ops->init_cmd_wait(hw,
+				     0x0100 | HERMES_CMD_INIT,
+				     0, 0, 0, NULL);
+	if (err)
+		return err;
+
+	err = hw->ops->init_cmd_wait(hw,
+				     0x0000 | HERMES_CMD_INIT,
+				     0, 0, 0, NULL);
+	if (err)
+		return err;
+
+	err = hermes_aux_control(hw, 1);
+	pr_debug("AUX enable returned %d\n", err);
+
+	if (err)
+		return err;
+
+	pr_debug("Enabling volatile, EP 0x%08x\n", offset);
+	err = hw->ops->init_cmd_wait(hw,
+				     HERMES_PROGRAM_ENABLE_VOLATILE,
+				     offset & 0xFFFFu,
+				     offset >> 16,
+				     0,
+				     NULL);
+	pr_debug("PROGRAM_ENABLE returned %d\n", err);
+
+	return err;
+}
+
+/* Done programming data (Hermes I)
+ *
+ * Spectrum_cs' Symbol fw does not require this
+ * wl_lkm Agere fw does
+ * Don't know about intersil
+ */
+static int hermesi_program_end(hermes_t *hw)
+{
+	struct hermes_response resp;
+	int rc = 0;
+	int err;
+
+	rc = hw->ops->cmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
+
+	pr_debug("PROGRAM_DISABLE returned %d, "
+		 "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
+		 rc, resp.resp0, resp.resp1, resp.resp2);
+
+	if ((rc == 0) &&
+	    ((resp.status & HERMES_STATUS_CMDCODE) != HERMES_CMD_DOWNLD))
+		rc = -EIO;
+
+	err = hermes_aux_control(hw, 0);
+	pr_debug("AUX disable returned %d\n", err);
+
+	/* Acknowledge any outstanding command */
+	hermes_write_regn(hw, EVACK, 0xFFFF);
+
+	/* Reinitialise, ignoring return */
+	(void) hw->ops->init_cmd_wait(hw, 0x0000 | HERMES_CMD_INIT,
+				      0, 0, 0, NULL);
+
+	return rc ? rc : err;
+}
+
+static int hermes_program_bytes(struct hermes *hw, const char *data,
+				u32 addr, u32 len)
+{
+	/* wl lkm splits the programming into chunks of 2000 bytes.
+	 * This restriction appears to come from USB. The PCMCIA
+	 * adapters can program the whole lot in one go */
+	hermes_aux_setaddr(hw, addr);
+	hermes_write_bytes(hw, HERMES_AUXDATA, data, len);
+	return 0;
+}
+
+/* Read PDA from the adapter */
+static int hermes_read_pda(hermes_t *hw, __le16 *pda, u32 pda_addr, u16 pda_len)
+{
+	int ret;
+	u16 pda_size;
+	u16 data_len = pda_len;
+	__le16 *data = pda;
+
+	if (hw->eeprom_pda) {
+		/* PDA of spectrum symbol is in eeprom */
+
+		/* Issue command to read EEPROM */
+		ret = hw->ops->cmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
+		if (ret)
+			return ret;
+	} else {
+		/* wl_lkm does not include PDA size in the PDA area.
+		 * We will pad the information into pda, so other routines
+		 * don't have to be modified */
+		pda[0] = cpu_to_le16(pda_len - 2);
+			/* Includes CFG_PROD_DATA but not itself */
+		pda[1] = cpu_to_le16(0x0800); /* CFG_PROD_DATA */
+		data_len = pda_len - 4;
+		data = pda + 2;
+	}
+
+	/* Open auxiliary port */
+	ret = hermes_aux_control(hw, 1);
+	pr_debug("AUX enable returned %d\n", ret);
+	if (ret)
+		return ret;
+
+	/* Read PDA */
+	hermes_aux_setaddr(hw, pda_addr);
+	hermes_read_words(hw, HERMES_AUXDATA, data, data_len / 2);
+
+	/* Close aux port */
+	ret = hermes_aux_control(hw, 0);
+	pr_debug("AUX disable returned %d\n", ret);
+
+	/* Check PDA length */
+	pda_size = le16_to_cpu(pda[0]);
+	pr_debug("Actual PDA length %d, Max allowed %d\n",
+		 pda_size, pda_len);
+	if (pda_size > pda_len)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void hermes_lock_irqsave(spinlock_t *lock,
 				unsigned long *flags) __acquires(lock)
 {
@@ -561,6 +765,10 @@ static const struct hermes_ops hermes_ops_local = {
 	.write_ltv = hermes_write_ltv,
 	.bap_pread = hermes_bap_pread,
 	.bap_pwrite = hermes_bap_pwrite,
+	.read_pda = hermes_read_pda,
+	.program_init = hermesi_program_init,
+	.program_end = hermesi_program_end,
+	.program = hermes_program_bytes,
 	.lock_irqsave = hermes_lock_irqsave,
 	.unlock_irqrestore = hermes_unlock_irqrestore,
 	.lock_irq = hermes_lock_irq,
diff --git a/drivers/net/wireless/orinoco/hermes.h b/drivers/net/wireless/orinoco/hermes.h
index aed14ff..9ca34e7 100644
--- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -393,6 +393,12 @@ struct hermes_ops {
 			 u16 id, u16 offset);
 	int (*bap_pwrite)(struct hermes *hw, int bap, const void *buf,
 			  int len, u16 id, u16 offset);
+	int (*read_pda)(struct hermes *hw, __le16 *pda,
+			u32 pda_addr, u16 pda_len);
+	int (*program_init)(struct hermes *hw, u32 entry_point);
+	int (*program_end)(struct hermes *hw);
+	int (*program)(struct hermes *hw, const char *buf,
+		       u32 addr, u32 len);
 	void (*lock_irqsave)(spinlock_t *lock, unsigned long *flags);
 	void (*unlock_irqrestore)(spinlock_t *lock, unsigned long *flags);
 	void (*lock_irq)(spinlock_t *lock);
@@ -406,6 +412,7 @@ typedef struct hermes {
 #define HERMES_16BIT_REGSPACING	0
 #define HERMES_32BIT_REGSPACING	1
 	u16 inten; /* Which interrupts should be enabled? */
+	bool eeprom_pda;
 	const struct hermes_ops *ops;
 	void *priv;
 } hermes_t;
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index 8f22e20..6da85e7 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -46,37 +46,11 @@
 
 #define PFX "hermes_dld: "
 
-/*
- * AUX port access.  To unlock the AUX port write the access keys to the
- * PARAM0-2 registers, then write HERMES_AUX_ENABLE to the HERMES_CONTROL
- * register.  Then read it and make sure it's HERMES_AUX_ENABLED.
- */
-#define HERMES_AUX_ENABLE	0x8000	/* Enable auxiliary port access */
-#define HERMES_AUX_DISABLE	0x4000	/* Disable to auxiliary port access */
-#define HERMES_AUX_ENABLED	0xC000	/* Auxiliary port is open */
-#define HERMES_AUX_DISABLED	0x0000	/* Auxiliary port is closed */
-
-#define HERMES_AUX_PW0	0xFE01
-#define HERMES_AUX_PW1	0xDC23
-#define HERMES_AUX_PW2	0xBA45
-
-/* HERMES_CMD_DOWNLD */
-#define HERMES_PROGRAM_DISABLE             (0x0000 | HERMES_CMD_DOWNLD)
-#define HERMES_PROGRAM_ENABLE_VOLATILE     (0x0100 | HERMES_CMD_DOWNLD)
-#define HERMES_PROGRAM_ENABLE_NON_VOLATILE (0x0200 | HERMES_CMD_DOWNLD)
-#define HERMES_PROGRAM_NON_VOLATILE        (0x0300 | HERMES_CMD_DOWNLD)
-
 /* End markers used in dblocks */
 #define PDI_END		0x00000000	/* End of PDA */
 #define BLOCK_END	0xFFFFFFFF	/* Last image block */
 #define TEXT_END	0x1A		/* End of text header */
 
-/* Limit the amout we try to download in a single shot.
- * Size is in bytes.
- */
-#define MAX_DL_SIZE 1024
-#define LIMIT_PROGRAM_SIZE 0
-
 /*
  * The following structures have little-endian fields denoted by
  * the leading underscore.  Don't access them directly - use inline
@@ -165,41 +139,6 @@ pdi_len(const struct pdi *pdi)
 	return 2 * (le16_to_cpu(pdi->len) - 1);
 }
 
-/*** Hermes AUX control ***/
-
-static inline void
-hermes_aux_setaddr(hermes_t *hw, u32 addr)
-{
-	hermes_write_reg(hw, HERMES_AUXPAGE, (u16) (addr >> 7));
-	hermes_write_reg(hw, HERMES_AUXOFFSET, (u16) (addr & 0x7F));
-}
-
-static inline int
-hermes_aux_control(hermes_t *hw, int enabled)
-{
-	int desired_state = enabled ? HERMES_AUX_ENABLED : HERMES_AUX_DISABLED;
-	int action = enabled ? HERMES_AUX_ENABLE : HERMES_AUX_DISABLE;
-	int i;
-
-	/* Already open? */
-	if (hermes_read_reg(hw, HERMES_CONTROL) == desired_state)
-		return 0;
-
-	hermes_write_reg(hw, HERMES_PARAM0, HERMES_AUX_PW0);
-	hermes_write_reg(hw, HERMES_PARAM1, HERMES_AUX_PW1);
-	hermes_write_reg(hw, HERMES_PARAM2, HERMES_AUX_PW2);
-	hermes_write_reg(hw, HERMES_CONTROL, action);
-
-	for (i = 0; i < 20; i++) {
-		udelay(10);
-		if (hermes_read_reg(hw, HERMES_CONTROL) ==
-		    desired_state)
-			return 0;
-	}
-
-	return -EBUSY;
-}
-
 /*** Plug Data Functions ***/
 
 /*
@@ -271,62 +210,7 @@ hermes_plug_pdi(hermes_t *hw, const struct pdr *first_pdr,
 		return -EINVAL;
 
 	/* do the actual plugging */
-	hermes_aux_setaddr(hw, pdr_addr(pdr));
-	hermes_write_bytes(hw, HERMES_AUXDATA, pdi->data, pdi_len(pdi));
-
-	return 0;
-}
-
-/* Read PDA from the adapter */
-int hermes_read_pda(hermes_t *hw,
-		    __le16 *pda,
-		    u32 pda_addr,
-		    u16 pda_len,
-		    int use_eeprom) /* can we get this into hw? */
-{
-	int ret;
-	u16 pda_size;
-	u16 data_len = pda_len;
-	__le16 *data = pda;
-
-	if (use_eeprom) {
-		/* PDA of spectrum symbol is in eeprom */
-
-		/* Issue command to read EEPROM */
-		ret = hw->ops->cmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
-		if (ret)
-			return ret;
-	} else {
-		/* wl_lkm does not include PDA size in the PDA area.
-		 * We will pad the information into pda, so other routines
-		 * don't have to be modified */
-		pda[0] = cpu_to_le16(pda_len - 2);
-			/* Includes CFG_PROD_DATA but not itself */
-		pda[1] = cpu_to_le16(0x0800); /* CFG_PROD_DATA */
-		data_len = pda_len - 4;
-		data = pda + 2;
-	}
-
-	/* Open auxiliary port */
-	ret = hermes_aux_control(hw, 1);
-	pr_debug(PFX "AUX enable returned %d\n", ret);
-	if (ret)
-		return ret;
-
-	/* read PDA from EEPROM */
-	hermes_aux_setaddr(hw, pda_addr);
-	hermes_read_words(hw, HERMES_AUXDATA, data, data_len / 2);
-
-	/* Close aux port */
-	ret = hermes_aux_control(hw, 0);
-	pr_debug(PFX "AUX disable returned %d\n", ret);
-
-	/* Check PDA length */
-	pda_size = le16_to_cpu(pda[0]);
-	pr_debug(PFX "Actual PDA length %d, Max allowed %d\n",
-		 pda_size, pda_len);
-	if (pda_size > pda_len)
-		return -EINVAL;
+	hw->ops->program(hw, pdi->data, pdr_addr(pdr), pdi_len(pdi));
 
 	return 0;
 }
@@ -389,101 +273,13 @@ hermes_blocks_length(const char *first_block, const void *end)
 
 /*** Hermes programming ***/
 
-/* About to start programming data (Hermes I)
- * offset is the entry point
- *
- * Spectrum_cs' Symbol fw does not require this
- * wl_lkm Agere fw does
- * Don't know about intersil
- */
-int hermesi_program_init(hermes_t *hw, u32 offset)
-{
-	int err;
-
-	/* Disable interrupts?*/
-	/*hw->inten = 0x0;*/
-	/*hermes_write_regn(hw, INTEN, 0);*/
-	/*hermes_set_irqmask(hw, 0);*/
-
-	/* Acknowledge any outstanding command */
-	hermes_write_regn(hw, EVACK, 0xFFFF);
-
-	/* Using init_cmd_wait rather than cmd_wait */
-	err = hw->ops->init_cmd_wait(hw,
-				     0x0100 | HERMES_CMD_INIT,
-				     0, 0, 0, NULL);
-	if (err)
-		return err;
-
-	err = hw->ops->init_cmd_wait(hw,
-				     0x0000 | HERMES_CMD_INIT,
-				     0, 0, 0, NULL);
-	if (err)
-		return err;
-
-	err = hermes_aux_control(hw, 1);
-	pr_debug(PFX "AUX enable returned %d\n", err);
-
-	if (err)
-		return err;
-
-	pr_debug(PFX "Enabling volatile, EP 0x%08x\n", offset);
-	err = hw->ops->init_cmd_wait(hw,
-				     HERMES_PROGRAM_ENABLE_VOLATILE,
-				     offset & 0xFFFFu,
-				     offset >> 16,
-				     0,
-				     NULL);
-	pr_debug(PFX "PROGRAM_ENABLE returned %d\n", err);
-
-	return err;
-}
-
-/* Done programming data (Hermes I)
- *
- * Spectrum_cs' Symbol fw does not require this
- * wl_lkm Agere fw does
- * Don't know about intersil
- */
-int hermesi_program_end(hermes_t *hw)
-{
-	struct hermes_response resp;
-	int rc = 0;
-	int err;
-
-	rc = hw->ops->cmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
-
-	pr_debug(PFX "PROGRAM_DISABLE returned %d, "
-		 "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
-		 rc, resp.resp0, resp.resp1, resp.resp2);
-
-	if ((rc == 0) &&
-	    ((resp.status & HERMES_STATUS_CMDCODE) != HERMES_CMD_DOWNLD))
-		rc = -EIO;
-
-	err = hermes_aux_control(hw, 0);
-	pr_debug(PFX "AUX disable returned %d\n", err);
-
-	/* Acknowledge any outstanding command */
-	hermes_write_regn(hw, EVACK, 0xFFFF);
-
-	/* Reinitialise, ignoring return */
-	(void) hw->ops->init_cmd_wait(hw, 0x0000 | HERMES_CMD_INIT,
-				      0, 0, 0, NULL);
-
-	return rc ? rc : err;
-}
-
 /* Program the data blocks */
 int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 {
 	const struct dblock *blk;
 	u32 blkaddr;
 	u32 blklen;
-#if LIMIT_PROGRAM_SIZE
-	u32 addr;
-	u32 len;
-#endif
+	int err = 0;
 
 	blk = (const struct dblock *) first_block;
 
@@ -498,30 +294,10 @@ int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 		pr_debug(PFX "Programming block of length %d "
 			 "to address 0x%08x\n", blklen, blkaddr);
 
-#if !LIMIT_PROGRAM_SIZE
-		/* wl_lkm driver splits this into writes of 2000 bytes */
-		hermes_aux_setaddr(hw, blkaddr);
-		hermes_write_bytes(hw, HERMES_AUXDATA, blk->data,
-				   blklen);
-#else
-		len = (blklen < MAX_DL_SIZE) ? blklen : MAX_DL_SIZE;
-		addr = blkaddr;
-
-		while (addr < (blkaddr + blklen)) {
-			pr_debug(PFX "Programming subblock of length %d "
-				 "to address 0x%08x. Data @ %p\n",
-				 len, addr, &blk->data[addr - blkaddr]);
-
-			hermes_aux_setaddr(hw, addr);
-			hermes_write_bytes(hw, HERMES_AUXDATA,
-					   &blk->data[addr - blkaddr],
-					   len);
-
-			addr += len;
-			len = ((blkaddr + blklen - addr) < MAX_DL_SIZE) ?
-				(blkaddr + blklen - addr) : MAX_DL_SIZE;
-		}
-#endif
+		err = hw->ops->program(hw, blk->data, blkaddr, blklen);
+		if (err)
+			break;
+
 		blk = (const struct dblock *) &blk->data[blklen];
 
 		if ((void *) blk > (end - sizeof(*blk)))
@@ -530,7 +306,7 @@ int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 		blkaddr = dblock_addr(blk);
 		blklen = dblock_len(blk);
 	}
-	return 0;
+	return err;
 }
 
 /*** Default plugging data for Hermes I ***/
@@ -690,9 +466,8 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 			if ((pdi_len(pdi) == pdr_len(pdr)) &&
 			    ((void *) pdi->data + pdi_len(pdi) < pda_end)) {
 				/* do the actual plugging */
-				hermes_aux_setaddr(hw, pdr_addr(pdr));
-				hermes_write_bytes(hw, HERMES_AUXDATA,
-						   pdi->data, pdi_len(pdi));
+				hw->ops->program(hw, pdi->data, pdr_addr(pdr),
+						 pdi_len(pdi));
 			}
 		}
 
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 8e1b31c..e220933 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -184,6 +184,11 @@ MODULE_FIRMWARE("orinoco_ezusb_fw");
 #define EZUSB_RID_RX			0x0701
 #define EZUSB_RID_INIT1			0x0702
 #define EZUSB_RID_ACK			0x0710
+#define EZUSB_RID_READ_PDA		0x0800
+#define EZUSB_RID_PROG_INIT		0x0852
+#define EZUSB_RID_PROG_SET_ADDR		0x0853
+#define EZUSB_RID_PROG_BYTES		0x0854
+#define EZUSB_RID_PROG_END		0x0855
 #define EZUSB_RID_DOCMD			0x0860
 
 /* Recognize info frames */
@@ -198,6 +203,8 @@ MODULE_FIRMWARE("orinoco_ezusb_fw");
 
 #define BULK_BUF_SIZE			2048
 
+#define MAX_DL_SIZE (BULK_BUF_SIZE - sizeof(struct ezusb_packet))
+
 #define FW_BUF_SIZE			64
 #define FW_VAR_OFFSET_PTR		0x359
 #define FW_VAR_VALUE			0
@@ -1077,6 +1084,115 @@ static int ezusb_bap_pread(struct hermes *hw, int bap,
 	return 0;
 }
 
+static int ezusb_read_pda(struct hermes *hw, __le16 *pda,
+			  u32 pda_addr, u16 pda_len)
+{
+	struct ezusb_priv *upriv = hw->priv;
+	struct request_context *ctx;
+	__le16 data[] = {
+		cpu_to_le16(pda_addr & 0xffff),
+		cpu_to_le16(pda_len - 4)
+	};
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_READ_PDA, EZUSB_RID_READ_PDA);
+	if (!ctx)
+		return -ENOMEM;
+
+	/* wl_lkm does not include PDA size in the PDA area.
+	 * We will pad the information into pda, so other routines
+	 * don't have to be modified */
+	pda[0] = cpu_to_le16(pda_len - 2);
+	/* Includes CFG_PROD_DATA but not itself */
+	pda[1] = cpu_to_le16(0x0800); /* CFG_PROD_DATA */
+
+	return ezusb_access_ltv(upriv, ctx, sizeof(data), &data,
+				EZUSB_FRAME_CONTROL, &pda[2], pda_len - 4,
+				NULL);
+}
+
+static int ezusb_program_init(struct hermes *hw, u32 entry_point)
+{
+	struct ezusb_priv *upriv = hw->priv;
+	struct request_context *ctx;
+	__le32 data = cpu_to_le32(entry_point);
+
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_PROG_INIT, EZUSB_RID_ACK);
+	if (!ctx)
+		return -ENOMEM;
+
+	return ezusb_access_ltv(upriv, ctx, sizeof(data), &data,
+				EZUSB_FRAME_CONTROL, NULL, 0, NULL);
+}
+
+static int ezusb_program_end(struct hermes *hw)
+{
+	struct ezusb_priv *upriv = hw->priv;
+	struct request_context *ctx;
+
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_PROG_END, EZUSB_RID_ACK);
+	if (!ctx)
+		return -ENOMEM;
+
+	return ezusb_access_ltv(upriv, ctx, 0, NULL,
+				EZUSB_FRAME_CONTROL, NULL, 0, NULL);
+}
+
+static int ezusb_program_bytes(struct hermes *hw, const char *buf,
+			       u32 addr, u32 len)
+{
+	struct ezusb_priv *upriv = hw->priv;
+	struct request_context *ctx;
+	__le32 data = cpu_to_le32(addr);
+	int err;
+
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_PROG_SET_ADDR, EZUSB_RID_ACK);
+	if (!ctx)
+		return -ENOMEM;
+
+	err = ezusb_access_ltv(upriv, ctx, sizeof(data), &data,
+			       EZUSB_FRAME_CONTROL, NULL, 0, NULL);
+	if (err)
+		return err;
+
+	ctx = ezusb_alloc_ctx(upriv, EZUSB_RID_PROG_BYTES, EZUSB_RID_ACK);
+	if (!ctx)
+		return -ENOMEM;
+
+	return ezusb_access_ltv(upriv, ctx, len, buf,
+				EZUSB_FRAME_CONTROL, NULL, 0, NULL);
+}
+
+static int ezusb_program(struct hermes *hw, const char *buf,
+			 u32 addr, u32 len)
+{
+	u32 ch_addr;
+	u32 ch_len;
+	int err = 0;
+
+	/* We can only send 2048 bytes out of the bulk xmit at a time,
+	 * so we have to split any programming into chunks of <2048
+	 * bytes. */
+
+	ch_len = (len < MAX_DL_SIZE) ? len : MAX_DL_SIZE;
+	ch_addr = addr;
+
+	while (ch_addr < (addr + len)) {
+		pr_debug("Programming subblock of length %d "
+			 "to address 0x%08x. Data @ %p\n",
+			 ch_len, ch_addr, &buf[ch_addr - addr]);
+
+		err = ezusb_program_bytes(hw, &buf[ch_addr - addr],
+					  ch_addr, ch_len);
+		if (err)
+			break;
+
+		ch_addr += ch_len;
+		ch_len = ((addr + len - ch_addr) < MAX_DL_SIZE) ?
+			(addr + len - ch_addr) : MAX_DL_SIZE;
+	}
+
+	return err;
+}
+
 static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1440,6 +1556,10 @@ static const struct hermes_ops ezusb_ops = {
 	.read_ltv = ezusb_read_ltv,
 	.write_ltv = ezusb_write_ltv,
 	.bap_pread = ezusb_bap_pread,
+	.read_pda = ezusb_read_pda,
+	.program_init = ezusb_program_init,
+	.program_end = ezusb_program_end,
+	.program = ezusb_program,
 	.lock_irqsave = ezusb_lock_irqsave,
 	.unlock_irqrestore = ezusb_unlock_irqrestore,
 	.lock_irq = ezusb_lock_irq,
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index b4f68ef..9b1af49 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -349,6 +349,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 		goto failed;
 
 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
+	hw->eeprom_pda = true;
 
 	/*
 	 * This actually configures the PCMCIA socket -- setting up
-- 
1.6.4.4

