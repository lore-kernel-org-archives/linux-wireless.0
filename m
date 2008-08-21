Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:15324 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494AbYHUW24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:56 -0400
Received: by ik-out-1112.google.com with SMTP id c28so104766ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:55 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 09/19] orinoco: Invoke firmware download in main driver
Date: Thu, 21 Aug 2008 23:27:55 +0100
Message-Id: <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com> (sfid-20080822_005042_762097_62AAB34B)
In-Reply-To: <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware download is enabled for Agere in orinoco_cs. Symbol firmware
download has been moved out of spectrum_cs into orinoco_cs. Firmware
download is not enabled for Intersil.

Symbol based firmware is restricted to only download on spectrum_cs
based cards.

The firmware names are hardcoded for each firmware type.

Signed-off by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/Kconfig          |    2 +-
 drivers/net/wireless/airport.c        |    3 +-
 drivers/net/wireless/orinoco.c        |  314 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/orinoco.h        |    9 +-
 drivers/net/wireless/orinoco_cs.c     |    3 +-
 drivers/net/wireless/orinoco_nortel.c |    3 +-
 drivers/net/wireless/orinoco_pci.c    |    3 +-
 drivers/net/wireless/orinoco_plx.c    |    3 +-
 drivers/net/wireless/orinoco_tmd.c    |    3 +-
 drivers/net/wireless/spectrum_cs.c    |  159 ++---------------
 10 files changed, 346 insertions(+), 156 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 2405c54..cf51ea7 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -335,6 +335,7 @@ config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
 	depends on (PPC_PMAC || PCI || PCMCIA) && WLAN_80211
 	select WIRELESS_EXT
+	select FW_LOADER
 	---help---
 	  A driver for 802.11b wireless cards based on the "Hermes" or
 	  Intersil HFA384x (Prism 2) MAC controller.  This includes the vast
@@ -424,7 +425,6 @@ config PCMCIA_HERMES
 config PCMCIA_SPECTRUM
 	tristate "Symbol Spectrum24 Trilogy PCMCIA card support"
 	depends on PCMCIA && HERMES
-	select FW_LOADER
 	---help---
 
 	  This is a driver for 802.11b cards using RAM-loadable Symbol
diff --git a/drivers/net/wireless/airport.c b/drivers/net/wireless/airport.c
index 6f7eb9f..ce03a2e 100644
--- a/drivers/net/wireless/airport.c
+++ b/drivers/net/wireless/airport.c
@@ -180,7 +180,8 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	/* Allocate space for private device-specific data */
-	dev = alloc_orinocodev(sizeof(*card), airport_hard_reset);
+	dev = alloc_orinocodev(sizeof(*card), &mdev->ofdev.dev,
+			       airport_hard_reset, NULL);
 	if (! dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		return -ENODEV;
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 00b1d59..306697a 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -82,12 +82,14 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/firmware.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
 
 #include "hermes_rid.h"
+#include "hermes_dld.h"
 #include "orinoco.h"
 
 /********************************************************************/
@@ -301,6 +303,272 @@ static void orinoco_bss_data_init(struct orinoco_private *priv)
 		list_add_tail(&priv->bss_data[i].list, &priv->bss_free_list);
 }
 
+
+/********************************************************************/
+/* Download functionality                                           */
+/********************************************************************/
+
+struct fw_info {
+	char *pri_fw;
+	char *sta_fw;
+	char *ap_fw;
+	u32 pda_addr;
+	u16 pda_size;
+};
+
+const static struct fw_info orinoco_fw[] = {
+	{ "", "agere_sta_fw.bin", "agere_ap_fw.bin", 0x00390000, 1000 },
+	{ "", "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
+	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", "", 0x00003100, 0x100 }
+};
+
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
+
+/* Download either STA or AP firmware into the card. */
+static int
+orinoco_dl_firmware(struct orinoco_private *priv,
+		    const struct fw_info *fw,
+		    int ap)
+{
+	/* Plug Data Area (PDA) */
+	__le16 pda[512] = { 0 };
+
+	hermes_t *hw = &priv->hw;
+	const struct firmware *fw_entry;
+	const struct orinoco_fw_header *hdr;
+	const unsigned char *first_block;
+	const unsigned char *end;
+	const char *firmware;
+	struct net_device *dev = priv->ndev;
+	int err;
+
+	if (ap)
+		firmware = fw->ap_fw;
+	else
+		firmware = fw->sta_fw;
+
+	printk(KERN_DEBUG "%s: Attempting to download firmware %s\n",
+	       dev->name, firmware);
+
+	/* Read current plug data */
+	err = hermes_read_pda(hw, pda, fw->pda_addr,
+			      min_t(u16, fw->pda_size, sizeof(pda)), 0);
+	printk(KERN_DEBUG "%s: Read PDA returned %d\n", dev->name, err);
+	if (err)
+		return err;
+
+	err = request_firmware(&fw_entry, firmware, priv->dev);
+	if (err) {
+		printk(KERN_ERR "%s: Cannot find firmware %s\n",
+		       dev->name, firmware);
+		return -ENOENT;
+	}
+
+	hdr = (const struct orinoco_fw_header *) fw_entry->data;
+
+	/* Enable aux port to allow programming */
+	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
+	printk(KERN_DEBUG "%s: Program init returned %d\n", dev->name, err);
+	if (err != 0)
+		goto abort;
+
+	/* Program data */
+	first_block = (fw_entry->data +
+		       le16_to_cpu(hdr->headersize) +
+		       le32_to_cpu(hdr->block_offset));
+	end = fw_entry->data + fw_entry->size;
+
+	err = hermes_program(hw, first_block, end);
+	printk(KERN_DEBUG "%s: Program returned %d\n", dev->name, err);
+	if (err != 0)
+		goto abort;
+
+	/* Update production data */
+	first_block = (fw_entry->data +
+		       le16_to_cpu(hdr->headersize) +
+		       le32_to_cpu(hdr->pdr_offset));
+
+	err = hermes_apply_pda_with_defaults(hw, first_block, pda);
+	printk(KERN_DEBUG "%s: Apply PDA returned %d\n", dev->name, err);
+	if (err)
+		goto abort;
+
+	/* Tell card we've finished */
+	err = hermesi_program_end(hw);
+	printk(KERN_DEBUG "%s: Program end returned %d\n", dev->name, err);
+	if (err != 0)
+		goto abort;
+
+	/* Check if we're running */
+	printk(KERN_DEBUG "%s: hermes_present returned %d\n",
+	       dev->name, hermes_present(hw));
+
+abort:
+	release_firmware(fw_entry);
+	return err;
+}
+
+/* End markers */
+#define TEXT_END	0x1A		/* End of text header */
+
+/*
+ * Process a firmware image - stop the card, load the firmware, reset
+ * the card and make sure it responds.  For the secondary firmware take
+ * care of the PDA - read it and then write it on top of the firmware.
+ */
+static int
+symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
+		const unsigned char *image, const unsigned char *end,
+		int secondary)
+{
+	hermes_t *hw = &priv->hw;
+	int ret;
+	const unsigned char *ptr;
+	const unsigned char *first_block;
+
+	/* Plug Data Area (PDA) */
+	__le16 pda[256];
+
+	/* Binary block begins after the 0x1A marker */
+	ptr = image;
+	while (*ptr++ != TEXT_END);
+	first_block = ptr;
+
+	/* Read the PDA from EEPROM */
+	if (secondary) {
+		ret = hermes_read_pda(hw, pda, fw->pda_addr, sizeof(pda), 1);
+		if (ret)
+			return ret;
+	}
+
+	/* Stop the firmware, so that it can be safely rewritten */
+	if (priv->stop_fw) {
+		ret = priv->stop_fw(priv, 1);
+		if (ret)
+			return ret;
+	}
+
+	/* Program the adapter with new firmware */
+	ret = hermes_program(hw, first_block, end);
+	if (ret)
+		return ret;
+
+	/* Write the PDA to the adapter */
+	if (secondary) {
+		size_t len = hermes_blocks_length(first_block);
+		ptr = first_block + len;
+		ret = hermes_apply_pda(hw, ptr, pda);
+		if (ret)
+			return ret;
+	}
+
+	/* Run the firmware */
+	if (priv->stop_fw) {
+		ret = priv->stop_fw(priv, 0);
+		if (ret)
+			return ret;
+	}
+
+	/* Reset hermes chip and make sure it responds */
+	ret = hermes_init(hw);
+
+	/* hermes_reset() should return 0 with the secondary firmware */
+	if (secondary && ret != 0)
+		return -ENODEV;
+
+	/* And this should work with any firmware */
+	if (!hermes_present(hw))
+		return -ENODEV;
+
+	return 0;
+}
+
+
+/*
+ * Download the firmware into the card, this also does a PCMCIA soft
+ * reset on the card, to make sure it's in a sane state.
+ */
+static int
+symbol_dl_firmware(struct orinoco_private *priv,
+		   const struct fw_info *fw)
+{
+	struct net_device *dev = priv->ndev;
+	int ret;
+	const struct firmware *fw_entry;
+
+	if (request_firmware(&fw_entry, fw->pri_fw,
+			     priv->dev) != 0) {
+		printk(KERN_ERR "%s: Cannot find firmware: %s\n",
+		       dev->name, fw->pri_fw);
+		return -ENOENT;
+	}
+
+	/* Load primary firmware */
+	ret = symbol_dl_image(priv, fw, fw_entry->data,
+			      fw_entry->data + fw_entry->size, 0);
+	release_firmware(fw_entry);
+	if (ret) {
+		printk(KERN_ERR "%s: Primary firmware download failed\n",
+		       dev->name);
+		return ret;
+	}
+
+	if (request_firmware(&fw_entry, fw->sta_fw,
+			     priv->dev) != 0) {
+		printk(KERN_ERR "%s: Cannot find firmware: %s\n",
+		       dev->name, fw->sta_fw);
+		return -ENOENT;
+	}
+
+	/* Load secondary firmware */
+	ret = symbol_dl_image(priv, fw, fw_entry->data,
+			      fw_entry->data + fw_entry->size, 1);
+	release_firmware(fw_entry);
+	if (ret) {
+		printk(KERN_ERR "%s: Secondary firmware download failed\n",
+		       dev->name);
+	}
+
+	return ret;
+}
+
+static int orinoco_download(struct orinoco_private *priv)
+{
+	int err = 0;
+	/* Reload firmware */
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		/* case FIRMWARE_TYPE_INTERSIL: */
+		err = orinoco_dl_firmware(priv,
+					  &orinoco_fw[priv->firmware_type], 0);
+		break;
+
+	case FIRMWARE_TYPE_SYMBOL:
+		err = symbol_dl_firmware(priv,
+					 &orinoco_fw[priv->firmware_type]);
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+		break;
+	}
+	/* TODO: if we fail we probably need to reinitialise
+	 * the driver */
+
+	return err;
+}
+
 /********************************************************************/
 /* Device methods                                                   */
 /********************************************************************/
@@ -2043,6 +2311,12 @@ static void orinoco_reset(struct work_struct *work)
 		}
 	}
 
+	if (priv->do_fw_download) {
+		err = orinoco_download(priv);
+		if (err)
+			priv->do_fw_download = 0;
+	}
+
 	err = orinoco_reinit_firmware(dev);
 	if (err) {
 		printk(KERN_ERR "%s: orinoco_reset: Error %d re-initializing firmware\n",
@@ -2254,6 +2528,7 @@ static int determine_firmware(struct net_device *dev)
 	priv->has_ibss = 1;
 	priv->has_wep = 0;
 	priv->has_big_wep = 0;
+	priv->do_fw_download = 0;
 
 	/* Determine capabilities from the firmware version */
 	switch (priv->firmware_type) {
@@ -2273,6 +2548,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->has_pm = (firmver >= 0x40020); /* Don't work in 7.52 ? */
 		priv->ibss_port = 1;
 		priv->has_hostscan = (firmver >= 0x8000a);
+		priv->do_fw_download = 1;
 		priv->broken_monitor = (firmver >= 0x80000);
 
 		/* Tested with Agere firmware :
@@ -2317,6 +2593,21 @@ static int determine_firmware(struct net_device *dev)
 			       firmver >= 0x31000;
 		priv->has_preamble = (firmver >= 0x20000);
 		priv->ibss_port = 4;
+
+		/* Symbol firmware is found on various cards, but
+		 * there has been no attempt to check firmware
+		 * download on non-spectrum_cs based cards.
+		 *
+		 * Given that the Agere firmware download works
+		 * differently, we should avoid doing a firmware
+		 * download with the Symbol algorithm on non-spectrum
+		 * cards.
+		 *
+		 * For now we can identify a spectrum_cs based card
+		 * because it has a firmware reset function.
+		 */
+		priv->do_fw_download = (priv->stop_fw != NULL);
+
  		priv->broken_disableport = (firmver == 0x25013) ||
  					   (firmver >= 0x30000 && firmver <= 0x31000);
 		priv->has_hostscan = (firmver >= 0x31001) ||
@@ -2387,6 +2678,20 @@ static int orinoco_init(struct net_device *dev)
 		goto out;
 	}
 
+	if (priv->do_fw_download) {
+		err = orinoco_download(priv);
+		if (err)
+			priv->do_fw_download = 0;
+
+		/* Check firmware version again */
+		err = determine_firmware(dev);
+		if (err != 0) {
+			printk(KERN_ERR "%s: Incompatible firmware, aborting\n",
+			       dev->name);
+			goto out;
+		}
+	}
+
 	if (priv->has_port3)
 		printk(KERN_DEBUG "%s: Ad-hoc demo mode supported\n", dev->name);
 	if (priv->has_ibss)
@@ -2529,8 +2834,11 @@ static int orinoco_init(struct net_device *dev)
 	return err;
 }
 
-struct net_device *alloc_orinocodev(int sizeof_card,
-				    int (*hard_reset)(struct orinoco_private *))
+struct net_device
+*alloc_orinocodev(int sizeof_card,
+		  struct device *device,
+		  int (*hard_reset)(struct orinoco_private *),
+		  int (*stop_fw)(struct orinoco_private *, int))
 {
 	struct net_device *dev;
 	struct orinoco_private *priv;
@@ -2545,6 +2853,7 @@ struct net_device *alloc_orinocodev(int sizeof_card,
 				      + sizeof(struct orinoco_private));
 	else
 		priv->card = NULL;
+	priv->dev = device;
 
 	if (orinoco_bss_data_allocate(priv))
 		goto err_out_free;
@@ -2570,6 +2879,7 @@ struct net_device *alloc_orinocodev(int sizeof_card,
 	dev->open = orinoco_open;
 	dev->stop = orinoco_stop;
 	priv->hard_reset = hard_reset;
+	priv->stop_fw = stop_fw;
 
 	spin_lock_init(&priv->lock);
 	priv->open = 0;
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index c6b1858..e0acb63 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -44,7 +44,9 @@ typedef struct {
 
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
+	struct device *dev;
 	int (*hard_reset)(struct orinoco_private *);
+	int (*stop_fw)(struct orinoco_private *, int);
 
 	/* Synchronisation stuff */
 	spinlock_t lock;
@@ -83,6 +85,7 @@ struct orinoco_private {
 	unsigned int has_preamble:1;
 	unsigned int has_sensitivity:1;
 	unsigned int has_hostscan:1;
+	unsigned int do_fw_download:1;
 	unsigned int broken_disableport:1;
 	unsigned int broken_monitor:1;
 
@@ -130,8 +133,10 @@ extern int orinoco_debug;
 /* Exported prototypes                                              */
 /********************************************************************/
 
-extern struct net_device *alloc_orinocodev(int sizeof_card,
-					   int (*hard_reset)(struct orinoco_private *));
+extern struct net_device *alloc_orinocodev(
+	int sizeof_card, struct device *device,
+	int (*hard_reset)(struct orinoco_private *),
+	int (*stop_fw)(struct orinoco_private *, int));
 extern void free_orinocodev(struct net_device *dev);
 extern int __orinoco_up(struct net_device *dev);
 extern int __orinoco_down(struct net_device *dev);
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index 1c216e0..1ccf5a4 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -109,7 +109,8 @@ orinoco_cs_probe(struct pcmcia_device *link)
 	struct orinoco_private *priv;
 	struct orinoco_pccard *card;
 
-	dev = alloc_orinocodev(sizeof(*card), orinoco_cs_hard_reset);
+	dev = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
+			       orinoco_cs_hard_reset, NULL);
 	if (! dev)
 		return -ENOMEM;
 	priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/orinoco_nortel.c b/drivers/net/wireless/orinoco_nortel.c
index 35ec5fc..2fc8659 100644
--- a/drivers/net/wireless/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco_nortel.c
@@ -182,7 +182,8 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), orinoco_nortel_cor_reset);
+	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
+			       orinoco_nortel_cor_reset, NULL);
 	if (!dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
diff --git a/drivers/net/wireless/orinoco_pci.c b/drivers/net/wireless/orinoco_pci.c
index 2547d5d..4ebd638 100644
--- a/drivers/net/wireless/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco_pci.c
@@ -139,7 +139,8 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), orinoco_pci_cor_reset);
+	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
+			       orinoco_pci_cor_reset, NULL);
 	if (!dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
diff --git a/drivers/net/wireless/orinoco_plx.c b/drivers/net/wireless/orinoco_plx.c
index 98fe165..ef76185 100644
--- a/drivers/net/wireless/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco_plx.c
@@ -221,7 +221,8 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), orinoco_plx_cor_reset);
+	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
+			       orinoco_plx_cor_reset, NULL);
 	if (!dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
diff --git a/drivers/net/wireless/orinoco_tmd.c b/drivers/net/wireless/orinoco_tmd.c
index df49318..ede24ec 100644
--- a/drivers/net/wireless/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco_tmd.c
@@ -124,7 +124,8 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate network device */
-	dev = alloc_orinocodev(sizeof(*card), orinoco_tmd_cor_reset);
+	dev = alloc_orinocodev(sizeof(*card), &pdev->dev,
+			       orinoco_tmd_cor_reset, NULL);
 	if (!dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		err = -ENOMEM;
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 2fb0018..e368759 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/firmware.h>
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
@@ -33,10 +32,6 @@
 #include <pcmcia/ds.h>
 
 #include "orinoco.h"
-#include "hermes_dld.h"
-
-static const char primary_fw_name[] = "symbol_sp24t_prim_fw";
-static const char secondary_fw_name[] = "symbol_sp24t_sec_fw";
 
 /********************************************************************/
 /* Module stuff							    */
@@ -72,26 +67,11 @@ struct orinoco_pccard {
 static int spectrum_cs_config(struct pcmcia_device *link);
 static void spectrum_cs_release(struct pcmcia_device *link);
 
-/********************************************************************/
-/* Firmware downloader						    */
-/********************************************************************/
-
-/* Position of PDA in the adapter memory */
-#define EEPROM_ADDR	0x3000
-#define EEPROM_LEN	0x200
-#define PDA_OFFSET	0x100
-
-#define PDA_ADDR	(EEPROM_ADDR + PDA_OFFSET)
-#define PDA_WORDS	((EEPROM_LEN - PDA_OFFSET) / 2)
-
 /* Constants for the CISREG_CCSR register */
 #define HCR_RUN		0x07	/* run firmware after reset */
 #define HCR_IDLE	0x0E	/* don't run firmware after reset */
 #define HCR_MEM16	0x10	/* memory width bit, should be preserved */
 
-/* End markers */
-#define TEXT_END	0x1A		/* End of text header */
-
 
 #define CS_CHECK(fn, ret) \
   do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
@@ -158,142 +138,29 @@ spectrum_reset(struct pcmcia_device *link, int idle)
 	return -ENODEV;
 }
 
+/********************************************************************/
+/* Device methods     						    */
+/********************************************************************/
 
-/*
- * Process a firmware image - stop the card, load the firmware, reset
- * the card and make sure it responds.  For the secondary firmware take
- * care of the PDA - read it and then write it on top of the firmware.
- */
 static int
-spectrum_dl_image(hermes_t *hw, struct pcmcia_device *link,
-		  const unsigned char *image, const unsigned char *end,
-		  int secondary)
+spectrum_cs_hard_reset(struct orinoco_private *priv)
 {
-	int ret;
-	const unsigned char *ptr;
-	const unsigned char *first_block;
-
-	/* Plug Data Area (PDA) */
-	__le16 pda[PDA_WORDS];
-
-	/* Binary block begins after the 0x1A marker */
-	ptr = image;
-	while (*ptr++ != TEXT_END);
-	first_block = ptr;
-
-	/* Read the PDA from EEPROM */
-	if (secondary) {
-		ret = hermes_read_pda(hw, pda, PDA_ADDR, sizeof(pda), 1);
-		if (ret)
-			return ret;
-	}
-
-	/* Stop the firmware, so that it can be safely rewritten */
-	ret = spectrum_reset(link, 1);
-	if (ret)
-		return ret;
-
-	/* Program the adapter with new firmware */
-	ret = hermes_program(hw, first_block, end);
-	if (ret)
-		return ret;
-
-	/* Write the PDA to the adapter */
-	if (secondary) {
-		size_t len = hermes_blocks_length(first_block);
-		ptr = first_block + len;
-		ret = hermes_apply_pda(hw, ptr, pda);
-		if (ret)
-			return ret;
-	}
-
-	/* Run the firmware */
-	ret = spectrum_reset(link, 0);
-	if (ret)
-		return ret;
-
-	/* Reset hermes chip and make sure it responds */
-	ret = hermes_init(hw);
-
-	/* hermes_reset() should return 0 with the secondary firmware */
-	if (secondary && ret != 0)
-		return -ENODEV;
+	struct orinoco_pccard *card = priv->card;
+	struct pcmcia_device *link = card->p_dev;
 
-	/* And this should work with any firmware */
-	if (!hermes_present(hw))
-		return -ENODEV;
+	/* Soft reset using COR and HCR */
+	spectrum_reset(link, 0);
 
 	return 0;
 }
 
-
-/*
- * Download the firmware into the card, this also does a PCMCIA soft
- * reset on the card, to make sure it's in a sane state.
- */
 static int
-spectrum_dl_firmware(hermes_t *hw, struct pcmcia_device *link)
-{
-	int ret;
-	const struct firmware *fw_entry;
-
-	if (request_firmware(&fw_entry, primary_fw_name,
-			     &handle_to_dev(link)) != 0) {
-		printk(KERN_ERR PFX "Cannot find firmware: %s\n",
-		       primary_fw_name);
-		return -ENOENT;
-	}
-
-	/* Load primary firmware */
-	ret = spectrum_dl_image(hw, link, fw_entry->data,
-				fw_entry->data + fw_entry->size, 0);
-	release_firmware(fw_entry);
-	if (ret) {
-		printk(KERN_ERR PFX "Primary firmware download failed\n");
-		return ret;
-	}
-
-	if (request_firmware(&fw_entry, secondary_fw_name,
-			     &handle_to_dev(link)) != 0) {
-		printk(KERN_ERR PFX "Cannot find firmware: %s\n",
-		       secondary_fw_name);
-		return -ENOENT;
-	}
-
-	/* Load secondary firmware */
-	ret = spectrum_dl_image(hw, link, fw_entry->data,
-				fw_entry->data + fw_entry->size, 1);
-	release_firmware(fw_entry);
-	if (ret) {
-		printk(KERN_ERR PFX "Secondary firmware download failed\n");
-	}
-
-	return ret;
-}
-
-/********************************************************************/
-/* Device methods     						    */
-/********************************************************************/
-
-static int
-spectrum_cs_hard_reset(struct orinoco_private *priv)
+spectrum_cs_stop_firmware(struct orinoco_private *priv, int idle)
 {
 	struct orinoco_pccard *card = priv->card;
 	struct pcmcia_device *link = card->p_dev;
-	int err;
 
-	if (!hermes_present(&priv->hw)) {
-		/* The firmware needs to be reloaded */
-		if (spectrum_dl_firmware(&priv->hw, link) != 0) {
-			printk(KERN_ERR PFX "Firmware download failed\n");
-			err = -ENODEV;
-		}
-	} else {
-		/* Soft reset using COR and HCR */
-		spectrum_reset(link, 0);
-	}
-
-	return 0;
+	return spectrum_reset(link, idle);
 }
 
 /********************************************************************/
@@ -315,7 +182,9 @@ spectrum_cs_probe(struct pcmcia_device *link)
 	struct orinoco_private *priv;
 	struct orinoco_pccard *card;
 
-	dev = alloc_orinocodev(sizeof(*card), spectrum_cs_hard_reset);
+	dev = alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
+			       spectrum_cs_hard_reset,
+			       spectrum_cs_stop_firmware);
 	if (! dev)
 		return -ENOMEM;
 	priv = netdev_priv(dev);
@@ -517,7 +386,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 	dev->irq = link->irq.AssignedIRQ;
 	card->node.major = card->node.minor = 0;
 
-	/* Reset card and download firmware */
+	/* Reset card */
 	if (spectrum_cs_hard_reset(priv) != 0) {
 		goto failed;
 	}
-- 
1.5.6.4

