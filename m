Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763389AbZE3Rhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:36 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:38 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 10/23] orinoco: firmware helpers should use dev_err and friends
Date: Sat, 30 May 2009 18:36:44 +0100
Message-Id: <1243705017-8784-11-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should be able to call these routines before we register with
netdev, so avoid printks using the netdev name.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/fw.c |   41 +++++++++++++++---------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 1084b43..1257250 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -4,6 +4,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/firmware.h>
+#include <linux/device.h>
 
 #include "hermes.h"
 #include "hermes_dld.h"
@@ -99,7 +100,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	const void *end;
 	const char *firmware;
 	const char *fw_err;
-	struct net_device *dev = priv->ndev;
+	struct device *dev = priv->dev;
 	int err = 0;
 
 	pda = kzalloc(fw->pda_size, GFP_KERNEL);
@@ -111,12 +112,11 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	else
 		firmware = fw->sta_fw;
 
-	printk(KERN_DEBUG "%s: Attempting to download firmware %s\n",
-	       dev->name, firmware);
+	dev_dbg(dev, "Attempting to download firmware %s\n", firmware);
 
 	/* Read current plug data */
 	err = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 0);
-	printk(KERN_DEBUG "%s: Read PDA returned %d\n", dev->name, err);
+	dev_dbg(dev, "Read PDA returned %d\n", err);
 	if (err)
 		goto free;
 
@@ -124,8 +124,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		err = request_firmware(&fw_entry, firmware, priv->dev);
 
 		if (err) {
-			printk(KERN_ERR "%s: Cannot find firmware %s\n",
-			       dev->name, firmware);
+			dev_err(dev, "Cannot find firmware %s\n", firmware);
 			err = -ENOENT;
 			goto free;
 		}
@@ -136,16 +135,15 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 	fw_err = validate_fw(hdr, fw_entry->size);
 	if (fw_err) {
-		printk(KERN_WARNING "%s: Invalid firmware image detected (%s). "
-		       "Aborting download\n",
-		       dev->name, fw_err);
+		dev_warn(dev, "Invalid firmware image detected (%s). "
+			 "Aborting download\n", fw_err);
 		err = -EINVAL;
 		goto abort;
 	}
 
 	/* Enable aux port to allow programming */
 	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
-	printk(KERN_DEBUG "%s: Program init returned %d\n", dev->name, err);
+	dev_dbg(dev, "Program init returned %d\n", err);
 	if (err != 0)
 		goto abort;
 
@@ -156,7 +154,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	end = fw_entry->data + fw_entry->size;
 
 	err = hermes_program(hw, first_block, end);
-	printk(KERN_DEBUG "%s: Program returned %d\n", dev->name, err);
+	dev_dbg(dev, "Program returned %d\n", err);
 	if (err != 0)
 		goto abort;
 
@@ -167,19 +165,18 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 	err = hermes_apply_pda_with_defaults(hw, first_block, end, pda,
 					     &pda[fw->pda_size / sizeof(*pda)]);
-	printk(KERN_DEBUG "%s: Apply PDA returned %d\n", dev->name, err);
+	dev_dbg(dev, "Apply PDA returned %d\n", err);
 	if (err)
 		goto abort;
 
 	/* Tell card we've finished */
 	err = hermesi_program_end(hw);
-	printk(KERN_DEBUG "%s: Program end returned %d\n", dev->name, err);
+	dev_dbg(dev, "Program end returned %d\n", err);
 	if (err != 0)
 		goto abort;
 
 	/* Check if we're running */
-	printk(KERN_DEBUG "%s: hermes_present returned %d\n",
-	       dev->name, hermes_present(hw));
+	dev_dbg(dev, "hermes_present returned %d\n", hermes_present(hw));
 
 abort:
 	/* If we requested the firmware, release it. */
@@ -282,14 +279,13 @@ static int
 symbol_dl_firmware(struct orinoco_private *priv,
 		   const struct fw_info *fw)
 {
-	struct net_device *dev = priv->ndev;
+	struct device *dev = priv->dev;
 	int ret;
 	const struct firmware *fw_entry;
 
 	if (!orinoco_cached_fw_get(priv, true)) {
 		if (request_firmware(&fw_entry, fw->pri_fw, priv->dev) != 0) {
-			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
-			       dev->name, fw->pri_fw);
+			dev_err(dev, "Cannot find firmware: %s\n", fw->pri_fw);
 			return -ENOENT;
 		}
 	} else
@@ -302,15 +298,13 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	if (!orinoco_cached_fw_get(priv, true))
 		release_firmware(fw_entry);
 	if (ret) {
-		printk(KERN_ERR "%s: Primary firmware download failed\n",
-		       dev->name);
+		dev_err(dev, "Primary firmware download failed\n");
 		return ret;
 	}
 
 	if (!orinoco_cached_fw_get(priv, false)) {
 		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) != 0) {
-			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
-			       dev->name, fw->sta_fw);
+			dev_err(dev, "Cannot find firmware: %s\n", fw->sta_fw);
 			return -ENOENT;
 		}
 	} else
@@ -322,8 +316,7 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
 	if (ret) {
-		printk(KERN_ERR "%s: Secondary firmware download failed\n",
-		       dev->name);
+		dev_err(dev, "Secondary firmware download failed\n");
 	}
 
 	return ret;
-- 
1.6.0.6

