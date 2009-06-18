Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbZFRWWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:30 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:32 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 15/23] orinoco: make firmware download less verbose
Date: Thu, 18 Jun 2009 23:21:27 +0100
Message-Id: <1245363695-8289-16-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware download code has been in a couple of releases, without any
significant issues reported in this code.

Convert to use pr_debug, so the messages can be recoverred by defining
DEBUG.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hermes_dld.c |   50 +++++++++++++---------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index a9ba195..a3eefe1 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -309,7 +309,7 @@ int hermes_read_pda(hermes_t *hw,
 
 	/* Open auxiliary port */
 	ret = hermes_aux_control(hw, 1);
-	printk(KERN_DEBUG PFX "AUX enable returned %d\n", ret);
+	pr_debug(PFX "AUX enable returned %d\n", ret);
 	if (ret)
 		return ret;
 
@@ -319,12 +319,12 @@ int hermes_read_pda(hermes_t *hw,
 
 	/* Close aux port */
 	ret = hermes_aux_control(hw, 0);
-	printk(KERN_DEBUG PFX "AUX disable returned %d\n", ret);
+	pr_debug(PFX "AUX disable returned %d\n", ret);
 
 	/* Check PDA length */
 	pda_size = le16_to_cpu(pda[0]);
-	printk(KERN_DEBUG PFX "Actual PDA length %d, Max allowed %d\n",
-	       pda_size, pda_len);
+	pr_debug(PFX "Actual PDA length %d, Max allowed %d\n",
+		 pda_size, pda_len);
 	if (pda_size > pda_len)
 		return -EINVAL;
 
@@ -422,20 +422,19 @@ int hermesi_program_init(hermes_t *hw, u32 offset)
 		return err;
 
 	err = hermes_aux_control(hw, 1);
-	printk(KERN_DEBUG PFX "AUX enable returned %d\n", err);
+	pr_debug(PFX "AUX enable returned %d\n", err);
 
 	if (err)
 		return err;
 
-	printk(KERN_DEBUG PFX "Enabling volatile, EP 0x%08x\n", offset);
+	pr_debug(KERN_DEBUG PFX "Enabling volatile, EP 0x%08x\n", offset);
 	err = hermes_doicmd_wait(hw,
 				 HERMES_PROGRAM_ENABLE_VOLATILE,
 				 offset & 0xFFFFu,
 				 offset >> 16,
 				 0,
 				 NULL);
-	printk(KERN_DEBUG PFX "PROGRAM_ENABLE returned %d\n",
-	       err);
+	pr_debug(PFX "PROGRAM_ENABLE returned %d\n", err);
 
 	return err;
 }
@@ -454,16 +453,16 @@ int hermesi_program_end(hermes_t *hw)
 
 	rc = hermes_docmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
 
-	printk(KERN_DEBUG PFX "PROGRAM_DISABLE returned %d, "
-	       "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
-	       rc, resp.resp0, resp.resp1, resp.resp2);
+	pr_debug(PFX "PROGRAM_DISABLE returned %d, "
+		 "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
+		 rc, resp.resp0, resp.resp1, resp.resp2);
 
 	if ((rc == 0) &&
 	    ((resp.status & HERMES_STATUS_CMDCODE) != HERMES_CMD_DOWNLD))
 		rc = -EIO;
 
 	err = hermes_aux_control(hw, 0);
-	printk(KERN_DEBUG PFX "AUX disable returned %d\n", err);
+	pr_debug(PFX "AUX disable returned %d\n", err);
 
 	/* Acknowledge any outstanding command */
 	hermes_write_regn(hw, EVACK, 0xFFFF);
@@ -496,9 +495,8 @@ int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 
 	while ((blkaddr != BLOCK_END) &&
 	       (((void *) blk + blklen) <= end)) {
-		printk(KERN_DEBUG PFX
-		       "Programming block of length %d to address 0x%08x\n",
-		       blklen, blkaddr);
+		pr_debug(PFX "Programming block of length %d "
+			 "to address 0x%08x\n", blklen, blkaddr);
 
 #if !LIMIT_PROGRAM_SIZE
 		/* wl_lkm driver splits this into writes of 2000 bytes */
@@ -510,10 +508,9 @@ int hermes_program(hermes_t *hw, const char *first_block, const void *end)
 		addr = blkaddr;
 
 		while (addr < (blkaddr + blklen)) {
-			printk(KERN_DEBUG PFX
-			       "Programming subblock of length %d "
-			       "to address 0x%08x. Data @ %p\n",
-			       len, addr, &blk->data[addr - blkaddr]);
+			pr_debug(PFX "Programming subblock of length %d "
+				 "to address 0x%08x. Data @ %p\n",
+				 len, addr, &blk->data[addr - blkaddr]);
 
 			hermes_aux_setaddr(hw, addr);
 			hermes_write_bytes(hw, HERMES_AUXDATA,
@@ -643,8 +640,8 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 
 		pdi = hermes_find_pdi(first_pdi, record_id, pda_end);
 		if (pdi)
-			printk(KERN_DEBUG PFX "Found record 0x%04x at %p\n",
-			       record_id, pdi);
+			pr_debug(PFX "Found record 0x%04x at %p\n",
+				 record_id, pdi);
 
 		switch (record_id) {
 		case 0x110: /* Modem REFDAC values */
@@ -654,9 +651,9 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 			default_pdi = NULL;
 			if (outdoor_pdi) {
 				pdi = outdoor_pdi;
-				printk(KERN_DEBUG PFX
-				       "Using outdoor record 0x%04x at %p\n",
-				       record_id + 1, pdi);
+				pr_debug(PFX
+					 "Using outdoor record 0x%04x at %p\n",
+					 record_id + 1, pdi);
 			}
 			break;
 		case 0x5: /*  HWIF Compatiblity */
@@ -684,9 +681,8 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 		if (!pdi && default_pdi) {
 			/* Use default */
 			pdi = default_pdi;
-			printk(KERN_DEBUG PFX
-			       "Using default record 0x%04x at %p\n",
-			       record_id, pdi);
+			pr_debug(PFX "Using default record 0x%04x at %p\n",
+				 record_id, pdi);
 		}
 
 		if (pdi) {
-- 
1.6.0.6

