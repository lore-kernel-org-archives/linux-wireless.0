Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42048 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0HPXQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 19:16:14 -0400
Received: by bwz3 with SMTP id 3so3080029bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 16:16:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] p54spi: fix eeprom checksum
Date: Tue, 17 Aug 2010 01:16:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008170116.06309.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects the bogus descriptor checksum of our
Nokia N8XX EEPROM blob.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54spi_eeprom.h b/drivers/net/wireless/p54/p54spi_eeprom.h
index 1ea1050..d592cbd 100644
--- a/drivers/net/wireless/p54/p54spi_eeprom.h
+++ b/drivers/net/wireless/p54/p54spi_eeprom.h
@@ -671,7 +671,7 @@ static unsigned char p54spi_eeprom[] = {
 	0xa8, 0x09, 0x25, 0x00, 0xf5, 0xff, 0xf9, 0xff, 0x00, 0x01,
 
 0x02, 0x00, 0x00, 0x00,		/* PDR_END */
-	0xa8, 0xf5			/* bogus data */
+	0x67, 0x99,
 };
 
 #endif /* P54SPI_EEPROM_H */
