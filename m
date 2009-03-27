Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48029 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZC0E65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:58:57 -0400
Received: by bwz17 with SMTP id 17so836474bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 21:58:54 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] p54spi: compensate firmware alignment bug in p54spi_rx
Date: Fri, 27 Mar 2009 07:50:53 +0300
Message-Id: <1238129453-7478-1-git-send-email-jcmvbkbc@gmail.com> (sfid-20090327_055951_074963_7844B4A7)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware may insert up to 4 padding bytes after the lmac header,
but it does not amend the size of SPI data transfer.
Such packets has correct data size in header, thus referencing
past the end of allocated skb. Put extra 4 bytes to the end of the
received skb to compensate for this case.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 5e8011c..35ea0dd 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -381,7 +381,12 @@ static int p54spi_rx(struct p54s_priv *priv)
 		return 0;
 	}
 
-	skb = dev_alloc_skb(len);
+
+	/* Firmware may insert up to 4 padding bytes after the lmac header,
+	 * but it does not amend the size of SPI data transfer.
+	 * Such packets has correct data size in header, thus referencing
+	 * past the end of allocated skb. Reserve extra 4 bytes for this case */
+	skb = dev_alloc_skb(len + 4);
 	if (!skb) {
 		dev_err(&priv->spi->dev, "could not alloc skb");
 		return 0;
@@ -389,6 +394,9 @@ static int p54spi_rx(struct p54s_priv *priv)
 
 	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, skb_put(skb, len), len);
 	p54spi_sleep(priv);
+	/* Put additional bytes to compensate for the possible
+	 * alignment-caused truncation */
+	skb_put(skb, 4);
 
 	if (p54_rx(priv->hw, skb) == 0)
 		dev_kfree_skb(skb);
-- 
1.5.4.3

