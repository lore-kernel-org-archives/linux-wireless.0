Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763384AbZE3Rhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:33 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:35 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 09/23] orinoco: use dev_err in early initialisation routines
Date: Sat, 30 May 2009 18:36:43 +0100
Message-Id: <1243705017-8784-10-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to use determine_fw_capabilities,
orinoco_hw_read_card_setting and orinoco_hw_allocate_fid prior to
netdev registration.

Since dev_dbg only prints if DEBUG is defined (or dynamic debug is
enabled), move a couple of the more useful prints up to info.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c |   92 +++++++++++++++++--------------------
 1 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 0f6426d..4a26d68 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -3,6 +3,7 @@
  * See copyright notice in main.c
  */
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/if_arp.h>
 #include <linux/ieee80211.h>
 #include <linux/wireless.h>
@@ -56,10 +57,13 @@ static inline fwtype_t determine_firmware_type(struct comp_id *nic_id)
 		return FIRMWARE_TYPE_INTERSIL;
 }
 
-/* Set priv->firmware type, determine firmware properties */
+/* Set priv->firmware type, determine firmware properties
+ * This function can be called before we have registerred with netdev,
+ * so all errors go out with dev_* rather than printk
+ */
 int determine_fw_capabilities(struct orinoco_private *priv)
 {
-	struct net_device *dev = priv->ndev;
+	struct device *dev = priv->dev;
 	hermes_t *hw = &priv->hw;
 	int err;
 	struct comp_id nic_id, sta_id;
@@ -69,8 +73,8 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	/* Get the hardware version */
 	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);
 	if (err) {
-		printk(KERN_ERR "%s: Cannot read hardware identity: error %d\n",
-		       dev->name, err);
+		dev_err(dev, "Cannot read hardware identity: error %d\n",
+			err);
 		return err;
 	}
 
@@ -78,17 +82,16 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	le16_to_cpus(&nic_id.variant);
 	le16_to_cpus(&nic_id.major);
 	le16_to_cpus(&nic_id.minor);
-	printk(KERN_DEBUG "%s: Hardware identity %04x:%04x:%04x:%04x\n",
-	       dev->name, nic_id.id, nic_id.variant,
-	       nic_id.major, nic_id.minor);
+	dev_info(dev, "Hardware identity %04x:%04x:%04x:%04x\n",
+		 nic_id.id, nic_id.variant, nic_id.major, nic_id.minor);
 
 	priv->firmware_type = determine_firmware_type(&nic_id);
 
 	/* Get the firmware version */
 	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_STAID, &sta_id);
 	if (err) {
-		printk(KERN_ERR "%s: Cannot read station identity: error %d\n",
-		       dev->name, err);
+		dev_err(dev, "Cannot read station identity: error %d\n",
+			err);
 		return err;
 	}
 
@@ -96,25 +99,21 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	le16_to_cpus(&sta_id.variant);
 	le16_to_cpus(&sta_id.major);
 	le16_to_cpus(&sta_id.minor);
-	printk(KERN_DEBUG "%s: Station identity  %04x:%04x:%04x:%04x\n",
-	       dev->name, sta_id.id, sta_id.variant,
-	       sta_id.major, sta_id.minor);
+	dev_info(dev, "Station identity  %04x:%04x:%04x:%04x\n",
+		 sta_id.id, sta_id.variant, sta_id.major, sta_id.minor);
 
 	switch (sta_id.id) {
 	case 0x15:
-		printk(KERN_ERR "%s: Primary firmware is active\n",
-		       dev->name);
+		dev_err(dev, "Primary firmware is active\n");
 		return -ENODEV;
 	case 0x14b:
-		printk(KERN_ERR "%s: Tertiary firmware is active\n",
-		       dev->name);
+		dev_err(dev, "Tertiary firmware is active\n");
 		return -ENODEV;
 	case 0x1f:	/* Intersil, Agere, Symbol Spectrum24 */
 	case 0x21:	/* Symbol Spectrum24 Trilogy */
 		break;
 	default:
-		printk(KERN_NOTICE "%s: Unknown station ID, please report\n",
-		       dev->name);
+		dev_notice(dev, "Unknown station ID, please report\n");
 		break;
 	}
 
@@ -168,10 +167,8 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 				      HERMES_RID_SECONDARYVERSION_SYMBOL,
 				      SYMBOL_MAX_VER_LEN, NULL, &tmp);
 		if (err) {
-			printk(KERN_WARNING
-			       "%s: Error %d reading Symbol firmware info. "
-			       "Wildly guessing capabilities...\n",
-			       dev->name, err);
+			dev_warn(dev, "Error %d reading Symbol firmware info. "
+				 "Wildly guessing capabilities...\n", err);
 			firmver = 0;
 			tmp[0] = '\0';
 		} else {
@@ -242,24 +239,24 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 		if (firmver >= 0x000800)
 			priv->ibss_port = 0;
 		else {
-			printk(KERN_NOTICE "%s: Intersil firmware earlier "
-			       "than v0.8.x - several features not supported\n",
-			       dev->name);
+			dev_notice(dev, "Intersil firmware earlier than v0.8.x"
+				   " - several features not supported\n");
 			priv->ibss_port = 1;
 		}
 		break;
 	}
-	printk(KERN_DEBUG "%s: Firmware determined as %s\n", dev->name,
-	       priv->fw_name);
+	dev_info(dev, "Firmware determined as %s\n", priv->fw_name);
 
 	return 0;
 }
 
 /* Read settings from EEPROM into our private structure.
- * MAC address gets dropped into callers buffer */
+ * MAC address gets dropped into callers buffer
+ * Can be called before netdev registration.
+ */
 int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 {
-	struct net_device *dev = priv->ndev;
+	struct device *dev = priv->dev;
 	struct hermes_idstring nickbuf;
 	hermes_t *hw = &priv->hw;
 	int len;
@@ -270,20 +267,17 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
 			      ETH_ALEN, NULL, dev_addr);
 	if (err) {
-		printk(KERN_WARNING "%s: failed to read MAC address!\n",
-		       dev->name);
+		dev_warn(dev, "Failed to read MAC address!\n");
 		goto out;
 	}
 
-	printk(KERN_DEBUG "%s: MAC address %pM\n",
-	       dev->name, dev_addr);
+	dev_dbg(dev, "MAC address %pM\n", dev_addr);
 
 	/* Get the station name */
 	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
 			      sizeof(nickbuf), &reclen, &nickbuf);
 	if (err) {
-		printk(KERN_ERR "%s: failed to read station name\n",
-		       dev->name);
+		dev_err(dev, "failed to read station name\n");
 		goto out;
 	}
 	if (nickbuf.len)
@@ -293,14 +287,13 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 	memcpy(priv->nick, &nickbuf.val, len);
 	priv->nick[len] = '\0';
 
-	printk(KERN_DEBUG "%s: Station name \"%s\"\n", dev->name, priv->nick);
+	dev_dbg(dev, "Station name \"%s\"\n", priv->nick);
 
 	/* Get allowed channels */
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CHANNELLIST,
 				  &priv->channel_mask);
 	if (err) {
-		printk(KERN_ERR "%s: failed to read channel list!\n",
-		       dev->name);
+		dev_err(dev, "Failed to read channel list!\n");
 		goto out;
 	}
 
@@ -314,8 +307,7 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
 				  &priv->rts_thresh);
 	if (err) {
-		printk(KERN_ERR "%s: failed to read RTS threshold!\n",
-		       dev->name);
+		dev_err(dev, "Failed to read RTS threshold!\n");
 		goto out;
 	}
 
@@ -329,8 +321,7 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
 					  &priv->frag_thresh);
 	if (err) {
-		printk(KERN_ERR "%s: failed to read fragmentation settings!\n",
-		       dev->name);
+		dev_err(dev, "Failed to read fragmentation settings!\n");
 		goto out;
 	}
 
@@ -342,16 +333,16 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 					  HERMES_RID_CNFMAXSLEEPDURATION,
 					  &priv->pm_period);
 		if (err) {
-			printk(KERN_ERR "%s: failed to read power management "
-			       "period!\n", dev->name);
+			dev_err(dev, "Failed to read power management "
+				"period!\n");
 			goto out;
 		}
 		err = hermes_read_wordrec(hw, USER_BAP,
 					  HERMES_RID_CNFPMHOLDOVERDURATION,
 					  &priv->pm_timeout);
 		if (err) {
-			printk(KERN_ERR "%s: failed to read power management "
-			       "timeout!\n", dev->name);
+			dev_err(dev, "Failed to read power management "
+				"timeout!\n");
 			goto out;
 		}
 	}
@@ -367,9 +358,10 @@ out:
 	return err;
 }
 
+/* Can be called before netdev registration */
 int orinoco_hw_allocate_fid(struct orinoco_private *priv)
 {
-	struct net_device *dev = priv->ndev;
+	struct device *dev = priv->dev;
 	struct hermes *hw = &priv->hw;
 	int err;
 
@@ -379,9 +371,9 @@ int orinoco_hw_allocate_fid(struct orinoco_private *priv)
 		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
 		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
 
-		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
-		       "(old Symbol firmware?). Work around %s\n",
-		       dev->name, err ? "failed!" : "ok.");
+		dev_warn(dev, "Firmware ALLOC bug detected "
+			 "(old Symbol firmware?). Work around %s\n",
+			 err ? "failed!" : "ok.");
 	}
 
 	return err;
-- 
1.6.0.6

