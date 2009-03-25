Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41398 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZCYLRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:17:38 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 2/2] p54spi: fix p54_upload_firmware
Date: Wed, 25 Mar 2009 12:21:38 +0100
Cc: linux-wireless@vger.kernel.org
References: <> <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <1237959016-17311-2-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1237959016-17311-2-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903251221.38912.chunkeey@web.de> (sfid-20090325_121747_901837_6719F57C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 March 2009 06:30:16 Max Filippov wrote:
>  Instead of firmware itself p54_upload_firmware was sending to the device content of struct firmware
>  and the following random garbage. Notice '&' before priv->firmware->data at p54spi_spi_write.
>  But simple removing of '&' sign triggered BUG_ON at dma_cache_maint. Thus kmemdup - kfree workaround.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  drivers/net/wireless/p54/p54spi.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index d13268f..4ef57c5 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -265,8 +265,15 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
>  		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE,
>  			       cpu_to_le32(fw_addr));
>  
> -		p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
> -				 &priv->firmware->data, _fw_len);
> +		{
> +			void *fw = kmemdup(priv->firmware->data, _fw_len, GFP_KERNEL);
> +			if (fw)
> +			{
> +				p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
> +						 fw, _fw_len);
> +				kfree(fw);
> +			}
> +		}
>  
>  		fw_len -= _fw_len;
>  		fw_addr += _fw_len;
---
checkpatch.pl complains

WARNING: line over 80 characters
#94: FILE: drivers/net/wireless/p54/p54spi.c:269:
+                       void *fw = kmemdup(priv->firmware->data, _fw_len, GFP_KERNEL);

ERROR: that open brace { should be on the previous line
#95: FILE: drivers/net/wireless/p54/p54spi.c:270:
+                       if (fw)
+                       {

what do you think about the attached proposal?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index d13268f..7d32a2f 100644
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
+	void *fw;
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
