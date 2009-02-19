Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:60242 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbZBTAAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:00:12 -0500
Received: by mail-bw0-f161.google.com with SMTP id 5so1892042bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 16:00:11 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/2] orinoco: prevent accessing memory outside the firmware image
Date: Thu, 19 Feb 2009 23:46:27 +0000
Message-Id: <1235087187-23425-3-git-send-email-kilroyd@googlemail.com> (sfid-20090220_010018_252911_4BCAE727)
In-Reply-To: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com>
References: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do this by indicating the end of the appropriate regions of memory.

Note that MAX_PDA_SIZE should only apply to the PDA block read from
flash/EEPROM, and has been erronously applied to the pdr elements.
Remove the macro, and use the actual PDA size passed down by the caller.

We also fix up some of the types used, marking as much as possible
const, and using void* for the end pointers.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/fw.c         |   10 ++-
 drivers/net/wireless/orinoco/hermes_dld.c |   89 +++++++++++++++--------------
 drivers/net/wireless/orinoco/hermes_dld.h |   10 ++-
 3 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index b2ad24f..4410edd 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -92,7 +92,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	const struct firmware *fw_entry;
 	const struct orinoco_fw_header *hdr;
 	const unsigned char *first_block;
-	const unsigned char *end;
+	const void *end;
 	const char *firmware;
 	struct net_device *dev = priv->ndev;
 	int err = 0;
@@ -160,7 +160,8 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		       le16_to_cpu(hdr->headersize) +
 		       le32_to_cpu(hdr->pdr_offset));
 
-	err = hermes_apply_pda_with_defaults(hw, first_block, pda);
+	err = hermes_apply_pda_with_defaults(hw, first_block, end, pda,
+					     &pda[fw->pda_size / sizeof(*pda)]);
 	printk(KERN_DEBUG "%s: Apply PDA returned %d\n", dev->name, err);
 	if (err)
 		goto abort;
@@ -192,7 +193,7 @@ free:
  */
 static int
 symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
-		const unsigned char *image, const unsigned char *end,
+		const unsigned char *image, const void *end,
 		int secondary)
 {
 	hermes_t *hw = &priv->hw;
@@ -235,7 +236,8 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 	if (secondary) {
 		size_t len = hermes_blocks_length(first_block);
 		ptr = first_block + len;
-		ret = hermes_apply_pda(hw, ptr, pda);
+		ret = hermes_apply_pda(hw, ptr, end, pda,
+				       &pda[fw->pda_size / sizeof(*pda)]);
 		kfree(pda);
 		if (ret)
 			return ret;
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index 5260ceb..aaf8c68 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -71,18 +71,6 @@
 #define BLOCK_END	0xFFFFFFFF	/* Last image block */
 #define TEXT_END	0x1A		/* End of text header */
 
-/*
- * PDA == Production Data Area
- *
- * In principle, the max. size of the PDA is is 4096 words. Currently,
- * however, only about 500 bytes of this area are used.
- *
- * Some USB implementations can't handle sizes in excess of 1016. Note
- * that PDA is not actually used in those USB environments, but may be
- * retrieved by common code.
- */
-#define MAX_PDA_SIZE	1000
-
 /* Limit the amout we try to download in a single shot.
  * Size is in bytes.
  */
@@ -218,13 +206,14 @@ hermes_aux_control(hermes_t *hw, int enabled)
  * Scan PDR for the record with the specified RECORD_ID.
  * If it's not found, return NULL.
  */
-static struct pdr *
-hermes_find_pdr(struct pdr *first_pdr, u32 record_id)
+static const struct pdr *
+hermes_find_pdr(const struct pdr *first_pdr, u32 record_id, const void *end)
 {
-	struct pdr *pdr = first_pdr;
-	void *end = (void *)first_pdr + MAX_PDA_SIZE;
+	const struct pdr *pdr = first_pdr;
 
-	while (((void *)pdr < end) &&
+	end -= sizeof(struct pdr);
+
+	while (((void *)pdr <= end) &&
 	       (pdr_id(pdr) != PDI_END)) {
 		/*
 		 * PDR area is currently not terminated by PDI_END.
@@ -244,12 +233,15 @@ hermes_find_pdr(struct pdr *first_pdr, u32 record_id)
 }
 
 /* Scan production data items for a particular entry */
-static struct pdi *
-hermes_find_pdi(struct pdi *first_pdi, u32 record_id)
+static const struct pdi *
+hermes_find_pdi(const struct pdi *first_pdi, u32 record_id, const void *end)
 {
-	struct pdi *pdi = first_pdi;
+	const struct pdi *pdi = first_pdi;
+
+	end -= sizeof(struct pdi);
 
-	while (pdi_id(pdi) != PDI_END) {
+	while (((void *)pdi <= end) &&
+	       (pdi_id(pdi) != PDI_END)) {
 
 		/* If the record ID matches, we are done */
 		if (pdi_id(pdi) == record_id)
@@ -262,12 +254,13 @@ hermes_find_pdi(struct pdi *first_pdi, u32 record_id)
 
 /* Process one Plug Data Item - find corresponding PDR and plug it */
 static int
-hermes_plug_pdi(hermes_t *hw, struct pdr *first_pdr, const struct pdi *pdi)
+hermes_plug_pdi(hermes_t *hw, const struct pdr *first_pdr,
+		const struct pdi *pdi, const void *pdr_end)
 {
-	struct pdr *pdr;
+	const struct pdr *pdr;
 
 	/* Find the PDR corresponding to this PDI */
-	pdr = hermes_find_pdr(first_pdr, pdi_id(pdi));
+	pdr = hermes_find_pdr(first_pdr, pdi_id(pdi), pdr_end);
 
 	/* No match is found, safe to ignore */
 	if (!pdr)
@@ -345,18 +338,22 @@ int hermes_read_pda(hermes_t *hw,
  */
 int hermes_apply_pda(hermes_t *hw,
 		     const char *first_pdr,
-		     const __le16 *pda)
+		     const void *pdr_end,
+		     const __le16 *pda,
+		     const void *pda_end)
 {
 	int ret;
 	const struct pdi *pdi;
-	struct pdr *pdr;
+	const struct pdr *pdr;
 
-	pdr = (struct pdr *) first_pdr;
+	pdr = (const struct pdr *) first_pdr;
+	pda_end -= sizeof(struct pdi);
 
 	/* Go through every PDI and plug them into the adapter */
 	pdi = (const struct pdi *) (pda + 2);
-	while (pdi_id(pdi) != PDI_END) {
-		ret = hermes_plug_pdi(hw, pdr, pdi);
+	while (((void *)pdi <= pda_end) &&
+	       (pdi_id(pdi) != PDI_END)) {
+		ret = hermes_plug_pdi(hw, pdr, pdi, pdr_end);
 		if (ret)
 			return ret;
 
@@ -476,7 +473,7 @@ int hermesi_program_end(hermes_t *hw)
 }
 
 /* Program the data blocks */
-int hermes_program(hermes_t *hw, const char *first_block, const char *end)
+int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 {
 	const struct dblock *blk;
 	u32 blkaddr;
@@ -488,14 +485,14 @@ int hermes_program(hermes_t *hw, const char *first_block, const char *end)
 
 	blk = (const struct dblock *) first_block;
 
-	if ((const char *) blk > (end - sizeof(*blk)))
+	if ((void *) blk > (end - sizeof(*blk)))
 		return -EIO;
 
 	blkaddr = dblock_addr(blk);
 	blklen = dblock_len(blk);
 
 	while ((blkaddr != BLOCK_END) &&
-	       (((const char *) blk + blklen) <= end)) {
+	       (((void *) blk + blklen) <= end)) {
 		printk(KERN_DEBUG PFX
 		       "Programming block of length %d to address 0x%08x\n",
 		       blklen, blkaddr);
@@ -527,7 +524,7 @@ int hermes_program(hermes_t *hw, const char *first_block, const char *end)
 #endif
 		blk = (const struct dblock *) &blk->data[blklen];
 
-		if ((const char *) blk > (end - sizeof(*blk)))
+		if ((void *) blk > (end - sizeof(*blk)))
 			return -EIO;
 
 		blkaddr = dblock_addr(blk);
@@ -545,9 +542,9 @@ static const struct {							\
 	__le16 id;							\
 	u8 val[length];							\
 } __attribute__ ((packed)) default_pdr_data_##pid = {			\
-	cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
+	cpu_to_le16((sizeof(default_pdr_data_##pid)/			\
 				sizeof(__le16)) - 1),			\
-	cpu_to_le16(pid),					\
+	cpu_to_le16(pid),						\
 	data								\
 }
 
@@ -616,17 +613,20 @@ DEFINE_DEFAULT_PDR(0x0161, 256,
  */
 int hermes_apply_pda_with_defaults(hermes_t *hw,
 				   const char *first_pdr,
-				   const __le16 *pda)
+				   const void *pdr_end,
+				   const __le16 *pda,
+				   const void *pda_end)
 {
 	const struct pdr *pdr = (const struct pdr *) first_pdr;
-	struct pdi *first_pdi = (struct pdi *) &pda[2];
-	struct pdi *pdi;
-	struct pdi *default_pdi = NULL;
-	struct pdi *outdoor_pdi;
-	void *end = (void *)first_pdr + MAX_PDA_SIZE;
+	const struct pdi *first_pdi = (const struct pdi *) &pda[2];
+	const struct pdi *pdi;
+	const struct pdi *default_pdi = NULL;
+	const struct pdi *outdoor_pdi;
 	int record_id;
 
-	while (((void *)pdr < end) &&
+	pdr_end -= sizeof(struct pdr);
+
+	while (((void *)pdr <= pdr_end) &&
 	       (pdr_id(pdr) != PDI_END)) {
 		/*
 		 * For spectrum_cs firmwares,
@@ -638,7 +638,7 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 			break;
 		record_id = pdr_id(pdr);
 
-		pdi = hermes_find_pdi(first_pdi, record_id);
+		pdi = hermes_find_pdi(first_pdi, record_id, pda_end);
 		if (pdi)
 			printk(KERN_DEBUG PFX "Found record 0x%04x at %p\n",
 			       record_id, pdi);
@@ -646,7 +646,8 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 		switch (record_id) {
 		case 0x110: /* Modem REFDAC values */
 		case 0x120: /* Modem VGDAC values */
-			outdoor_pdi = hermes_find_pdi(first_pdi, record_id + 1);
+			outdoor_pdi = hermes_find_pdi(first_pdi, record_id + 1,
+						      pda_end);
 			default_pdi = NULL;
 			if (outdoor_pdi) {
 				pdi = outdoor_pdi;
diff --git a/drivers/net/wireless/orinoco/hermes_dld.h b/drivers/net/wireless/orinoco/hermes_dld.h
index 6fcb262..9881f08 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.h
+++ b/drivers/net/wireless/orinoco/hermes_dld.h
@@ -29,7 +29,7 @@
 
 int hermesi_program_init(hermes_t *hw, u32 offset);
 int hermesi_program_end(hermes_t *hw);
-int hermes_program(hermes_t *hw, const char *first_block, const char *end);
+int hermes_program(hermes_t *hw, const char *first_block, const void *end);
 
 int hermes_read_pda(hermes_t *hw,
 		    __le16 *pda,
@@ -38,10 +38,14 @@ int hermes_read_pda(hermes_t *hw,
 		    int use_eeprom);
 int hermes_apply_pda(hermes_t *hw,
 		     const char *first_pdr,
-		     const __le16 *pda);
+		     const void *pdr_end,
+		     const __le16 *pda,
+		     const void *pda_end);
 int hermes_apply_pda_with_defaults(hermes_t *hw,
 				   const char *first_pdr,
-				   const __le16 *pda);
+				   const void *pdr_end,
+				   const __le16 *pda,
+				   const void *pda_end);
 
 size_t hermes_blocks_length(const char *first_block);
 
-- 
1.6.0.6

