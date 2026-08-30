Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6748B1A9FBC;
	Sun, 30 Aug 2026 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788096923; cv=none; b=oqAFrjjVAMyBiCRip/74XgBb1ZJ253KTUcjxVVXnibbBjIURRb+c0+aHZNPW3duSFCe984g6/j9DWpaodcZ1yeZw7ByvnHmb6dWRxlhZQ+JkQHcGPBeLG1UjdwD/QioTgxejVsm9ZYfbgYLikWvu+6ZQfE3j6XhYbxLCOP/hym0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788096923; c=relaxed/simple;
	bh=ZtVxWIWVbzOMb3DAofvMlrFbgiEuPnQJsqbuL+CpDB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GaXQJOZDU37opBnDF46WpkAdTx7/qfb7D6paJVwEHXarJo/EdVRNOzUsdxw/tJJ6ksaI5MVpDNTD4jncknMmals7WvIHreRMC3dKvO5r8aSCp/3JPZzAEAM8L19amYU0lD96ZHUk8uuZrohrdiyWZS3SvLuF1VwrTOcGWK3HPu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHzz2WMZRq3CybBg--.26045S2;
	Sun, 30 Aug 2026 21:35:18 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Srinivasan Raju <srini.raju@purelifi.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: plfxlc: validate packed firmware file extents
Date: Sun, 30 Aug 2026 21:35:16 +0800
Message-ID: <20260830133516.7267-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHzz2WMZRq3CybBg--.26045S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr15Xry3Gr1rXw17WF13twb_yoWrAFy5pa
	15GFy2qr4UJrWfJry7tFs3CFyFg397tr1qgFW3u34xZrsFyr93Xa4xKFy5XrWS9w1kJ3Wj
	kF1DKryxGFn0q3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj9a97UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The XL firmware loader reads an offset table and copies fixed-size chunks
without first proving that the table and each subfile lie inside the
firmware image. Padding a short first-stage chunk can also make the final
copy read beyond its subfile.

Validate the table and monotonic subfile offsets, bind each range to the
firmware size, and zero-pad partial chunks instead of reading padding from
the image.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/purelifi/plfxlc/firmware.c | 60 +++++++++++++++++--------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/firmware.c b/drivers/net/wireless/purelifi/plfxlc/firmware.c
index 8a3529d07927d..b017c7bb71465 100644
--- a/drivers/net/wireless/purelifi/plfxlc/firmware.c
+++ b/drivers/net/wireless/purelifi/plfxlc/firmware.c
@@ -166,8 +166,13 @@ int plfxlc_download_xl_firmware(struct usb_interface *intf)
 		dev_err(&intf->dev, "Request_firmware failed (%d)\n", r);
 		return -EINVAL;
 	}
+	if (fwp->size < sizeof(u32) || fwp->size > U32_MAX) {
+		r = -EINVAL;
+		goto out_release;
+	}
+
 	file.total_files = get_unaligned_le32(&fwp->data[0]);
-	file.total_size = get_unaligned_le32(&fwp->size);
+	file.total_size = fwp->size;
 
 	dev_dbg(&intf->dev, "XL Firmware (%d, %d)\n",
 		file.total_files, file.total_size);
@@ -178,18 +183,32 @@ int plfxlc_download_xl_firmware(struct usb_interface *intf)
 		return -ENOMEM;
 	}
 
-	if (file.total_files > 10) {
+	if (file.total_files > 10 ||
+	    file.total_files > (file.total_size - sizeof(u32)) / sizeof(u32)) {
 		dev_err(&intf->dev, "Too many files (%d)\n", file.total_files);
-		release_firmware(fwp);
-		kfree(buf);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_free;
 	}
 
 	/* Download firmware files in multiple steps */
 	for (s = 0; s < file.total_files; s++) {
+		u32 copy_len, end_addr;
+
 		buf[0] = s;
 		r = send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,
 					PLF_XL_BUF_LEN);
+		if (r)
+			goto out_free;
+
+		file.start_addr = get_unaligned_le32(&fwp->data[4 + (s * 4)]);
+		if (s < file.total_files - 1)
+			end_addr = get_unaligned_le32(&fwp->data[4 + ((s + 1) * 4)]);
+		else
+			end_addr = file.total_size;
+		if (file.start_addr > end_addr || end_addr > file.total_size) {
+			r = -EINVAL;
+			goto out_free;
+		}
 
 		if (s < file.total_files - 1)
 			file.size = get_unaligned_le32(&fwp->data[4 + ((s + 1) * 4)])
@@ -200,35 +219,41 @@ int plfxlc_download_xl_firmware(struct usb_interface *intf)
 
 		if (file.size > file.total_size || file.size > 60000) {
 			dev_err(&intf->dev, "File size is too large (%d)\n", file.size);
-			break;
+			r = -EINVAL;
+			goto out_free;
 		}
 
-		file.start_addr = get_unaligned_le32(&fwp->data[4 + (s * 4)]);
-
-		if (file.size % PLF_XL_BUF_LEN && s < 2)
-			file.size += PLF_XL_BUF_LEN - file.size % PLF_XL_BUF_LEN;
-
-		file.control_packets = file.size / PLF_XL_BUF_LEN;
+		if (s < 2)
+			file.control_packets =
+				DIV_ROUND_UP(file.size, PLF_XL_BUF_LEN);
+		else
+			file.control_packets = file.size / PLF_XL_BUF_LEN;
 
 		for (i = 0; i < file.control_packets; i++) {
+			copy_len = min_t(u32, PLF_XL_BUF_LEN,
+					 file.size - i * PLF_XL_BUF_LEN);
+			memset(buf, 0, PLF_XL_BUF_LEN);
 			memcpy(buf,
 			       &fwp->data[file.start_addr + (i * PLF_XL_BUF_LEN)],
-			       PLF_XL_BUF_LEN);
+			       copy_len);
 			r = send_vendor_command(udev, PLF_VNDR_XL_DATA_CMD, buf,
 						PLF_XL_BUF_LEN);
+			if (r)
+				goto out_free;
 		}
 		dev_dbg(&intf->dev, "fw-dw step=%d,r=%d size=%d\n", s, r,
 			file.size);
 	}
-	release_firmware(fwp);
-	kfree(buf);
-
 	/* Code for single pack file download ends fw download finish */
 
 	r = send_vendor_command(udev, PLF_VNDR_XL_EX_CMD, NULL, 0);
 	dev_dbg(&intf->dev, "Download fpga (4) (%d)\n", r);
 
-	return 0;
+out_free:
+	kfree(buf);
+out_release:
+	release_firmware(fwp);
+	return r;
 }
 
 int plfxlc_upload_mac_and_serial(struct usb_interface *intf,
@@ -273,4 +298,3 @@ int plfxlc_upload_mac_and_serial(struct usb_interface *intf,
 
 	return 0;
 }
-

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

