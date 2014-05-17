Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37993 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaEQVZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 17:25:07 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so2478406eek.12
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 14:25:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [next][PATCH 1/4] b43: split upload of init values into 2 functions
Date: Sat, 17 May 2014 23:24:53 +0200
Message-Id: <1400361896-7345-1-git-send-email-zajec5@gmail.com> (sfid-20140517_232513_846281_6BCD2526)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two groups of init values. The first one has to be uploaded
once per wireless core reset but the second one on every band switch.
To implement band switching in an optimal way allow uploading band
init values only (by using a separated function).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 558abe7..d670c87 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2711,27 +2711,30 @@ static int b43_upload_initvals(struct b43_wldev *dev)
 	struct b43_firmware *fw = &dev->fw;
 	const struct b43_iv *ivals;
 	size_t count;
-	int err;
 
 	hdr = (const struct b43_fw_header *)(fw->initvals.data->data);
 	ivals = (const struct b43_iv *)(fw->initvals.data->data + hdr_len);
 	count = be32_to_cpu(hdr->size);
-	err = b43_write_initvals(dev, ivals, count,
+	return b43_write_initvals(dev, ivals, count,
 				 fw->initvals.data->size - hdr_len);
-	if (err)
-		goto out;
-	if (fw->initvals_band.data) {
-		hdr = (const struct b43_fw_header *)(fw->initvals_band.data->data);
-		ivals = (const struct b43_iv *)(fw->initvals_band.data->data + hdr_len);
-		count = be32_to_cpu(hdr->size);
-		err = b43_write_initvals(dev, ivals, count,
-					 fw->initvals_band.data->size - hdr_len);
-		if (err)
-			goto out;
-	}
-out:
+}
 
-	return err;
+static int b43_upload_initvals_band(struct b43_wldev *dev)
+{
+	const size_t hdr_len = sizeof(struct b43_fw_header);
+	const struct b43_fw_header *hdr;
+	struct b43_firmware *fw = &dev->fw;
+	const struct b43_iv *ivals;
+	size_t count;
+
+	if (!fw->initvals_band.data)
+		return 0;
+
+	hdr = (const struct b43_fw_header *)(fw->initvals_band.data->data);
+	ivals = (const struct b43_iv *)(fw->initvals_band.data->data + hdr_len);
+	count = be32_to_cpu(hdr->size);
+	return b43_write_initvals(dev, ivals, count,
+				  fw->initvals_band.data->size - hdr_len);
 }
 
 /* Initialize the GPIOs
@@ -3100,6 +3103,10 @@ static int b43_chip_init(struct b43_wldev *dev)
 	if (err)
 		goto err_gpio_clean;
 
+	err = b43_upload_initvals_band(dev);
+	if (err)
+		goto err_gpio_clean;
+
 	/* Turn the Analog on and initialize the PHY. */
 	phy->ops->switch_analog(dev, 1);
 	err = b43_phy_init(dev);
-- 
1.8.4.5

