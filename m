Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58721 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYEQVrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 17:47:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Allow running without PCM firmware
Date: Sat, 17 May 2008 23:43:57 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200805172343.57558.mb@bu3sch.de> (sfid-20080517_234713_885953_304D0E9C)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds code to allow running the device without PCM firmware loaded.
Without PCM firmware we don't have hardware accelerated crypto on
devices with a core rev <= 10.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-05-17 20:22:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-05-17 23:09:09.000000000 +0200
@@ -772,12 +772,16 @@ struct b43_firmware {
 	u16 rev;
 	/* Firmware patchlevel */
 	u16 patch;
 
 	/* Set to true, if we are using an opensource firmware. */
 	bool opensource;
+	/* Set to true, if the core needs a PCM firmware, but
+	 * we failed to load one. This is always false for
+	 * core rev > 10, as these don't need PCM firmware. */
+	bool pcm_request_failed;
 };
 
 /* Device (802.11 core) initialization status. */
 enum {
 	B43_STAT_UNINIT = 0,	/* Uninitialized. */
 	B43_STAT_INITIALIZED = 1,	/* Initialized, but not started, yet. */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-17 22:35:00.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-17 23:33:15.000000000 +0200
@@ -1907,13 +1907,14 @@ static void b43_print_fw_helptext(struct
 	else
 		b43warn(wl, text);
 }
 
 static int do_request_fw(struct b43_wldev *dev,
 			 const char *name,
-			 struct b43_firmware_file *fw)
+			 struct b43_firmware_file *fw,
+			 bool silent)
 {
 	char path[sizeof(modparam_fwpostfix) + 32];
 	const struct firmware *blob;
 	struct b43_fw_header *hdr;
 	u32 size;
 	int err;
@@ -1931,15 +1932,21 @@ static int do_request_fw(struct b43_wlde
 	}
 
 	snprintf(path, ARRAY_SIZE(path),
 		 "b43%s/%s.fw",
 		 modparam_fwpostfix, name);
 	err = request_firmware(&blob, path, dev->dev->dev);
-	if (err) {
-		b43err(dev->wl, "Firmware file \"%s\" not found "
-		       "or load failed.\n", path);
+	if (err == -ENOENT) {
+		if (!silent) {
+			b43err(dev->wl, "Firmware file \"%s\" not found\n",
+			       path);
+		}
+		return err;
+	} else if (err) {
+		b43err(dev->wl, "Firmware file \"%s\" request failed (err=%d)\n",
+		       path, err);
 		return err;
 	}
 	if (blob->size < sizeof(struct b43_fw_header))
 		goto err_format;
 	hdr = (struct b43_fw_header *)(blob->data);
 	switch (hdr->type) {
@@ -1984,25 +1991,30 @@ static int b43_request_firmware(struct b
 	else if ((rev >= 11) && (rev <= 12))
 		filename = "ucode11";
 	else if (rev >= 13)
 		filename = "ucode13";
 	else
 		goto err_no_ucode;
-	err = do_request_fw(dev, filename, &fw->ucode);
+	err = do_request_fw(dev, filename, &fw->ucode, 0);
 	if (err)
 		goto err_load;
 
 	/* Get PCM code */
 	if ((rev >= 5) && (rev <= 10))
 		filename = "pcm5";
 	else if (rev >= 11)
 		filename = NULL;
 	else
 		goto err_no_pcm;
-	err = do_request_fw(dev, filename, &fw->pcm);
-	if (err)
+	fw->pcm_request_failed = 0;
+	err = do_request_fw(dev, filename, &fw->pcm, 1);
+	if (err == -ENOENT) {
+		/* We did not find a PCM file? Not fatal, but
+		 * core rev <= 10 must do without hwcrypto then. */
+		fw->pcm_request_failed = 1;
+	} else if (err)
 		goto err_load;
 
 	/* Get initvals */
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
 		if ((rev >= 5) && (rev <= 10)) {
@@ -2027,13 +2039,13 @@ static int b43_request_firmware(struct b
 		else
 			goto err_no_initvals;
 		break;
 	default:
 		goto err_no_initvals;
 	}
-	err = do_request_fw(dev, filename, &fw->initvals);
+	err = do_request_fw(dev, filename, &fw->initvals, 0);
 	if (err)
 		goto err_load;
 
 	/* Get bandswitch initvals */
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
@@ -2061,13 +2073,13 @@ static int b43_request_firmware(struct b
 		else
 			goto err_no_initvals;
 		break;
 	default:
 		goto err_no_initvals;
 	}
-	err = do_request_fw(dev, filename, &fw->initvals_band);
+	err = do_request_fw(dev, filename, &fw->initvals_band, 0);
 	if (err)
 		goto err_load;
 
 	return 0;
 
 err_load:
@@ -2185,20 +2197,26 @@ static int b43_upload_microcode(struct b
 	dev->fw.patch = fwpatch;
 	dev->fw.opensource = (fwdate == 0xFFFF);
 
 	if (dev->fw.opensource) {
 		/* Patchlevel info is encoded in the "time" field. */
 		dev->fw.patch = fwtime;
-		b43info(dev->wl, "Loading OpenSource firmware version %u.%u\n",
-			dev->fw.rev, dev->fw.patch);
+		b43info(dev->wl, "Loading OpenSource firmware version %u.%u%s\n",
+			dev->fw.rev, dev->fw.patch,
+			dev->fw.pcm_request_failed ? " (Hardware crypto not supported)" : "");
 	} else {
 		b43info(dev->wl, "Loading firmware version %u.%u "
 			"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
 			fwrev, fwpatch,
 			(fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
 			(fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+		if (dev->fw.pcm_request_failed) {
+			b43warn(dev->wl, "No \"pcm5.fw\" firmware file found. "
+				"Hardware accelerated cryptography is disabled.\n");
+			b43_print_fw_helptext(dev->wl, 0);
+		}
 	}
 
 	if (b43_is_old_txhdr_format(dev)) {
 		b43warn(dev->wl, "You are using an old firmware image. "
 			"Support for old firmware will be removed in July 2008.\n");
 		b43_print_fw_helptext(dev->wl, 0);
@@ -3358,12 +3376,19 @@ static int b43_op_set_key(struct ieee802
 
 	dev = wl->current_dev;
 	err = -ENODEV;
 	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
 
+	if (dev->fw.pcm_request_failed) {
+		/* We don't have firmware for the crypto engine.
+		 * Must use software-crypto. */
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	err = -EINVAL;
 	switch (key->alg) {
 	case ALG_WEP:
 		if (key->keylen == 5)
 			algorithm = B43_SEC_ALGO_WEP40;
 		else
