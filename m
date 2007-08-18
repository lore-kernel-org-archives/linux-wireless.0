Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49216
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbXHRXxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:21 -0400
Message-Id: <20070818234835.956854000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:38 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 5/6] b43: Use new firmware file naming scheme
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a sane firmware file naming scheme and also move
the firmware files into a subdir.
This avoids conflicts with bcm43xx and b43legacy.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/b43.h	2007-08-15 19:15:03.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/b43.h	2007-08-16 17:15:46.000000000 +0200
@@ -406,9 +406,9 @@ struct b43_dmaring;
 struct b43_pioqueue;
 
 struct b43_initval {
-	u16 offset;
-	u16 size;
-	u32 value;
+	__be16 offset;
+	__be16 size;
+	__be32 value;
 } __attribute__ ((__packed__));
 
 #define B43_PHYMODE(phytype)		(1 << (phytype))
@@ -609,10 +609,10 @@ struct b43_firmware {
 	const struct firmware *ucode;
 	/* PCM code */
 	const struct firmware *pcm;
-	/* Initial MMIO values 0 */
-	const struct firmware *initvals0;
-	/* Initial MMIO values 1 */
-	const struct firmware *initvals1;
+	/* Initial MMIO values for the firmware */
+	const struct firmware *initvals;
+	/* Initial MMIO values for the firmware, band-specific */
+	const struct firmware *initvals_band;
 	/* Firmware revision */
 	u16 rev;
 	/* Firmware patchlevel */
Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-15 19:15:03.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-16 17:32:10.000000000 +0200
@@ -1566,136 +1566,155 @@ static void b43_release_firmware(struct 
 	dev->fw.ucode = NULL;
 	release_firmware(dev->fw.pcm);
 	dev->fw.pcm = NULL;
-	release_firmware(dev->fw.initvals0);
-	dev->fw.initvals0 = NULL;
-	release_firmware(dev->fw.initvals1);
-	dev->fw.initvals1 = NULL;
+	release_firmware(dev->fw.initvals);
+	dev->fw.initvals = NULL;
+	release_firmware(dev->fw.initvals_band);
+	dev->fw.initvals_band = NULL;
 }
 
-static int b43_request_firmware(struct b43_wldev *dev)
+static void b43_print_fw_helptext(struct b43_wl *wl)
 {
-	u8 rev = dev->dev->id.revision;
-	int err = 0;
-	int nr;
-	char buf[22 + sizeof(modparam_fwpostfix) - 1] = { 0 };
+	b43err(wl, "You must go to "
+	       "http://linuxwireless.org/en/users/Drivers/bcm43xx#devicefirmware "
+	       "and download the correct firmware (version 4).\n");
+}
 
-	if (!dev->fw.ucode) {
-		snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_microcode%d%s.fw",
-			 (rev >= 5 ? 5 : rev), modparam_fwpostfix);
-		err = request_firmware(&dev->fw.ucode, buf, dev->dev->dev);
-		if (err) {
-			b43err(dev->wl, "Microcode \"%s\" not "
-			       "available or load failed.\n", buf);
-			goto error;
-		}
-	}
+static int do_request_fw(struct b43_wldev *dev,
+			 const char *name,
+			 const struct firmware **fw)
+{
+	const size_t plen = sizeof(modparam_fwpostfix) + 32;
+	char path[plen];
+	int err;
 
-	if (!dev->fw.pcm) {
-		snprintf(buf, ARRAY_SIZE(buf),
-			 "bcm43xx_pcm%d%s.fw",
-			 (rev < 5 ? 4 : 5), modparam_fwpostfix);
-		err = request_firmware(&dev->fw.pcm, buf, dev->dev->dev);
-		if (err) {
-			b43err(dev->wl, "PCM \"%s\" not available "
-			       "or load failed.\n", buf);
-			goto error;
-		}
+	if (!name)
+		return 0;
+
+	snprintf(path, ARRAY_SIZE(path),
+		 "b43%s/%s.fw",
+		 modparam_fwpostfix, name);
+	err = request_firmware(fw, path, dev->dev->dev);
+	if (err) {
+		b43err(dev->wl, "Firmware file \"%s\" not found "
+		       "or load failed.\n", path);
 	}
 
-	if (!dev->fw.initvals0) {
-		if (rev == 2 || rev == 4) {
-			switch (dev->phy.type) {
-			case B43_PHYTYPE_A:
-				nr = 3;
-				break;
-			case B43_PHYTYPE_B:
-			case B43_PHYTYPE_G:
-				nr = 1;
-				break;
-			default:
-				goto err_noinitval;
-			}
+	return err;
+}
 
-		} else if (rev >= 5) {
-			switch (dev->phy.type) {
-			case B43_PHYTYPE_A:
-				nr = 7;
-				break;
-			case B43_PHYTYPE_B:
-			case B43_PHYTYPE_G:
-				nr = 5;
-				break;
-			default:
-				goto err_noinitval;
-			}
-		} else
-			goto err_noinitval;
-		snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_initval%02d%s.fw",
-			 nr, modparam_fwpostfix);
+static int b43_request_firmware(struct b43_wldev *dev)
+{
+	struct b43_firmware *fw = &dev->fw;
+	const u8 rev = dev->dev->id.revision;
+	const char *filename;
+	u32 tmshigh;
+	int err;
 
-		err = request_firmware(&dev->fw.initvals0, buf, dev->dev->dev);
-		if (err) {
-			b43err(dev->wl, "InitVals \"%s\" not available "
-			       "or load failed.\n", buf);
-			goto error;
-		}
-		if (dev->fw.initvals0->size % sizeof(struct b43_initval)) {
-			b43err(dev->wl, "InitVals fileformat error.\n");
-			goto error;
+	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+	if (!fw->ucode) {
+		if ((rev >= 5) && (rev <= 10))
+			filename = "ucode5";
+		else if ((rev >= 11) && (rev <= 12))
+			filename = "ucode11";
+		else if (rev >= 13)
+			filename = "ucode13";
+		else
+			goto err_no_ucode;
+		err = do_request_fw(dev, filename, &fw->ucode);
+		if (err)
+			goto err_load;
+	}
+	if (!fw->pcm) {
+		if ((rev >= 5) && (rev <= 10))
+			filename = "pcm5";
+		else if (rev >= 11)
+			filename = NULL;
+		else
+			goto err_no_pcm;
+		err = do_request_fw(dev, filename, &fw->pcm);
+		if (err)
+			goto err_load;
+	}
+	if (!fw->initvals) {
+		switch (dev->phy.type) {
+		case B43_PHYTYPE_A:
+			if ((rev >= 5) && (rev <= 10)) {
+				if (tmshigh & B43_TMSHIGH_GPHY)
+					filename = "a0g1initvals5";
+				else
+					filename = "a0g0initvals5";
+			} else
+				goto err_no_initvals;
+			break;
+		case B43_PHYTYPE_G:
+			if ((rev >= 5) && (rev <= 10))
+				filename = "b0g0initvals5";
+			else if (rev >= 13)
+				filename = "lp0initvals13";
+			else
+				goto err_no_initvals;
+			break;
+		default:
+			goto err_no_initvals;
 		}
+		err = do_request_fw(dev, filename, &fw->initvals);
+		if (err)
+			goto err_load;
 	}
-
-	if (!dev->fw.initvals1) {
-		if (rev >= 5) {
-			u32 sbtmstatehigh;
-
-			switch (dev->phy.type) {
-			case B43_PHYTYPE_A:
-				sbtmstatehigh =
-				    ssb_read32(dev->dev, SSB_TMSHIGH);
-				if (sbtmstatehigh & 0x00010000)
-					nr = 9;
+	if (!fw->initvals_band) {
+		switch (dev->phy.type) {
+		case B43_PHYTYPE_A:
+			if ((rev >= 5) && (rev <= 10)) {
+				if (tmshigh & B43_TMSHIGH_GPHY)
+					filename = "a0g1bsinitvals5";
 				else
-					nr = 10;
-				break;
-			case B43_PHYTYPE_B:
-			case B43_PHYTYPE_G:
-				nr = 6;
-				break;
-			default:
-				goto err_noinitval;
-			}
-			snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_initval%02d%s.fw",
-				 nr, modparam_fwpostfix);
-
-			err =
-			    request_firmware(&dev->fw.initvals1, buf,
-					     dev->dev->dev);
-			if (err) {
-				b43err(dev->wl, "InitVals \"%s\" not available "
-				       "or load failed.\n", buf);
-				goto error;
-			}
-			if (dev->fw.initvals1->size %
-			    sizeof(struct b43_initval)) {
-				b43err(dev->wl, "InitVals fileformat error.\n");
-				goto error;
-			}
+					filename = "a0g0bsinitvals5";
+			} else if (rev >= 11)
+				filename = NULL;
+			else
+				goto err_no_initvals;
+			break;
+		case B43_PHYTYPE_G:
+			if ((rev >= 5) && (rev <= 10))
+				filename = "b0g0bsinitvals5";
+			else if (rev >= 11)
+				filename = NULL;
+			else
+				goto err_no_initvals;
+			break;
+		default:
+			goto err_no_initvals;
 		}
+		err = do_request_fw(dev, filename, &fw->initvals_band);
+		if (err)
+			goto err_load;
 	}
 
-      out:
-	return err;
-      error:
-	b43err(dev->wl, "You must go to "
-	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
-	       "and download the correct firmware (version 4)\n");
-	b43_release_firmware(dev);
-	goto out;
-      err_noinitval:
-	b43err(dev->wl, "No InitVals available\n");
-	err = -ENOENT;
+	return 0;
+
+err_load:
+	b43_print_fw_helptext(dev->wl);
 	goto error;
+
+err_no_ucode:
+	err = -ENODEV;
+	b43err(dev->wl, "No microcode available for core rev %u\n", rev);
+	goto error;
+
+err_no_pcm:
+	err = -ENODEV;
+	b43err(dev->wl, "No PCM available for core rev %u\n", rev);
+	goto error;
+
+err_no_initvals:
+	err = -ENODEV;
+	b43err(dev->wl, "No Initial Values firmware file for PHY %u, "
+	       "core rev %u\n", dev->phy.type, rev);
+	goto error;
+
+error:
+	b43_release_firmware(dev);
+	return err;
 }
 
 static int b43_upload_microcode(struct b43_wldev *dev)
@@ -1741,6 +1760,7 @@ static int b43_upload_microcode(struct b
 		i++;
 		if (i >= 50) {
 			b43err(dev->wl, "Microcode not responding\n");
+			b43_print_fw_helptext(dev->wl);
 			err = -ENODEV;
 			goto out;
 		}
@@ -1758,6 +1778,7 @@ static int b43_upload_microcode(struct b
 		b43err(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
+		b43_print_fw_helptext(dev->wl);
 		b43_write32(dev, B43_MMIO_MACCTL, 0);
 		err = -EOPNOTSUPP;
 		goto out;
@@ -1777,13 +1798,13 @@ static int b43_upload_microcode(struct b
 
 static int b43_write_initvals(struct b43_wldev *dev,
 			      const struct b43_initval *data,
-			      const unsigned int len)
+			      size_t count)
 {
 	u16 offset, size;
 	u32 value;
-	unsigned int i;
+	size_t i;
 
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < count; i++) {
 		offset = be16_to_cpu(data[i].offset);
 		size = be16_to_cpu(data[i].size);
 		value = be32_to_cpu(data[i].value);
@@ -1802,34 +1823,32 @@ static int b43_write_initvals(struct b43
 
 	return 0;
 
-      err_format:
-	b43err(dev->wl, "InitVals (b43_initvalXX.fw) file-format error. "
-	       "Please fix your b43 firmware files.\n");
+err_format:
+	b43err(dev->wl, "Initial Values Firmware file-format error\n");
+	b43_print_fw_helptext(dev->wl);
+
 	return -EPROTO;
 }
 
 static int b43_upload_initvals(struct b43_wldev *dev)
 {
+	struct b43_firmware *fw = &dev->fw;
+	struct b43_initval *ivals;
+	size_t count;
 	int err;
 
-	err =
-	    b43_write_initvals(dev,
-			       (struct b43_initval *)dev->fw.initvals0->data,
-			       dev->fw.initvals0->size /
-			       sizeof(struct b43_initval));
+	ivals = (struct b43_initval *)(fw->initvals->data);
+	count = fw->initvals->size / sizeof(struct b43_initval);
+	err = b43_write_initvals(dev, ivals, count);
 	if (err)
 		goto out;
-	if (dev->fw.initvals1) {
-		err =
-		    b43_write_initvals(dev,
-				       (struct b43_initval *)dev->fw.initvals1->
-				       data,
-				       dev->fw.initvals1->size /
-				       sizeof(struct b43_initval));
-		if (err)
-			goto out;
+	if (fw->initvals_band) {
+		ivals = (struct b43_initval *)(fw->initvals_band->data);
+		count = fw->initvals_band->size / sizeof(struct b43_initval);
+		err = b43_write_initvals(dev, ivals, count);
 	}
-      out:
+out:
+
 	return err;
 }
 

-- 

