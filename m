Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:19697 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYJaBPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 21:15:53 -0400
Received: by ey-out-2122.google.com with SMTP id 6so363356eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 18:15:52 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, linux-pm@lists.linux-foundation.org,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC PATCH 1/2] orinoco: Use PM notifier to cache firmware for use during resume
Date: Fri, 31 Oct 2008 01:15:42 +0000
Message-Id: <1225415743-28209-2-git-send-email-kilroyd@googlemail.com> (sfid-20081031_021556_214203_5C846756)
In-Reply-To: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com>
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When preparing for either suspend or hibernation, load the necessary
firmware from userspace.

Upon error or resume, release the firmware.

Works for both Agere and Symbol firmware.

Signed-off by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |  140 +++++++++++++++++++++++++++++++---------
 drivers/net/wireless/orinoco.h |    8 ++-
 2 files changed, 115 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 653306f..190fcec 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -84,6 +84,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/firmware.h>
+#include <linux/suspend.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
@@ -431,9 +432,9 @@ struct fw_info {
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
@@ -487,18 +488,17 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	if (err)
 		goto free;
 
-	if (priv->cached_fw)
-		fw_entry = priv->cached_fw;
-	else {
+	if (!priv->cached_sta_fw) {
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
+		fw_entry = priv->cached_sta_fw;
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
@@ -540,11 +540,10 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, hermes_present(hw));
 
 abort:
-	/* In case of error, assume firmware was bogus and release it */
-	if (err) {
-		priv->cached_fw = NULL;
+	/* If we requested the firmware, release it. Otherwise leave
+	 * it to the PM notifier */
+	if (!priv->cached_sta_fw)
 		release_firmware(fw_entry);
-	}
 
 free:
 	kfree(pda);
@@ -621,7 +620,7 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 	ret = hermes_init(hw);
 
 	/* hermes_reset() should return 0 with the secondary firmware */
-	if (secondary && ret != 0)
+	if (secondary && (ret != 0))
 		return -ENODEV;
 
 	/* And this should work with any firmware */
@@ -648,34 +647,41 @@ symbol_dl_firmware(struct orinoco_private *priv,
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
+	if (!priv->cached_sta_fw) {
+		if (request_firmware(&fw_entry, fw->sta_fw, priv->dev) != 0) {
+			printk(KERN_ERR "%s: Cannot find firmware: %s\n",
+			       dev->name, fw->sta_fw);
+			return -ENOENT;
+		}
+	} else
+		fw_entry = priv->cached_sta_fw;
 
 	/* Load secondary firmware */
 	ret = symbol_dl_image(priv, fw, fw_entry->data,
 			      fw_entry->data + fw_entry->size, 1);
-	release_firmware(fw_entry);
+	if (!priv->cached_sta_fw)
+		release_firmware(fw_entry);
 	if (ret) {
 		printk(KERN_ERR "%s: Secondary firmware download failed\n",
 		       dev->name);
@@ -3064,6 +3070,68 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 }
 
 /********************************************************************/
+/* Power management                                                 */
+/********************************************************************/
+
+static int orinoco_pm_notifier(struct notifier_block *notifier,
+			       unsigned long pm_event,
+			       void *unused)
+{
+	struct orinoco_private *priv = container_of(notifier,
+						    struct orinoco_private,
+						    pm_notifier);
+
+	/* All we need to do is cache the firmware before suspend, and
+	 * release it when we come out */
+
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+	{
+		const struct firmware *fw_entry = NULL;
+		const char *pri_fw;
+		const char *sta_fw;
+
+		pri_fw = orinoco_fw[priv->firmware_type].pri_fw;
+		sta_fw = orinoco_fw[priv->firmware_type].sta_fw;
+
+		if (pri_fw) {
+			if (request_firmware(&fw_entry, pri_fw, priv->dev) == 0)
+				priv->cached_pri_fw = fw_entry;
+		}
+
+		if (sta_fw) {
+			if (request_firmware(&fw_entry, sta_fw, priv->dev) == 0)
+				priv->cached_sta_fw = fw_entry;
+		}
+
+		break;
+	}
+	case PM_POST_RESTORE:
+		/* Restore from hibernation failed. We need to clean
+		 * up in exactly the same way, so fall through. */
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		if (priv->cached_pri_fw)
+			release_firmware(priv->cached_pri_fw);
+
+		if (priv->cached_sta_fw)
+			release_firmware(priv->cached_sta_fw);
+
+		priv->cached_pri_fw = NULL;
+		priv->cached_sta_fw = NULL;
+
+		break;
+
+	case PM_RESTORE_PREPARE:
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/********************************************************************/
 /* Initialization                                                   */
 /********************************************************************/
 
@@ -3543,7 +3611,12 @@ struct net_device
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
-	priv->cached_fw = NULL;
+	priv->cached_pri_fw = NULL;
+	priv->cached_sta_fw = NULL;
+
+	/* Register PM notifiers */
+	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
 
 	return dev;
 }
@@ -3556,9 +3629,14 @@ void free_orinocodev(struct net_device *dev)
 	 * when we call tasklet_kill it will run one final time,
 	 * emptying the list */
 	tasklet_kill(&priv->rx_tasklet);
-	if (priv->cached_fw)
-		release_firmware(priv->cached_fw);
-	priv->cached_fw = NULL;
+	unregister_pm_notifier(&priv->pm_notifier);
+
+	if (priv->cached_pri_fw)
+		release_firmware(priv->cached_pri_fw);
+	if (priv->cached_sta_fw)
+		release_firmware(priv->cached_sta_fw);
+	priv->cached_pri_fw = NULL;
+	priv->cached_sta_fw = NULL;
 	priv->wpa_ie_len = 0;
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 8c29538..5a9685a 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -10,6 +10,7 @@
 #define DRIVER_VERSION "0.15"
 
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
@@ -167,8 +168,11 @@ struct orinoco_private {
 	unsigned int tkip_cm_active:1;
 	unsigned int key_mgmt:3;
 
-	/* Cached in memory firmware to use in ->resume */
-	const struct firmware *cached_fw;
+	/* Cached in memory firmware to use during ->resume. */
+	const struct firmware *cached_pri_fw;
+	const struct firmware *cached_sta_fw;
+
+	struct notifier_block pm_notifier;
 };
 
 #ifdef ORINOCO_DEBUG
-- 
1.5.6.4

