Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53726 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYAUS7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 13:59:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix firmware caching
Date: Mon, 21 Jan 2008 19:55:09 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801211955.09594.mb@bu3sch.de> (sfid-20080121_185925_949249_7EBED98D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must also store the ID string (filename) for the cached firmware blobs
and verify that we really have the right firmware cached before using it.
If we don't have the right fw cached, we must free it and request the
correct blobs.

This fixes bandswitch on A/B/G multi-PHY devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, as we don't support A-PHY operation, yet, we don't need to
apply this patch to 2.6.24. Please queue this patch for 2.6.25.



Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2008-01-16 23:26:30.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2008-01-21 18:38:33.000000000 +0100
@@ -663,22 +663,29 @@ struct b43_wl {
 	 * This beacon stuff is protected by the irq_lock. */
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
 };
 
+/* In-memory representation of a cached microcode file. */
+struct b43_firmware_file {
+	const char *filename;
+	const struct firmware *data;
+};
+
 /* Pointers to the firmware data and meta information about it. */
 struct b43_firmware {
 	/* Microcode */
-	const struct firmware *ucode;
+	struct b43_firmware_file ucode;
 	/* PCM code */
-	const struct firmware *pcm;
+	struct b43_firmware_file pcm;
 	/* Initial MMIO values for the firmware */
-	const struct firmware *initvals;
+	struct b43_firmware_file initvals;
 	/* Initial MMIO values for the firmware, band-specific */
-	const struct firmware *initvals_band;
+	struct b43_firmware_file initvals_band;
+
 	/* Firmware revision */
 	u16 rev;
 	/* Firmware patchlevel */
 	u16 patch;
 };
 
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-21 18:28:36.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-21 19:42:15.000000000 +0100
@@ -1554,22 +1554,25 @@ static irqreturn_t b43_interrupt_handler
 	mmiowb();
 	spin_unlock(&dev->wl->irq_lock);
 
 	return ret;
 }
 
+static void do_release_fw(struct b43_firmware_file *fw)
+{
+	release_firmware(fw->data);
+	fw->data = NULL;
+	fw->filename = NULL;
+}
+
 static void b43_release_firmware(struct b43_wldev *dev)
 {
-	release_firmware(dev->fw.ucode);
-	dev->fw.ucode = NULL;
-	release_firmware(dev->fw.pcm);
-	dev->fw.pcm = NULL;
-	release_firmware(dev->fw.initvals);
-	dev->fw.initvals = NULL;
-	release_firmware(dev->fw.initvals_band);
-	dev->fw.initvals_band = NULL;
+	do_release_fw(&dev->fw.ucode);
+	do_release_fw(&dev->fw.pcm);
+	do_release_fw(&dev->fw.initvals);
+	do_release_fw(&dev->fw.initvals_band);
 }
 
 static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
 	const char *text;
 
@@ -1581,155 +1584,169 @@ static void b43_print_fw_helptext(struct
 	else
 		b43warn(wl, text);
 }
 
 static int do_request_fw(struct b43_wldev *dev,
 			 const char *name,
-			 const struct firmware **fw)
+			 struct b43_firmware_file *fw)
 {
 	char path[sizeof(modparam_fwpostfix) + 32];
+	const struct firmware *blob;
 	struct b43_fw_header *hdr;
 	u32 size;
 	int err;
 
-	if (!name)
+	if (!name) {
+		/* Don't fetch anything. Free possibly cached firmware. */
+		do_release_fw(fw);
 		return 0;
+	}
+	if (fw->filename) {
+		if (strcmp(fw->filename, name) == 0)
+			return 0; /* Already have this fw. */
+		/* Free the cached firmware first. */
+		do_release_fw(fw);
+	}
 
 	snprintf(path, ARRAY_SIZE(path),
 		 "b43%s/%s.fw",
 		 modparam_fwpostfix, name);
-	err = request_firmware(fw, path, dev->dev->dev);
+	err = request_firmware(&blob, path, dev->dev->dev);
 	if (err) {
 		b43err(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
 		return err;
 	}
-	if ((*fw)->size < sizeof(struct b43_fw_header))
+	if (blob->size < sizeof(struct b43_fw_header))
 		goto err_format;
-	hdr = (struct b43_fw_header *)((*fw)->data);
+	hdr = (struct b43_fw_header *)(blob->data);
 	switch (hdr->type) {
 	case B43_FW_TYPE_UCODE:
 	case B43_FW_TYPE_PCM:
 		size = be32_to_cpu(hdr->size);
-		if (size != (*fw)->size - sizeof(struct b43_fw_header))
+		if (size != blob->size - sizeof(struct b43_fw_header))
 			goto err_format;
 		/* fallthrough */
 	case B43_FW_TYPE_IV:
 		if (hdr->ver != 1)
 			goto err_format;
 		break;
 	default:
 		goto err_format;
 	}
 
-	return err;
+	fw->data = blob;
+	fw->filename = name;
+
+	return 0;
 
 err_format:
 	b43err(dev->wl, "Firmware file \"%s\" format error.\n", path);
+	release_firmware(blob);
+
 	return -EPROTO;
 }
 
 static int b43_request_firmware(struct b43_wldev *dev)
 {
 	struct b43_firmware *fw = &dev->fw;
 	const u8 rev = dev->dev->id.revision;
 	const char *filename;
 	u32 tmshigh;
 	int err;
 
+	/* Get microcode */
 	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
-	if (!fw->ucode) {
+	if ((rev >= 5) && (rev <= 10))
+		filename = "ucode5";
+	else if ((rev >= 11) && (rev <= 12))
+		filename = "ucode11";
+	else if (rev >= 13)
+		filename = "ucode13";
+	else
+		goto err_no_ucode;
+	err = do_request_fw(dev, filename, &fw->ucode);
+	if (err)
+		goto err_load;
+
+	/* Get PCM code */
+	if ((rev >= 5) && (rev <= 10))
+		filename = "pcm5";
+	else if (rev >= 11)
+		filename = NULL;
+	else
+		goto err_no_pcm;
+	err = do_request_fw(dev, filename, &fw->pcm);
+	if (err)
+		goto err_load;
+
+	/* Get initvals */
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+		if ((rev >= 5) && (rev <= 10)) {
+			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
+				filename = "a0g1initvals5";
+			else
+				filename = "a0g0initvals5";
+		} else
+			goto err_no_initvals;
+		break;
+	case B43_PHYTYPE_G:
 		if ((rev >= 5) && (rev <= 10))
-			filename = "ucode5";
-		else if ((rev >= 11) && (rev <= 12))
-			filename = "ucode11";
+			filename = "b0g0initvals5";
 		else if (rev >= 13)
-			filename = "ucode13";
+			filename = "lp0initvals13";
 		else
-			goto err_no_ucode;
-		err = do_request_fw(dev, filename, &fw->ucode);
-		if (err)
-			goto err_load;
+			goto err_no_initvals;
+		break;
+	case B43_PHYTYPE_N:
+		if ((rev >= 11) && (rev <= 12))
+			filename = "n0initvals11";
+		else
+			goto err_no_initvals;
+		break;
+	default:
+		goto err_no_initvals;
 	}
-	if (!fw->pcm) {
+	err = do_request_fw(dev, filename, &fw->initvals);
+	if (err)
+		goto err_load;
+
+	/* Get bandswitch initvals */
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+		if ((rev >= 5) && (rev <= 10)) {
+			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
+				filename = "a0g1bsinitvals5";
+			else
+				filename = "a0g0bsinitvals5";
+		} else if (rev >= 11)
+			filename = NULL;
+		else
+			goto err_no_initvals;
+		break;
+	case B43_PHYTYPE_G:
 		if ((rev >= 5) && (rev <= 10))
-			filename = "pcm5";
+			filename = "b0g0bsinitvals5";
 		else if (rev >= 11)
 			filename = NULL;
 		else
-			goto err_no_pcm;
-		err = do_request_fw(dev, filename, &fw->pcm);
-		if (err)
-			goto err_load;
-	}
-	if (!fw->initvals) {
-		switch (dev->phy.type) {
-		case B43_PHYTYPE_A:
-			if ((rev >= 5) && (rev <= 10)) {
-				if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
-					filename = "a0g1initvals5";
-				else
-					filename = "a0g0initvals5";
-			} else
-				goto err_no_initvals;
-			break;
-		case B43_PHYTYPE_G:
-			if ((rev >= 5) && (rev <= 10))
-				filename = "b0g0initvals5";
-			else if (rev >= 13)
-				filename = "lp0initvals13";
-			else
-				goto err_no_initvals;
-			break;
-		case B43_PHYTYPE_N:
-			if ((rev >= 11) && (rev <= 12))
-				filename = "n0initvals11";
-			else
-				goto err_no_initvals;
-			break;
-		default:
 			goto err_no_initvals;
-		}
-		err = do_request_fw(dev, filename, &fw->initvals);
-		if (err)
-			goto err_load;
-	}
-	if (!fw->initvals_band) {
-		switch (dev->phy.type) {
-		case B43_PHYTYPE_A:
-			if ((rev >= 5) && (rev <= 10)) {
-				if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
-					filename = "a0g1bsinitvals5";
-				else
-					filename = "a0g0bsinitvals5";
-			} else if (rev >= 11)
-				filename = NULL;
-			else
-				goto err_no_initvals;
-			break;
-		case B43_PHYTYPE_G:
-			if ((rev >= 5) && (rev <= 10))
-				filename = "b0g0bsinitvals5";
-			else if (rev >= 11)
-				filename = NULL;
-			else
-				goto err_no_initvals;
-			break;
-		case B43_PHYTYPE_N:
-			if ((rev >= 11) && (rev <= 12))
-				filename = "n0bsinitvals11";
-			else
-				goto err_no_initvals;
-			break;
-		default:
+		break;
+	case B43_PHYTYPE_N:
+		if ((rev >= 11) && (rev <= 12))
+			filename = "n0bsinitvals11";
+		else
 			goto err_no_initvals;
-		}
-		err = do_request_fw(dev, filename, &fw->initvals_band);
-		if (err)
-			goto err_load;
+		break;
+	default:
+		goto err_no_initvals;
 	}
+	err = do_request_fw(dev, filename, &fw->initvals_band);
+	if (err)
+		goto err_load;
 
 	return 0;
 
 err_load:
 	b43_print_fw_helptext(dev->wl, 1);
 	goto error;
@@ -1762,24 +1779,24 @@ static int b43_upload_microcode(struct b
 	unsigned int i, len;
 	u16 fwrev, fwpatch, fwdate, fwtime;
 	u32 tmp;
 	int err = 0;
 
 	/* Upload Microcode. */
-	data = (__be32 *) (dev->fw.ucode->data + hdr_len);
-	len = (dev->fw.ucode->size - hdr_len) / sizeof(__be32);
+	data = (__be32 *) (dev->fw.ucode.data->data + hdr_len);
+	len = (dev->fw.ucode.data->size - hdr_len) / sizeof(__be32);
 	b43_shm_control_word(dev, B43_SHM_UCODE | B43_SHM_AUTOINC_W, 0x0000);
 	for (i = 0; i < len; i++) {
 		b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
 		udelay(10);
 	}
 
-	if (dev->fw.pcm) {
+	if (dev->fw.pcm.data) {
 		/* Upload PCM data. */
-		data = (__be32 *) (dev->fw.pcm->data + hdr_len);
-		len = (dev->fw.pcm->size - hdr_len) / sizeof(__be32);
+		data = (__be32 *) (dev->fw.pcm.data->data + hdr_len);
+		len = (dev->fw.pcm.data->size - hdr_len) / sizeof(__be32);
 		b43_shm_control_word(dev, B43_SHM_HW, 0x01EA);
 		b43_write32(dev, B43_MMIO_SHM_DATA, 0x00004000);
 		/* No need for autoinc bit in SHM_HW */
 		b43_shm_control_word(dev, B43_SHM_HW, 0x01EB);
 		for (i = 0; i < len; i++) {
 			b43_write32(dev, B43_MMIO_SHM_DATA, be32_to_cpu(data[i]));
@@ -1910,25 +1927,25 @@ static int b43_upload_initvals(struct b4
 	const struct b43_fw_header *hdr;
 	struct b43_firmware *fw = &dev->fw;
 	const struct b43_iv *ivals;
 	size_t count;
 	int err;
 
-	hdr = (const struct b43_fw_header *)(fw->initvals->data);
-	ivals = (const struct b43_iv *)(fw->initvals->data + hdr_len);
+	hdr = (const struct b43_fw_header *)(fw->initvals.data->data);
+	ivals = (const struct b43_iv *)(fw->initvals.data->data + hdr_len);
 	count = be32_to_cpu(hdr->size);
 	err = b43_write_initvals(dev, ivals, count,
-				 fw->initvals->size - hdr_len);
+				 fw->initvals.data->size - hdr_len);
 	if (err)
 		goto out;
-	if (fw->initvals_band) {
-		hdr = (const struct b43_fw_header *)(fw->initvals_band->data);
-		ivals = (const struct b43_iv *)(fw->initvals_band->data + hdr_len);
+	if (fw->initvals_band.data) {
+		hdr = (const struct b43_fw_header *)(fw->initvals_band.data->data);
+		ivals = (const struct b43_iv *)(fw->initvals_band.data->data + hdr_len);
 		count = be32_to_cpu(hdr->size);
 		err = b43_write_initvals(dev, ivals, count,
-					 fw->initvals_band->size - hdr_len);
+					 fw->initvals_band.data->size - hdr_len);
 		if (err)
 			goto out;
 	}
 out:
 
 	return err;
