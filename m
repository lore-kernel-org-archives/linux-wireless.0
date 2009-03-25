Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:33024 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbZCYMja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:39:30 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
Date: Wed, 25 Mar 2009 13:45:01 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903251221.38912.chunkeey@web.de> <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com>
In-Reply-To: <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903251345.01608.chunkeey@web.de> (sfid-20090325_133937_333933_9BB5C122)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Filippov <jcmvbkbc@gmail.com>

Instead of firmware itself p54_upload_firmware was sending to the device
content of struct firmware and the following random garbage.

Notice '&' before priv->firmware->data at p54spi_spi_write.
But simple removing of '&' sign triggered BUG_ON at dma_cache_maint.
Thus kmemdup - kfree workaround.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
On Wednesday 25 March 2009 13:00:33 Max Filippov wrote:
> Sorry, I haven't been used to checkpatch.
But your PATCH 1/2 sailed through without any complains. ;-)
 
> > what do you think about the attached proposal?
> 
> It looks generally better. But (fw + offset) wouldn't compile, because
> fw is void*.
??? but it does compile?!
  CHECK   drivers/net/wireless/p54/p54spi.c
  CC [M]  drivers/net/wireless/p54/p54spi.o
 Building modules, stage 2.
  MODPOST 4 modules
  CC      drivers/net/wireless/p54/p54spi.mod.o
  LD [M]  drivers/net/wireless/p54/p54spi.ko

But yes, I agree we better change void *fw to u8 *fw.

BTW: does p54spi really work now?
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index d13268f..93c761e 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -228,8 +228,15 @@ static int p54spi_request_eeprom(struct ieee80211_hw *dev)
 static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
-	unsigned long fw_len, fw_addr;
-	long _fw_len;
+	unsigned long fw_len, _fw_len;
+	unsigned int offset = 0;
+	int err = 0;
+	u8 *fw;
+
+	fw_len = priv->firmware->size;
+	fw = kmemdup(priv->firmware->data, fw_len, GFP_KERNEL);
+	if (!fw)
+		return -ENOMEM;
 
 	/* stop the device */
 	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT, cpu_to_le16(
@@ -244,9 +251,6 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 
 	msleep(TARGET_BOOT_SLEEP);
 
-	fw_addr = ISL38XX_DEV_FIRMWARE_ADDR;
-	fw_len = priv->firmware->size;
-
 	while (fw_len > 0) {
 		_fw_len = min_t(long, fw_len, SPI_MAX_PACKET_SIZE);
 
@@ -257,23 +261,20 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 				    cpu_to_le32(HOST_ALLOWED)) == 0) {
 			dev_err(&priv->spi->dev, "fw_upload not allowed "
 				"to DMA write.");
-			return -EAGAIN;
+			err = -EAGAIN;
+			goto out;
 		}
 
 		p54spi_write16(priv, SPI_ADRS_DMA_WRITE_LEN,
 			       cpu_to_le16(_fw_len));
-		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE,
-			       cpu_to_le32(fw_addr));
+		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE, cpu_to_le32(
+				ISL38XX_DEV_FIRMWARE_ADDR + offset));
 
 		p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
-				 &priv->firmware->data, _fw_len);
+				 (fw + offset), _fw_len);
 
 		fw_len -= _fw_len;
-		fw_addr += _fw_len;
-
-		/* FIXME: I think this doesn't work if firmware is large,
-		 * this loop goes to second round. fw->data is not
-		 * increased at all! */
+		offset += _fw_len;
 	}
 
 	BUG_ON(fw_len != 0);
@@ -292,7 +293,10 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT, cpu_to_le16(
 		       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_RAM_BOOT));
 	msleep(TARGET_BOOT_SLEEP);
-	return 0;
+
+out:
+	kfree(fw);
+	return err;
 }
 
 static void p54spi_power_off(struct p54s_priv *priv)
