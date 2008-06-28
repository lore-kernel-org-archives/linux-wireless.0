Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:16947 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYF1SjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:06 -0400
Received: by ik-out-1112.google.com with SMTP id c28so379044ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:05 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 08/19] orinoco: Extend hermes_dld routines for Agere firmware
Date: Sat, 28 Jun 2008 19:38:14 +0100
Message-Id: <1214678305-7057-9-git-send-email-kilroyd@gmail.com> (sfid-20080628_203918_735096_6084C3D1)
In-Reply-To: <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add programming initialisation and termination functions.
Add checks to avoid overrunning the firmware image or PDA areas.
Extra algorithm to program PDA values using defaults where necessary.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes_dld.c |  285 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/hermes_dld.h |    5 +
 2 files changed, 290 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hermes_dld.c b/drivers/net/wireless/hermes_dld.c
index 454452f..4f11363 100644
--- a/drivers/net/wireless/hermes_dld.c
+++ b/drivers/net/wireless/hermes_dld.c
@@ -70,6 +70,12 @@ MODULE_LICENSE("Dual MPL/GPL");
 #define HERMES_AUX_PW1	0xDC23
 #define HERMES_AUX_PW2	0xBA45
 
+/* HERMES_CMD_DOWNLD */
+#define HERMES_PROGRAM_DISABLE             (0x0000 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_ENABLE_VOLATILE     (0x0100 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_ENABLE_NON_VOLATILE (0x0200 | HERMES_CMD_DOWNLD)
+#define HERMES_PROGRAM_NON_VOLATILE        (0x0300 | HERMES_CMD_DOWNLD)
+
 /* End markers used in dblocks */
 #define PDI_END		0x00000000	/* End of PDA */
 #define BLOCK_END	0xFFFFFFFF	/* Last image block */
@@ -247,6 +253,23 @@ hermes_find_pdr(struct pdr *first_pdr, u32 record_id)
 	return NULL;
 }
 
+/* Scan production data items for a particular entry */
+static struct pdi *
+hermes_find_pdi(struct pdi *first_pdi, u32 record_id)
+{
+	struct pdi *pdi = first_pdi;
+
+	while (pdi_id(pdi) != PDI_END) {
+
+		/* If the record ID matches, we are done */
+		if (pdi_id(pdi) == record_id)
+			return pdi;
+
+		pdi = (struct pdi *) &pdi->data[pdi_len(pdi)];
+	}
+	return NULL;
+}
+
 /* Process one Plug Data Item - find corresponding PDR and plug it */
 static int
 hermes_plug_pdi(hermes_t *hw, struct pdr *first_pdr, const struct pdi *pdi)
@@ -290,6 +313,15 @@ int hermes_read_pda(hermes_t *hw,
 		ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
 		if (ret)
 			return ret;
+	} else {
+		/* wl_lkm does not include PDA size in the PDA area.
+		 * We will pad the information into pda, so other routines
+		 * don't have to be modified */
+		pda[0] = cpu_to_le16(pda_len - 2);
+			/* Includes CFG_PROD_DATA but not itself */
+		pda[1] = cpu_to_le16(0x0800); /* CFG_PROD_DATA */
+		data_len = pda_len - 4;
+		data = pda + 2;
 	}
 
 	/* Open auxiliary port */
@@ -370,6 +402,94 @@ EXPORT_SYMBOL(hermes_blocks_length);
 
 /*** Hermes programming ***/
 
+/* About to start programming data (Hermes I)
+ * offset is the entry point
+ *
+ * Spectrum_cs' Symbol fw does not require this
+ * wl_lkm Agere fw does
+ * Don't know about intersil
+ */
+int hermesi_program_init(hermes_t *hw, u32 offset)
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
+	/* Using doicmd_wait rather than docmd_wait */
+	err = hermes_doicmd_wait(hw,
+				 0x0100 | HERMES_CMD_INIT,
+				 0, 0, 0, NULL);
+	if (err)
+		return err;
+
+	err = hermes_doicmd_wait(hw,
+				 0x0000 | HERMES_CMD_INIT,
+				 0, 0, 0, NULL);
+	if (err)
+		return err;
+
+	err = hermes_aux_control(hw, 1);
+	printk(KERN_DEBUG PFX "AUX enable returned %d\n", err);
+
+	if (err)
+		return err;
+
+	printk(KERN_DEBUG PFX "Enabling volatile, EP 0x%08x\n", offset);
+	err = hermes_doicmd_wait(hw,
+				 HERMES_PROGRAM_ENABLE_VOLATILE,
+				 offset & 0xFFFFu,
+				 offset >> 16,
+				 0,
+				 NULL);
+	printk(KERN_DEBUG PFX "PROGRAM_ENABLE returned %d\n",
+	       err);
+
+	return err;
+}
+EXPORT_SYMBOL(hermesi_program_init);
+
+/* Done programming data (Hermes I)
+ *
+ * Spectrum_cs' Symbol fw does not require this
+ * wl_lkm Agere fw does
+ * Don't know about intersil
+ */
+int hermesi_program_end(hermes_t *hw)
+{
+	struct hermes_response resp;
+	int rc = 0;
+	int err;
+
+	rc = hermes_docmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
+
+	printk(KERN_DEBUG PFX "PROGRAM_DISABLE returned %d, "
+	       "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
+	       rc, resp.resp0, resp.resp1, resp.resp2);
+
+	if ((rc == 0) &&
+	    ((resp.status & HERMES_STATUS_CMDCODE) != HERMES_CMD_DOWNLD))
+		rc = -EIO;
+
+	err = hermes_aux_control(hw, 0);
+	printk(KERN_DEBUG PFX "AUX disable returned %d\n", err);
+
+	/* Acknowledge any outstanding command */
+	hermes_write_regn(hw, EVACK, 0xFFFF);
+
+	/* Reinitialise, ignoring return */
+	(void) hermes_doicmd_wait(hw, 0x0000 | HERMES_CMD_INIT,
+				  0, 0, 0, NULL);
+
+	return rc ? rc : err;
+}
+EXPORT_SYMBOL(hermesi_program_end);
+
 /* Program the data blocks */
 int hermes_program(hermes_t *hw, const char *first_block, const char *end)
 {
@@ -443,3 +563,168 @@ static void __exit exit_hermes_dld(void)
 
 module_init(init_hermes_dld);
 module_exit(exit_hermes_dld);
+
+/*** Default plugging data for Hermes I ***/
+/* Values from wl_lkm_718/hcf/dhf.c */
+
+#define DEFINE_DEFAULT_PDR(pid, length, data)				\
+static const struct {							\
+	__le16 len;							\
+	__le16 id;							\
+	u8 val[length];							\
+} __attribute__ ((packed)) default_pdr_data_##pid = {			\
+	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
+				sizeof(__le16)) - 1),			\
+	__constant_cpu_to_le16(pid),					\
+	data								\
+}
+
+#define DEFAULT_PDR(pid) default_pdr_data_##pid
+
+/*  HWIF Compatiblity */
+DEFINE_DEFAULT_PDR(0x0005, 10, "\x00\x00\x06\x00\x01\x00\x01\x00\x01\x00");
+
+/* PPPPSign */
+DEFINE_DEFAULT_PDR(0x0108, 4, "\x00\x00\x00\x00");
+
+/* PPPPProf */
+DEFINE_DEFAULT_PDR(0x0109, 10, "\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00");
+
+/* Antenna diversity */
+DEFINE_DEFAULT_PDR(0x0150, 2, "\x00\x3F");
+
+/* Modem VCO band Set-up */
+DEFINE_DEFAULT_PDR(0x0160, 28,
+		   "\x00\x00\x00\x00\x00\x00\x00\x00"
+		   "\x00\x00\x00\x00\x00\x00\x00\x00"
+		   "\x00\x00\x00\x00\x00\x00\x00\x00"
+		   "\x00\x00\x00\x00");
+
+/* Modem Rx Gain Table Values */
+DEFINE_DEFAULT_PDR(0x0161, 256,
+		   "\x3F\x01\x3F\01\x3F\x01\x3F\x01"
+		   "\x3F\x01\x3F\01\x3F\x01\x3F\x01"
+		   "\x3F\x01\x3F\01\x3F\x01\x3F\x01"
+		   "\x3F\x01\x3F\01\x3F\x01\x3F\x01"
+		   "\x3F\x01\x3E\01\x3E\x01\x3D\x01"
+		   "\x3D\x01\x3C\01\x3C\x01\x3B\x01"
+		   "\x3B\x01\x3A\01\x3A\x01\x39\x01"
+		   "\x39\x01\x38\01\x38\x01\x37\x01"
+		   "\x37\x01\x36\01\x36\x01\x35\x01"
+		   "\x35\x01\x34\01\x34\x01\x33\x01"
+		   "\x33\x01\x32\x01\x32\x01\x31\x01"
+		   "\x31\x01\x30\x01\x30\x01\x7B\x01"
+		   "\x7B\x01\x7A\x01\x7A\x01\x79\x01"
+		   "\x79\x01\x78\x01\x78\x01\x77\x01"
+		   "\x77\x01\x76\x01\x76\x01\x75\x01"
+		   "\x75\x01\x74\x01\x74\x01\x73\x01"
+		   "\x73\x01\x72\x01\x72\x01\x71\x01"
+		   "\x71\x01\x70\x01\x70\x01\x68\x01"
+		   "\x68\x01\x67\x01\x67\x01\x66\x01"
+		   "\x66\x01\x65\x01\x65\x01\x57\x01"
+		   "\x57\x01\x56\x01\x56\x01\x55\x01"
+		   "\x55\x01\x54\x01\x54\x01\x53\x01"
+		   "\x53\x01\x52\x01\x52\x01\x51\x01"
+		   "\x51\x01\x50\x01\x50\x01\x48\x01"
+		   "\x48\x01\x47\x01\x47\x01\x46\x01"
+		   "\x46\x01\x45\x01\x45\x01\x44\x01"
+		   "\x44\x01\x43\x01\x43\x01\x42\x01"
+		   "\x42\x01\x41\x01\x41\x01\x40\x01"
+		   "\x40\x01\x40\x01\x40\x01\x40\x01"
+		   "\x40\x01\x40\x01\x40\x01\x40\x01"
+		   "\x40\x01\x40\x01\x40\x01\x40\x01"
+		   "\x40\x01\x40\x01\x40\x01\x40\x01");
+
+/* Write PDA according to certain rules.
+ *
+ * For every production data record, look for a previous setting in
+ * the pda, and use that.
+ *
+ * For certain records, use defaults if they are not found in pda.
+ */
+int hermes_apply_pda_with_defaults(hermes_t *hw,
+				   const char *first_pdr,
+				   const __le16 *pda)
+{
+	const struct pdr *pdr = (const struct pdr *) first_pdr;
+	struct pdi *first_pdi = (struct pdi *) &pda[2];
+	struct pdi *pdi;
+	struct pdi *default_pdi = NULL;
+	struct pdi *outdoor_pdi;
+	void *end = (void *)first_pdr + MAX_PDA_SIZE;
+	int record_id;
+
+	while (((void *)pdr < end) &&
+	       (pdr_id(pdr) != PDI_END)) {
+		/*
+		 * For spectrum_cs firmwares,
+		 * PDR area is currently not terminated by PDI_END.
+		 * It's followed by CRC records, which have the type
+		 * field where PDR has length.  The type can be 0 or 1.
+		 */
+		if (pdr_len(pdr) < 2)
+			break;
+		record_id = pdr_id(pdr);
+
+		pdi = hermes_find_pdi(first_pdi, record_id);
+		if (pdi)
+			printk(KERN_DEBUG PFX "Found record 0x%04x at %p\n",
+			       record_id, pdi);
+
+		switch (record_id) {
+		case 0x110: /* Modem REFDAC values */
+		case 0x120: /* Modem VGDAC values */
+			outdoor_pdi = hermes_find_pdi(first_pdi, record_id + 1);
+			default_pdi = NULL;
+			if (outdoor_pdi) {
+				pdi = outdoor_pdi;
+				printk(KERN_DEBUG PFX
+				       "Using outdoor record 0x%04x at %p\n",
+				       record_id + 1, pdi);
+			}
+			break;
+		case 0x5: /*  HWIF Compatiblity */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0005);
+			break;
+		case 0x108: /* PPPPSign */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0108);
+			break;
+		case 0x109: /* PPPPProf */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0109);
+			break;
+		case 0x150: /* Antenna diversity */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0150);
+			break;
+		case 0x160: /* Modem VCO band Set-up */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0160);
+			break;
+		case 0x161: /* Modem Rx Gain Table Values */
+			default_pdi = (struct pdi *) &DEFAULT_PDR(0x0161);
+			break;
+		default:
+			default_pdi = NULL;
+			break;
+		}
+		if (!pdi && default_pdi) {
+			/* Use default */
+			pdi = default_pdi;
+			printk(KERN_DEBUG PFX
+			       "Using default record 0x%04x at %p\n",
+			       record_id, pdi);
+		}
+
+		if (pdi) {
+			/* Lengths of the data in PDI and PDR must match */
+			if (pdi_len(pdi) == pdr_len(pdr)) {
+				/* do the actual plugging */
+				hermes_aux_setaddr(hw, pdr_addr(pdr));
+				hermes_write_bytes(hw, HERMES_AUXDATA,
+						   pdi->data, pdi_len(pdi));
+			}
+		}
+
+		pdr++;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(hermes_apply_pda_with_defaults);
diff --git a/drivers/net/wireless/hermes_dld.h b/drivers/net/wireless/hermes_dld.h
index a39a482..c13a1c2 100644
--- a/drivers/net/wireless/hermes_dld.h
+++ b/drivers/net/wireless/hermes_dld.h
@@ -27,6 +27,8 @@
 
 #include "hermes.h"
 
+int hermesi_program_init(hermes_t *hw, u32 offset);
+int hermesi_program_end(hermes_t *hw);
 int hermes_program(hermes_t *hw, const char *first_block, const char *end);
 
 int hermes_read_pda(hermes_t *hw,
@@ -37,6 +39,9 @@ int hermes_read_pda(hermes_t *hw,
 int hermes_apply_pda(hermes_t *hw,
 		     const char *first_pdr,
 		     const __le16 *pda);
+int hermes_apply_pda_with_defaults(hermes_t *hw,
+				   const char *first_pdr,
+				   const __le16 *pda);
 
 size_t hermes_blocks_length(const char *first_block);
 
-- 
1.5.4.5

