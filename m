Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:51272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYKVKhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 05:37:42 -0500
Received: by nf-out-0910.google.com with SMTP id d3so650327nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 02:37:40 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/4] orinoco: Separate fw caching from download
Date: Sat, 22 Nov 2008 10:37:25 +0000
Message-Id: <1227350248-8917-2-git-send-email-kilroyd@googlemail.com> (sfid-20081122_113744_837328_D457831D)
In-Reply-To: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com>
References: <1227350248-8917-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactorring will make it easier to share logic with Symbol
firmware.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |   53 +++++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 5459b69..4cefb80 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -431,9 +431,9 @@ struct fw_info {
 };
 
 const static struct fw_info orinoco_fw[] = {
-	{ "", "agere_sta_fw.bin", "agere_ap_fw.bin", 0x00390000, 1000 },
-	{ "", "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
-	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", "", 0x00003100, 512 }
+	{ NULL, "agere_sta_fw.bin", "agere_ap_fw.bin", 0x00390000, 1000 },
+	{ NULL, "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
+	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", NULL, 0x00003100, 512 }
 };
 
 /* Structure used to access fields in FW
@@ -487,18 +487,17 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
 
-	if (priv->cached_fw)
-		fw_entry = priv->cached_fw;
-	else {
+	if (!priv->cached_fw) {
 		err = request_firmware(&fw_entry, firmware, priv->dev);
+
 		if (err) {
 			printk(KERN_ERR "%s: Cannot find firmware %s\n",
 			       dev->name, firmware);
 			err = -ENOENT;
 			goto free;
 		}
-		priv->cached_fw = fw_entry;
-	}
+	} else
+		fw_entry = priv->cached_fw;
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
@@ -540,11 +539,9 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, hermes_present(hw));
 
 abort:
-	/* In case of error, assume firmware was bogus and release it */
-	if (err) {
-		priv->cached_fw = NULL;
+	/* If we requested the firmware, release it. */
+	if (!priv->cached_fw)
 		release_firmware(fw_entry);
-	}
 
 free:
 	kfree(pda);
@@ -708,6 +705,30 @@ static int orinoco_download(struct orinoco_private *priv)
 	return err;
 }
 
+static void orinoco_cache_fw(struct orinoco_private *priv, int ap)
+{
+	const struct firmware *fw_entry = NULL;
+	const char *fw;
+
+	if (ap)
+		fw = orinoco_fw[priv->firmware_type].ap_fw;
+	else
+		fw = orinoco_fw[priv->firmware_type].sta_fw;
+
+	if (fw) {
+		if (request_firmware(&fw_entry, fw, priv->dev) == 0)
+			priv->cached_fw = fw_entry;
+	}
+}
+
+static void orinoco_uncache_fw(struct orinoco_private *priv)
+{
+	if (priv->cached_fw)
+		release_firmware(priv->cached_fw);
+
+	priv->cached_fw = NULL;
+}
+
 /********************************************************************/
 /* Device methods                                                   */
 /********************************************************************/
@@ -3308,6 +3329,8 @@ static int orinoco_init(struct net_device *dev)
 	}
 
 	if (priv->do_fw_download) {
+		orinoco_cache_fw(priv, 0);
+
 		err = orinoco_download(priv);
 		if (err)
 			priv->do_fw_download = 0;
@@ -3557,9 +3580,9 @@ void free_orinocodev(struct net_device *dev)
 	 * when we call tasklet_kill it will run one final time,
 	 * emptying the list */
 	tasklet_kill(&priv->rx_tasklet);
-	if (priv->cached_fw)
-		release_firmware(priv->cached_fw);
-	priv->cached_fw = NULL;
+
+	orinoco_uncache_fw(priv);
+
 	priv->wpa_ie_len = 0;
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
-- 
1.5.6.4

