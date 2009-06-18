Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZFRWWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:02 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:04 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 07/23] orinoco: Move card reading code into hw.c
Date: Thu, 18 Jun 2009 23:21:19 +0100
Message-Id: <1245363695-8289-8-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is part of refactorring the initialisation code so that we can
load the firmware before registerring with netdev.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |  112 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    1 +
 drivers/net/wireless/orinoco/main.c |  102 +-------------------------------
 3 files changed, 115 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 209c6be..40dc25c 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -252,6 +252,118 @@ int determine_fw_capabilities(struct orinoco_private *priv)
 	return 0;
 }
 
+/* Read settings from EEPROM into our private structure.
+ * MAC address gets dropped into callers buffer */
+int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
+{
+	struct net_device *dev = priv->ndev;
+	struct hermes_idstring nickbuf;
+	hermes_t *hw = &priv->hw;
+	int len;
+	int err;
+	u16 reclen;
+
+	/* Get the MAC address */
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
+			      ETH_ALEN, NULL, dev_addr);
+	if (err) {
+		printk(KERN_WARNING "%s: failed to read MAC address!\n",
+		       dev->name);
+		goto out;
+	}
+
+	printk(KERN_DEBUG "%s: MAC address %pM\n",
+	       dev->name, dev_addr);
+
+	/* Get the station name */
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
+			      sizeof(nickbuf), &reclen, &nickbuf);
+	if (err) {
+		printk(KERN_ERR "%s: failed to read station name\n",
+		       dev->name);
+		goto out;
+	}
+	if (nickbuf.len)
+		len = min(IW_ESSID_MAX_SIZE, (int)le16_to_cpu(nickbuf.len));
+	else
+		len = min(IW_ESSID_MAX_SIZE, 2 * reclen);
+	memcpy(priv->nick, &nickbuf.val, len);
+	priv->nick[len] = '\0';
+
+	printk(KERN_DEBUG "%s: Station name \"%s\"\n", dev->name, priv->nick);
+
+	/* Get allowed channels */
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CHANNELLIST,
+				  &priv->channel_mask);
+	if (err) {
+		printk(KERN_ERR "%s: failed to read channel list!\n",
+		       dev->name);
+		goto out;
+	}
+
+	/* Get initial AP density */
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFSYSTEMSCALE,
+				  &priv->ap_density);
+	if (err || priv->ap_density < 1 || priv->ap_density > 3)
+		priv->has_sensitivity = 0;
+
+	/* Get initial RTS threshold */
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
+				  &priv->rts_thresh);
+	if (err) {
+		printk(KERN_ERR "%s: failed to read RTS threshold!\n",
+		       dev->name);
+		goto out;
+	}
+
+	/* Get initial fragmentation settings */
+	if (priv->has_mwo)
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFMWOROBUST_AGERE,
+					  &priv->mwo_robust);
+	else
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
+					  &priv->frag_thresh);
+	if (err) {
+		printk(KERN_ERR "%s: failed to read fragmentation settings!\n",
+		       dev->name);
+		goto out;
+	}
+
+	/* Power management setup */
+	if (priv->has_pm) {
+		priv->pm_on = 0;
+		priv->pm_mcast = 1;
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFMAXSLEEPDURATION,
+					  &priv->pm_period);
+		if (err) {
+			printk(KERN_ERR "%s: failed to read power management "
+			       "period!\n", dev->name);
+			goto out;
+		}
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFPMHOLDOVERDURATION,
+					  &priv->pm_timeout);
+		if (err) {
+			printk(KERN_ERR "%s: failed to read power management "
+			       "timeout!\n", dev->name);
+			goto out;
+		}
+	}
+
+	/* Preamble setup */
+	if (priv->has_preamble) {
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFPREAMBLE_SYMBOL,
+					  &priv->preamble);
+	}
+
+out:
+	return err;
+}
+
 int orinoco_get_bitratemode(int bitrate, int automatic)
 {
 	int ratemode = -1;
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index f7845b8..6186e44 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -24,6 +24,7 @@ struct orinoco_private;
 struct dev_addr_list;
 
 int determine_fw_capabilities(struct orinoco_private *priv);
+int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr);
 int orinoco_get_bitratemode(int bitrate, int automatic);
 void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic);
 
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 33326d6..0fe9420 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2100,9 +2100,6 @@ static int orinoco_init(struct net_device *dev)
 	struct orinoco_private *priv = netdev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err = 0;
-	struct hermes_idstring nickbuf;
-	u16 reclen;
-	int len;
 
 	/* No need to lock, the hw_unavailable flag is already set in
 	 * alloc_orinocodev() */
@@ -2166,34 +2163,9 @@ static int orinoco_init(struct net_device *dev)
 		goto out;
 	orinoco_bss_data_init(priv);
 
-	/* Get the MAC address */
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
-			      ETH_ALEN, NULL, dev->dev_addr);
-	if (err) {
-		printk(KERN_WARNING "%s: failed to read MAC address!\n",
-		       dev->name);
-		goto out;
-	}
-
-	printk(KERN_DEBUG "%s: MAC address %pM\n",
-	       dev->name, dev->dev_addr);
-
-	/* Get the station name */
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
-			      sizeof(nickbuf), &reclen, &nickbuf);
-	if (err) {
-		printk(KERN_ERR "%s: failed to read station name\n",
-		       dev->name);
+	err = orinoco_hw_read_card_settings(priv, dev->dev_addr);
+	if (err)
 		goto out;
-	}
-	if (nickbuf.len)
-		len = min(IW_ESSID_MAX_SIZE, (int)le16_to_cpu(nickbuf.len));
-	else
-		len = min(IW_ESSID_MAX_SIZE, 2 * reclen);
-	memcpy(priv->nick, &nickbuf.val, len);
-	priv->nick[len] = '\0';
-
-	printk(KERN_DEBUG "%s: Station name \"%s\"\n", dev->name, priv->nick);
 
 	err = orinoco_allocate_fid(dev);
 	if (err) {
@@ -2202,76 +2174,6 @@ static int orinoco_init(struct net_device *dev)
 		goto out;
 	}
 
-	/* Get allowed channels */
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CHANNELLIST,
-				  &priv->channel_mask);
-	if (err) {
-		printk(KERN_ERR "%s: failed to read channel list!\n",
-		       dev->name);
-		goto out;
-	}
-
-	/* Get initial AP density */
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFSYSTEMSCALE,
-				  &priv->ap_density);
-	if (err || priv->ap_density < 1 || priv->ap_density > 3)
-		priv->has_sensitivity = 0;
-
-	/* Get initial RTS threshold */
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
-				  &priv->rts_thresh);
-	if (err) {
-		printk(KERN_ERR "%s: failed to read RTS threshold!\n",
-		       dev->name);
-		goto out;
-	}
-
-	/* Get initial fragmentation settings */
-	if (priv->has_mwo)
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFMWOROBUST_AGERE,
-					  &priv->mwo_robust);
-	else
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
-					  &priv->frag_thresh);
-	if (err) {
-		printk(KERN_ERR "%s: failed to read fragmentation settings!\n",
-		       dev->name);
-		goto out;
-	}
-
-	/* Power management setup */
-	if (priv->has_pm) {
-		priv->pm_on = 0;
-		priv->pm_mcast = 1;
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFMAXSLEEPDURATION,
-					  &priv->pm_period);
-		if (err) {
-			printk(KERN_ERR "%s: failed to read power management period!\n",
-			       dev->name);
-			goto out;
-		}
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFPMHOLDOVERDURATION,
-					  &priv->pm_timeout);
-		if (err) {
-			printk(KERN_ERR "%s: failed to read power management timeout!\n",
-			       dev->name);
-			goto out;
-		}
-	}
-
-	/* Preamble setup */
-	if (priv->has_preamble) {
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CNFPREAMBLE_SYMBOL,
-					  &priv->preamble);
-		if (err)
-			goto out;
-	}
-
 	/* Set up the default configuration */
 	priv->iw_mode = IW_MODE_INFRA;
 	/* By default use IEEE/IBSS ad-hoc mode if we have it */
-- 
1.6.0.6

