Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:51272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYKVKhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 05:37:46 -0500
Received: by nf-out-0910.google.com with SMTP id d3so650327nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 02:37:45 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/4] orinoco: Cache Symbol firmware
Date: Sat, 22 Nov 2008 10:37:26 +0000
Message-Id: <1227350248-8917-3-git-send-email-kilroyd@googlemail.com> (sfid-20081122_113748_754253_E0642B9F)
In-Reply-To: <1227350248-8917-2-git-send-email-kilroyd@googlemail.com>
References: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com>
 <1227350248-8917-2-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |   46 ++++++++++++++++++++++---------
 drivers/net/wireless/orinoco/orinoco.h |    3 +-
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 4cefb80..4c8f4c2 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -645,34 +645,41 @@ symbol_dl_firmware(struct orinoco_private *priv,
 	int ret;
 	const struct firmware *fw_entry;
 
-	if (request_firmware(&fw_entry, fw->pri_fw,
-			     priv->dev) != 0) {
-		printk(KERN_ERR "%s: Cannot find firmware: %s\n",
-		       dev->name, fw->pri_fw);
-		return -ENOENT;
-	}
+	if (!priv->cached_pri_fw) {
+		if (request_firmware(&fw_entry, fw->pri_fw, priv->dev) != 0) {
+			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
+			       dev->name, fw->pri_fw);
+			return -ENOENT;
+		}
+	} else
+		fw_entry = priv->cached_pri_fw;
 
 	/* Load primary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 0);
-	release_firmware(fw_entry);
+
+	if (!priv->cached_pri_fw)
+		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Primary firmware download failed\n",
 		       dev->name);
 		return ret;
 	}
 
-	if (request_firmware(&fw_entry, fw->sta_fw,
-			     priv->dev) != 0) {
-		printk(KERN_ERR "%s: Cannot find firmware: %s\n",
-		       dev->name, fw->sta_fw);
-		return -ENOENT;
-	}
+	if (!priv->cached_fw) {
+		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) != 0) {
+			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
+			       dev->name, fw->sta_fw);
+			return -ENOENT;
+		}
+	} else
+		fw_entry = priv->cached_fw;
 
 	/* Load secondary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 1);
-	release_firmware(fw_entry);
+	if (!priv->cached_fw)
+		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Secondary firmware download failed\n",
 		       dev->name);
@@ -708,13 +715,20 @@ static int orinoco_download(struct orinoco_private *priv)
 static void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 {
 	const struct firmware *fw_entry = NULL;
+	const char *pri_fw;
 	const char *fw;
 
+	pri_fw = orinoco_fw[priv->firmware_type].pri_fw;
 	if (ap)
 		fw = orinoco_fw[priv->firmware_type].ap_fw;
 	else
 		fw = orinoco_fw[priv->firmware_type].sta_fw;
 
+	if (pri_fw) {
+		if (request_firmware(&fw_entry, pri_fw, priv->dev) == 0)
+			priv->cached_pri_fw = fw_entry;
+	}
+
 	if (fw) {
 		if (request_firmware(&fw_entry, fw, priv->dev) == 0)
 			priv->cached_fw = fw_entry;
@@ -723,9 +737,12 @@ static void orinoco_cache_fw(struct orinoco_private *priv, int ap)
 
 static void orinoco_uncache_fw(struct orinoco_private *priv)
 {
+	if (priv->cached_pri_fw)
+		release_firmware(priv->cached_pri_fw);
 	if (priv->cached_fw)
 		release_firmware(priv->cached_fw);
 
+	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
 }
 
@@ -3567,6 +3584,7 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
+	priv->cached_pri_fw = NULL;
 	priv->cached_fw = NULL;
 
 	return dev;
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 8c29538..f6eaea9 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -167,7 +167,8 @@ struct orinoco_private {
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
 
-	/* Cached in memory firmware to use in ->resume */
+	/* Cached in memory firmware to use during ->resume. */
+	const struct firmware *cached_pri_fw;
 	const struct firmware *cached_fw;
 };
 
-- 
1.5.6.4

