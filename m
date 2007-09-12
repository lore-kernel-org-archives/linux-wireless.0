Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:53170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764481AbXILVFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 17:05:02 -0400
Received: by ug-out-1314.google.com with SMTP id z38so303649ugc
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 14:05:02 -0700 (PDT)
Message-ID: <46E855AA.5090702@gmail.com>
Date: Wed, 12 Sep 2007 22:10:02 +0100
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net,
	orinoco-users@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, proski@gnu.org,
	hermes@gibson.dropbear.id.au
Subject: [PATCH 05/05] orinoco: Agere/Lucent firmware download
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable firmware download for orinoco_cs

Add module parameters download_firmware and firmware. The first option
specifies whether or not to attempt a download. The second the name of
the firmware file to use.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index d1e5022..db3cc95 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -17,12 +17,14 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/firmware.h>
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
+#include "hermes_dld.h"
 #include "orinoco.h"
 
 /********************************************************************/
@@ -41,6 +43,17 @@ static int ignore_cis_vcc; /* = 0 */
 module_param(ignore_cis_vcc, int, 0);
 MODULE_PARM_DESC(ignore_cis_vcc, "Allow voltage mismatch between card and socket");
 
+static char *firmware = "orinoco.fw";
+module_param(firmware, charp, 0644);
+MODULE_PARM_DESC(firmware, "Name of firmware file to load");
+
+static int download_firmware; /* = 0 */
+module_param(download_firmware, int, 0644);
+MODULE_PARM_DESC(download_firmware, "Attempt firmware download");
+
+#define PDA_ADDR 0x00390000
+#define PDA_SIZE 1000
+
 /********************************************************************/
 /* Data structures						    */
 /********************************************************************/
@@ -57,6 +70,20 @@ struct orinoco_pccard {
 	unsigned long hard_reset_in_progress; 
 };
 
+/* Structure used to access fields in FW
+ * Make sure LE decoding macros are used
+ */
+struct orinoco_fw_header {
+	char hdr_vers[6];       /* ASCII string for header version */
+	__le16 headersize;      /* Total length of header */
+	__le32 entry_point;     /* NIC entry point */
+	__le32 blocks;          /* Number of blocks to program */
+	__le32 block_offset;    /* Offset of block data from eof header */
+	__le32 pdr_offset;      /* Offset to PDR data from eof header */
+	__le32 pri_offset;      /* Offset to primary plug data */
+	__le32 compat_offset;   /* Offset to compatibility data*/
+	char signature[0];      /* FW signature length headersize-20 */
+} __attribute__ ((packed));
 
 /********************************************************************/
 /* Function prototypes						    */
@@ -70,6 +97,94 @@ static void orinoco_cs_detach(struct pcmcia_device *p_dev);
 /* Device methods     						    */
 /********************************************************************/
 
+/*
+ * Download the firmware into the card, this also does a PCMCIA soft
+ * reset on the card, to make sure it's in a sane state.
+ */
+static int
+orinoco_cs_dl_firmware(hermes_t *hw,
+		       struct pcmcia_device *link)
+{
+	/* Plug Data Area (PDA) */
+	__le16 pda[PDA_SIZE/sizeof(__le16)] = { 0 };
+
+	const struct firmware *fw_entry;
+	const struct orinoco_fw_header *hdr;
+	const unsigned char *first_block;
+	unsigned long len;
+	int err;
+
+#if 0
+	int i;
+	for (i = 0; i < 6; i++) {
+		/* wl_lkm driver disables these if configured as an AP */
+		err = hermes_disable_port(hw, i);
+		if (err)
+			printk(KERN_ERR PFX
+			       "WARNING: can't disable port %d. %d\n",
+			       i, err);
+	}
+#endif
+	printk(KERN_DEBUG PFX "Attempting to download firmware %s\n",
+	       firmware);
+
+	/* Read current plug data */
+	err = hermes_read_pda(hw, pda, PDA_ADDR, sizeof(pda), 0);
+	printk(KERN_DEBUG PFX "Read PDA returned %d\n", err);
+	if (err)
+		return err;
+
+	err = request_firmware(&fw_entry, firmware, &handle_to_dev(link));
+	if (err) {
+		printk(KERN_ERR PFX "Cannot find firmware %s\n",
+		       firmware);
+		return -ENOENT;
+	}
+
+	hdr = (const struct orinoco_fw_header *) fw_entry->data;
+	len = fw_entry->size;
+
+	/* Enable aux port to allow programming */
+	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
+	printk(KERN_DEBUG PFX "Program init returned %d\n", err);
+	if (err != 0)
+		goto abort;
+
+	/* Program data */
+	first_block = (fw_entry->data +
+		       le16_to_cpu(hdr->headersize) +
+		       le32_to_cpu(hdr->block_offset));
+
+	err = hermes_program(hw, first_block);
+	printk(KERN_DEBUG PFX "Program returned %d\n", err);
+	if (err != 0)
+		goto abort;
+
+	/* Update production data */
+	first_block = (fw_entry->data +
+		       le16_to_cpu(hdr->headersize) +
+		       le32_to_cpu(hdr->pdr_offset));
+
+	err = hermes_apply_pda_with_defaults(hw, first_block, pda);
+	printk(KERN_DEBUG PFX "Apply PDA returned %d\n", err);
+	if (err)
+		goto abort;
+
+	/* Tell card we've finished */
+	err = hermesi_program_end(hw);
+	printk(KERN_DEBUG PFX "Program end returned %d\n", err);
+	if (err != 0)
+		goto abort;
+
+	/* Check if we're running */
+	printk(KERN_DEBUG PFX "hermes_present returned %d\n",
+	       hermes_present(hw));
+
+abort:
+	release_firmware(fw_entry);
+	return err;
+}
+
 static int
 orinoco_cs_hard_reset(struct orinoco_private *priv)
 {
@@ -85,6 +200,13 @@ orinoco_cs_hard_reset(struct orinoco_private *priv)
 		return err;
 
 	msleep(100);
+
+	/* Download firmware if necessary */
+	if (download_firmware) {
+		err = orinoco_cs_dl_firmware(&priv->hw, link);
+		if (err)
+			return err;
+	}
 	clear_bit(0, &card->hard_reset_in_progress);
 
 	return 0;
@@ -316,6 +438,12 @@ orinoco_cs_config(struct pcmcia_device *link)
 	SET_MODULE_OWNER(dev);
 	card->node.major = card->node.minor = 0;
 
+	/* Download firmware if necessary */
+	if (download_firmware) {
+		if (orinoco_cs_dl_firmware(&priv->hw, link) != 0)
+			goto failed;
+	}
+
 	SET_NETDEV_DEV(dev, &handle_to_dev(link));
 	/* Tell the stack we exist */
 	if (register_netdev(dev) != 0) {
