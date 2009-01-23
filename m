Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60854 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZAWUWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 15:22:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Automatically probe for opensource firmware
Date: Fri, 23 Jan 2009 21:21:51 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901232121.52012.mb@bu3sch.de> (sfid-20090123_212250_530176_1BD51858)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First probe for proprietary firmware and then probe for opensource firmware.
This way around it's a win-win situation.
1) If proprietary fw is available, it will work.
2) If opensource firmware is available, but no proprietary (Distros can only ship open fw)
   it might work.
3) If both open and proprietary are available, it will work, because it selects
   the proprietary. We currently don't prefer the open fw in this case, because it doesn't
   work on all devices. It would introduce a regression otherwise.

The remaining FIXMEs in this patch are harmless, because they only matter on multiband
devices, which are not implemented yet anyway.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next feature round.

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-23 19:19:20.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-23 19:23:18.000000000 +0100
@@ -1931,25 +1931,25 @@ static irqreturn_t b43_interrupt_handler
 	mmiowb();
 	spin_unlock(&dev->wl->irq_lock);
 
 	return ret;
 }
 
-static void do_release_fw(struct b43_firmware_file *fw)
+void b43_do_release_fw(struct b43_firmware_file *fw)
 {
 	release_firmware(fw->data);
 	fw->data = NULL;
 	fw->filename = NULL;
 }
 
 static void b43_release_firmware(struct b43_wldev *dev)
 {
-	do_release_fw(&dev->fw.ucode);
-	do_release_fw(&dev->fw.pcm);
-	do_release_fw(&dev->fw.initvals);
-	do_release_fw(&dev->fw.initvals_band);
+	b43_do_release_fw(&dev->fw.ucode);
+	b43_do_release_fw(&dev->fw.pcm);
+	b43_do_release_fw(&dev->fw.initvals);
+	b43_do_release_fw(&dev->fw.initvals_band);
 }
 
 static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
 	const char *text;
 
@@ -1960,48 +1960,66 @@ static void b43_print_fw_helptext(struct
 	if (error)
 		b43err(wl, text);
 	else
 		b43warn(wl, text);
 }
 
-static int do_request_fw(struct b43_wldev *dev,
-			 const char *name,
-			 struct b43_firmware_file *fw,
-			 bool silent)
+int b43_do_request_fw(struct b43_request_fw_context *ctx,
+		      const char *name,
+		      struct b43_firmware_file *fw)
 {
-	char path[sizeof(modparam_fwpostfix) + 32];
 	const struct firmware *blob;
 	struct b43_fw_header *hdr;
 	u32 size;
 	int err;
 
 	if (!name) {
 		/* Don't fetch anything. Free possibly cached firmware. */
-		do_release_fw(fw);
+		/* FIXME: We should probably keep it anyway, to save some headache
+		 * on suspend/resume with multiband devices. */
+		b43_do_release_fw(fw);
 		return 0;
 	}
 	if (fw->filename) {
-		if (strcmp(fw->filename, name) == 0)
+		if ((fw->type == ctx->req_type) &&
+		    (strcmp(fw->filename, name) == 0))
 			return 0; /* Already have this fw. */
 		/* Free the cached firmware first. */
-		do_release_fw(fw);
+		/* FIXME: We should probably do this later after we successfully
+		 * got the new fw. This could reduce headache with multiband devices.
+		 * We could also redesign this to cache the firmware for all possible
+		 * bands all the time. */
+		b43_do_release_fw(fw);
+	}
+
+	switch (ctx->req_type) {
+	case B43_FWTYPE_PROPRIETARY:
+		snprintf(ctx->fwname, sizeof(ctx->fwname),
+			 "b43%s/%s.fw",
+			 modparam_fwpostfix, name);
+		break;
+	case B43_FWTYPE_OPENSOURCE:
+		snprintf(ctx->fwname, sizeof(ctx->fwname),
+			 "b43-open%s/%s.fw",
+			 modparam_fwpostfix, name);
+		break;
+	default:
+		B43_WARN_ON(1);
+		return -ENOSYS;
 	}
-
-	snprintf(path, ARRAY_SIZE(path),
-		 "b43%s/%s.fw",
-		 modparam_fwpostfix, name);
-	err = request_firmware(&blob, path, dev->dev->dev);
+	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
 	if (err == -ENOENT) {
-		if (!silent) {
-			b43err(dev->wl, "Firmware file \"%s\" not found\n",
-			       path);
-		}
+		snprintf(ctx->errors[ctx->req_type],
+			 sizeof(ctx->errors[ctx->req_type]),
+			 "Firmware file \"%s\" not found\n", ctx->fwname);
 		return err;
 	} else if (err) {
-		b43err(dev->wl, "Firmware file \"%s\" request failed (err=%d)\n",
-		       path, err);
+		snprintf(ctx->errors[ctx->req_type],
+			 sizeof(ctx->errors[ctx->req_type]),
+			 "Firmware file \"%s\" request failed (err=%d)\n",
+			 ctx->fwname, err);
 		return err;
 	}
 	if (blob->size < sizeof(struct b43_fw_header))
 		goto err_format;
 	hdr = (struct b43_fw_header *)(blob->data);
 	switch (hdr->type) {
@@ -2018,26 +2036,30 @@ static int do_request_fw(struct b43_wlde
 	default:
 		goto err_format;
 	}
 
 	fw->data = blob;
 	fw->filename = name;
+	fw->type = ctx->req_type;
 
 	return 0;
 
 err_format:
-	b43err(dev->wl, "Firmware file \"%s\" format error.\n", path);
+	snprintf(ctx->errors[ctx->req_type],
+		 sizeof(ctx->errors[ctx->req_type]),
+		 "Firmware file \"%s\" format error.\n", ctx->fwname);
 	release_firmware(blob);
 
 	return -EPROTO;
 }
 
-static int b43_request_firmware(struct b43_wldev *dev)
+static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 {
-	struct b43_firmware *fw = &dev->fw;
-	const u8 rev = dev->dev->id.revision;
+	struct b43_wldev *dev = ctx->dev;
+	struct b43_firmware *fw = &ctx->dev->fw;
+	const u8 rev = ctx->dev->dev->id.revision;
 	const char *filename;
 	u32 tmshigh;
 	int err;
 
 	/* Get microcode */
 	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
@@ -2046,25 +2068,25 @@ static int b43_request_firmware(struct b
 	else if ((rev >= 11) && (rev <= 12))
 		filename = "ucode11";
 	else if (rev >= 13)
 		filename = "ucode13";
 	else
 		goto err_no_ucode;
-	err = do_request_fw(dev, filename, &fw->ucode, 0);
+	err = b43_do_request_fw(ctx, filename, &fw->ucode);
 	if (err)
 		goto err_load;
 
 	/* Get PCM code */
 	if ((rev >= 5) && (rev <= 10))
 		filename = "pcm5";
 	else if (rev >= 11)
 		filename = NULL;
 	else
 		goto err_no_pcm;
 	fw->pcm_request_failed = 0;
-	err = do_request_fw(dev, filename, &fw->pcm, 1);
+	err = b43_do_request_fw(ctx, filename, &fw->pcm);
 	if (err == -ENOENT) {
 		/* We did not find a PCM file? Not fatal, but
 		 * core rev <= 10 must do without hwcrypto then. */
 		fw->pcm_request_failed = 1;
 	} else if (err)
 		goto err_load;
@@ -2094,13 +2116,13 @@ static int b43_request_firmware(struct b
 		else
 			goto err_no_initvals;
 		break;
 	default:
 		goto err_no_initvals;
 	}
-	err = do_request_fw(dev, filename, &fw->initvals, 0);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals);
 	if (err)
 		goto err_load;
 
 	/* Get bandswitch initvals */
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
@@ -2128,43 +2150,89 @@ static int b43_request_firmware(struct b
 		else
 			goto err_no_initvals;
 		break;
 	default:
 		goto err_no_initvals;
 	}
-	err = do_request_fw(dev, filename, &fw->initvals_band, 0);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals_band);
 	if (err)
 		goto err_load;
 
 	return 0;
 
-err_load:
-	b43_print_fw_helptext(dev->wl, 1);
-	goto error;
-
 err_no_ucode:
-	err = -ENODEV;
-	b43err(dev->wl, "No microcode available for core rev %u\n", rev);
+	err = ctx->fatal_failure = -EOPNOTSUPP;
+	b43err(dev->wl, "The driver does not know which firmware (ucode) "
+	       "is required for your device (wl-core rev %u)\n", rev);
 	goto error;
 
 err_no_pcm:
-	err = -ENODEV;
-	b43err(dev->wl, "No PCM available for core rev %u\n", rev);
+	err = ctx->fatal_failure = -EOPNOTSUPP;
+	b43err(dev->wl, "The driver does not know which firmware (PCM) "
+	       "is required for your device (wl-core rev %u)\n", rev);
 	goto error;
 
 err_no_initvals:
-	err = -ENODEV;
-	b43err(dev->wl, "No Initial Values firmware file for PHY %u, "
-	       "core rev %u\n", dev->phy.type, rev);
+	err = ctx->fatal_failure = -EOPNOTSUPP;
+	b43err(dev->wl, "The driver does not know which firmware (initvals) "
+	       "is required for your device (wl-core rev %u)\n", rev);
+	goto error;
+
+err_load:
+	/* We failed to load this firmware image. The error message
+	 * already is in ctx->errors. Return and let our caller decide
+	 * what to do. */
 	goto error;
 
 error:
 	b43_release_firmware(dev);
 	return err;
 }
 
+static int b43_request_firmware(struct b43_wldev *dev)
+{
+	struct b43_request_fw_context *ctx;
+	unsigned int i;
+	int err;
+	const char *errmsg;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->dev = dev;
+
+	ctx->req_type = B43_FWTYPE_PROPRIETARY;
+	err = b43_try_request_fw(ctx);
+	if (!err)
+		goto out; /* Successfully loaded it. */
+	err = ctx->fatal_failure;
+	if (err)
+		goto out;
+
+	ctx->req_type = B43_FWTYPE_OPENSOURCE;
+	err = b43_try_request_fw(ctx);
+	if (!err)
+		goto out; /* Successfully loaded it. */
+	err = ctx->fatal_failure;
+	if (err)
+		goto out;
+
+	/* Could not find a usable firmware. Print the errors. */
+	for (i = 0; i < B43_NR_FWTYPES; i++) {
+		errmsg = ctx->errors[i];
+		if (strlen(errmsg))
+			b43err(dev->wl, errmsg);
+	}
+	b43_print_fw_helptext(dev->wl, 1);
+	err = -ENOENT;
+
+out:
+	kfree(ctx);
+	return err;
+}
+
 static int b43_upload_microcode(struct b43_wldev *dev)
 {
 	const size_t hdr_len = sizeof(struct b43_fw_header);
 	const __be32 *data;
 	unsigned int i, len;
 	u16 fwrev, fwpatch, fwdate, fwtime;
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-12-21 20:59:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-01-23 19:33:23.000000000 +0100
@@ -652,16 +652,45 @@ struct b43_wl {
 	/* Work for adjustment of the transmission power.
 	 * This is scheduled when we determine that the actual TX output
 	 * power doesn't match what we want. */
 	struct work_struct txpower_adjust_work;
 };
 
+/* The type of the firmware file. */
+enum b43_firmware_file_type {
+	B43_FWTYPE_PROPRIETARY,
+	B43_FWTYPE_OPENSOURCE,
+	B43_NR_FWTYPES,
+};
+
+/* Context data for fetching firmware. */
+struct b43_request_fw_context {
+	/* The device we are requesting the fw for. */
+	struct b43_wldev *dev;
+	/* The type of firmware to request. */
+	enum b43_firmware_file_type req_type;
+	/* Error messages for each firmware type. */
+	char errors[B43_NR_FWTYPES][128];
+	/* Temporary buffer for storing the firmware name. */
+	char fwname[64];
+	/* A fatal error occured while requesting. Firmware reqest
+	 * can not continue, as any other reqest will also fail. */
+	int fatal_failure;
+};
+
 /* In-memory representation of a cached microcode file. */
 struct b43_firmware_file {
 	const char *filename;
 	const struct firmware *data;
+	/* Type of the firmware file name. Note that this does only indicate
+	 * the type by the firmware name. NOT the file contents.
+	 * If you want to check for proprietary vs opensource, use (struct b43_firmware)->opensource
+	 * instead! The (struct b43_firmware)->opensource flag is derived from the actual firmware
+	 * binary code, not just the filename.
+	 */
+	enum b43_firmware_file_type type;
 };
 
 /* Pointers to the firmware data and meta information about it. */
 struct b43_firmware {
 	/* Microcode */
 	struct b43_firmware_file ucode;
@@ -674,13 +703,14 @@ struct b43_firmware {
 
 	/* Firmware revision */
 	u16 rev;
 	/* Firmware patchlevel */
 	u16 patch;
 
-	/* Set to true, if we are using an opensource firmware. */
+	/* Set to true, if we are using an opensource firmware.
+	 * Use this to check for proprietary vs opensource. */
 	bool opensource;
 	/* Set to true, if the core needs a PCM firmware, but
 	 * we failed to load one. This is always false for
 	 * core rev > 10, as these don't need PCM firmware. */
 	bool pcm_request_failed;
 };
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h	2008-08-28 18:38:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.h	2009-01-23 19:19:40.000000000 +0100
@@ -118,7 +118,14 @@ void b43_controller_restart(struct b43_w
 #define B43_PS_ASLEEP	(1 << 3)	/* Force device asleep */
 void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags);
 
 void b43_mac_suspend(struct b43_wldev *dev);
 void b43_mac_enable(struct b43_wldev *dev);
 
+
+struct b43_request_fw_context;
+int b43_do_request_fw(struct b43_request_fw_context *ctx,
+		      const char *name,
+		      struct b43_firmware_file *fw);
+void b43_do_release_fw(struct b43_firmware_file *fw);
+
 #endif /* B43_MAIN_H_ */

-- 
Greetings, Michael.
