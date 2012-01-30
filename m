Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2A3EvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 23:51:25 -0500
Date: Sun, 29 Jan 2012 22:51:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] b43legacy: Convert to asychronous firmware loading
Message-ID: <4f2621c9.y1UfR8jn+ZfKThef%Larry.Finger@lwfinger.net> (sfid-20120130_055149_863926_31CA8692)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes in udev are causing problems for drivers that load firmware
from the probe routine. As b43legacy is one of them, it is changed to
using asynchronous firmware loading.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/atomic.h>
 #include <linux/io.h>
+#include <linux/completion.h>
 
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_driver_chipcommon.h>
@@ -599,6 +600,9 @@ struct b43legacy_wl {
 	/* Stats about the wireless interface */
 	struct ieee80211_low_level_stats ieee_stats;
 
+	/* Completion queue */
+	struct completion b43legacy_fw_ready;
+
 #ifdef CONFIG_B43LEGACY_HWRNG
 	struct hwrng rng;
 	u8 rng_initialized;
@@ -633,6 +637,11 @@ struct b43legacy_wl {
 
 };
 
+struct b43legacy_fw_context {
+	struct b43legacy_wldev *dev;
+	const struct firmware *fw;
+};
+
 /* Pointers to the firmware data and meta information about it. */
 struct b43legacy_firmware {
 	/* Microcode */
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -1511,50 +1511,88 @@ static void b43legacy_print_fw_helptext(
 		     "and download the correct firmware (version 3).\n");
 }
 
-static int do_request_fw(struct b43legacy_wldev *dev,
-			 const char *name,
-			 const struct firmware **fw)
+static void b43legacy_fw_cb(const struct firmware *firmware, void *context)
 {
-	char path[sizeof(modparam_fwpostfix) + 32];
+	struct b43legacy_fw_context *fw_context = context;
+	struct b43legacy_wldev *dev = fw_context->dev;
+	const struct firmware *fw = fw_context->fw;
 	struct b43legacy_fw_header *hdr;
 	u32 size;
-	int err;
 
-	if (!name)
-		return 0;
-
-	snprintf(path, ARRAY_SIZE(path),
-		 "b43legacy%s/%s.fw",
-		 modparam_fwpostfix, name);
-	err = request_firmware(fw, path, dev->dev->dev);
-	if (err) {
-		b43legacyerr(dev->wl, "Firmware file \"%s\" not found "
-		       "or load failed.\n", path);
-		return err;
-	}
-	if ((*fw)->size < sizeof(struct b43legacy_fw_header))
-		goto err_format;
-	hdr = (struct b43legacy_fw_header *)((*fw)->data);
+	if (!firmware)
+		goto err_out;
+	if (firmware->size < sizeof(struct b43legacy_fw_header))
+		goto err_out;
+	hdr = (struct b43legacy_fw_header *)firmware->data;
 	switch (hdr->type) {
 	case B43legacy_FW_TYPE_UCODE:
 	case B43legacy_FW_TYPE_PCM:
 		size = be32_to_cpu(hdr->size);
-		if (size != (*fw)->size - sizeof(struct b43legacy_fw_header))
-			goto err_format;
+		if (size != firmware->size - sizeof(struct b43legacy_fw_header))
+			goto err_out;
 		/* fallthrough */
 	case B43legacy_FW_TYPE_IV:
 		if (hdr->ver != 1)
-			goto err_format;
+			goto err_out;
 		break;
 	default:
-		goto err_format;
+		goto err_out;
 	}
+	/* copy pointer to firmware */
+	fw = firmware;
 
-	return err;
+	kfree(fw_context);
 
-err_format:
-	b43legacyerr(dev->wl, "Firmware file \"%s\" format error.\n", path);
-	return -EPROTO;
+	/* check to see if all fw parts read */
+	if (!dev->fw.ucode || !dev->fw.pcm ||
+	    !dev->fw.initvals || !dev->fw.initvals_band)
+		return;
+
+	complete(&dev->wl->b43legacy_fw_ready);
+
+	/* We reach here only when all firmware files have been loaded
+	 * and copied. First detect if initvals_band is not needed,
+	 * and fix the dummy pointer.
+	 * It is now safe to start mac80211.  */
+	if (dev->fw.initvals_band == (struct firmware *)dev)
+		dev->fw.initvals_band = NULL;
+	if (ieee80211_register_hw(dev->wl->hw))
+		b43legacyerr(dev->wl, "Unable to start mac80211\n");
+	return;
+
+err_out:
+	b43legacyerr(dev->wl, "Firmware not found, or has wrong format.\n");
+	complete(&dev->wl->b43legacy_fw_ready);
+	kfree(fw_context);
+	return;
+}
+
+static int do_request_fw(struct b43legacy_wldev *dev,
+			 const char *name,
+			 const struct firmware *fw)
+{
+	struct b43legacy_fw_context *fw_context;
+	char path[sizeof(modparam_fwpostfix) + 32];
+	int err;
+
+	if (!name)
+		return 0;
+
+	fw_context = kmalloc(sizeof(struct b43legacy_fw_context), GFP_KERNEL);
+	if (!fw_context)
+		return -ENOMEM;
+	fw_context->dev = dev;
+	fw_context->fw = fw;
+
+	snprintf(path, ARRAY_SIZE(path),
+		 "b43legacy%s/%s.fw",
+		 modparam_fwpostfix, name);
+	b43legacyinfo(dev->wl, "Loading firmware file %s\n", path);
+	err = request_firmware_nowait(THIS_MODULE, 1, path, dev->dev->dev,
+				      GFP_KERNEL, fw_context, b43legacy_fw_cb);
+	if (err)
+		b43legacyerr(dev->wl, "Asynchronous firmware loading failed\n");
+	return err;
 }
 
 static int b43legacy_request_firmware(struct b43legacy_wldev *dev)
@@ -1573,16 +1611,7 @@ static int b43legacy_request_firmware(st
 			filename = "ucode4";
 		else
 			filename = "ucode5";
-		err = do_request_fw(dev, filename, &fw->ucode);
-		if (err)
-			goto err_load;
-	}
-	if (!fw->pcm) {
-		if (rev < 5)
-			filename = "pcm4";
-		else
-			filename = "pcm5";
-		err = do_request_fw(dev, filename, &fw->pcm);
+		err = do_request_fw(dev, filename, fw->ucode);
 		if (err)
 			goto err_load;
 	}
@@ -1600,7 +1629,7 @@ static int b43legacy_request_firmware(st
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals);
+		err = do_request_fw(dev, filename, fw->initvals);
 		if (err)
 			goto err_load;
 	}
@@ -1620,7 +1649,22 @@ static int b43legacy_request_firmware(st
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals_band);
+		/* not all devices need initvals_band -
+		 * supply a dummy value for now */
+		if (!filename) {
+			fw->initvals_band = (struct firmware *)dev;
+			return 0;
+		}
+		err = do_request_fw(dev, filename, fw->initvals_band);
+		if (err)
+			goto err_load;
+	}
+	if (!fw->pcm) {
+		if (rev < 5)
+			filename = "pcm4";
+		else
+			filename = "pcm5";
+		err = do_request_fw(dev, filename, fw->pcm);
 		if (err)
 			goto err_load;
 	}
@@ -2153,9 +2197,6 @@ static int b43legacy_chip_init(struct b4
 	macctl |= B43legacy_MACCTL_INFRA;
 	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 
-	err = b43legacy_request_firmware(dev);
-	if (err)
-		goto out;
 	err = b43legacy_upload_microcode(dev);
 	if (err)
 		goto out; /* firmware is released later */
@@ -3756,6 +3797,10 @@ static int b43legacy_one_core_attach(str
 	wl->nr_devs++;
 	ssb_set_drvdata(dev, wldev);
 	b43legacy_debugfs_add_device(wldev);
+
+	err = b43legacy_request_firmware(wldev);
+	if (err)
+		goto out;
 out:
 	return err;
 
@@ -3856,21 +3901,15 @@ static int b43legacy_probe(struct ssb_de
 		wl = ssb_get_devtypedata(dev);
 		B43legacy_WARN_ON(!wl);
 	}
+	init_completion(&wl->b43legacy_fw_ready);
 	err = b43legacy_one_core_attach(dev, wl);
 	if (err)
 		goto err_wireless_exit;
 
-	if (first) {
-		err = ieee80211_register_hw(wl->hw);
-		if (err)
-			goto err_one_core_detach;
-	}
 
 out:
 	return err;
 
-err_one_core_detach:
-	b43legacy_one_core_detach(dev);
 err_wireless_exit:
 	if (first)
 		b43legacy_wireless_exit(dev, wl);
@@ -3886,6 +3925,9 @@ static void b43legacy_remove(struct ssb_
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
 
+	/* make certain firmware load callbacks are complete */
+	wait_for_completion(&wl->b43legacy_fw_ready);
+
 	B43legacy_WARN_ON(!wl);
 	if (wl->current_dev == wldev)
 		ieee80211_unregister_hw(wl->hw);
