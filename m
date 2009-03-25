Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49738 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCYFiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 01:38:06 -0400
Received: by fxm2 with SMTP id 2so2582046fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 22:38:02 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/2] p54spi: mask value read from SPI_ADRS_DMA_WRITE_CTRL in p54spi_wait_bit
Date: Wed, 25 Mar 2009 08:30:15 +0300
Message-Id: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> (sfid-20090325_063816_336429_EB04D872)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Mask value read from SPI_ADRS_DMA_WRITE_CTRL in p54spi_wait_bit.
 Without this, 'fw_upload not allowed to DMA write' is observed at both N800 and N810.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 2b222aa..d13268f 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -171,7 +171,7 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 
 	for (i = 0; i < 2000; i++) {
 		p54spi_spi_read(priv, reg, &buffer, sizeof(buffer));
-		if (buffer == bits)
+		if ((buffer & bits) == bits)
 			return 1;
 
 		msleep(1);
-- 
1.5.4.3

