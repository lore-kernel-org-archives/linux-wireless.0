Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395AbYHUW2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:40 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:39 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 07/19] orinoco: Make firmware download logic more generic
Date: Thu, 21 Aug 2008 23:27:52 +0100
Message-Id: <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002843_616100_D6CD69A8)
In-Reply-To: <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure PDA read is terminated.
Prevent invalid programming blocks from causing reads outside the
firmware image
Turn off aux stuff when finished.
Option to program in limited block sizes (controlled by macro).
Option to read PDA from EEPROM.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes_dld.c  |  209 +++++++++++++++++++++++++++---------
 drivers/net/wireless/hermes_dld.h  |   22 ++--
 drivers/net/wireless/spectrum_cs.c |   23 +++--
 3 files changed, 182 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/hermes_dld.c b/drivers/net/wireless/hermes_dld.c
index 9a8ef30..22ae79d 100644
--- a/drivers/net/wireless/hermes_dld.c
+++ b/drivers/net/wireless/hermes_dld.c
@@ -64,14 +64,34 @@ MODULE_LICENSE("Dual MPL/GPL");
 #define HERMES_AUX_ENABLE	0x8000	/* Enable auxiliary port access */
 #define HERMES_AUX_DISABLE	0x4000	/* Disable to auxiliary port access */
 #define HERMES_AUX_ENABLED	0xC000	/* Auxiliary port is open */
+#define HERMES_AUX_DISABLED	0x0000	/* Auxiliary port is closed */
 
 #define HERMES_AUX_PW0	0xFE01
 #define HERMES_AUX_PW1	0xDC23
 #define HERMES_AUX_PW2	0xBA45
 
-/* End markers */
+/* End markers used in dblocks */
 #define PDI_END		0x00000000	/* End of PDA */
 #define BLOCK_END	0xFFFFFFFF	/* Last image block */
+#define TEXT_END	0x1A		/* End of text header */
+
+/*
+ * PDA == Production Data Area
+ *
+ * In principle, the max. size of the PDA is is 4096 words. Currently,
+ * however, only about 500 bytes of this area are used.
+ *
+ * Some USB implementations can't handle sizes in excess of 1016. Note
+ * that PDA is not actually used in those USB environments, but may be
+ * retrieved by common code.
+ */
+#define MAX_PDA_SIZE	1000
+
+/* Limit the amout we try to download in a single shot.
+ * Size is in bytes.
+ */
+#define MAX_DL_SIZE 1024
+#define LIMIT_PROGRAM_SIZE 0
 
 /*
  * The following structures have little-endian fields denoted by
@@ -112,7 +132,8 @@ struct pdi {
 	char data[0];		/* plug data */
 } __attribute__ ((packed));
 
-/* Functions for access to little-endian data */
+/*** FW data block access functions ***/
+
 static inline u32
 dblock_addr(const struct dblock *blk)
 {
@@ -125,6 +146,8 @@ dblock_len(const struct dblock *blk)
 	return le16_to_cpu(blk->len);
 }
 
+/*** PDR Access functions ***/
+
 static inline u32
 pdr_id(const struct pdr *pdr)
 {
@@ -143,6 +166,8 @@ pdr_len(const struct pdr *pdr)
 	return le32_to_cpu(pdr->len);
 }
 
+/*** PDI Access functions ***/
+
 static inline u32
 pdi_id(const struct pdi *pdi)
 {
@@ -156,49 +181,55 @@ pdi_len(const struct pdi *pdi)
 	return 2 * (le16_to_cpu(pdi->len) - 1);
 }
 
-/* Set address of the auxiliary port */
+/*** Hermes AUX control ***/
+
 static inline void
-spectrum_aux_setaddr(hermes_t *hw, u32 addr)
+hermes_aux_setaddr(hermes_t *hw, u32 addr)
 {
 	hermes_write_reg(hw, HERMES_AUXPAGE, (u16) (addr >> 7));
 	hermes_write_reg(hw, HERMES_AUXOFFSET, (u16) (addr & 0x7F));
 }
 
-/* Open access to the auxiliary port */
-static int
-spectrum_aux_open(hermes_t *hw)
+static inline int
+hermes_aux_control(hermes_t *hw, int enabled)
 {
+	int desired_state = enabled ? HERMES_AUX_ENABLED : HERMES_AUX_DISABLED;
+	int action = enabled ? HERMES_AUX_ENABLE : HERMES_AUX_DISABLE;
 	int i;
 
 	/* Already open? */
-	if (hermes_read_reg(hw, HERMES_CONTROL) == HERMES_AUX_ENABLED)
+	if (hermes_read_reg(hw, HERMES_CONTROL) == desired_state)
 		return 0;
 
 	hermes_write_reg(hw, HERMES_PARAM0, HERMES_AUX_PW0);
 	hermes_write_reg(hw, HERMES_PARAM1, HERMES_AUX_PW1);
 	hermes_write_reg(hw, HERMES_PARAM2, HERMES_AUX_PW2);
-	hermes_write_reg(hw, HERMES_CONTROL, HERMES_AUX_ENABLE);
+	hermes_write_reg(hw, HERMES_CONTROL, action);
 
 	for (i = 0; i < 20; i++) {
 		udelay(10);
 		if (hermes_read_reg(hw, HERMES_CONTROL) ==
-		    HERMES_AUX_ENABLED)
+		    desired_state)
 			return 0;
 	}
 
 	return -EBUSY;
 }
 
+/*** Plug Data Functions ***/
+
 /*
  * Scan PDR for the record with the specified RECORD_ID.
  * If it's not found, return NULL.
  */
 static struct pdr *
-spectrum_find_pdr(struct pdr *first_pdr, u32 record_id)
+hermes_find_pdr(struct pdr *first_pdr, u32 record_id)
 {
 	struct pdr *pdr = first_pdr;
+	void *end = (void *)first_pdr + MAX_PDA_SIZE;
 
-	while (pdr_id(pdr) != PDI_END) {
+	while (((void *)pdr < end) &&
+	       (pdr_id(pdr) != PDI_END)) {
 		/*
 		 * PDR area is currently not terminated by PDI_END.
 		 * It's followed by CRC records, which have the type
@@ -218,12 +249,12 @@ spectrum_find_pdr(struct pdr *first_pdr, u32 record_id)
 
 /* Process one Plug Data Item - find corresponding PDR and plug it */
 static int
-spectrum_plug_pdi(hermes_t *hw, struct pdr *first_pdr, struct pdi *pdi)
+hermes_plug_pdi(hermes_t *hw, struct pdr *first_pdr, const struct pdi *pdi)
 {
 	struct pdr *pdr;
 
-	/* Find the PDI corresponding to this PDR */
-	pdr = spectrum_find_pdr(first_pdr, pdi_id(pdi));
+	/* Find the PDR corresponding to this PDI */
+	pdr = hermes_find_pdr(first_pdr, pdi_id(pdi));
 
 	/* No match is found, safe to ignore */
 	if (!pdr)
@@ -234,96 +265,172 @@ spectrum_plug_pdi(hermes_t *hw, struct pdr *first_pdr, struct pdi *pdi)
 		return -EINVAL;
 
 	/* do the actual plugging */
-	spectrum_aux_setaddr(hw, pdr_addr(pdr));
+	hermes_aux_setaddr(hw, pdr_addr(pdr));
 	hermes_write_bytes(hw, HERMES_AUXDATA, pdi->data, pdi_len(pdi));
 
 	return 0;
 }
 
 /* Read PDA from the adapter */
-int
-spectrum_read_pda(hermes_t *hw, __le16 *pda, int pda_len)
+int hermes_read_pda(hermes_t *hw,
+		    __le16 *pda,
+		    u32 pda_addr,
+		    u16 pda_len,
+		    int use_eeprom) /* can we get this into hw? */
 {
 	int ret;
-	int pda_size;
+	u16 pda_size;
+	u16 data_len = pda_len;
+	__le16 *data = pda;
 
-	/* Issue command to read EEPROM */
-	ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
-	if (ret)
-		return ret;
+	if (use_eeprom) {
+		/* PDA of spectrum symbol is in eeprom */
+
+		/* Issue command to read EEPROM */
+		ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
+		if (ret)
+			return ret;
+	}
 
 	/* Open auxiliary port */
-	ret = spectrum_aux_open(hw);
+	ret = hermes_aux_control(hw, 1);
+	printk(KERN_DEBUG PFX "AUX enable returned %d\n", ret);
 	if (ret)
 		return ret;
 
 	/* read PDA from EEPROM */
-	spectrum_aux_setaddr(hw, PDA_ADDR);
-	hermes_read_words(hw, HERMES_AUXDATA, pda, pda_len / 2);
+	hermes_aux_setaddr(hw, pda_addr);
+	hermes_read_words(hw, HERMES_AUXDATA, data, data_len / 2);
+
+	/* Close aux port */
+	ret = hermes_aux_control(hw, 0);
+	printk(KERN_DEBUG PFX "AUX disable returned %d\n", ret);
 
 	/* Check PDA length */
 	pda_size = le16_to_cpu(pda[0]);
+	printk(KERN_DEBUG PFX "Actual PDA length %d, Max allowed %d\n",
+	       pda_size, pda_len);
 	if (pda_size > pda_len)
 		return -EINVAL;
 
 	return 0;
 }
-EXPORT_SYMBOL(spectrum_read_pda);
+EXPORT_SYMBOL(hermes_read_pda);
 
-/* Parse PDA and write the records into the adapter */
-int
-spectrum_apply_pda(hermes_t *hw, const struct dblock *first_block,
-		   __le16 *pda)
+/* Parse PDA and write the records into the adapter
+ *
+ * Attempt to write every records that is in the specified pda
+ * which also has a valid production data record for the firmware.
+ */
+int hermes_apply_pda(hermes_t *hw,
+		     const char *first_pdr,
+		     const __le16 *pda)
 {
 	int ret;
-	struct pdi *pdi;
-	struct pdr *first_pdr;
-	const struct dblock *blk = first_block;
-
-	/* Skip all blocks to locate Plug Data References */
-	while (dblock_addr(blk) != BLOCK_END)
-		blk = (struct dblock *) &blk->data[dblock_len(blk)];
+	const struct pdi *pdi;
+	struct pdr *pdr;
 
-	first_pdr = (struct pdr *) blk;
+	pdr = (struct pdr *) first_pdr;
 
 	/* Go through every PDI and plug them into the adapter */
-	pdi = (struct pdi *) (pda + 2);
+	pdi = (const struct pdi *) (pda + 2);
 	while (pdi_id(pdi) != PDI_END) {
-		ret = spectrum_plug_pdi(hw, first_pdr, pdi);
+		ret = hermes_plug_pdi(hw, pdr, pdi);
 		if (ret)
 			return ret;
 
 		/* Increment to the next PDI */
-		pdi = (struct pdi *) &pdi->data[pdi_len(pdi)];
+		pdi = (const struct pdi *) &pdi->data[pdi_len(pdi)];
 	}
 	return 0;
 }
-EXPORT_SYMBOL(spectrum_apply_pda);
+EXPORT_SYMBOL(hermes_apply_pda);
+
+/* Identify the total number of bytes in all blocks
+ * including the header data.
+ */
+size_t
+hermes_blocks_length(const char *first_block)
+{
+	const struct dblock *blk = (const struct dblock *) first_block;
+	int total_len = 0;
+	int len;
+
+	/* Skip all blocks to locate Plug Data References
+	 * (Spectrum CS) */
+	while (dblock_addr(blk) != BLOCK_END) {
+		len = dblock_len(blk);
+		total_len += sizeof(*blk) + len;
+		blk = (struct dblock *) &blk->data[len];
+	}
+
+	return total_len;
+}
+EXPORT_SYMBOL(hermes_blocks_length);
+
+/*** Hermes programming ***/
 
-/* Load firmware blocks into the adapter */
-int
-spectrum_load_blocks(hermes_t *hw, const struct dblock *first_block)
+/* Program the data blocks */
+int hermes_program(hermes_t *hw, const char *first_block, const char *end)
 {
 	const struct dblock *blk;
 	u32 blkaddr;
 	u32 blklen;
+#if LIMIT_PROGRAM_SIZE
+	u32 addr;
+	u32 len;
+#endif
+
+	blk = (const struct dblock *) first_block;
+
+	if ((const char *) blk > (end - sizeof(*blk)))
+		return -EIO;
 
-	blk = first_block;
 	blkaddr = dblock_addr(blk);
 	blklen = dblock_len(blk);
 
-	while (dblock_addr(blk) != BLOCK_END) {
-		spectrum_aux_setaddr(hw, blkaddr);
+	while ((blkaddr != BLOCK_END) &&
+	       (((const char *) blk + blklen) <= end)) {
+		printk(KERN_DEBUG PFX
+		       "Programming block of length %d to address 0x%08x\n",
+		       blklen, blkaddr);
+
+#if !LIMIT_PROGRAM_SIZE
+		/* wl_lkm driver splits this into writes of 2000 bytes */
+		hermes_aux_setaddr(hw, blkaddr);
 		hermes_write_bytes(hw, HERMES_AUXDATA, blk->data,
 				   blklen);
+#else
+		len = (blklen < MAX_DL_SIZE) ? blklen : MAX_DL_SIZE;
+		addr = blkaddr;
+
+		while (addr < (blkaddr + blklen)) {
+			printk(KERN_DEBUG PFX
+			       "Programming subblock of length %d "
+			       "to address 0x%08x. Data @ %p\n",
+			       len, addr, &blk->data[addr - blkaddr]);
+
+			hermes_aux_setaddr(hw, addr);
+			hermes_write_bytes(hw, HERMES_AUXDATA,
+					   &blk->data[addr - blkaddr],
+					   len);
+
+			addr += len;
+			len = ((blkaddr + blklen - addr) < MAX_DL_SIZE) ?
+				(blkaddr + blklen - addr) : MAX_DL_SIZE;
+		}
+#endif
+		blk = (const struct dblock *) &blk->data[blklen];
+
+		if ((const char *) blk > (end - sizeof(*blk)))
+			return -EIO;
 
-		blk = (struct dblock *) &blk->data[blklen];
 		blkaddr = dblock_addr(blk);
 		blklen = dblock_len(blk);
 	}
 	return 0;
 }
-EXPORT_SYMBOL(spectrum_load_blocks);
+EXPORT_SYMBOL(hermes_program);
 
 static int __init init_hermes_dld(void)
 {
diff --git a/drivers/net/wireless/hermes_dld.h b/drivers/net/wireless/hermes_dld.h
index 2c8892a..af75c03 100644
--- a/drivers/net/wireless/hermes_dld.h
+++ b/drivers/net/wireless/hermes_dld.h
@@ -27,19 +27,17 @@
 
 #include "hermes.h"
 
-/* Position of PDA in the adapter memory */
-#define EEPROM_ADDR	0x3000
-#define EEPROM_LEN	0x200
-#define PDA_OFFSET	0x100
+int hermes_program(hermes_t *hw, const char *first_block, const char *end);
 
-#define PDA_ADDR	(EEPROM_ADDR + PDA_OFFSET)
-#define PDA_WORDS	((EEPROM_LEN - PDA_OFFSET) / 2)
+int hermes_read_pda(hermes_t *hw,
+		    __le16 *pda,
+		    u32 pda_addr,
+		    u16 pda_len,
+		    int use_eeprom);
+int hermes_apply_pda(hermes_t *hw,
+		     const char *first_pdr,
+		     const __le16 *pda);
 
-struct dblock;
-
-int spectrum_read_pda(hermes_t *hw, __le16 *pda, int pda_len);
-int spectrum_apply_pda(hermes_t *hw, const struct dblock *first_block,
-		       __le16 *pda);
-int spectrum_load_blocks(hermes_t *hw, const struct dblock *first_block);
+size_t hermes_blocks_length(const char *first_block);
 
 #endif /* _HERMES_DLD_H */
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 579873d..2fb0018 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -166,11 +166,12 @@ spectrum_reset(struct pcmcia_device *link, int idle)
  */
 static int
 spectrum_dl_image(hermes_t *hw, struct pcmcia_device *link,
-		  const unsigned char *image, int secondary)
+		  const unsigned char *image, const unsigned char *end,
+		  int secondary)
 {
 	int ret;
 	const unsigned char *ptr;
-	const struct dblock *first_block;
+	const unsigned char *first_block;
 
 	/* Plug Data Area (PDA) */
 	__le16 pda[PDA_WORDS];
@@ -178,11 +179,11 @@ spectrum_dl_image(hermes_t *hw, struct pcmcia_device *link,
 	/* Binary block begins after the 0x1A marker */
 	ptr = image;
 	while (*ptr++ != TEXT_END);
-	first_block = (const struct dblock *) ptr;
+	first_block = ptr;
 
-	/* Read the PDA */
+	/* Read the PDA from EEPROM */
 	if (secondary) {
-		ret = spectrum_read_pda(hw, pda, sizeof(pda));
+		ret = hermes_read_pda(hw, pda, PDA_ADDR, sizeof(pda), 1);
 		if (ret)
 			return ret;
 	}
@@ -193,13 +194,15 @@ spectrum_dl_image(hermes_t *hw, struct pcmcia_device *link,
 		return ret;
 
 	/* Program the adapter with new firmware */
-	ret = spectrum_load_blocks(hw, first_block);
+	ret = hermes_program(hw, first_block, end);
 	if (ret)
 		return ret;
 
 	/* Write the PDA to the adapter */
 	if (secondary) {
-		ret = spectrum_apply_pda(hw, first_block, pda);
+		size_t len = hermes_blocks_length(first_block);
+		ptr = first_block + len;
+		ret = hermes_apply_pda(hw, ptr, pda);
 		if (ret)
 			return ret;
 	}
@@ -242,7 +245,8 @@ spectrum_dl_firmware(hermes_t *hw, struct pcmcia_device *link)
 	}
 
 	/* Load primary firmware */
-	ret = spectrum_dl_image(hw, link, fw_entry->data, 0);
+	ret = spectrum_dl_image(hw, link, fw_entry->data,
+				fw_entry->data + fw_entry->size, 0);
 	release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR PFX "Primary firmware download failed\n");
@@ -257,7 +261,8 @@ spectrum_dl_firmware(hermes_t *hw, struct pcmcia_device *link)
 	}
 
 	/* Load secondary firmware */
-	ret = spectrum_dl_image(hw, link, fw_entry->data, 1);
+	ret = spectrum_dl_image(hw, link, fw_entry->data,
+				fw_entry->data + fw_entry->size, 1);
 	release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR PFX "Secondary firmware download failed\n");
-- 
1.5.6.4

